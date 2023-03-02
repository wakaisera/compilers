lexer grammar GoLexer;

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
// CHAR_LIT : '\'' (~[\n\\] | ESCAPED_VALUE) '\'';

RAW_STRING_LIT: '`' ~'`'* '`';
INTERPRETED_STRING_LIT: '"' (~["\\] | ESCAPED_VALUE)*  '"';

INTEGER_LIT : [+-]? DEC_LIT;
DEC_LIT: ('0' | DEC_DIGIT_NO_ZERO (DEC_DIGIT)*);

fragment DEC_DIGIT: [0-9];
fragment DEC_DIGIT_NO_ZERO: [1-9];

fragment ESCAPED_VALUE: '\\' [abfnrtv\\'"];

INVALID: .;