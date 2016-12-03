#!/usr/bin/env ruby

require_relative 'sintatico'

class Lambda_Machine

  MEM_SIZE = 512

  attr_reader :mem #array com [512] posições.
  attr_reader :instruction #registrador
  attr_reader :data #registrador
  attr_reader :result #registrador

  def createMem
    mem[0..MEM_SIZE] = 0
  end

  def put(address, value)
    mem[address] = value
  end

end
