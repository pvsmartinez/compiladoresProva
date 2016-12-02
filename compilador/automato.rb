#!/usr/bin/env ruby

class Automato

  attr_accessor :currentState

  attr_reader :name
  attr_reader :states
  attr_reader :initial
  attr_reader :endStates
  attr_reader :transitions
  attr_reader :firsts

  @@templates = Hash.new

  def self.addTemplate(name, initial, final, transitions)
    template = Automato.new(name, initial, final, transitions)
    @@templates[name] = template
  end

  def self.newMachine(name)
    newMachine = @@templates[name]
    newMachine.currentState = newMachine.initial
    return newMachine
  end

  def self.defineFirsts
    @@templates['PROG'].defineFirst
  end

  def initialize(name, initial, final, transitions)
    @name = name
    @initial = initial.to_i
    @currentState = initial.to_i
    @endStates = final
    @transitions = transitions
    @firsts = Hash.new
  end

  def defineFirst
    #TODO: Aqui está o erro.
    # o @firsts só olha o first do estado inicial.
    # Precisa ter um desse para cada estado
    # é por isso que no exemplo atual o LABEL(1,9) volta para INST(2,9)
    # quando deveria ir para DIG(0,9) - Automato(estado, token)
    # algo como @firsts[estado][token] deve funcionar
    # mas precisa atualizar a criação dessa estrutura
    # e os lugares que o usam
    transi = @transitions.find_all do | transition |
      @initial == transition.first.to_i
    end

    transi.each do | transition |
      term = transition[1]
      if term.match /^"/
        @firsts[term.gsub(/\"/,'')] = term.gsub(/\"/,'')
      else
        if term != @name
          @@templates[term].defineFirst if @@templates[term].firsts.empty?
          concatFirsts term
        else
          puts 'tem que pegar os follows do ' + term + '?'
        end
      end
    end

    return @firsts
  end

  def concatFirsts(name)
    @@templates[name].defineFirst.each do | key, value |
      ky = key.gsub(/\"/,'')
      if @firsts.key?(ky)
        next if @firsts[ky] == name
        puts 'ambiguous language! ' + @firsts[ky] + ' or ' + name + '?'
      else
        @firsts[ky] = name
      end
    end
  end

  def getTransitionForTerm(term)
    token = @firsts[term]

    transi = @transitions.select do | transition |
      transition.first.to_i == @currentState && transition[1].gsub(/\"/,'') == token
    end

    if transi.nil?
      return nil
    else
      if transi.length > 1
        puts 'ambiguous language! ' + transi.to_s
      else
        return transi.first
      end
    end

  end




end
