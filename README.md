# Dallish

Dallish is an extended [Dalli](https://github.com/mperham/dalli) for memcached 1.4.x.

## Note

Dallish is slower than Dalli, so just use as a tool for debugging or management.

Unfortunately, the methods by Dallish won't work with memcached 1.6 or higher.

## How to use?

First, get Dallish.

```
gem install dallish
```

And then, try it as follows.

```ruby
require 'dallish'

dallish = Dallish.new('localhost:11211')

# methods by Dalli
dallish.set('foo', 123)
dallish.set('fooo', 234)
dallish.set('bar', 345)
dallish.set('baz', 456)

dallish.get('foo') # => 123

# mehods by Dallish
dallish.all_keys # => [foo,fooo,bar,baz]

dallish.find_keys_by(/foo.+/) # => [foo,fooo]

dallish.find_all_by(/foo.+/) # => 

dallish.delete_all_by(/foo.+/)
```

## License

The MIT License
