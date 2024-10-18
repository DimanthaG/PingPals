package com.pingpals.pingpals.Controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.gson.GsonFactory; // Replaced deprecated JacksonFactory with GsonFactory
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UserService userService;

    @Value("${google.clientId}")
    private String CLIENT_ID;  // Injected from application.properties

    @Autowired
    public AuthController(UserService userService, @Value("${google.clientId}") String clientId) {
        this.userService = userService;
        this.CLIENT_ID = clientId;
    }

    @PostMapping("/google")
    public ResponseEntity<?> googleSignIn(@RequestBody Map<String, String> payload) {
        String idTokenString = payload.get("idToken");

        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(CLIENT_ID))  // Using the CLIENT_ID injected from properties
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload googlePayload = idToken.getPayload();

                String googleId = googlePayload.getSubject();
                String email = googlePayload.getEmail();
                String name = (String) googlePayload.get("name");
                String pictureUrl = (String) googlePayload.get("picture");

                // Process the Google user and generate access token and refresh token
                User user = userService.processGoogleUser(googleId, email, name, pictureUrl);

                String accessToken = userService.generateTokenForUser(user); // Access Token
                String refreshToken = userService.generateRefreshTokenForUser(user); // Refresh Token

                // Return both access and refresh tokens
                Map<String, String> response = new HashMap<>();
                response.put("accessToken", accessToken);
                response.put("refreshToken", refreshToken);
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(401).body("Invalid ID token.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("An error occurred.");
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
                Map<String, String> response = new HashMap<>();
                response.put("accessToken", newAccessToken);
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(401).body("Invalid refresh token.");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body("An error occurred while refreshing the token.");
        }
    }
}
