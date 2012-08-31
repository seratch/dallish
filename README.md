# Dallish

Dallish is an extended [Dalli](https://github.com/mperham/dalli) for memcached 1.4.x.

https://rubygems.org/gems/dallish


## Note

Dallish is slower than Dalli. Just use as a tool for debugging or management.

The methods by Dallish won't work with memcached 1.6 or higher.

## How to use?

```
gem install dallish
```

Try it out as follows.

```ruby
require 'dallish'

dallish = Dallish.new('localhost:11211')

# methods by Dalli

dallish.set('foo', 123)
dallish.set('fooo', 234)
dallish.set('bar', 345)
dallish.set('baz', 456)

dallish.get('foo') # => 123

# methods by Dallish

dallish.all_keys # => [foo,fooo,bar,baz]

dallish.find_keys_by(/foo.+/) # => [foo,fooo]

dallish.find_all_by(/foo.+/) # => {"foo"=>123,"fooo"=>234,"bar"=>345,"baz"=>456}

dallish.delete_all_by(/foo.+/) # 'foo', 'fooo' will be deleted
```

## License

The MIT License

