#!/usr/bin/env ruby

module ReservedWorlds
  NOP = 'nop'
  READ = 'read'
  LOAD = 'load'
  ADD = 'add'
  PRINT = 'print'
  INSTRUCTION = 'instruction'
  DATA = 'data'
  RESULT = 'result'
end

module TokenKind
  TYPE_LABEL = 0
  TYPE_NUM = 1
  TYPE_OPERATOR_NO_EXP = 2
  TYPE_OPERATOR_ONE_EXP = 3
  TYPE_OPERATOR_TWO_EXP = 4
  TYPE_REGISTER = 5
  TYPE_EXPECIAL_CHAR = 6
end
