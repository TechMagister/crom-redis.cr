module CROM::Redis
  
  module Events

    def after_delete(arg)
      @id = nil if arg
    end


  end

end