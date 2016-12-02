#!/usr/bin/env ruby

require_relative 'automato'

class Sintatico

  attr_reader :automatos

  def initialize(tokens, filename)
    createAutomatos filename
    start tokens
  end

  def start(tokens)

    pilha = Array.new
    text = ''
    machine = Automato.newMachine 'PROG'

    @@termList = nil

    updateTerm tokens

    until tokens.nil? do
      puts machine.name + '(' + machine.currentState.to_s + ',' + @@term + ')'

      transition = machine.getTransitionForTerm @@term

      if transition.nil?
        if machine.endStates.index(machine.currentState.to_s).nil?
          puts 'Should reject code! Ended on non endState'
          return
        else
          machine = pilha.pop
          updateTerm tokens
        end
      else
        machine.currentState = transition[2].to_i
        if transition[1].match /^"/
          text += transition[1].gsub(/\"/,'')
          updateTerm tokens
        else
          pilha.push machine
          machine = Automato.newMachine transition[1]
        end
      end

    end

    puts text

  end

  def updateTerm(tokens)
    if @@termList.nil? || @@termList.empty?
      @@token = tokens.shift
      if @@token.isReservedWord
        @@term = @@token.value == '' ? 'EOL' : @@token.value
        @@termList = nil
      else
        @@termList = @@token.value.split ''
        @@term = @@termList.shift
      end
    else
      @@term = @@termList.shift
    end
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
        @automatos.push Automato.addTemplate(name, initial, final, transitions)
        transitions = Array.new
      else
        words = line.gsub(/\n/,'').split /,? /
        first = words.shift
        case first
        when 'automato:'
          name = words.first
        when 'initial:'
          initial = words.first
        when 'final:'
          final = words
        else
          unless line.strip.match '---'
            transitions.push [first[1..-1], words.first[0..-2], words.last]
          end
        end
      end
    end

    Automato.defineFirsts

  end

end
