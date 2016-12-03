#!/usr/bin/env ruby

require_relative 'constants'

class Token

  attr_reader :lexeme
  attr_reader :kind
  attr_reader :opcode

  def initialize(lexeme)
    @lexeme = lexeme
    set_kind_and_opcode lexeme
  end

  def set_kind_and_opcode(lexeme)
    case lexeme
    when "nop"
      @opcode = 0
      @kind = :TYPE_OPERATOR_NO_EXP

    when "read"
      @opcode = 1
      @kind = :TYPE_OPERATOR_ONE_EXP

    when "load"
      @opcode = 2
      @kind = :TYPE_OPERATOR_TWO_EXP

    when "add"
      @opcode = 3
      @kind = :TYPE_OPERATOR_TWO_EXP

    when "print"
      @kind = :TYPE_OPERATOR_ONE_EXP
      @opcode = 4

    when "instruction"
      @kind = :TYPE_REGISTER
      @opcode = 32

    when "data"
      @kind = :TYPE_REGISTER
      @opcode = 34

    when "result"
      @kind = :TYPE_REGISTER
      @opcode = 36

    when /[a-zA-Z]*/
      @kind = :TYPE_LABEL

    when /[0-9]*/
      @kind = :TYPE_NUM

    when "!" || ":"
      @kind = :TYPE_SPECIAL_CHARACTER

    else
      puts '>> Error: Token not valid!'
    end
  end

  def is_reserved_word?
    return @kind != :TYPE_LABEL && @kind != :TYPE_NUM
  end

end
