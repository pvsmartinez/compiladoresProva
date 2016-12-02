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
      elsif value.match /^[0-9]/
        @kind = TokenKind::TYPE_NUM
      else
        puts 'some error with the tokens - lexico'
      end
    end
  end

  def getTerm
    return @value[0] if !isReservedWord
    return @value == '' ? 'EOL' : @value
  end

  def isReservedWord
    return @kind != TokenKind::TYPE_LABEL && @kind != TokenKind::TYPE_NUM
  end

end
