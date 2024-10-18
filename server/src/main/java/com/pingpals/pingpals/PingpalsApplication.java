package com.pingpals.pingpals;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.pingpals.pingpals")
public class PingpalsApplication {
	public static void main(String[] args) {
		SpringApplication.run(PingpalsApplication.class, args);
	}
}

