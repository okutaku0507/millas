# Millas

Millas is a simple cache mechanism. In this mechanism, cached values are dispersed and layered in time.

By the way, Millas is a magic cake which becomes 3 layers when baked once. And it is traditional sweets in Landes (France).

![compressed_thumbnail_square_small](https://user-images.githubusercontent.com/4189626/27506204-9d02d5f0-58ee-11e7-8517-8b16a003fd42.png)

## Mechanism

### Dispersed cache

Cached values whose key is appended random and specified number to the end.

### Layered in time

Expiration time of cached values is Layered.

## Usage

It is not conscious of Milas.

```
cache = ActiveSupport::Cache::DalliStore.new

cache.write('millas', 'cake', expires_in: 1.minutes)
# Cache write: millas-1 ({:expires_in=>60 seconds})
# Cache write: millas-2 ({:expires_in=>120 seconds})
# Cache write: millas-3 ({:expires_in=>180 seconds})

cache.read('millas')
# Cache read: millas-2
# => "cake"

cache.exist?('millas')
# Cache exist: millas-1
# => true

cache.delete('millas')
# Cache delete: millas-1
# Cache delete: millas-2
# Cache delete: millas-3
=> true
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'dalli'
gem 'millas'
```

Or install it yourself as:
```bash
$ gem install dalli
$ gem install millas
```

## Copyright
Copyright (c) 2017 Takuya Okuhara. Licensed under the  [MIT License](http://opensource.org/licenses/MIT).
