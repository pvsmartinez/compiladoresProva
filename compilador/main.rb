#!/usr/bin/env ruby

require_relative 'lexico'
require_relative 'sintatico'

def initCompiler(file = "./programa.txt")
  lexico = Lexico.new file
  sintatico = Sintatico.new "compilador/wirth.txt"
end

initCompiler
