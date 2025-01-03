package org.hdmd.hearingdemo.model;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String message;
    private String fcmToken;
    private boolean isRead = false;
    private int resendAttempts = 0;  // 재전송 횟수

    private LocalDateTime sentTime;  // 처음 보낸 시간

}
