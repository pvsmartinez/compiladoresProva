#!/usr/bin/env ruby

require_relative 'lexico'
require_relative 'sintatico'

def initCompiler(input_file_name)
  lexico = Lexico.new input_file_name
  sintatico = Sintatico.new(lexico)
end

initCompiler "./ENTRADA.txt"
