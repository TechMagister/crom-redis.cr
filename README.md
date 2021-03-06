# crom-redis

Redis backend for [CROM](https://github.com/TechMagister/crom.cr) ( CRystal Object Mapper)

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  crom-redis:
    github: TechMagister/crom-redis.cr
```

## Features
- [x] Insert Basic Object
- [x] Update Basic Object
- [x] Delete Basic Object
- [x] Fetch by Id
- [x] Aggregation support

## Usage


```crystal
require "crom-redis"

class User
  CROM.mapping(:redis, {
    name: String,
    age:  Int32,
  })
end

class Users < CROM::Redis::Repository(User)
end

crom = CROM.container("redis://") # eq redis://localhost:6379

# user_repo = Users.new crom
# or
# CROM.register_repository Users.new crom
# if repo = Users.repo
#   ... do stuff ...
# end

```


## Development

To run spec, run a redis server and configure the URI in ./spec/spec_helper.cr

## Contributing

1. Fork it ( https://github.com/TechMagister/crom-redis.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TechMagister](https://github.com/TechMagister) Arnaud Fernandés - creator, maintainer
