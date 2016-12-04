#!/bin/sh
clear

echo "Prova 2 - Compiladores - Dezembro de 2016"
echo "   Pedro Martinez e Vinicius Adaime"

echo "\n\nPrograma exemplo (ENTRADA.txt)"
echo "-------------------------------"
more ENTRADA.txt

echo "\n\nCompilando programa exemplo"
echo "---------------------------"
compilador/main.rb

echo "\n\nComparando com o compilador exemplo!"
echo "------------------------------------"
java Lambda ENTRADA.txt
