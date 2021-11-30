#!/bin/sh

nasm -f elf64 -o proc.o proc.asm
gcc -o mainapp mainapp.cpp proc.o
rm -f proc.o

