package br.compiler.lexicalanalyzer;

import br.compiler.language.LanguageToken;

%%

%{

private LanguageToken createToken(String name, String value, Integer line, Integer column) {
    return new LanguageToken(name, "\"" + value + "\"", line + 1, column + 1);
}

%}

%public
%class LexicalAnalyzer
%type LanguageToken
%unicode
%char
%line
%column

SPACE = [\r| |\t]
NEWLINE = [\n]
ID = [_|a-z|A-Z][a-z|A-Z|0-9|_]*
ARITHMETICOPERATORS = ["+"|"-"|"/"|"*"]
INTEGER = 0|[1-9][0-9]*
PARENTHESES = ["("|")"]


%%

"if"                          { return createToken("Palavra reservada if", yytext(), yyline, yycolumn); }
"then"                        { return createToken("Palavra reservada then", yytext(), yyline, yycolumn); }
{PARENTHESES}                 { return createToken("Parênteses", yytext(), yyline, yycolumn); }
{SPACE}                       { return createToken("Espaço em branco", null, yyline, yycolumn); }
{NEWLINE}                     { return createToken("Nova linha", null, yyline + 1, yycolumn); }
{ID}                          { return createToken("Identificador", yytext(), yyline, yycolumn); }
{ARITHMETICOPERATORS}         { return createToken("Operador de soma", yytext(), yyline, yycolumn); }
{INTEGER}                     { return createToken("Número Inteiro", yytext(), yyline, yycolumn); }

. { return createToken("Caractere inválido", yytext(), yyline, yycolumn); }