package com.pingpals.pingpals.Config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
public class EnvConfig {
    
    @Autowired
    private Environment springEnv;
    
    private static Dotenv dotenv;
    
    @PostConstruct
    public void init() {
        // Only load .env file in development environment
        if (!isProduction()) {
            dotenv = Dotenv.configure()
                    .ignoreIfMissing()
                    .load();
            
            // Print a message to indicate dotenv is loaded
            System.out.println("Loaded environment variables from .env file");
        } else {
            System.out.println("Running in production mode, using system environment variables");
        }
    }
    
    private boolean isProduction() {
        String[] activeProfiles = springEnv.getActiveProfiles();
        for (String profile : activeProfiles) {
            if (profile.equals("prod") || profile.equals("production")) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get an environment variable, first checking system environment,
     * then the .env file if in development
     */
    public static String getEnv(String key) {
        String value = System.getenv(key);
        
        // If not found in system environment and dotenv is loaded, try dotenv
        if ((value == null || value.isEmpty()) && dotenv != null) {
            value = dotenv.get(key);
        }
        
        return value;
    }
}