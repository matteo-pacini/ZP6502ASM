cmake_minimum_required (VERSION 3.2)

project(zp6502asm)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

flex_target(SCANNER lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
bison_target(PARSER parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
add_flex_bison_dependency(SCANNER PARSER)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(zp6502asm 
  	${BISON_PARSER_OUTPUTS}
	${FLEX_SCANNER_OUTPUTS}
)
