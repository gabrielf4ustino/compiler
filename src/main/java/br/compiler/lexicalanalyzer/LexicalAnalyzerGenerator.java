package br.compiler.lexicalanalyzer;

import jflex.exceptions.GeneratorException;
import jflex.exceptions.SilentExit;

import java.nio.file.Paths;

public class LexicalAnalyzerGenerator {
    public static boolean Generate(String lexeme) {
        try {
            String rootPath = Paths.get("").toAbsolutePath().toString();
            String subPath = "/src/main/java/br/compiler/lexicalanalyzer/";
            jflex.Main.generate(new String[]{rootPath + subPath + lexeme + ".lex"});
            return true;
        } catch (GeneratorException | SilentExit e) {
            return false;
        }
    }
}