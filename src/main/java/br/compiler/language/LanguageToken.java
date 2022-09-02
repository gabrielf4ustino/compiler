package br.compiler.language;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
public class LanguageToken {

    public String name;

    public String value;

    public Integer line;

    public Integer column;
}
