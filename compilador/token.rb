#!/usr/bin/env ruby

require_relative 'constants'

class Token
  def initialize(value)
    @value = value
  end

  def setKind(value)
    case value
    when ReservedWorlds::NOP
      @kind = TokenKind::TYPE_OPERATOR_NO_EXP
    when ReservedWorlds::READ
      @kind = TokenKind::TYPE_OPERATOR_ONE_EXP
    when ReservedWorlds::LOAD
      @kind = TokenKind::TYPE_OPERATOR_TWO_EXP
    when ReservedWorlds::ADD
      @kind = TokenKind::TYPE_OPERATOR_TWO_EXP
    when ReservedWorlds::PRINT
      @kind = TokenKind::TYPE_OPERATOR_ONE_EXP
    when ReservedWorlds::INSTRUCTION
      @kind = TokenKind::TYPE_REGISTER
    when ReservedWorlds::DATA
      @kind = TokenKind::TYPE_REGISTER
    when ReservedWorlds::RESULT
      @kind = TokenKind::TYPE_REGISTER
    end
  end
end
