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
        //clear terminal
        clearTerminal();
        //start a new prompt scanner
        Scanner scan = new Scanner(System.in);
        String rootPath = Paths.get("").toAbsolutePath().toString();
        System.out.print(rootPath + "> ");
        //read a word in prompt
        String input = scan.next();
        //if input == quit end the program
        while (!Objects.equals(input, "quit")) {
            if (Objects.equals(input, "compile")) {
                input = scan.next();
                if (Objects.equals(input, "--help")) {
                    System.out.println("commands: compile | cat | quit | cls | clear\n" +
                            "usage: compile [-l | --lexical-analysis [<file>] [-o <name>]] [-g | --generate-analyzer [<file>]]\n" +
                            "       cat [<file>]" +
                            "       cls | clear");
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                } else if (Objects.equals(input, "-l") || Objects.equals(input, "--lexical-analysis")) {
                    try {
                        input = scan.next();
                        //start the lexical analyzer with the file passed as parameter
                        LexicalAnalyzer lexical = new LexicalAnalyzer(new FileReader(input));
                        String token;
                        input = scan.next();
                        if (!Objects.equals(input, "-o")) {
                            throw new RuntimeException();
                        }
                        input = scan.next();
                        //make the path "result" if it does not exist
                        File theDir = new File(rootPath + "/src/main/java/br/compiler/result");
                        if (!theDir.exists()) {
                            theDir.mkdirs();
                        }
                        //making the result file with the name passed as parameter
                        FileOutputStream outputStream = new FileOutputStream(rootPath + "/src/main/java/br/compiler/result/" + input + ".txt");
                        //writing result in file
                        while ((token = lexical.yytext()) != null) {
                            String value;
                            if (!Objects.equals(token, " "))
                                value = ", " + "\"" + token + "\"";
                            else
                                value = "";
                            String output = ("<" /*+ token.line + ":" + token.column + " " + lexical.yytext()*/ + value + ">\n");
                            outputStream.write(output.getBytes());
                        }
                        outputStream.close();
                        System.out.println("done.");
                        System.out.print(rootPath + "> ");
                        input = scan.next();
                    } catch (FileNotFoundException e) {
                        System.out.println("compile: file '" + input + "' not found.");
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (IOException e) {
                        System.out.println("error: " + e.getMessage());
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
                        //generating a new lexical analyzer
                        if (Generate(input)) {
                            if (System.getProperty("os.name").contains("Windows"))
                                //rerun the program with the new lexical analyzer (in windows)
                                new ProcessBuilder("cmd", "/c", "mvn install &&  java -jar ./target/compiler-v1.2.3-shaded.jar").inheritIO().start().waitFor();
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
                    } catch (FileNotFoundException e) {
                        System.out.println("compile: file '" + input + "' not found.");
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (IOException | InterruptedException e) {
                        System.out.println("error: " + e.getMessage());
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
            } else if (Objects.equals(input, "cls") || Objects.equals(input, "clear")) {
                clearTerminal();
                System.out.print(rootPath + "> ");
                input = scan.next();
            } else if (Objects.equals(input, "cat")) {
                try {
                    input = scan.next();
                    //reading the result file
                    FileReader file = new FileReader(rootPath + "/src/main/java/br/compiler/result/" + input + ".txt");
                    BufferedReader fileReader = new BufferedReader(file);
                    String line = fileReader.readLine();
                    //printing the result file in prompt
                    while (line != null) {
                        System.out.println(line);
                        line = fileReader.readLine();
                    }
                    file.close();
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                } catch (IOException e) {
                    System.out.println("error: " + e.getMessage());
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
        } catch (InterruptedException | IOException ignored) {
        }
    }
}
