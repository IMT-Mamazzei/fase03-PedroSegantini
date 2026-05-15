package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS (Expressões Regulares Auxiliares)                                  */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit = [0-9]
IdentifierChar = {Letter}|{Digit}|_
Identifier = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}{IdentifierChar}{32}{IdentifierChar}*

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                            */
/* ========================================================================= */

<YYINITIAL> {

    {WhiteSpace}    { /* Ignora espaços em branco */ }

    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }

    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    {OversizedIdentifier} {
        throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext());
    }

    .               { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

<<EOF>>             { return symbol(sym.EOF); }