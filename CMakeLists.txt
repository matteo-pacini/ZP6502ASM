cmake_minimum_required (VERSION 3.2)

project(zp6502asm)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
set(VERSION "0.1")
set(CODENAME "Senbonzakura Kageyoshi")

configure_file(inc/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

flex_target(SCANNER grammar/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
bison_target(PARSER grammar/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
add_flex_bison_dependency(SCANNER PARSER)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(zp6502asm 
    src/main.c
    ${BISON_PARSER_OUTPUTS}
    ${FLEX_SCANNER_OUTPUTS}
)
