#!/usr/bin/ruby

require './morpheme'

class Markov
	include Morpheme

	ENDMARK = '%END%'
	CHAIN_MAX = 30

	def initialize
		@dic = {}
		@starts = {}
	end

	def register(line)
		lines = line.chomp.split(/[。?？!！ 　]+/)

		lines.each do |line|
			next if line.empty?

			morphemes = Morpheme::analyze(line)
			add_sentence(morphemes)
		end
	end

  #parts:  [
  #          ['I', 'noun'], - prefix1
  #          ['am', '-'],   - prefix2
  #          ['a' , '-'],
  #          ['boy', 'noun']
  #        ]
	def add_sentence(morphemes)
		return if morphemes.size < 3

		morphemes = morphemes.dup
		prefix1 = morphemes.shift[0].split(/\t/)[0]
		prefix2 = morphemes.shift[0].split(/\t/)[0]

		add_start(prefix1)

		morphemes.each do |suffix|
			suffix = suffix[0].split(/\t/)[0]

			if suffix == ""
				add_suffix(prefix1, prefix2, ENDMARK)
				next
			end

			add_suffix(prefix1, prefix2, suffix)
			prefix1, prefix2 = prefix2, suffix
		end
  end


	def generate(keyword)
		return nil if @dic.empty?

		words = []
		prefix1 = (@dic[keyword])? keyword : select_start
		prefix2 = select_random(@dic[prefix1].keys)
		words.push(prefix1, prefix2)

		CHAIN_MAX.times do
			suffix = select_random(@dic[prefix1][prefix2])
			break if suffix == ENDMARK
			words.push(suffix)
			prefix1, prefix2 = prefix2, suffix
		end

    return words.join
  end

  def add_suffix(prefix1, prefix2, suffix)
    @dic[prefix1] = {} unless @dic[prefix1]
    @dic[prefix1][prefix2] = [] unless @dic[prefix1][prefix2]
    @dic[prefix1][prefix2].push(suffix)
  end

  def add_start(prefix1)
		@starts[prefix1] = 1 unless @starts[prefix1]
    #@starts[prefix1] += 1
  end

  def select_start
    return select_random(@starts.keys)
  end

	def select_random(ary)
		return ary[rand(ary.size)]
	end

  def load(file)
		open(file, 'r') do |fp|
    	@dic = Marshal::load(fp)
    	@starts = Marshal::load(fp)
		end
  end

  def save(file)
		open(file, 'w') do |fp|
    	Marshal::dump(@dic, fp)
    	Marshal::dump(@starts, fp)
		end
  end


	attr_reader :dic
	attr_writer :load, :save
end
