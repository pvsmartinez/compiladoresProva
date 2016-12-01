#!/usr/bin/env ruby

require_relative 'token'

class Lexico

  attr_reader :tokens

  def self.getTokensFromFile(filename)
    @tokens = Array.new
    File.foreach(filename).with_index do |line, line_num|
      next if line.match /^\/\// #comentários são ignorados
      next if line.match /^$/ #linhas vazias são puladas

      words = line.split /\W+/

      words.each do | world |
        @tokens.push Token.new(world) #cria cada token
      end

      @tokens.push Token.new('') #adiciona o token EOL
    end

    @tokens.each do | token |
      puts token.value << '::' + token.kind.to_s
    end

  end

end
