#!/usr/bin/env ruby

require_relative 'lexico.rb'

def initCompiler(file = "./programa.txt")
  Lexico.getTokensFromFile file
end

initCompiler
