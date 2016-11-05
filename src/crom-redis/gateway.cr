require "crom"
require "redis"

module CROM::Redis
  
  class Gateway < CROM::Gateway

    COUNTER_NAME = "incr_counter_"

    @uri : URI

    private def not_nil_or_empty(str : String?, default : String)
      return default if str.nil?
      return default if str.empty?
      return str.not_nil!
    end

    def initialize(@uri, **options)
    # (host = "localhost", port = 6379, unixsocket = nil, password = nil, database = nil)
      database = @uri.path
      if database && !database.empty?
        database = database[1, database.size]
      else
        database = nil
      end

      host = not_nil_or_empty(@uri.host, "localhost")
      port = @uri.port || 6379
      @redis = ::Redis.new host, port, nil, @uri.password, nil
    end

    def insert(**args)
      @redis.incr(COUNTER_NAME + args[:dataset])
      counter = @redis.get(COUNTER_NAME + args[:dataset]).not_nil!
      key = args[:dataset] + counter
      value = args[:value]
      @redis.set(key, value)
      counter
    end

    def update(**args)
      key = args[:dataset] + args[:id]
      value = args[:value]
      @redis.set(key, value)
    end

    def delete(**args)
      key = args[:dataset] + args[:id].to_s
      ret = @redis.del key
      ret == 1
    end

    def all(dataset)
      keys = @redis.keys dataset + "*"
      @redis.mget keys
    end

    def delete_all(dataset)
      keys = @redis.keys dataset + "*"
      keys.each do |k|
        @redis.del k
      end
    end

    def count(dataset)
      keys = @redis.keys dataset + "*"
      keys.size
    end

    def by_id(dataset, id)
      @redis.get(dataset + id.to_s)
    end
    
  end

end

CROM.register_adapter("redis", CROM::Redis::Gateway)