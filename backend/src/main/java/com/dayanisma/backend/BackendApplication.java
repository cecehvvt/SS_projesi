package com.dayanisma.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

@SpringBootApplication
public class BackendApplication {

	public static void main(String[] args) {
		loadDotEnv();
		SpringApplication.run(BackendApplication.class, args);
	}

	static void loadDotEnv() {
		List<Path> candidates = List.of(
				Path.of(".env"),
				Path.of("backend", ".env")
		);
		for (Path candidate : candidates) {
			if (Files.isRegularFile(candidate)) {
				loadDotEnvFile(candidate);
			}
		}
	}

	private static void loadDotEnvFile(Path path) {
		try {
			for (String rawLine : Files.readAllLines(path)) {
				String line = rawLine.trim();
				if (line.isEmpty() || line.startsWith("#") || !line.contains("=")) {
					continue;
				}
				int separator = line.indexOf('=');
				String key = line.substring(0, separator).trim();
				String value = line.substring(separator + 1).trim();
				if (key.isEmpty() || System.getProperty(key) != null || System.getenv(key) != null) {
					continue;
				}
				System.setProperty(key, unquote(value));
			}
		} catch (IOException exception) {
			throw new IllegalStateException(".env dosyasi okunamadi: " + path, exception);
		}
	}

	private static String unquote(String value) {
		if (value.length() >= 2) {
			char first = value.charAt(0);
			char last = value.charAt(value.length() - 1);
			if ((first == '"' && last == '"') || (first == '\'' && last == '\'')) {
				return value.substring(1, value.length() - 1);
			}
		}
		return value;
	}
}
