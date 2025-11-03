package com.project.back_end.services;

import com.project.back_end.security.JwtUtil;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class TokenService {
    private final JwtUtil jwtUtil;

    public TokenService(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    public String generateToken(String username, Map<String, Object> claims) {
        return jwtUtil.generateToken(username, claims);
    }

    public boolean validate(String token) {
        try {
            jwtUtil.validateToken(token);
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    public String getUsername(String token) {
        return jwtUtil.getUsername(token);
    }
}
