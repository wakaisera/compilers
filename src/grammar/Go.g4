grammar Go;

/*
 *  PARSER
 */

eos: SEMI | EOF;

type_: typeName | L_PAREN type_ R_PAREN;

typeName: qualifiedIdent | IDENTIFIER;

qualifiedIdent: IDENTIFIER DOT IDENTIFIER;

packageClause: PACKAGE packageName = IDENTIFIER;

importDecl:
    IMPORT (importSpec | L_PAREN (importSpec eos)* R_PAREN);

importSpec: (DOT | IDENTIFIER)? (RAW_STRING_LIT | INTERPRETED_STRING_LIT);

declaration: constDecl | typeDecl | varDecl;

constDecl: CONST (constSpec | L_PAREN (constSpec eos)* R_PAREN);

constSpec: identifierList (type_? ASSIGN expressionList)?;

identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

expressionList: expression (COMMA expression)*;

typeDecl: TYPE (typeSpec | L_PAREN (typeSpec eos)* R_PAREN);

typeSpec: IDENTIFIER ASSIGN? type_;

varDecl: VAR (varSpec | L_PAREN (varSpec eos)* R_PAREN);

varSpec: identifierList (type_ (ASSIGN expressionList)? | ASSIGN expressionList);

expression:
	primaryExpr
	| unary_op = (PLUS | MINUS | EXCLAMATION | CARET | STAR | AMPERSAND | RECEIVE) expression
	| expression mul_op = (STAR	| DIV | MOD | LSHIFT | RSHIFT | AMPERSAND | BIT_CLEAR) expression
	| expression add_op = (PLUS | MINUS | OR | CARET) expression
	| expression rel_op = (EQUALS | NOT_EQUALS | LESS | LESS_OR_EQUALS | GREATER | GREATER_OR_EQUALS) expression
	| expression LOGICAL_AND expression
	| expression LOGICAL_OR expression;

// primaryExpr:
// 	operand
//	| conversion
//	| methodExpr
//	| primaryExpr ((DOT IDENTIFIER) | index | slice_ | typeAssertion | arguments);

primaryExpr:
	operand
	| conversion;

conversion: nonNamedType L_PAREN expression COMMA? R_PAREN;

nonNamedType: L_PAREN nonNamedType R_PAREN;       // | typeLit
operand: literal | operandName | L_PAREN expression R_PAREN;

literal: NIL_LIT | INTEGER_LIT | (RAW_STRING_LIT | INTERPRETED_STRING_LIT);

operandName: IDENTIFIER;

methodExpr: nonNamedType DOT IDENTIFIER;

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
// CHAR_LIT: '\'' (~[\n\\] | ESCAPED_VALUE) '\'';

RAW_STRING_LIT: '`' ~'`'* '`';
INTERPRETED_STRING_LIT: '"' (~["\\] | ESCAPED_VALUE | NULL_TERMINAL)*  '"';

INTEGER_LIT: [+-]? DEC_LIT;
DEC_LIT: ('0' | DEC_DIGIT_NO_ZERO (DEC_DIGIT)*);

fragment DEC_DIGIT: [0-9];
fragment DEC_DIGIT_NO_ZERO: [1-9];

fragment ESCAPED_VALUE: '\\' [abfnrtv\\'"];

fragment NULL_TERMINAL: '\\000';

INVALID: .;