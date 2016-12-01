#!/usr/bin/env ruby

require_relative 'automato'

class Sintatico

  def initialize(filename)
    createAutomatos filename
  end

  def createAutomatos(filename)
    @automatos = Array.new
    name = ''
    initial = 0
    final = Array.new
    transitions = Array.new

    File.foreach(filename).with_index do |line, line_num|
      next if line.match /^$/ #linhas vazias são puladas

      if line.strip.match '---'
        @automatos.push Automato.new(name, initial, final, transitions)
        transitions = Array.new
      else
        words = line.gsub(/\n/,'').split /,? /
        first = words.shift
        case first
        when 'automato:'
          name = words.first
        when 'initial:'
          initial = words
        when 'final:'
          final = words
        else
          unless line.strip.match '---'
            transitions.push [first, words.first, words.last]
          end
        end
      end
    end

  end

end
