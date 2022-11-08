package br.compiler.lexicalanalyzer;

import br.compiler.language.Token;
import br.compiler.syntacticanalyzer.Sym;
import java_cup.runtime.Symbol;

import java.util.HashSet;
import java.util.Set;
%%

%{
public Set<String> identifiers = new HashSet<String>();

private void setIdentifiers(String identifier){
    identifiers.add(identifier);
}

%}

%cup
%public
%class Lexer
%type Symbol
%unicode
%line
%column
%caseless
%eofval{
    return new Symbol(Sym.EOF, yyline, yycolumn, new Token("Fim do arquivo", yytext(), yyline + 1, yycolumn));
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
Else = "else"
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

{Alternative}                 { return new Symbol(Sym.ALTERNATIVE, yyline, yycolumn, new Token("Alternativa", yytext(), yyline + 1, yycolumn));}
{ParenthesesL}                { return new Symbol(Sym.PARENTHESESL, yyline, yycolumn, new Token("Abre parênteses", " ", yyline + 1, yycolumn));}
{ParenthesesR}                { return new Symbol(Sym.PARENTHESESR, yyline, yycolumn, new Token("Fecha parênteses", " ", yyline + 1, yycolumn));}
{CurlyBracesL}                { return new Symbol(Sym.CURLYBRACESL, yyline, yycolumn, new Token("Abre chaves", " ", yyline + 1, yycolumn));}
{CurlyBracesR}                { return new Symbol(Sym.CURLYBRACESR, yyline, yycolumn, new Token("Fecha chaves", " ", yyline + 1, yycolumn));}
{BracketL}                    { return new Symbol(Sym.BRACKETL, yyline, yycolumn, new Token("Abre Colchetes", " ", yyline + 1, yycolumn));}
{BracketR}                    { return new Symbol(Sym.BRACKETR, yyline, yycolumn, new Token("Fecha Colchetes", " ", yyline + 1, yycolumn));}
{QuotationMarks}              { return new Symbol(Sym.QUOTATIONMARKS, yyline, yycolumn, new Token("Aspas", yytext(), yyline + 1, yycolumn));}
{Comma}                       { return new Symbol(Sym.COMMA, yyline, yycolumn, new Token("Vírgula", yytext(), yyline + 1, yycolumn));}
{Space}                       { /* ignore */ }
{NewLine}                     { /* ignore */ }
{AdditiveOperator}            { return new Symbol(Sym.ADDITIVEOPERATOR, yyline, yycolumn, new Token("Operador múltiplicativo", yytext(), yyline + 1, yycolumn));}
{MultiplicativeOperator}      { return new Symbol(Sym.MULTIPLICATIVEOPERATOR, yyline, yycolumn, new Token("Operador aditivo", yytext(), yyline + 1, yycolumn));}
{Integer}                     { return new Symbol(Sym.INTEGER, yyline, yycolumn, new Token("Número Inteiro", yytext(), yyline + 1, yycolumn));}
{RelationalOperator}          { return new Symbol(Sym.RELATIONALOPERATOR,  new Token("Operador relacional", yytext(), yyline + 1, yycolumn)); }
{EmptyStatement}              { return new Symbol(Sym.EMPTYSTATEMENT, yyline, yycolumn, new Token("Declaração vazia", yytext(), yyline + 1, yycolumn));}
{Colon}                       { return new Symbol(Sym.COLON, yyline, yycolumn, new Token("Dois pontos", yytext(), yyline + 1, yycolumn));}
{AssignmentOperator}          { return new Symbol(Sym.ASSIGNMENTOPERATOR, yyline, yycolumn, new Token("Operador de atribuição", yytext(), yyline + 1, yycolumn));}
{ExclamationMark}             { return new Symbol(Sym.EXCLAMATIONMARK, yyline, yycolumn, new Token("Ponto de exclamação", yytext(), yyline + 1, yycolumn));}
{If}                          { return new Symbol(Sym.IF, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Else}                        { return new Symbol(Sym.ELSE, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{While}                       { return new Symbol(Sym.WHILE, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Functions}                   { return new Symbol(Sym.FUNCTIONS, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Vars}                        { return new Symbol(Sym.VARS, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Labels}                      { return new Symbol(Sym.LABELS, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Var}                         { return new Symbol(Sym.VAR, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Void}                        { return new Symbol(Sym.VOID, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Goto}                        { return new Symbol(Sym.GOTO, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Return}                      { return new Symbol(Sym.RETURN, yyline, yycolumn, new Token("Palavra reservada", yytext(), yyline + 1, yycolumn));}
{Identifier}                  {
                                    setIdentifiers(yytext().toLowerCase());
                                    return new Symbol(Sym.IDENTIFIER, yyline, yycolumn, new Token("Identificador", yytext(), yyline + 1, yycolumn));
                              }
{Comment}                     { /* ignore */ }

.                             { System.out.println("Caracter inválido: " + yytext()); }