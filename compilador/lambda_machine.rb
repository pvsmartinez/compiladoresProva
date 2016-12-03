#!/usr/bin/env ruby

require_relative 'sintatico'

class Lambda_Machine

  MEM_SIZE = 256

  NOP = 0
  READ = 1
  LOAD = 2
  ADD = 3
  PRINT = 4

  INSTRUCTION = 32
  DATA = 34
  RESULT = 36

  VALUE = 255

  def createMem
    @mem[0..MEM_SIZE] = 0
  end

  def addToken(value)
    @mem[MEM_SIZE] = value
    MEM_SIZE ++
  end

  def execute
    resetPointers

    puts 'read ' + (MEM_SIZE - 256) + ' tokens'

    while get(INSTRUCTION) > 0 && get(INSTRUCTION) < MEM_SIZE
      printString = @mem[INSTRUCTION].to_s + ':'
      readInstruction
      puts printString
    end

    if get(INSTRUCTION) >= MEM_SIZE
      puts 'INFINITY; ready.'
    else
      puts 'ready.'
  end

  private

  def get(address)
    return @mem[address]
  end

  def put(address, value)
    @mem[address] = value
  end

  def readInstruction
    opcode = get(@mem[INSTRUCTION])

    if get(@mem[INSTRUCTION] + 1) == VALUE
      # its a value
      @mem[RESULT] = opcode
      printString += ' ' + @mem[RESULT].to_s
      nextInstruction
      nextInstruction
      return
    end

    case opcode
    when NOP
      printString += ' NOP'
      nextInstruction
    when READ
      printString += ' (read'
      @mem[RESULT] = readParam
      printString += ')'
    when LOAD
      printString += ' load ('
      address = readParam
      printString += ') ('
      value = readParam
      printString += ')'
      puts '[' + address.to_s + ']<--' + value.to_s
      put address value
    when ADD
      printString += ' add ('
      address = readParam
      printString += ') ('
      value = readParam
      printString += ')'
      puts '[' + address.to_s + ']+=' + value.to_s
      sum = get(address) + value
      put address sum
      @mem[RESULT] = get(address)
    when PRINT
      printString += ' print'
      value = readParam
      puts '-->' + value
    else
      if get(opcode + 1) == VALUE
        #variable
        printString += ' read ' + opcode
        @mem[RESULT] = get(opcode)
        nextInstruction
      else
        #jump
        printString += ' jump ' + opcode
        @mem[DATA] = @mem[INSTRUCTION] + 1
        @mem[INSTRUCTION] = opcode
        printString += ' ('
        readInstruction
        printString += ')'
      end
    end
  end

  def readParam
    nextInstruction
    readInstruction
    get @mem[RESULT]
  end

  def nextInstruction
    @mem[INSTRUCTION] ++;
  end

  def resetPointers
    @mem[INSTRUCTION] = 256;
    @mem[INSTRUCTION+1] = VALUE;
    @mem[DATA+1] = VALUE;
    @mem[RESULT+1] = VALUE;

    @mem[RESULT+2] = LOAD;
    @mem[RESULT+3] = INSTRUCTION;
    @mem[RESULT+4] = VALUE;
    @mem[RESULT+5] = 0;
    @mem[RESULT+6] = VALUE; #exit
  end

end
