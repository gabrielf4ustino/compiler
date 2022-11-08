package br.compiler.language;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Token {

    public String name;

    public String value;

    public Integer line;

    public Integer column;
}
