#!/usr/bin/env ruby

require_relative 'automata'

class Sintatico

  attr_reader :automatos

  def initialize(lexico)

    puts ''
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts '- A N A L I S A D O R   S I N T A T I C O -'
    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts ''

    @lexico = lexico
    @automata_stack = [] #Array com os automatos
    @subautomatas_terminals = {}
    create_automatas_from_file "compilador/automatos.txt"
    start_syntactic_analysis
  end

  def start_syntactic_analysis()
    push_automata @automatas.values[0].name
    # current_state_subautomatas_terminals
    # puts @subautomatas_terminals

    @lexico.tokens.each do |token|
      @was_token_consumed = false

      next_state(token)

    end
  end

  private

  def next_state(token)
    puts 'token: ' + token.lexeme
    puts '--------'
    # puts 'token.lexme: ' + token.lexeme
    # puts 'token.type: ' + token.type.to_s
    # puts current_automata.inspect
    # puts 'current_state_terminals: ' + current_state_terminals.to_s
    # puts 'current_state_nonterminals: ' + current_state_nonterminals.to_s
    # puts current_state_subautomatas_terminals

    if current_state_terminals.include? token.lexeme
      change_state token.lexeme
      @was_token_consumed = true
      return

    elsif current_state_terminals.include? token.type.to_s
      change_state token.type.to_s
      @was_token_consumed = true
      return

    elsif (!current_state_terminals.empty? || !current_state_nonterminals.empty?) && (current_state_subautomatas_terminals.values.flatten(1).include?(token.lexeme) ||  current_state_subautomatas_terminals.values.flatten(1).include?(token.type.to_s))

      current_state_subautomatas_terminals.each do |automata, terminals|
        if terminals.include?(token.lexeme) || terminals.include?(token.type.to_s)
          change_state automata
          push_automata(automata, token)
          return
        end
      end

    elsif current_automata.final_states.include? current_automata.current_state
      pop_automata()
      next_state(token) if !@was_token_consumed
      return
    end
  end

  def current_state_subautomatas_terminals
    @subautomatas_terminals = {}
    get_current_state_subautomatas_terminals
    @subautomatas_terminals
  end

  # Pega todos os terminais que podem ser atingido pelo estado da maquina presente
  def get_current_state_subautomatas_terminals
    if current_state_nonterminals.length > 0
      current_state_nonterminals.each do |child_automata|
        @subautomatas_terminals[child_automata] = [] if @subautomatas_terminals[child_automata].nil?
        get_subautomata_terminals(child_automata) if @automatas[child_automata].subautomatas_terminals.keys.flatten(1).empty?
        @subautomatas_terminals[child_automata].concat(@automatas[child_automata].terminals)
        @subautomatas_terminals[child_automata].concat(@automatas[child_automata].subautomatas_terminals.values.flatten(1))

        @subautomatas_terminals[child_automata] = @subautomatas_terminals[child_automata].uniq
      end
    end
  end

  # Pega todos os terminais que podem ser atingido por uma maquina
  def get_subautomata_terminals(automata_name)
    if @automatas[automata_name].nonterminals.length > 0
      @automatas[automata_name].nonterminals.each do |child_automata|
        @automatas[automata_name].subautomatas_terminals[child_automata] = [] if @automatas[automata_name].subautomatas_terminals[child_automata].nil?
        get_subautomata_terminals(child_automata) if @automatas[child_automata].subautomatas_terminals.keys.flatten(1).empty?
        @automatas[automata_name].subautomatas_terminals[child_automata].concat(@automatas[child_automata].terminals)
        @automatas[automata_name].subautomatas_terminals[child_automata].concat(@automatas[child_automata].subautomatas_terminals.values.flatten(1))

        @automatas[automata_name].subautomatas_terminals[child_automata] = @automatas[automata_name].subautomatas_terminals[child_automata].uniq
      end
    end
  end

  def current_state_terminals
    terminals = []
    if !current_automata.transitions[current_automata.current_state].nil?
      current_automata.transitions[current_automata.current_state].keys.each do |key|
        terminals << key if is_terminal?(key)
      end
    end
    return terminals
  end

  def current_state_nonterminals
    terminals = []
    if !current_automata.transitions[current_automata.current_state].nil?
      current_automata.transitions[current_automata.current_state].keys.each do |key|
        terminals << key unless is_terminal?(key)
      end
    end
    return terminals
  end

  def change_state(input)
    last_state = current_automata.current_state
    current_automata.current_state = current_automata.transitions[current_automata.current_state][input]
    puts current_automata.name + ': (' + last_state + ', ' + input + ') -> ' + current_automata.current_state
  end

  def current_automata
    @automata_stack.last
  end

  def push_automata(automata_name, token = nil)
    last_automata = current_automata.name unless current_automata.nil?
    @automata_stack << @automatas[automata_name].clone
    # current_automata.current_state = @automatas[automata_name].initial_state
    puts ''
    puts 'Entrando submaquina: ' +  current_automata.name if last_automata.nil?
    puts 'Entrando submaquina: ' + last_automata + ' ~> ' + current_automata.name unless last_automata.nil?
    puts ''
    next_state(token) unless token.nil?

  end

  def pop_automata()
    last_automata = current_automata.name
    @automata_stack.pop
    puts ''
    puts 'Saindo submaquina: ' + last_automata + ' ~> ' + current_automata.name
    puts ''
  end

  def create_automatas_from_file(filename)
    @automatas = {}
    automata_name = ''

    File.foreach(filename).with_index do |line, line_num|
      next if line.match /^$/ #linhas vazias são puladas

      if line.match /^automato:/
        automata_name = line.split(' ')[-1]
        @automatas[automata_name] = Automata.new(automata_name)

      elsif line.match /^initial:/
        @automatas[automata_name].initial_state = line.gsub(',','').split(' ')[-1]
        @automatas[automata_name].current_state = @automatas[automata_name].initial_state

      elsif line.match /^final:/
        @automatas[automata_name].final_states = line.gsub(',','').split(' ')[1..-1]

      else
        sanitized_line = line.gsub(/[\(\),\s\-\\">]/,' ').split(' ')
        @automatas[automata_name].add_transition(sanitized_line[0], sanitized_line[1], sanitized_line[2])

        # Guardando os terminais da maquina
        # puts line
        if is_terminal?(sanitized_line[1])
          @automatas[automata_name].terminals << sanitized_line[1] unless @automatas[automata_name].terminals.include? sanitized_line[1]

        # Guardando os nao-terminais da maquina
        elsif !is_terminal?(sanitized_line[1])
          @automatas[automata_name].nonterminals << sanitized_line[1] unless @automatas[automata_name].nonterminals.include? sanitized_line[1]
        end
      end
    end
  end

  def is_terminal?(name)
    return (name[0] != '_')
  end

end
