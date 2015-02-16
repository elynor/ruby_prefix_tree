require 'simplecov'
SimpleCov.start
require 'test/unit'
require './prefix_tree'
#
# class PrefixTreeTest
# Just a testing class
#
class PrefixTreeTest < Test::Unit::TestCase
  def setup
    @storage = Storage.new('willow, willy, volley, wall')
  end

  def test_all
    assert_equal %w(willow willy wall volley), @storage.all
  end

  def test_contains_existing_word
    assert @storage.contains?('wil')
  end

  def test_find_existing_word
    assert_equal ['willow'], @storage.find('willo')
  end

  def test_find_non_existing_word
    assert_equal [], @storage.find('dobby')
  end

  def test_find_too_short_string
    assert_raise RuntimeError do
      @storage.find('do')
    end
  end

  def test_not_contains_word
    assert_equal false, @storage.contains?('dobby')
  end

  def test_adding
    @storage.add('dobby, batman')
    assert @storage.contains?('batman')
  end

  def test_array_adding
    @storage.add(%w(robin duck))
    assert @storage.contains?('duck')
  end

  def test_unknown_input
    assert_raise ArgumentError do
      @storage.add(42)
    end
  end
end
