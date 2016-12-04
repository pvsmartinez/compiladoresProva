#!/usr/bin/env ruby

class Lambda_Machine

  @@mem_size = 256

  NOP   = 0
  READ  = 1
  LOAD  = 2
  ADD   = 3
  PRINT = 4

  INSTRUCTION = 32
  DATA        = 34
  RESULT      = 36

  VALUE = 255

  def print_mem
    @mem[256..-1].each_with_index {|mem_pos, index| puts (VALUE + index + 1).to_s + ': ' + mem_pos.to_s }
  end

  def create_mem
    @mem = []
    @mem[0..@@mem_size] = 0

  end

  def add_token(value)
    @mem[@@mem_size] = value
    @@mem_size += 1
  end

  def execute
    resetPointers

    puts 'read ' + (@@mem_size - 255).to_s + ' tokens'
    puts 'executing'

    while get(INSTRUCTION) > 0 && get(INSTRUCTION) < @@mem_size
      @printString = @mem[INSTRUCTION].to_s + ':'
      readInstruction
      puts @printString
    end

    if get(INSTRUCTION) >= @@mem_size
      puts 'INFINITY; ready.'
    else
      puts 'ready.'
    end
  end

  private

  def get(address)
    @mem[address]
  end

  def put(address, value)
    @mem[address] = value
  end

  def readInstruction
    opcode = get(@mem[INSTRUCTION])

    if opcode.nil?
      opcode = NOP
    end

    if get(@mem[INSTRUCTION] + 1) == VALUE
      # its a value
      @mem[RESULT] = opcode
      @printString += ' ' + @mem[RESULT].to_s
      nextInstruction 2
      return
    end

    case opcode
    when NOP
      @printString += ' nop'
      nextInstruction
    when READ
      @printString += ' (read'
      @mem[RESULT] = get readParam
      @printString += ')'
    when LOAD
      @printString += ' load ('
      address = readParam
      @printString += ') ('
      value = readSecondParam
      @printString += ')'
      puts '[' + address.to_s + ']<--' + value.to_s
      put(address, value)
    when ADD
      @printString += ' add ('
      address = readParam
      @printString += ') ('
      value = readSecondParam
      @printString += ')'
      puts '[' + address.to_s + ']+=' + value.to_s
      sum = get(address) + value
      put(address, sum)
      @mem[RESULT] = get(address)
    when PRINT
      @printString += ' print'
      value = readParam
      puts '-->' + value.to_s
    else
      if get(opcode + 1) == VALUE
        #variable
        @printString += ' read ' + opcode.to_s
        @mem[RESULT] = get(opcode)
        nextInstruction
      else
        #jump
        @printString += ' jump ' + opcode.to_s
        @mem[DATA] = @mem[INSTRUCTION] + 1
        @mem[INSTRUCTION] = opcode
        @printString += ' ('
        readInstruction
        @printString += ')'
      end
    end
  end

  def readParam
    nextInstruction
    readInstruction
    get RESULT
  end

  def readSecondParam
    readInstruction
    get RESULT
  end

  def nextInstruction(steps = 1)
    @mem[INSTRUCTION] += steps
  end

  def resetPointers
    @mem[INSTRUCTION] = 256
    @mem[INSTRUCTION+1] = VALUE
    @mem[DATA+1] = VALUE
    @mem[RESULT+1] = VALUE

    @mem[RESULT+2] = LOAD
    @mem[RESULT+3] = INSTRUCTION
    @mem[RESULT+4] = VALUE
    @mem[RESULT+5] = 0
    @mem[RESULT+6] = VALUE #exit
  end

end
