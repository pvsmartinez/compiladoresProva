#!/usr/bin/env ruby

require 'set'

class Automata

  attr_accessor :current_state
  attr_accessor :name
  attr_accessor :initial_state
  attr_accessor :final_states
  attr_accessor :transitions
  attr_accessor :terminals
  attr_accessor :nonterminals
  attr_accessor :subautomatas_terminals

  def initialize(name)
    @name = name
    @transitions = {}
    @terminals = []
    @nonterminals = []
    @subautomatas_terminals = {}
  end

  def add_transition(state, input, next_state)
    @transitions[state] = {} if @transitions[state].nil?
    @transitions[state][input] = next_state
  end
end
