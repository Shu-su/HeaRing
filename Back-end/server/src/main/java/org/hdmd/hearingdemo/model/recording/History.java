package org.hdmd.hearingdemo.model.recording;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.hdmd.hearingdemo.model.device.Device;
import org.hibernate.annotations.GenericGenerator;

import java.util.UUID;

@Entity @Data
@NoArgsConstructor(access = AccessLevel.PUBLIC)
@AllArgsConstructor
@Schema(description = "기록 엔티티")
@Table(name="history")
public class History {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="history_id", nullable = false)
    @Schema(description = "기록 아이디")
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "device_id",nullable = false)
    @Schema(description = "소속 단말기")
    private Device device;

    @Column(name = "created_at")
    @Schema(description = "생성 시각")
    private String timestamp;

    @Column(name = "location")
    @Schema(description = "발화 위치 주소 정보")
    private String location;

    @Column(name = "filepath")
    @Schema(description = "파일 저장 경로")
    private String filepath;

    @Column(name= "text")
    @Schema(description = "발화 텍스트")
    private String text;

}

