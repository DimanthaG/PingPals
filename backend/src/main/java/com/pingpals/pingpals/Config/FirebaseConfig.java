package com.pingpals.pingpals.Config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

@Configuration
public class FirebaseConfig {

    @Bean
    public FirebaseMessaging firebaseMessaging() throws IOException {
        GoogleCredentials googleCredentials;
        
        // Get Firebase credentials JSON from environment variable
        String firebaseCredentialsJson = EnvConfig.getEnv("FIREBASE_CREDENTIALS_JSON");
        
        if (firebaseCredentialsJson != null && !firebaseCredentialsJson.isEmpty()) {
            try (InputStream credentialsStream = new ByteArrayInputStream(firebaseCredentialsJson.getBytes())) {
                googleCredentials = GoogleCredentials.fromStream(credentialsStream);
                System.out.println("Using Firebase credentials from environment variable");
            }
        } else {
            // Fallback to file for development or testing
            try (InputStream credentialsStream = new ClassPathResource("firebase-service-account.json").getInputStream()) {
                googleCredentials = GoogleCredentials.fromStream(credentialsStream);
                System.out.println("Using Firebase credentials from file (fallback)");
            }
        }

        FirebaseOptions firebaseOptions = FirebaseOptions.builder()
                .setCredentials(googleCredentials)
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(firebaseOptions);
        }

        return FirebaseMessaging.getInstance();
    }
}