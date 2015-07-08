#!/usr/bin/ruby

require './markov'

class Ai
	def initialize()
		@markov = Markov.new
		#load()
	end

	def load()
		save_file = "/var/tmp/hoge.b"
		@markov.load(save_file)
	end

	def load_new_sentence(line)
		@markov.register(line)
		@markov.dic
	end


	def learn
		file = "/var/tmp/hoge.b"
		@markov.save(file)
	end


	def conversate
		loop do
			sentence = ""
			print('YOU: ')
			line = gets.chomp
			break if line.empty?

			morphemes = Morpheme::analyze(line)

			morphemes.find do |morpheme| 
				#boy, noun
				word, part = morpheme[0].split(/\t/)
				if Morpheme::noun?(part)
					sentence = @markov.generate(word)
				end
			end
			puts "AI : #{sentence}"
		end
	end
	attr_reader :markov
end
