package br.compilador;

import br.compilador.language.LanguageToken;
import br.compilador.lexicalanalyzer.LexicalAnalyzer;
import jflex.exceptions.SilentExit;

import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Objects;
import java.util.Scanner;

import static br.compilador.lexicalanalyzer.LexicalAnalyzerGenerator.Generate;

public class Main {

    public static void main(String[] args) throws IOException, SilentExit, InterruptedException {

        Scanner scan = new Scanner(System.in);
        printMenu();
        String option = scan.next();
        while (!Objects.equals(option, "0")) {
            switch (option) {
                case "0" -> {
                    System.out.println(option);
                    option = "0";
                }
                case "1" -> {
                    clearTerminal();
                    System.out.println("Gerando analizador léxico...");
                    Generate();
                    if (System.getProperty("os.name").contains("Windows"))
                        new ProcessBuilder("cmd", "/c", "mvn install && mvn exec:java").inheritIO().start().waitFor();
                    else
                        Runtime.getRuntime().exec("mvn install && mvn exec:java");
                }
                case "2" -> {
                    clearTerminal();
                    System.out.println("Executando teste...");
                    String rootPath = Paths.get("").toAbsolutePath().toString();
                    String subPath = "/src/main/java/br/compilador/test";
                    String sourceCode = rootPath + subPath + "/test.txt";
                    LexicalAnalyzer lexical = new LexicalAnalyzer(new FileReader(sourceCode));
                    LanguageToken token;
                    while ((token = lexical.yylex()) != null) {
                        System.out.println("<" + token.name + ", " + token.value + "> (" + token.line + ":" + token.column + ")");
                    }
                    printMenu();
                    option = scan.next();
                }
                default -> {
                    clearTerminal();
                    printMenu();
                    option = scan.next();
                }
            }
        }
    }

    private static void printMenu() {
        System.out.println("Selecione uma das opções: \n 1 - Gerar analizador léxico (será necessário recompilar o programa) \n 2 - Executar teste \n 0 - Sair");
    }

    private static void clearTerminal() throws InterruptedException, IOException {
        if (System.getProperty("os.name").contains("Windows"))
            new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
        else
            Runtime.getRuntime().exec("clear");
    }
}
