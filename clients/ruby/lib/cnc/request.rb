module CNC
  class Request
    @req = nil

    def initialize(opts)
      @req = Mechanize.new.tap do |r|
        if opts[:proxy_host]
          r.set_proxy(opts[:proxy_host], opts[:proxy_port])
        end

        if opts[:server].match(/^https/)  # enable SSL/TLS
          r.agent.ca_file = opts[:cert_path]
        end
      end
    end

    def method_missing(method_id, *args, &block)
      if @req.respond_to?(method_id)
        @req.public_send(method_id, *args, &block)
      else
        throw "Not Sure What Happened"
      end
    end
  end
end