package br.compilador.lexicalanalyzer;

import jflex.exceptions.SilentExit;

import java.nio.file.Paths;

public class LexicalAnalyzerGenerator {
    public static void Generate() throws SilentExit {
        String rootPath = Paths.get("").toAbsolutePath(). toString();
        String subPath = "/src/main/java/br/compilador/lexicalanalyzer/";

        String file = rootPath + subPath + "lexeme.lex";

        jflex.Main.generate(new String[]{file});
    }
}