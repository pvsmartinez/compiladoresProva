#!/usr/bin/env ruby

require_relative 'lambda_machine'

class Semantico

  def initialize(lexico)
    @lexico = lexico
    @lambda_machine = Lambda_Machine.new
    @lambda_machine.create_mem
  end

  def semantic_action(token, token_index)
    if !token.opcode.nil?
      @lambda_machine.add_token token.opcode.to_i

    elsif token.type == :TYPE_NUM
      @lambda_machine.add_token token.lexeme.to_i
      @lambda_machine.add_token 255

    elsif token.type == :TYPE_LABEL && !lookahead(token_index, 1).nil? && lookahead(token_index, 1).lexeme != ':'
      @lambda_machine.add_token(@lexico.labels[token.lexeme].to_i)

    elsif token.lexeme == "!"
      @lambda_machine.add_token 255

    end
  end

  def run
    @lambda_machine.execute
  end

  def print_memory
    @lambda_machine.print_mem
  end

  private

  def lookahead(token_index, k)
    if token_index + k < @lexico.tokens.length - 1
      @lexico.tokens[token_index + k]
    else
      return nil
    end
  end

end
