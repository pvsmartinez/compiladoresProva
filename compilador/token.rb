#!/usr/bin/env ruby

class Token

  attr_reader :lexeme
  attr_reader :type
  attr_reader :opcode

  def initialize(lexeme)
    @lexeme = lexeme
    set_type_and_opcode lexeme
  end

  def set_type_and_opcode(lexeme)
    case lexeme
    when "nop"
      @opcode = 0
      @type = :TYPE_OPERATOR_NO_EXP

    when "read"
      @opcode = 1
      @type = :TYPE_OPERATOR_ONE_EXP

    when "load"
      @opcode = 2
      @type = :TYPE_OPERATOR_TWO_EXP

    when "add"
      @opcode = 3
      @type = :TYPE_OPERATOR_TWO_EXP

    when "print"
      @type = :TYPE_OPERATOR_ONE_EXP
      @opcode = 4

    when "instruction"
      @type = :TYPE_REGISTER
      @opcode = 32

    when "data"
      @type = :TYPE_REGISTER
      @opcode = 34

    when "result"
      @type = :TYPE_REGISTER
      @opcode = 36

    when "EOL"
      @type = :TYPE_EOL

    when "!"
      @type = :TYPE_SPECIAL_CHARACTER

    when ":"
      @type = :TYPE_SPECIAL_CHARACTER

    when /^[0-9]+/
      @type = :TYPE_NUM

    when /[a-zA-Z]+/
      @type = :TYPE_LABEL

    else

      puts '>> Error: Token (' + lexeme.to_s + ') not valid!'
    end
  end

  def is_reserved_word?
    return @type != :TYPE_LABEL && @type != :TYPE_NUM
  end

end
