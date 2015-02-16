#
# class Storage
#
class Storage
  def initialize(input = nil)
    @root = PrefixTree.new('')
    add(input) unless input.nil?
  end

  def add(input)
    if input.is_a?(Array)
      input.each { |word| @root.add_children(word) }
    elsif input.is_a?(String)
      words = input.split(',')
      words.each { |word| @root.add_children(word.strip) }
    else
      fail ArgumentError
    end
  end

  def contains?(word)
    @root.include_word?(word)
  end

  def find(string)
    chars_array = string.chars
    fail 'String is less than 3 symbols!' if chars_array.length < 3
    @root.generate_from_string(string)
  end

  def all
    @root.generate_words
  end
  #
  # class PrefixTree
  # Just a tree
  #
  class PrefixTree
    def initialize(value, children = [])
      @value = value
      first = children.shift
      @children = []
      leaf = children.empty? && first.nil?
      @children << PrefixTree.new(first, children) unless leaf
    end

    def add_children(word)
      word = word.chars unless word.is_a?(Array)
      create_or_insert(word)
    end

    def include_word?(word)
      return true if word.empty?
      word = word.chars unless word.is_a?(Array)
      result = false
      first = word.shift
      @children.each do |child|
        result |= child.include_word?(word) if child == first
      end
      result
    end

    def generate_from_string(word, full_string = word)
      return form_words(full_string) if word.empty?
      word = word.chars unless word.is_a?(Array)
      first = word.shift
      words = []
      @children.each do |child|
        words = child.generate_from_string(word, full_string) if child == first
      end
      words
    end

    def generate_words
      iteration = []
      return [@value] if @children.empty?
      @children.each do |child|
        child_words = child.generate_words
        iteration << child_words.map { |word| @value.to_s + word.to_s }
      end
      iteration.flatten
    end

    def ==(other)
      @value == other
    end

    private

    def form_words(full_string)
      result = []
      @children.each do |child|
        result << child.generate_words
      end
      result.flatten.map { |part| full_string + part }
    end

    def create_or_insert(children)
      first_letter = children.shift
      child = @children.find { |e| e == first_letter }
      if child.nil?
        @children << PrefixTree.new(first_letter, children)
      else
        child.add_children(children)
      end
    end
  end
end
