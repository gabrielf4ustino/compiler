package br.compiler.lexicalanalyzer;

import br.compiler.language.LanguageToken;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java_cup.runtime.Symbol;

%%

%{

public Set<String> keyWords = Stream.of("integer","boolean","true","false","read","write","return","goto","if", "void", "var", "type", "function", "while","label").collect(Collectors.toSet());

public Set<String> identifiers = new HashSet<String>();

private LanguageToken createToken(String name, String value, Integer line, Integer column) {
    return new LanguageToken(name, value, line + 1, column + 1);
}

private void setIdentifiers(String identifier){
    identifiers.add(identifier);
}

%}

%public
%class LexicalAnalyzer
%type java_cup.runtime.Symbol
%unicode
%line
%column
%caseless
%cup

Space = [\r| |\t]
EmptyStatement = ";"
NewLine = [\n]
Identifier = [:jletter:] [:jletterdigit:]*
MultiplicativeOperator = "/" | "*" | "&&"
AdditiveOperator = "+" | "-" | "||"
Integer = 0|[1-9][0-9]*
Parentheses = "("|")"
CurlyBraces = "{"|"}"
Bracket = "[" | "]"
Alternative = "|"
QuotationMarks = "\""
Comma = ","
RelationalOperator = "<" | ">" | "<=" | ">=" | "==" | "!="
Colon = ":"
AssignmentOperator = "="
ExclamationMark = "!"

/* comments */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}
TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"

// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

%%

{Alternative}                 { createToken("Alternativa", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Parentheses}                 { createToken("Parênteses", yytext(), yyline, yycolumn); return new Symbol(sym);}
{CurlyBraces}                 { createToken("Chaves", yytext(), yyline, yycolumn); return new Symbol(sym);}
{QuotationMarks}              { createToken("Aspas", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Comma}                       { createToken("Vírgula", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Bracket}                     { createToken("Colchetes", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Space}                       { createToken("Espaço em branco", " ", yyline, yycolumn); return new Symbol(sym);}
{NewLine}                     { createToken("Nova linha", " ", yyline + 1, yycolumn); return new Symbol(sym);}
{Identifier}                  {
                                if(keyWords.contains(yytext().toLowerCase())){
                                    createToken("Palavra reservada", yytext(), yyline, yycolumn);
                                    return new Symbol(sym);
                                } else if(!identifiers.contains(yytext().toLowerCase())){
                                      setIdentifiers(yytext().toLowerCase());
                                      createToken("Identificador", yytext(), yyline, yycolumn);
                                      return new Symbol(sym);
                                }
                              }
{AdditiveOperator}            { createToken("Operador múltiplicativo", yytext(), yyline, yycolumn); return new Symbol(sym);}
{MultiplicativeOperator}      { createToken("Operador aditivo", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Integer}                     { createToken("Número Inteiro", yytext(), yyline, yycolumn); return new Symbol(sym);}
{RelationalOperator}          { createToken("Operador relacional", yytext(), yyline, yycolumn); return new Symbol(sym);}
{EmptyStatement}              { createToken("Declaração vazia", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Colon}                       { createToken("Dois pontos", yytext(), yyline, yycolumn); return new Symbol(sym);}
{AssignmentOperator}          { createToken("Operador de atribuição", yytext(), yyline, yycolumn); return new Symbol(sym);}
{ExclamationMark}             { createToken("Ponto de exclamação", yytext(), yyline, yycolumn); return new Symbol(sym);}
{Comment}                     { /* ignore */ }

. { createToken("Caractere inválido", yytext(), yyline, yycolumn); return new Symbol(sym);}