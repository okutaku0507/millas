# Millas

Millas is a simple cache mechanism. In this mechanism, cached values are dispersed and layered in time.

By the way, Millas is a magic cake which becomes 3 layers when baked once. And it is traditional sweets in Landes (France).

<img src="https://user-images.githubusercontent.com/4189626/27506204-9d02d5f0-58ee-11e7-8517-8b16a003fd42.png" width="200px">

## Mechanism

### Dispersed cache

Cached values whose key is appended random and specified number to the end.

<img src="https://user-images.githubusercontent.com/4189626/27507452-b372eebc-590a-11e7-88fc-32cc424454b7.jpg" width="500px">

### Layered in time

Expiration time of cached values is Layered.

<img src="https://user-images.githubusercontent.com/4189626/27507451-b2760260-590a-11e7-90a9-d481cb4e8bc2.png" width="500px">

### Magic number vs Frequency

The lower the frequency, the earlier the expiration of the cache key.

<img src="https://user-images.githubusercontent.com/4189626/41190988-45f8d356-6c23-11e8-968e-11e0381fc63b.png" width="500px">

## Usage

It is not conscious of Milas.

```ruby
cache = ActiveSupport::Cache::DalliStore.new

cache.write('millas', 'cake', expires_in: 1.minutes)
# Cache write: millas-1 ({:expires_in=>60 seconds})
# Cache write: millas-2 ({:expires_in=>120 seconds})
# Cache write: millas-3 ({:expires_in=>180 seconds})
=> 90916417477541888

cache.read('millas')
# Cache read: millas-2
=> "cake"

cache.exist?('millas')
# Cache exist: millas-1
=> true

cache.delete('millas')
# Cache delete: millas-1
# Cache delete: millas-2
# Cache delete: millas-3
=> true
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'millas'
```

Or install it yourself as:
```bash
$ gem install millas
```

## Configuration

```ruby
Millas.configure do |config|
  config.dispersion_number = 5 # default
  config.perform_dispersing = true # default
  config.second_intervals = 60 # default
end
```

If this mechanism is adopted only for a specific part, it should do as follows.

```ruby
Millas.config.perform_dispersing = false

cache.write('millas', 'cake', expires_in: 1.minutes)
# Cache write: millas ({:expires_in=>60 seconds})
=> 883549951894749184

cache.write('millas', 'cake', expires_in: 1.minutes, dispersed: true)
# Cache write: millas-1 ({:expires_in=>60 seconds})
# Cache write: millas-2 ({:expires_in=>120 seconds})
# Cache write: millas-3 ({:expires_in=>180 seconds})
=> 15366844878541553664
```

## Copyright
Copyright (c) 2017 Takuya Okuhara. Licensed under the  [MIT License](http://opensource.org/licenses/MIT).
