#!/usr/bin/env ruby

require_relative 'token'

class Lexico

  attr_reader :tokens

  def initialize(input_file_name)

    @tokens = []
    @labels = {}
    base_address = 256

    puts ''
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts '- A N A L I S A D O R   L E X I C O -'
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts ''

    File.foreach(input_file_name).with_index do |line, line_num|
      next if line.match /^\/\// #comentários são ignorados
      next if line.match /^$/ #linhas vazias são puladas
      puts 'Identificando tokens e rotulos: \'' + line[0..-2] + '\''
      words = line.split ' '

      words.each do | word | #cria cada token

        if word.match /(:)$/
          @labels[word[0..-2]] = base_address + @tokens.length
          puts ' (r) token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: ' + word[0..-2] + ')'
          @tokens << Token.new(word[0..-2])
          puts '     token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: ' + word[-1] + ')'
          @tokens << Token.new(word[-1])

        elsif word.match /(!)$/
          puts '     token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: ' + word[0..-2] + ')'
          @tokens << Token.new(word[0..-2])
          puts '     token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: ' + word[-1] + ')'
          @tokens << Token.new(word[-1])

        else
          puts '     token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: ' + word + ')'
          @tokens << Token.new(word)
        end
      end
      puts '     token: (pos: ' + (base_address + @tokens.length).to_s  + ', name: EOL)'
      @tokens << Token.new("EOL")
    end

    puts 'Foram identificados [' + @tokens.length.to_s + '] tokens, entre eles [' + @labels.length.to_s + '] rotulos: '

  end

end
