package br.compiler;

import br.compiler.language.Token;
import br.compiler.lexicalanalyzer.LexicalAnalyzer;
import br.compiler.syntacticanalyzer.Parser;
import br.compiler.syntacticanalyzer.Sym;
import java_cup.runtime.Symbol;

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
                    System.out.println("""
                            commands: compile | cat | quit | cls | clear
                            usage: compile [-l  | --lexical-analysis [<file>] [-o <name>]] 
                                           [-s  | --syntactic-analysis [<file>]]
                                           [-gl | --generate-lexical-analysis [<file>]]
                                           [-gs | --generate-syntactic-analysis [<file>]]
                                   cat [<file>]       cls | clear""");
                    System.out.print(rootPath + "> ");
                    input = scan.next();
                } else if ((Objects.equals(input, "-l") || Objects.equals(input, "--lexical-analysis"))) {
                    try {
                        input = scan.next();
                        //start the scanner analyzer with the file passed as parameter
                        LexicalAnalyzer scanner = new LexicalAnalyzer(new FileReader(input));
                        Symbol token = scanner.next_token();
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
                        while (token.sym != Sym.EOF) {
                            Token tokenObj = (Token) token.value;
                            String value;
                            if (!Objects.equals(tokenObj.value, " "))
                                value = ", " + "\"" + tokenObj.value + "\"";
                            else
                                value = "";
                            String output = ("<" + tokenObj.line + ":" + tokenObj.column + " " + tokenObj.name + value + ">\n");
                            outputStream.write(output.getBytes());
                            token = scanner.next_token();
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
                } else if ((Objects.equals(input, "-s") || Objects.equals(input, "--syntactic-analysis"))) {
                    try {
                        input = scan.next();
                        //start the parse analyzer with the file passed as parameter
                        Parser parser = new Parser(new LexicalAnalyzer(new FileReader(input)));
                        parser.parse();
                        System.out.println("Syntactically correct program.");
                        System.out.print(rootPath + "> ");
                        input = scan.next();
                    }catch (FileNotFoundException e) {
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
                        System.out.println(e);
                        System.out.println("compile: '" + input + "' is not a compile command. See 'compile --help'.");
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                        System.out.print(rootPath + "> ");
                        if (scan.hasNext()) {
                            scan.nextLine();
                        }
                        input = scan.next();
                    }
                } else if (Objects.equals(input, "-gl") || Objects.equals(input, "--generate-lexical-analysis")) {
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
                                System.out.println("""
                                        ##########################################################
                                        Recompile o programa para as alterações entrarem em vigor.
                                        ##########################################################""");
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
