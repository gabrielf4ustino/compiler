package br.compiler.lexicalanalyzer;

import jflex.exceptions.GeneratorException;
import jflex.exceptions.SilentExit;

import java.nio.file.Paths;

public class LexicalAnalyzerGenerator {
    public static boolean Generate(String lexeme){
        try {
            String rootPath = Paths.get("").toAbsolutePath().toString();
            String subPath = "/src/main/java/br/compiler/lexicalanalyzer/";

            String file = rootPath + subPath + lexeme + ".lex";

            jflex.Main.generate(new String[]{file});
            return true;
        } catch (GeneratorException e) {
            System.out.println(e);
            return false;
        } catch (SilentExit e) {
            System.out.println(e);
            return false;
        }
    }
}