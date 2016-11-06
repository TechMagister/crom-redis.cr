require "json"

module CROM::Redis
  
  class Repository(T) < CROM::Repository(T)

    def self.from_json(parser : ::JSON::PullParser) : T
      key = parser.read_string
      self[key].not_nil!
    end

    private def gateway
      container.gateway
    end

    private def prepare_data(model : T)
      data = model.to_crom.to_h
      data.each { |k, v|
        if v.responds_to? :redis_id
          data[k] = v.redis_id
        end
      }
      data.to_json
    end

    # Method used to get a model by id
    #
    # ```
    # model = repository[12]
    # if mymodel = model
    #   # do stuff with mymodel
    # end
    # ```
    def [](id : String?)
      if id && (ret = gateway.by_id(T.dataset, id))
        model = T.from_json(ret)
        model.redis_id = id
        model
      end
    end

    # Get all the models in the repository
    def all()
      array = gateway.all(T.dataset)
      result = [] of T
      array.each do |ret|
        result << T.from_json ret.to_s
      end
      result
    end

    # execute insert operation
    def do_insert(model : T, *args)
      data = prepare_data(model)
      id = gateway.insert(dataset: T.dataset, value: data)
      model.redis_id = id
      model
    end

    #execute update
    def do_update(model : T, *args)
      data = prepare_data(model)
      gateway.update dataset: T.dataset, id: model.redis_id.not_nil!, value: data
      self.[model.redis_id.not_nil!]
    end

    # execute delete
    def do_delete(model : T, *args)
      gateway.delete dataset: T.dataset, id: model.redis_id
    end

    def delete_all()
      gateway.delete_all(T.dataset)
    end

    def count()
      gateway.count(T.dataset)
    end
    
  end

end