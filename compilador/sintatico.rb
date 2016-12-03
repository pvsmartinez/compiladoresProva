#!/usr/bin/env ruby

require_relative 'automata'

class Sintatico

  attr_reader :automatos

  def initialize(lexico)
    @lexico = lexico
    @automata_stack = [] #Array com o nome dos automatos
    create_automatas_from_file "compilador/automatos.txt"
    start_syntactic_analysis
  end

  def start_syntactic_analysis()

    puts ''
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts '- A N A L I S A D O R   S I N T A T I C O -'
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts ''

    @lexico.tokens.each do |token|
      next_state(token)
    end
  end

  private

  def next_state(token)

  end

  def current_automata
    @automata_stack.last
  end

  def push_automata(automata)
    @automata_stack << automata
    puts ''
    puts 'Entrando na submaquina ' + automata
    puts ''
  end

  def pop_automata()
    @automata_stack.pop
  end

  def create_automatas_from_file(filename)
    @automatas = {}
    automata_name = ''

    File.foreach(filename).with_index do |line, line_num|
      next if line.match /^$/ #linhas vazias são puladas

      if line.match /^automato:/
        automata_name = line.split(' ')[-1]
        @automatas[automata_name] = Automata.new(automata_name)
        push_automata automata_name if @automatas.length == 1

      elsif line.match /^initial:/
        @automatas[automata_name].initial_state = line.gsub(',','').split(' ')[-1]
        @automatas[automata_name].current_state = @automatas[automata_name].initial_state

      elsif line.match /^final:/
        @automatas[automata_name].final_states = line.gsub(',','').split(' ')[1..-1]

      else
        sanitized_line = line.gsub(/[\(\),\s\-\\">]/,' ').split(' ')
        @automatas[automata_name].add_transition(sanitized_line[0], sanitized_line[1], sanitized_line[2])

        # Guardando os terminais da maquina
        if sanitized_line[0] == @automatas[automata_name].initial_state && is_terminal?(sanitized_line[1])
          @automatas[automata_name].terminals << sanitized_line[1]

        # Guardando os nao-terminais da maquina
        elsif sanitized_line[0] == @automatas[automata_name].initial_state && !is_terminal?(sanitized_line[1])
          @automatas[automata_name].nonterminals << sanitized_line[1]
        end
      end
    end

    # guardando todos os nao-terminais que podem ser acessados por cada uma dos automatos alcancados
    get_submachine_terminals(@automatas.keys[0])
  end

  def get_submachine_terminals(automata_name)
    if @automatas[automata_name].nonterminals.length > 0
      @automatas[automata_name].nonterminals.each do |child_automata|
        get_submachine_terminals(child_automata) if @automatas[child_automata].nonterminals.length > 0
        @automatas[automata_name].subautomatas_terminals[child_automata] = [] if @automatas[automata_name].subautomatas_terminals[child_automata].nil?
        @automatas[automata_name].subautomatas_terminals[child_automata].concat(@automatas[child_automata].terminals)
        @automatas[automata_name].subautomatas_terminals[child_automata].concat(@automatas[child_automata].subautomatas_terminals.values.flatten(1))
      end
    end
  end

  def is_terminal?(name)
    return (name[0] != '_')
  end

end
