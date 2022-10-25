package br.compiler.lexicalanalyzer;

import br.compiler.language.Token;import br.compiler.syntacticanalyzer.Sym;
import java_cup.runtime.Symbol;
import jflex.core.sym;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
%%

%{

public Set<String> keyWords = Stream.of("integer","boolean","true","false","read","write","return","goto","if", "void", "var", "type", "function", "while","label").collect(Collectors.toSet());

public Set<String> identifiers = new HashSet<String>();

private void setIdentifiers(String identifier){
    identifiers.add(identifier);
}

%}

%cup
%public
%class LexicalAnalyzer
%type Symbol
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

{Alternative}                 { return new Symbol(Sym.ALTERNATIVE, new Token("Alternativa", yytext(), yyline, yycolumn));}
{ParenthesesL}                { return new Symbol(Sym.PARENTHESESL, new Token("Abre parênteses", " ", yyline, yycolumn));}
{ParenthesesR}                { return new Symbol(Sym.PARENTHESESR, new Token("Fecha parênteses", " ", yyline, yycolumn));}
{CurlyBracesL}                { return new Symbol(Sym.CURLYBRACESL, new Token("Abre chaves", " ", yyline, yycolumn));}
{CurlyBracesR}                { return new Symbol(Sym.CURLYBRACESR, new Token("Fecha chaves", " ", yyline, yycolumn));}
{BracketL}                    { return new Symbol(Sym.BRACKETL, new Token("Abre Colchetes", " ", yyline, yycolumn));}
{BracketR}                    { return new Symbol(Sym.BRACKETR, new Token("Fecha Colchetes", " ", yyline, yycolumn));}
{QuotationMarks}              { return new Symbol(Sym.QUOTATIONMARKS, new Token("Aspas", yytext(), yyline, yycolumn));}
{Comma}                       { return new Symbol(Sym.COMMA, new Token("Vírgula", yytext(), yyline, yycolumn));}
{Space}                       { /* ignore */ }
{NewLine}                     { /* ignore */ }
{Identifier}                  {
                                if(keyWords.contains(yytext().toLowerCase())){
                                    return new Symbol(Sym.KEYWORD, new Token("Palavra reservada", yytext(), yyline, yycolumn));
                                } else if(!identifiers.contains(yytext().toLowerCase())){
                                    setIdentifiers(yytext().toLowerCase());
                                    return new Symbol(Sym.IDENTIFIER, new Token("Identificador", yytext(), yyline, yycolumn));  }
                              }
{AdditiveOperator}            { return new Symbol(Sym.ADDITIVEOPERATOR, new Token("Operador múltiplicativo", yytext(), yyline, yycolumn));}
{MultiplicativeOperator}      { return new Symbol(Sym.MULTIPLICATIVEOPERATOR, new Token("Operador aditivo", yytext(), yyline, yycolumn));}
{Integer}                     { return new Symbol(Sym.INTEGER, new Token("Número Inteiro", yytext(), yyline, yycolumn));}
{RelationalOperator}          { return new Symbol(Sym.RELATIONALOPERATOR,  new Token("Operador relacional", yytext(), yyline, yycolumn)); }
{EmptyStatement}              { return new Symbol(Sym.EMPTYSTATEMENT, new Token("Declaração vazia", yytext(), yyline, yycolumn));}
{Colon}                       { return new Symbol(Sym.COLON, new Token("Dois pontos", yytext(), yyline, yycolumn));}
{AssignmentOperator}          { return new Symbol(Sym.ASSIGNMENTOPERATOR, new Token("Operador de atribuição", yytext(), yyline, yycolumn));}
{ExclamationMark}             { return new Symbol(Sym.EXCLAMATIONMARK, new Token("Ponto de exclamação", yytext(), yyline, yycolumn));}
{Comment}                     { /* ignore */ }

.                             { System.out.println("Caracter inválido: " + yytext()); }