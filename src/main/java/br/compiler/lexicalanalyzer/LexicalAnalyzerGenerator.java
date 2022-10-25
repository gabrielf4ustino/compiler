package br.compiler.lexicalanalyzer;

import jflex.exceptions.GeneratorException;
import jflex.exceptions.SilentExit;

import java.nio.file.Paths;

public class LexicalAnalyzerGenerator {
    public static boolean Generate(String lexeme) {
        try {
            jflex.Main.generate(new String[]{lexeme});
            return true;
        } catch (GeneratorException | SilentExit e) {
            return false;
        }
    }
}