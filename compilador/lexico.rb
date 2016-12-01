#!/usr/bin/env ruby

class Lexico

  def self.getTokensFromFile(filename)
    @tokens = Array.new
    File.foreach(filename).with_index do |line, line_num|

      words = line.split(/\W+/)
      next if words.length == 0

      words.each do | world |
        @tokens.push(world)
      end

      @tokens.push('NOP')
    end

    puts @tokens

  end

end
