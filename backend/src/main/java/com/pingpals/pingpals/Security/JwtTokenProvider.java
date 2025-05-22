package com.pingpals.pingpals.Security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtTokenProvider {
    
    private final Key key;

    @Autowired
    public JwtTokenProvider(String jwtSecret) {
        // Use the injected jwtSecret from our AppConfig
        this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    // ... rest of the existing code ...
}