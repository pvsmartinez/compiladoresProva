#!/usr/bin/env ruby

require_relative 'token'

class Lexico

  attr_reader :tokens

  def initialize(filename)
    @tokens = Array.new
    File.foreach(filename).with_index do |line, line_num|
      next if line.match /^\/\// #comentários são ignorados
      next if line.match /^$/ #linhas vazias são puladas

      words = line.split ' '

      words.each do | word | #cria cada token
        if word.match /(:|!)$/
          @tokens.push Token.new(word[0..-2])
          @tokens.push Token.new(word[-1])
        else
          @tokens.push Token.new(word)
        end
      end

      @tokens.push Token.new('') #adiciona o token EOL
    end

    @tokens.each do | token |
      puts token.value + '::' + token.kind.to_s
    end

  end

end
