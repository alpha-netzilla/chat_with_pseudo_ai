#!/usr/bin/ruby

require './ai'

ai = Ai.new

read_file = "brain.txt"
open(read_file, 'r') do |file|
	file.each do |line|
		ai.load_new_sentence(line)
	end
end


ai.conversate()

ai.learn()

