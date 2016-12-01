#!/usr/bin/env ruby

class Automato

  attr_reader :name
  attr_reader :currentState
  attr_reader :states
  attr_reader :endStates
  attr_reader :transitions

  def initialize(name, initial, final, transitions)
    @name = name
    @initial = initial
    @endStates = final
    @transitions = transitions
    puts name + ': ini(' + initial.to_s + ') fin' + final.to_s + ')'
  end

end
