grammar Go;

/*
 *  PARSER
 */

program: packageClause (SEMI | EOF) (importDecl (SEMI | EOF))* ((functionDecl | declaration) (SEMI | EOF))* EOF;

packageName: IDENTIFIER;

packageClause: PACKAGE packageName;

importDecl: IMPORT (string | L_PAREN (string (SEMI | EOF))* R_PAREN);

string: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

declaration: constDecl | varDecl;

constDecl: CONST (constSpec | L_PAREN (constSpec (SEMI | EOF))* R_PAREN);

constSpec: identifierList (type_? ASSIGN expressionList)?;

identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

expressionList: expression (COMMA expression)*;

expression:
	primaryExpr
	| unary_op = (PLUS | MINUS | EXCLAMATION | CARET | STAR | AMPERSAND | RECEIVE) expression
	| expression mul_op = (STAR	| DIV | MOD | LSHIFT | RSHIFT | AMPERSAND | BIT_CLEAR) expression
	| expression add_op = (PLUS | MINUS | OR | CARET) expression
	| expression rel_op = (EQUALS | NOT_EQUALS | LESS | LESS_OR_EQUALS | GREATER | GREATER_OR_EQUALS) expression
	| expression LOGICAL_AND expression
	| expression LOGICAL_OR expression;

primaryExpr:
    operand
	| primaryExpr ((DOT IDENTIFIER) | index | typeAssertion | arguments);

index: L_BRACKET expression R_BRACKET;

typeAssertion: DOT L_PAREN type_ R_PAREN;

arguments: L_PAREN (expressionList ELLIPSIS? COMMA?)? R_PAREN;

operand: literal | operandName | L_PAREN expression R_PAREN;

literal: basicLit | functionLit;

basicLit: NIL_LIT | INTEGER_LIT | string;

operandName: IDENTIFIER;

qualifiedIdent: packageName DOT IDENTIFIER;

literalValue: L_CURLY (elementList COMMA?)? R_CURLY;

elementList: keyedElement (COMMA keyedElement)*;

keyedElement: (key COLON)? element;

key: expression | literalValue;

element: expression | literalValue;

functionLit: FUNC signature block;

// Function declarations

functionDecl: FUNC IDENTIFIER (signature block?);

receiver: parameters;

varDecl: VAR (varSpec | L_PAREN (varSpec (SEMI | EOF))* R_PAREN);

varSpec: identifierList (type_ (ASSIGN expressionList)?	| ASSIGN expressionList);

block: L_CURLY statementList? R_CURLY;

statementList: (SEMI? statement (SEMI | EOF))+;

statement:
	declaration
	| labeledStmt
	| simpleStmt
	| goStmt
	| returnStmt
	| breakStmt
	| continueStmt
	| gotoStmt
	| fallthroughStmt
	| block
	| ifStmt
	| switchStmt
	| selectStmt
	| forStmt
	| deferStmt;

simpleStmt:
	sendStmt
	| incDecStmt
	| assignment
	| expressionStmt
	| shortVarDecl;

expressionStmt: expression;

sendStmt: channel = expression RECEIVE expression;

incDecStmt: expression (PLUS_PLUS | MINUS_MINUS);

assignment: expressionList assign_op expressionList;

assign_op: (PLUS | MINUS | OR | CARET | STAR | DIV | MOD | LSHIFT | RSHIFT | AMPERSAND | BIT_CLEAR)? ASSIGN;

shortVarDecl: identifierList DECLARE_ASSIGN expressionList;

labeledStmt: IDENTIFIER COLON statement?;

returnStmt: RETURN expressionList?;

breakStmt: BREAK IDENTIFIER?;

continueStmt: CONTINUE IDENTIFIER?;

gotoStmt: GOTO IDENTIFIER;

fallthroughStmt: FALLTHROUGH;

deferStmt: DEFER expression;

ifStmt:
    IF (expression | (SEMI | EOF) expression | simpleStmt (SEMI | EOF) expression ) block
    (ELSE (ifStmt | block))?;

switchStmt: exprSwitchStmt | typeSwitchStmt;

exprSwitchStmt: SWITCH (expression? | simpleStmt? (SEMI | EOF) expression?) L_CURLY exprCaseClause* R_CURLY;

exprCaseClause: exprSwitchCase COLON statementList?;

exprSwitchCase: CASE expressionList | DEFAULT;

typeSwitchStmt:
    SWITCH (typeSwitchGuard | (SEMI | EOF) typeSwitchGuard |
    simpleStmt (SEMI | EOF) typeSwitchGuard) L_CURLY typeCaseClause* R_CURLY;

typeSwitchGuard: (IDENTIFIER DECLARE_ASSIGN)? primaryExpr DOT L_PAREN TYPE R_PAREN;

typeCaseClause: typeSwitchCase COLON statementList?;

typeSwitchCase: CASE typeList | DEFAULT;

typeList: (type_ | NIL_LIT) (COMMA (type_ | NIL_LIT))*;

selectStmt: SELECT L_CURLY commClause* R_CURLY;

commClause: commCase COLON statementList?;

commCase: CASE (sendStmt | recvStmt) | DEFAULT;

recvStmt: (expressionList ASSIGN | identifierList DECLARE_ASSIGN)? recvExpr = expression;

forStmt: FOR (expression? | forClause | rangeClause?) block;

forClause: initStmt = simpleStmt? (SEMI | EOF) expression? (SEMI | EOF) postStmt = simpleStmt?;

rangeClause: (expressionList ASSIGN | identifierList DECLARE_ASSIGN )? RANGE expression;

goStmt: GO expression;

type_: typeName | typeLit | L_PAREN type_ R_PAREN;

typeName: qualifiedIdent | IDENTIFIER;

typeLit:
	arrayType
	| functionType;

arrayType: L_BRACKET arrayLength R_BRACKET elementType;

arrayLength: expression;

elementType: type_;

functionType: FUNC signature;

signature: parameters result | parameters;

result: parameters | type_;

parameters: L_PAREN (parameterDecl (COMMA parameterDecl)* COMMA?)? R_PAREN;

parameterDecl: identifierList? ELLIPSIS? type_;

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