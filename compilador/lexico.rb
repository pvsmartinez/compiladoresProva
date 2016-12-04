#!/usr/bin/env ruby

require_relative 'token'

class Lexico

  attr_reader :tokens
  attr_reader :labels

  def initialize(input_file_name)

    @tokens = []
    @labels = {}
    base_address = 256
    address_deslocation = 0

    # puts ''
    # puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    # puts '- A N A L I S A D O R   L E X I C O -'
    # puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    # puts ''

    File.foreach(input_file_name).with_index do |line, line_num|
      next if line.match /^\/\// #comentários são ignorados
      next if line.match /^$/ #linhas vazias são puladas
      # puts 'Identificando tokens e rotulos: \'' + line[0..-2] + '\''
      puts 'tokenizing ' + (base_address + address_deslocation).to_s + ' [' + line[0..-2] + ']'
      words = line.split ' '

      words.each do | word | #cria cada token

        if word.match /(:)$/
          @labels[word[0..-2]] = base_address + address_deslocation
          # puts ' (r) token: (lexeme: ' + word[0..-2] + ')'
          @tokens << Token.new(word[0..-2])
          # address_deslocation += 1

          # puts '     token: (lexeme: ' + word[-1] + ')'
          @tokens << Token.new(word[-1])
          # address_deslocation += 1

        elsif word.match /(!)$/
          # puts '     token: (lexeme: ' + word[0..-2] + ')'
          @tokens << Token.new(word[0..-2])
          address_deslocation += 1

          # puts '     token: (lexeme: ' + word[-1] + ')'
          @tokens << Token.new(word[-1])
          address_deslocation += 1

        elsif word.match /^[0-9]*$/

          # puts '     token: (lexeme: ' + word + ')'
          @tokens << Token.new(word)
          address_deslocation += 2

        else
          # puts '     token: (lexeme: ' + word + ')'
          @tokens << Token.new(word)
          address_deslocation += 1
        end
      end

      # puts '     token: (lexeme: EOL)'
      @tokens << Token.new("EOL")
    end

    # puts 'Foram identificados [' + @tokens.length.to_s + '] tokens, entre eles [' + @labels.length.to_s + '] rotulos: '

  end

end
