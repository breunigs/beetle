module Beetle
  class Publisher < Base

    def initialize(client, options = {})
      super
      @dead_servers = {}
      @bunnies = {}
    end

    def publish(message_name, data, opts={})
      opts = @client.messages[message_name].merge(opts.symbolize_keys)
      exchange_name = opts.delete(:exchange)
      opts.delete(:queue)
      recycle_dead_servers unless @dead_servers.empty?
      if opts[:redundant]
        publish_with_redundancy(exchange_name, message_name, data, opts)
      else
        publish_with_failover(exchange_name, message_name, data, opts)
      end
    end

    def publish_with_failover(exchange_name, message_name, data, opts)
      tries = @servers.size
      logger.debug "Beetle: sending #{message_name}"
      data = Message.encode(data, :ttl => opts[:ttl])
      published = 0
      begin
        select_next_server
        bind_queues_for_exchange(exchange_name)
        logger.debug "Beetle: trying to send #{message_name} to #{@server}"
        exchange(exchange_name).publish(data, opts.slice(*PUBLISHING_KEYS))
        logger.debug "Beetle: message sent!"
        published = 1
      rescue Bunny::ServerDownError, Bunny::ConnectionError
        stop!
        mark_server_dead
        tries -= 1
        retry if tries > 0
        logger.error "Beetle: message could not be delivered: #{message_name}"
      end
      published
    end

    def publish_with_redundancy(exchange_name, message_name, data, opts)
      if @servers.size < 2
        logger.error "Beetle: at least two active servers are required for redundant publishing"
        return publish_with_failover(exchange_name, message_name, data, opts)
      end
      published = []
      data = Message.encode(data, :redundant => true, :ttl => opts[:ttl])
      loop do
        break if published.size == 2 || @servers.empty? || published == @servers
        begin
          select_next_server
          next if published.include? @server
          bind_queues_for_exchange(exchange_name)
          logger.debug "Beetle: trying to send #{message_name} to #{@server}"
          exchange(exchange_name).publish(data, opts.slice(*PUBLISHING_KEYS))
          published << @server
          logger.debug "Beetle: message sent (#{published})!"
        rescue Bunny::ServerDownError, Bunny::ConnectionError
          stop!
          mark_server_dead
        end
      end
      case published.size
      when 0
        logger.error "Beetle: message could not be delivered: #{message_name}"
      when 1
        logger.warn "Beetle: failed to send message redundantly"
      end
      published.size
    end

    def re_publish(server, message_name, data, opts = {})
      opts = @client.messages[message_name].merge(opts.symbolize_keys)
      exchange_name = opts[:exchange]
      recycle_dead_servers unless @dead_servers.empty?
      set_current_server server
      bind_queues_for_exchange(exchange_name)
      exchange(exchange_name).publish(data, opts.slice(*PUBLISHING_KEYS))
    end

    def purge(queue_name)
      each_server do
        queue(queue_name).purge
      end
    end

    def stop
      each_server { stop! }
    end

    private

    def bunny
      @bunnies[@server] ||= new_bunny
    end

    def new_bunny
      b = Bunny.new(:host => current_host, :port => current_port, :logging => !!@options[:logging])
      b.start
      b
    end

    def recycle_dead_servers
      recycle = []
      @dead_servers.each do |s, dead_since|
        recycle << s if dead_since < 10.seconds.ago
      end
      @servers.concat recycle
      recycle.each {|s| @dead_servers.delete(s)}
    end

    def mark_server_dead
      logger.info "Beetle: server #{@server} down: #{$!}"
      @dead_servers[@server] = Time.now
      @servers.delete @server
      @server = @servers[rand @servers.size]
    end

    def select_next_server
      return logger.error("Beetle: message could not be delivered: #{message_name} - no server available") && 0 if @servers.empty?
      set_current_server(@servers[((@servers.index(@server) || 0)+1) % @servers.size])
    end

    def create_exchange!(name, opts)
      bunny.exchange(name, opts)
    end

    def bind_queues_for_exchange(exchange_name)
      @client.exchanges[exchange_name][:queues].each {|q| queue(q) } if queues.empty?
    end

    # TODO: Refactor, fethch the keys and stuff itself
    def bind_queue!(queue_name, creation_keys, exchange_name, binding_keys)
      queue = bunny.queue(queue_name, creation_keys)
      queue.bind(exchange(exchange_name), binding_keys)
      queue
    end

    def stop!
      begin
        bunny.stop
      rescue Exception
        Beetle::reraise_expectation_errors!
      ensure
        @bunnies[@server] = nil
        @exchanges[@server] = {}
        @queues[@server] = {}
      end
    end
  end
end
