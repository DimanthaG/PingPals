package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // Use @Value to inject the JWT secret from application.properties
    @Value("${jwt.secret}")
    private String jwtSecret;

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    public User processGoogleUser(String googleId, String email, String name, String pictureUrl) {
        try {
            Optional<User> optionalUser = userRepository.findByGoogleId(googleId);
            logger.info("Processing Google user with ID: {}", googleId);
            if (optionalUser.isPresent()) {
                User user = optionalUser.get();
                user.setEmail(email);
                user.setName(name);
                user.setPictureUrl(pictureUrl);
                userRepository.save(user);
                return user;
            } else {
                User user = new User();
                user.setGoogleId(googleId);
                user.setEmail(email);
                user.setName(name);
                user.setPictureUrl(pictureUrl);
                userRepository.save(user);
                return user;
            }
        } catch (org.springframework.dao.DuplicateKeyException e) {

            return userRepository.findByGoogleId(googleId).orElseThrow(() -> e);
        }
    }

    public String generateTokenForUser(User user) {
        long expirationTime = 86400000L;  // 1 day in milliseconds
        Key key = Keys.hmacShaKeyFor(jwtSecret.getBytes());

        return Jwts.builder()
                .setSubject(user.getId())
                .claim("name", user.getName())
                .claim("email", user.getEmail())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public String generateRefreshTokenForUser(User user) {
        long refreshExpirationTime = 2592000000L; // 30 days in milliseconds
        Key key = Keys.hmacShaKeyFor(jwtSecret.getBytes());

        return Jwts.builder()
                .setSubject(user.getId())
                .claim("name", user.getName())
                .claim("email", user.getEmail())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + refreshExpirationTime))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public String refreshAccessToken(String refreshToken) {
        try {
            Key key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(refreshToken)
                    .getBody();

            String userId = claims.getSubject();
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            return generateTokenForUser(user);  // Generate new access token
        } catch (Exception e) {
            return null;  // Handle token validation failure
        }
    }

    public void removeFriend(String userId, String friendId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new RuntimeException("Friend not found with id: " + friendId));

        if (user.getFriends() != null) {
            user.getFriends().remove(friendId);
        }

        if (friend.getFriends() != null) {
            friend.getFriends().remove(userId);
        }

        userRepository.save(user);
        userRepository.save(friend);
    }

    // Method to search for users by name or email
    public List<User> searchUsers(String query) {
        return userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(query, query);
    }


    public List<User> getFriendsForUser(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<User> friends = userRepository.findAllById(user.getFriends());
        return friends;
    }

}


