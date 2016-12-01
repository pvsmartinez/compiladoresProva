#!/usr/bin/env ruby

require_relative 'lexico'

def initCompiler(file = "./programa.txt")
  Lexico.getTokensFromFile file
end

initCompiler
