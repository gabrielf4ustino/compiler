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
%type Symbol
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
ParenthesesL = "("
ParenthesesR = ")"
CurlyBracesL = "{"
CurlyBracesR = "}"
BracketL = "["
BracketR = "]"
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

{Alternative}                 {
                                createToken("Alternativa", yytext(), yyline, yycolumn);
                                return new Symbol(sym.ALTERNATIVE);
                              }
{ParenthesesL}                {
                                createToken("Abre parênteses", yytext(), yyline, yycolumn);
                                return new Symbol(sym.PARENTHESESL);
                              }
{ParenthesesR}                {
                                createToken("fecha parênteses", yytext(), yyline, yycolumn);
                                return new Symbol(sym.PARENTHESESR);
                              }
{CurlyBracesL}                {
                                createToken("Abre chaves", yytext(), yyline, yycolumn);
                                return new Symbol(sym.CURLYBRACESL);
                              }
{CurlyBracesR}                {
                                createToken("Fecha chaves", yytext(), yyline, yycolumn);
                                return new Symbol(sym.CURLYBRACESR);
                              }
{BracketL}                    {
                                createToken("Abre colchetes", yytext(), yyline, yycolumn);
                                return new Symbol(sym.BRACKETL);
                              }
{BracketR}                    {
                                createToken("Fecha colchetes", yytext(), yyline, yycolumn);
                                return new Symbol(sym.BRACKETR);
                              }
{QuotationMarks}              {
                                createToken("Aspas", yytext(), yyline, yycolumn);
                                return new Symbol(sym.QUOTATIONMARKS);
                              }
{Comma}                       {
                                createToken("Vírgula", yytext(), yyline, yycolumn);
                                return new Symbol(sym.COMMA);
                              }
{Space}                       { /* ignore */ }
{NewLine}                     { /* ignore */ }
{Identifier}                  {
                                if(keyWords.contains(yytext().toLowerCase())){
                                    createToken("Palavra reservada", yytext(), yyline, yycolumn);
                                    return new Symbol(sym.KEYWORD);
                                } else if(!identifiers.contains(yytext().toLowerCase())){
                                      setIdentifiers(yytext().toLowerCase());
                                      createToken("Identificador", yytext(), yyline, yycolumn);
                                      return new Symbol(sym.IDENTIFIER);
                                }
                              }
{AdditiveOperator}            {
                                createToken("Operador múltiplicativo", yytext(), yyline, yycolumn);
                                return new Symbol(sym.ADDITIVEOPERATOR);
                              }
{MultiplicativeOperator}      {
                                createToken("Operador aditivo", yytext(), yyline, yycolumn);
                                return new Symbol(sym.MULTIPLICATIVEOPERATOR);
                              }
{Integer}                     {
                                createToken("Número Inteiro", yytext(), yyline, yycolumn);
                                return new Symbol(sym.INTEGER);
                              }
{RelationalOperator}          {
                                createToken("Operador relacional", yytext(), yyline, yycolumn);
                                return new Symbol(sym.RELATIONALOPERATOR);
                              }
{EmptyStatement}              {
                                createToken("Declaração vazia", yytext(), yyline, yycolumn);
                                return new Symbol(sym.EMPTYSTATEMENT);
                              }
{Colon}                       {
                                createToken("Dois pontos", yytext(), yyline, yycolumn);
                                return new Symbol(sym.COLON);
                              }
{AssignmentOperator}          {
                                createToken("Operador de atribuição", yytext(), yyline, yycolumn);
                                return new Symbol(sym.ASSIGNMENTOPERATOR);
                              }
{ExclamationMark}             {
                                createToken("Ponto de exclamação", yytext(), yyline, yycolumn);
                                return new Symbol(sym.EXCLAMATIONMARK);
                              }
{Comment}                     { /* ignore */ }

.                             {
                                createToken("Caractere inválido", yytext(), yyline, yycolumn);
                                return new Symbol(sym.EOF);
                              }