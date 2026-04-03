package com.clinic.security;

import org.springframework.stereotype.Service;

import java.util.Base64;

@Service
public class TokenService {

    private static final String SECRET = "clinic-secret";

    // ✅ Gerar token (simples estilo JWT)
    public String generateToken(String username) {
        String raw = username + ":" + SECRET;
        return Base64.getEncoder().encodeToString(raw.getBytes());
    }

    // ✅ Validar token
    public boolean validateToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token));
            return decoded.contains(SECRET);
        } catch (Exception e) {
            return false;
        }
    }

    // 🔥 Extrair username do token
    public String getUsernameFromToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token));
            return decoded.split(":")[0];
        } catch (Exception e) {
            return null;
        }
    }
}