require "crom"

require "./crom-redis/*"

module CROM
  
  macro redis_adapter(properties)

    include CROM::Redis::Events

    property id : String?

    JSON.mapping({{properties}})

  end
  
end
