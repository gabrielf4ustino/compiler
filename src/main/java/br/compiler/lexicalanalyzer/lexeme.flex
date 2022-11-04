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

public Set<String> keyWords = Stream.of("integer", "boolean", "true", "false", "read", "write", "return", "goto", "void", "var", "var", "type", "function", "functions", "label", "if", "while").collect(Collectors.toSet());

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
%eofval{
    return new Symbol(Sym.EOF, new Token("Fim do arquivo", yytext(), yyline + 1, yycolumn));
%eofval}

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
If = "if"
While = "while"
Functions = "functions"
Vars = "vars"
Labels = "labels"
Var = "var"
Void = "void"
Goto = "goto"
Return = "return"


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

{Alternative}                 { return new Symbol(Sym.ALTERNATIVE, new Token("Alternativa", yytext(), yyline + 1, yycolumn));}
{ParenthesesL}                { return new Symbol(Sym.PARENTHESESL, new Token("Abre parênteses", " ", yyline + 1, yycolumn));}
{ParenthesesR}                { return new Symbol(Sym.PARENTHESESR, new Token("Fecha parênteses", " ", yyline + 1, yycolumn));}
{CurlyBracesL}                { return new Symbol(Sym.CURLYBRACESL, new Token("Abre chaves", " ", yyline + 1, yycolumn));}
{CurlyBracesR}                { return new Symbol(Sym.CURLYBRACESR, new Token("Fecha chaves", " ", yyline + 1, yycolumn));}
{BracketL}                    { return new Symbol(Sym.BRACKETL, new Token("Abre Colchetes", " ", yyline + 1, yycolumn));}
{BracketR}                    { return new Symbol(Sym.BRACKETR, new Token("Fecha Colchetes", " ", yyline + 1, yycolumn));}
{QuotationMarks}              { return new Symbol(Sym.QUOTATIONMARKS, new Token("Aspas", yytext(), yyline + 1, yycolumn));}
{Comma}                       { return new Symbol(Sym.COMMA, new Token("Vírgula", yytext(), yyline + 1, yycolumn));}
{Space}                       { /* ignore */ }
{NewLine}                     { /* ignore */ }
{AdditiveOperator}            { return new Symbol(Sym.ADDITIVEOPERATOR, new Token("Operador múltiplicativo", yytext(), yyline + 1, yycolumn));}
{MultiplicativeOperator}      { return new Symbol(Sym.MULTIPLICATIVEOPERATOR, new Token("Operador aditivo", yytext(), yyline + 1, yycolumn));}
{Integer}                     { return new Symbol(Sym.INTEGER, new Token("Número Inteiro", yytext(), yyline + 1, yycolumn));}
{RelationalOperator}          { return new Symbol(Sym.RELATIONALOPERATOR,  new Token("Operador relacional", yytext(), yyline + 1, yycolumn)); }
{EmptyStatement}              { return new Symbol(Sym.EMPTYSTATEMENT, new Token("Declaração vazia", yytext(), yyline + 1, yycolumn));}
{Colon}                       { return new Symbol(Sym.COLON, new Token("Dois pontos", yytext(), yyline + 1, yycolumn));}
{AssignmentOperator}          { return new Symbol(Sym.ASSIGNMENTOPERATOR, new Token("Operador de atribuição", yytext(), yyline + 1, yycolumn));}
{ExclamationMark}             { return new Symbol(Sym.EXCLAMATIONMARK, new Token("Ponto de exclamação", yytext(), yyline + 1, yycolumn));}
{If}                          { return new Symbol(Sym.IF, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{While}                       { return new Symbol(Sym.WHILE, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Functions}                   { return new Symbol(Sym.FUNCTIONS, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Vars}                        { return new Symbol(Sym.VARS, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Labels}                      { return new Symbol(Sym.LABELS, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Var}                         { return new Symbol(Sym.VAR, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Void}                        { return new Symbol(Sym.VOID, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Goto}                        { return new Symbol(Sym.GOTO, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Return}                      { return new Symbol(Sym.RETURN, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Identifier}                  {
                                if(keyWords.contains(yytext().toLowerCase())){
                                    return new Symbol(Sym.KEYWORD, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));
                                } else if(!identifiers.contains(yytext().toLowerCase())){
                                    setIdentifiers(yytext().toLowerCase());
                                    return new Symbol(Sym.IDENTIFIER, new Token("Identificador", yytext(), yyline + 1, yycolumn));  }
                              }
{Comment}                     { /* ignore */ }

.                             { System.out.println("Caracter inválido: " + yytext()); }