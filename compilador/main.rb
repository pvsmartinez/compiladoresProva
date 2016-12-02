#!/usr/bin/env ruby

require_relative 'lexico'
require_relative 'sintatico'

def initCompiler(file = "./programa.txt")
  lexico = Lexico.new file
  sintatico = Sintatico.new(lexico.tokens,"compilador/automatos.txt")
end

initCompiler
