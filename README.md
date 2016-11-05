# crom-redis

TODO: Write a description here

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  crom-redis:
    github: TechMagister/crom-redis.cr
```


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
# CROM.register_repository :users, Users.new crom
# if repo = CROM.repository(:users).as(Users)
#   ... do stuff ...
# end

```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/TechMagister/crom-redis.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TechMagister](https://github.com/TechMagister) Arnaud Fernandés - creator, maintainer
