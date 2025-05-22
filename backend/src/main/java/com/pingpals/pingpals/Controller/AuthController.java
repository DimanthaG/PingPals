package com.pingpals.pingpals.Controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.gson.GsonFactory; // Replaced deprecated JacksonFactory with GsonFactory
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);
    private final UserService userService;
    private final String androidClientId;
    private final String iosClientId;
    private final List<String> validClientIds;

    @Autowired
    public AuthController(UserService userService, 
                        @Value("${google.clientId}") String androidClientId,
                        @Value("${google.clientId.ios:#{null}}") String iosClientId) {
        this.userService = userService;
        this.androidClientId = androidClientId;
        this.iosClientId = iosClientId;
        
        // Create a list of valid client IDs
        this.validClientIds = new ArrayList<>();
        this.validClientIds.add(androidClientId);
        if (iosClientId != null && !iosClientId.isEmpty()) {
            this.validClientIds.add(iosClientId);
        }
        
        logger.info("AuthController initialized with Android client ID: {}", androidClientId);
        logger.info("AuthController initialized with iOS client ID: {}", iosClientId);
    }

    @PostMapping("/google")
    public ResponseEntity<?> googleSignIn(@RequestBody Map<String, String> payload) {
        String idTokenString = payload.get("idToken");

        try {
            logger.info("Processing Google sign-in request with token length: {}", idTokenString != null ? idTokenString.length() : 0);
            
            // Create a verifier without audience restriction - we'll verify audience manually
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(), GsonFactory.getDefaultInstance())
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload googlePayload = idToken.getPayload();

                // Log the audience and authorized party for debugging
                // Handle both String and Collection return types from getAudience()
                Object audienceObj = googlePayload.getAudience();
                String azp = (String) googlePayload.get("azp");
                
                logger.info("Token audience (string): {}, azp: {}", audienceObj, azp);
                
                boolean validAudience = false;
                
                // Handle different types of audience values
                if (audienceObj instanceof String) {
                    String audience = (String) audienceObj;
                    validAudience = validClientIds.contains(audience);
                } else if (audienceObj instanceof Collection<?>) {
                    Collection<?> audiences = (Collection<?>) audienceObj;
                    for (String validClientId : validClientIds) {
                        if (audiences.contains(validClientId)) {
                            validAudience = true;
                            break;
                        }
                    }
                } else {
                    logger.warn("Unknown audience type: {}", audienceObj != null ? audienceObj.getClass().getName() : "null");
                }
                
                boolean validAzp = azp != null && validClientIds.contains(azp);
                
                // Accept token if either audience or azp match any of our valid client IDs
                if (!validAudience && !validAzp) {
                    logger.error("Invalid token: neither audience ({}) nor azp ({}) match client IDs (Android: {}, iOS: {})", 
                                audienceObj, azp, androidClientId, iosClientId);
                    return ResponseEntity.status(401).body("Invalid ID token.");
                }
                
                logger.info("Token validation successful: audience match = {}, azp match = {}", 
                           validAudience, validAzp);

                String googleId = googlePayload.getSubject();
                String email = googlePayload.getEmail();
                String name = (String) googlePayload.get("name");
                String pictureUrl = (String) googlePayload.get("picture");

                // Process the Google user and generate access token and refresh token
                User user = userService.processGoogleUser(googleId, email, name, pictureUrl);

                String accessToken = userService.generateTokenForUser(user); // Access Token
                String refreshToken = userService.generateRefreshTokenForUser(user); // Refresh Token

                // Log the user ID and tokens for debugging
                logger.info("Authentication successful for user ID: {}", user.getId());
                logger.info("Generated access token: {}", accessToken);
                logger.info("Generated refresh token: {}", refreshToken);

                // Return both access and refresh tokens
                Map<String, String> response = new HashMap<>();
                response.put("accessToken", accessToken);
                response.put("refreshToken", refreshToken);
                return ResponseEntity.ok(response);
            } else {
                logger.error("Invalid ID token provided during authentication attempt");
                return ResponseEntity.status(401).body("Invalid ID token.");
            }
        } catch (Exception e) {
            logger.error("Authentication error: ", e);
            return ResponseEntity.status(500).body("An error occurred: " + e.getMessage());
        }
    }

    // Add Refresh Token Endpoint
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshToken(@RequestBody Map<String, String> payload) {
        String refreshToken = payload.get("refreshToken");

        try {
            // Validate and parse the refresh token to generate a new access token
            String newAccessToken = userService.refreshAccessToken(refreshToken);
            if (newAccessToken != null) {
                // Log the new access token
                logger.info("Generated new access token from refresh token: {}", newAccessToken);

                Map<String, String> response = new HashMap<>();
                response.put("accessToken", newAccessToken);
                return ResponseEntity.ok(response);
            } else {
                logger.error("Invalid refresh token attempt");
                return ResponseEntity.status(401).body("Invalid refresh token.");
            }
        } catch (Exception e) {
            logger.error("Error refreshing token: ", e);
            return ResponseEntity.status(500).body("An error occurred while refreshing the token.");
        }
    }
}
