package br.compiler.lexicalanalyzer;

import br.compiler.language.LanguageToken;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
%type LanguageToken
%unicode
%line
%column
%caseless

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

{Alternative}                 { return createToken("Alternativa", yytext(), yyline, yycolumn); }
{Parentheses}                 { return createToken("Parênteses", yytext(), yyline, yycolumn); }
{CurlyBraces}                 { return createToken("Chaves", yytext(), yyline, yycolumn); }
{QuotationMarks}              { return createToken("Aspas", yytext(), yyline, yycolumn); }
{Comma}                       { return createToken("Vírgula", yytext(), yyline, yycolumn); }
{Bracket}                     { return createToken("Colchetes", yytext(), yyline, yycolumn); }
{Space}                       { return createToken("Espaço em branco", " ", yyline, yycolumn); }
{NewLine}                     { return createToken("Nova linha", " ", yyline + 1, yycolumn); }
{Identifier}                  {
                                if(keyWords.contains(yytext().toLowerCase())){
                                    return createToken("Palavra reservada", yytext(), yyline, yycolumn);
                                } else if(!identifiers.contains(yytext().toLowerCase())){
                                      setIdentifiers(yytext().toLowerCase());
                                      return createToken("Identificador", yytext(), yyline, yycolumn);
                                }
                              }
{AdditiveOperator}            { return createToken("Operador múltiplicativo", yytext(), yyline, yycolumn); }
{MultiplicativeOperator}      { return createToken("Operador aditivo", yytext(), yyline, yycolumn); }
{Integer}                     { return createToken("Número Inteiro", yytext(), yyline, yycolumn); }
{RelationalOperator}          { return createToken("Operador relacional", yytext(), yyline, yycolumn); }
{EmptyStatement}              { return createToken("Declaração vazia", yytext(), yyline, yycolumn); }
{Colon}                       { return createToken("Dois pontos", yytext(), yyline, yycolumn); }
{AssignmentOperator}          { return createToken("Operador de atribuição", yytext(), yyline, yycolumn); }
{ExclamationMark}             { return createToken("Ponto de exclamação", yytext(), yyline, yycolumn); }
{Comment}                     { /* ignore */ }

. { return createToken("Caractere inválido", yytext(), yyline, yycolumn); }