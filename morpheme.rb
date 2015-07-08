#!/usr/bin/ruby

require 'natto'

module Morpheme
	def self.analyze(line)
		morphemes = []

		natto = Natto::MeCab.new
		natto.parse(line) do |nt|
			morphemes.push(["#{nt.surface}\t#{nt.feature}"])
		end

		return morphemes
	end

	def self.noun?(part)
		#return /名詞-(一般|固有名詞|サ変接続|形容動詞語幹)/ =~ part
		return /名詞/ =~ part
	end
end

