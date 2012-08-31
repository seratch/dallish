# -*- encoding: utf-8 -*-

require 'dallish'
require 'logger'

describe Dallish do

  before do
    @dallish = Dallish.new(
        :servers => ["localhost:11211", 'memcached:11211'],
        :log_level => Logger::INFO
    )
  end

  it "should be also created with Dalli style args" do
    dallish = Dallish.new('localhost:11211')
    dallish.should_not be(nil)
    keys = dallish.all_keys
    keys.should_not be(nil)
    keys.size.should > 0
  end

  it "should be created" do
    dallish = Dallish.new(:servers => "localhost:11211")
    dallish.should_not be(nil)
    keys = dallish.all_keys
    keys.should_not be(nil)
    keys.size.should > 0
  end

  it "should get all keys" do
    keys = @dallish.all_keys
    keys.should_not be(nil)
    keys.size.should > 0
  end

  it "should find_keys_by regexp" do
    (1..100).each { |i| @dallish.set("foo_#{i}", 123) }
    keys = @dallish.find_keys_by(/foo_\d+$/)
    keys.size.should >= 100
  end

  it "should delete_all_by regexp" do
    (1..100).each { |i| @dallish.set("to_delete_#{i}", 123) }
    keys = @dallish.find_keys_by(/to_delete_\d+$/)
    keys.size.should >= 100

    @dallish.delete_all_by(/to_delete_\d+$/)

    keys = @dallish.find_keys_by(/to_delete_\d+$/)
    keys.size.should == 0
  end

  it "should find_all_by regexp" do
    (1..100).each { |i| @dallish.set("to_get_#{i}", 123) }
    keys = @dallish.find_keys_by(/to_get_\d+$/)
    keys.size.should >= 100

    results = @dallish.find_all_by(/to_get_\d+$/)
    results.keys.size.should >= 100
  end

  it "should have dalli's methods" do
    @dallish.set("foo", 123)
    @dallish.set("bar", 234)
    @dallish.get("foo").should == 123
    @dallish.get_multi("foo", "bar").size.should == 2
    @dallish.fetch("foo").should == 123
  end

end
