package com.project.back_end.services;

import com.project.back_end.models.User;
import com.project.back_end.repo.UserRepository;
import com.project.back_end.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    public User register(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(Instant.now());
        return userRepository.save(user);
    }

    public String authenticate(String username, String rawPassword) throws Exception {
    java.util.Optional<com.project.back_end.models.User> opt = userRepository.findByUsername(username);
    if (opt.isEmpty()) throw new Exception("Invalid credentials");
    com.project.back_end.models.User user = opt.get();
        if (!passwordEncoder.matches(rawPassword, user.getPassword())) throw new Exception("Invalid credentials");
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole().name());
        return jwtUtil.generateToken(user.getUsername(), claims);
    }
}
