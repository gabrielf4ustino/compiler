package br.compiler;

import br.compiler.language.LanguageToken;
import br.compiler.lexicalanalyzer.LexicalAnalyzer;

import java.io.*;
import java.nio.file.Paths;
import java.util.Objects;
import java.util.Scanner;

import static br.compiler.lexicalanalyzer.LexicalAnalyzerGenerator.Generate;

public class Main {

    public static void main(String[] args) {
        clearTerminal();
        Scanner scan = new Scanner(System.in);
        String rootPath = Paths.get("").toAbsolutePath().toString();
        System.out.print(rootPath + "> ");
        String input = scan.next();
        while (!Objects.equals(input, "quit")) {
            if (Objects.equals(input, "compile")) {
                input = scan.next();
                if (Objects.equals(input, "--help")) {
                    System.out.println("usage: compile [-l | --lexical-analysis [<file>] [-o <name>]] [-g | --generate-analyzer [<file>]]");
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                } else if (Objects.equals(input, "-l") || Objects.equals(input, "--lexical-analysis")) {
                    try {
                        input = scan.next();
                        String subPath = "/src/main/java/br/compiler/test/";
                        String sourceCode = rootPath + subPath + input + ".txt";
                        LexicalAnalyzer lexical = new LexicalAnalyzer(new FileReader(sourceCode));
                        LanguageToken token;
                        input = scan.next();
                        if (!Objects.equals(input, "-o")) {
                            throw new RuntimeException();
                        }
                        input = scan.next();
                        FileOutputStream outputStream = new FileOutputStream(rootPath + "/src/main/java/br/compiler/result/" + input + ".txt");
                        while ((token = lexical.yylex()) != null) {
                            String output = ("<" + token.name + ", " + token.value + "> (" + token.line + ":" + token.column + ") \n");
                            outputStream.write(output.getBytes());
                        }
                        outputStream.close();
                        System.out.println("done.");
                        System.out.print(rootPath + "> ");
                        input = scan.next();
                    } catch (FileNotFoundException e) {
                        System.out.println("compile: file '" + input + "' not founded.");
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (IOException e) {
                        System.out.println("error: " + e);
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (RuntimeException e) {
                        System.out.println("compile: '" + input + "' is not a compile command. See 'compile --help'.");
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    }
                } else if (Objects.equals(input, "-g") || Objects.equals(input, "--generate-analyzer")) {
                    try {
                        input = scan.next();
                        clearTerminal();
                        System.out.println("Gerando analizador léxico...");
                        if (Generate(input)) {
                            if (System.getProperty("os.name").contains("Windows"))
                                new ProcessBuilder("cmd", "/c", "mvn install && mvn exec:java").inheritIO().start().waitFor();
                            else {
                                System.out.println("##########################################################\n" +
                                                   "Recompile o programa para as alterações entrarem em vigor.\n" +
                                                   "##########################################################");
                            }
                            System.out.print(rootPath + "> ");
                            input = scan.next();
                        } else {
                            throw new FileNotFoundException();
                        }
                    } catch (IOException e) {
                        System.out.println("error: " + e);
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (InterruptedException e) {
                        System.out.println("error: " + e);
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    }
                } else {
                    System.out.println("compile: '" + input + "' is not a compile command. See 'compile --help'.");
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                }
            } else if (Objects.equals(input, "cat")) {
                try {
                    input = scan.next();
                    FileReader file = new FileReader(rootPath + "/src/main/java/br/compiler/result/" + input + ".txt");
                    BufferedReader fileReader = new BufferedReader(file);
                    String line = fileReader.readLine();
                    while (line != null) {
                        System.out.printf("%s\n", line);
                        line = fileReader.readLine();
                    }
                    file.close();
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                } catch (FileNotFoundException e) {
                    System.out.println("error: " + e);
                    System.out.print(rootPath + "> ");
                    if (scan.hasNext()) {
                        scan.nextLine();
                    }
                    input = scan.next();
                } catch (IOException e) {
                    System.out.println("error: " + e);
                    System.out.print(rootPath + "> ");
                    if (scan.hasNext()) {
                        scan.nextLine();
                    }
                    input = scan.next();
                }
            } else {
                System.out.println("compile: '" + input + "' is not a compile command. See 'compile --help'.");
                System.out.print(rootPath + "> ");
                input = scan.next();
            }
        }
    }

    private static void clearTerminal() {
        try {
            if (System.getProperty("os.name").contains("Windows"))
                new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
            else {
                Process process = Runtime.getRuntime().exec("clear");
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println(line);
                }
            }
        } catch (InterruptedException e) {
        } catch (IOException e) {
        }
    }
}
