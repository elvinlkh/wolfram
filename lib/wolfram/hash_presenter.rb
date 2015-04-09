module Wolfram
  class HashPresenter
    attr_reader :result

    def initialize(result)
      @result = result
    end

    def to_hash
      {
        :pods => pods_to_hash,
        :assumptions => assumptions_to_hash
      }
    end

    private

    def pods_to_hash
      pods.inject Hash.new do |hash, pod|
        hash.update pod.title => {
          txt: pod.subpods.map(&:plaintext)[0], 
          img: pod.subpods.map(&:img).map(&:attributes)[0]["src"].value
        }
      end
    end

    def assumptions_to_hash
      assumptions.inject Hash.new do |hash, assumption|
        hash.update assumption.name => {
          txt: assumption.values.map(&:desc),
          query: assumption.values.map(&:input)
        }
      end
    end

    def method_missing(method, *args, &block)
      if result.respond_to? method
        result.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(meth, include_private)
      result.respond_to?(meth, include_private) || super
    end
  end
end
