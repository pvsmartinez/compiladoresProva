#!/usr/bin/env ruby

module ReservedWorlds
  NOP = 1
  READ = 2
  LOAD = 3
  ADD = 4
  PRINT = 5
  INSTRUCTION = 6
  DATA = 7
  RESULT = 8
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
