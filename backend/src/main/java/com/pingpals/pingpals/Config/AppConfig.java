package com.pingpals.pingpals.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.boot.autoconfigure.mongo.MongoProperties;

@Configuration
public class AppConfig {

    @Autowired
    private Environment springEnv;

    @Bean
    @Primary
    public MongoProperties mongoProperties() {
        MongoProperties properties = new MongoProperties();
        
        // Try to get MongoDB URI from environment
        String mongoUri = EnvConfig.getEnv("MONGODB_URI");
        if (mongoUri != null && !mongoUri.isEmpty()) {
            properties.setUri(mongoUri);
            System.out.println("Using MongoDB URI from environment variable");
        } else {
            // Fallback to application.properties
            properties.setUri(springEnv.getProperty("spring.data.mongodb.uri"));
            System.out.println("Using MongoDB URI from application.properties");
        }
        
        return properties;
    }
    
    @Bean
    public String jwtSecret() {
        // Try to get JWT secret from environment
        String jwtSecret = EnvConfig.getEnv("JWT_SECRET");
        if (jwtSecret != null && !jwtSecret.isEmpty()) {
            System.out.println("Using JWT secret from environment variable");
            return jwtSecret;
        } else {
            // Fallback to application.properties
            String secret = springEnv.getProperty("jwt.secret");
            System.out.println("Using JWT secret from application.properties");
            return secret;
        }
    }
    
    @Bean
    public String googleClientId() {
        // Try to get Google Client ID from environment
        String googleClientId = EnvConfig.getEnv("GOOGLE_CLIENT_ID");
        if (googleClientId != null && !googleClientId.isEmpty()) {
            System.out.println("Using Google Client ID from environment variable");
            return googleClientId;
        } else {
            // Fallback to application.properties
            String clientId = springEnv.getProperty("google.clientId");
            System.out.println("Using Google Client ID from application.properties");
            return clientId;
        }
    }
}