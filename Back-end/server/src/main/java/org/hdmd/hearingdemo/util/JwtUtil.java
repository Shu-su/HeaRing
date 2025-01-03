//package org.hdmd.hearingdemo.util;
//
//import io.jsonwebtoken.Claims;
//import io.jsonwebtoken.Jwts;
//import io.jsonwebtoken.SignatureAlgorithm;
//import java.util.Date;
//
//public class JwtUtil {
//    private String secretKey = "hearing"; //비밀키
//
//    public String generateToken(String username) {
//        return Jwts.builder()
//                .setSubject(username)
//                .setIssuedAt(new Date())
//                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60* 24)) // 1일 만료
//                .signWith(SignatureAlgorithm.HS256, secretKey)
//                .compact();
//    }
//
//    public Claims extractClaims(String token) {
//        return Jwts.parser()
//                .setSigningKey(secretKey)
//                .parseClaimsJws(token)
//                .getBody();
//    }
//
//    public boolean isTokenExpired(String token) {
//        return extractClaims(token).getExpiration().before(new Date());
//    }
//
//    public boolean validateToken(String token, String username) {
//        final String tokenUsername = extractClaims(token).getSubject();
//        return (tokenUsername.equals(username) && !isTokenExpired(token));
//    }
//}
