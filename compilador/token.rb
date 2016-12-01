#!/usr/bin/env ruby

require_relative 'constants'

class Token

  attr_reader :value
  attr_reader :kind

  def initialize(value)
    @value = value
    setKind value
  end

  def setKind(value)
    case value
    when ReservedWorlds::NOP
      @kind = TokenKind::TYPE_OPERATOR_NO_EXP
    when ReservedWorlds::READ || ReservedWorlds::PRINT
      @kind = TokenKind::TYPE_OPERATOR_ONE_EXP
    when ReservedWorlds::LOAD || ReservedWorlds::ADD
      @kind = TokenKind::TYPE_OPERATOR_TWO_EXP
    when ReservedWorlds::INSTRUCTION || ReservedWorlds::DATA || ReservedWorlds::RESULT
      @kind = TokenKind::TYPE_REGISTER
    else
      if value.match /^[A-Za-z]/
        @kind = TokenKind::TYPE_LABEL
      elsif value.match /(:|!|^$)/
        @kind = TokenKind::TYPE_EXPECIAL_CHAR
      else
        @kind = TokenKind::TYPE_NUM
      end
    end
  end

end
