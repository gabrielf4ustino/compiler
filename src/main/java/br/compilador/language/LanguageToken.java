package br.compilador.language;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class LanguageToken {

    public String name;
    public String value;
    public Integer line;
    public Integer column;
}
