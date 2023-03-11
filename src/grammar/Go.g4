grammar Go;

/*
 *  PARSER
 */

// program: packageClause (SEMI | EOF) (importDecl (SEMI | EOF))* ((functionDecl | declaration) (SEMI | EOF))* EOF;
program: packageClause (SEMI | EOF) (importDecl (SEMI | EOF))* (functionDecl (SEMI | EOF))* EOF;

packageName: IDENTIFIER;

packageClause: PACKAGE packageName;

importDecl: IMPORT (string | L_PAREN (string (SEMI | EOF))* R_PAREN);

string: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

// Function declarations

// finish it!!!
statement: NIL_LIT;

statementList: (SEMI? statement (SEMI | EOF))+;

block: L_CURLY statementList? R_CURLY;


operandName: IDENTIFIER;

literal: NIL_LIT | INTEGER_LIT | string;

operand: literal | operandName | L_PAREN expression R_PAREN;

index: L_BRACKET expression R_BRACKET;

arguments: L_PAREN (expressionList ELLIPSIS? COMMA?)? R_PAREN;

primaryExpr: operand | primaryExpr ((DOT IDENTIFIER) | index | arguments);

expression:
	primaryExpr
	| unary_op = (PLUS | MINUS | EXCLAMATION | CARET | STAR | AMPERSAND | RECEIVE) expression
	| expression mul_op = (STAR | DIV | MOD | LSHIFT | RSHIFT | AMPERSAND | BIT_CLEAR) expression
	| expression add_op = (PLUS | MINUS | OR | CARET) expression
	| expression rel_op = (EQUALS | NOT_EQUALS | LESS | LESS_OR_EQUALS | GREATER | GREATER_OR_EQUALS) expression
	| expression LOGICAL_AND expression
	| expression LOGICAL_OR expression;

expressionList: expression (COMMA expression)*;

arrayLength: expression;

elementType: type;

arrayType: L_BRACKET arrayLength R_BRACKET elementType;

functionType: FUNC signature;

typeLit: arrayType | functionType;

qualifiedIdent: packageName DOT IDENTIFIER;

typeName: qualifiedIdent | IDENTIFIER;

type: typeName | typeLit | L_PAREN type R_PAREN;

identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

parameterDecl: identifierList? ELLIPSIS? type;

parameters: L_PAREN (parameterDecl (COMMA parameterDecl)* COMMA?)? R_PAREN;

result: parameters | type;

signature: parameters result?;

functionDecl: FUNC IDENTIFIER (signature block?);

/*
 *  LEXER
 */

// Keywords
BREAK: 'break';
DEFAULT: 'default';
FUNC: 'func';
INTERFACE: 'interface';
SELECT: 'select';
CASE: 'case';
DEFER: 'defer';
GO: 'go';
MAP: 'map';
STRUCT: 'struct';
CHAN: 'chan';
ELSE: 'else';
GOTO: 'goto';
PACKAGE: 'package';
SWITCH: 'switch';
CONST: 'const';
FALLTHROUGH: 'fallthrough';
IF: 'if';
RANGE: 'range';
TYPE: 'type';
CONTINUE: 'continue';
FOR: 'for';
IMPORT: 'import';
RETURN: 'return';
VAR: 'var';
NIL_LIT: 'nil';
IDENTIFIER: [a-zA-Z][a-zA-Z0-9_]* | '_' [a-zA-Z0-9_]+;

L_PAREN: '(';
R_PAREN: ')';
L_CURLY: '{';
R_CURLY: '}';
L_BRACKET: '[';
R_BRACKET: ']';
ASSIGN: '=';
COMMA: ',';
SEMI: ';';
COLON: ':';
DOT: '.';
PLUS_PLUS: '++';
MINUS_MINUS: '--';
DECLARE_ASSIGN: ':=';
ELLIPSIS: '...';

LOGICAL_OR: '||';
LOGICAL_AND: '&&';

EQUALS: '==';
NOT_EQUALS: '!=';
LESS: '<';
LESS_OR_EQUALS: '<=';
GREATER: '>';
GREATER_OR_EQUALS: '>=';

OR: '|';
DIV: '/';
MOD: '%';
LSHIFT: '<<';
RSHIFT: '>>';
BIT_CLEAR: '&^';

EXCLAMATION: '!';

PLUS: '+';
MINUS: '-';
CARET: '^';
STAR: '*';
AMPERSAND: '&';
RECEIVE: '<-';

PLUSEQ: '+=';
MINUSEQ: '-=';
STAREQ: '*=';

DIVEQ: '/=';
MODEQ: '%=';

ANDEQ: '&=';
OREQ: '|=';
LSHIFTEQ: '<<=';
RSHIFTEQ: '>>=';

// Tokens we skip~
WHITESPACE: [ \t]+ -> skip;
COMMENT: '/*' ~[\r\n]*? '*/'-> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
NEWLINE: ('\r\n' | [\r\n]) -> skip;

// Literals

RAW_STRING_LIT: '`' ~'`'* '`';
INTERPRETED_STRING_LIT: '"' (~["\\] | ESCAPED_VALUE | NULL_TERMINAL)*  '"';

INTEGER_LIT: [+-]? DEC_LIT;
DEC_LIT: ('0' | DEC_DIGIT_NO_ZERO (DEC_DIGIT)*);

fragment DEC_DIGIT: [0-9];
fragment DEC_DIGIT_NO_ZERO: [1-9];

fragment ESCAPED_VALUE: '\\' [abfnrtv\\'"];

fragment NULL_TERMINAL: '\\000';

INVALID: .;