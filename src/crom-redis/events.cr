module CROM::Redis
  
  module Events

    def after_delete(arg)
      @redis_id = nil if arg
    end


  end

end