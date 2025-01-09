# Back-end Server 업로드 소스

해당 디렉토리를 헤아Ring 프로젝트의 백엔드 서버에 업로드하여 사용합니다. <br>
Spring Boot를 기반으로 RESTful API를 제공하며, AWS EC2에서 구현되는 것을 전제로 합니다. 

## 주요 기능
- 사용자 및 단말기 관리: 보호자가 관리할 단말기를 등록하고 정보를 수정할 수 있습니다.
- 녹음 데이터 처리 및 저장: 단말기로부터 전송받은 녹음 데이터를 서버에 저장하고 처리합니다.
- 위험 감지 및 알림 전송: 위험으로 판단된 데이터를 보호자가 확인할 수 있도록 알림을 발송합니다.
- 위험상황 데이터 조회 및 저장: 보호자의 판단 하에 데이터를 처리할 수 있도록 조회 및 기록으로 저장 기능을 제공합니다.

## 개발 환경 
- **프레임워크**: Spring Boot
- **데이터베이스**: MySQL
- **배포 환경**: AWS EC2 t2.micro 인스턴스 사용
- **알림 서비스**: Firebase FCM 
- **IDE**: IntelliJ IDEA  
- **빌드 도구**: Maven  
- **운영 체제**: Ubuntu 20.04  

---

# 실행 방법

## 1. 기본 프로그램 설치  

### 1.1 서버 업데이트
```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2 서버 Java JDK 21 설치
```bash
sudo apt update
sudo apt install openjdk-21-jdk -y
```

### 1.3 Maven 설치
```bash
sudo apt install maven -y
```

### 1.4 MQTT 브로커(Mosquitto) 설치 및 활성화
```bash
sudo apt install mosquitto mosquitto-clients -y
sudo systemctl enable mosquitto
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
```


## 2. Spring Boot 애플리케이션 설정
### 2.1 프로젝트 배포
* 해당 디렉토리의 .zip(pom.xml 포함) 을 서버에 업로드 후 압축 해제하여 사용합니다. 


### 2.2 application.properties 설정
아래와 같이 RDS MySQL 연결 정보와 AWS 자격 증명을 입력합니다.
```php
spring.datasource.url=jdbc:mysql://<RDS_ENDPOINT>:3306/<DB_NAME>
spring.datasource.username=<DB_USERNAME>
spring.datasource.password=<DB_PASSWORD>

cloud.aws.credentials.access-key=<AWS_ACCESS_KEY>
cloud.aws.credentials.secret-key=<AWS_SECRET_KEY>
```

### 2.3 애플리케이션 자동 실행 설정
서비스 파일 생성:
``bash
sudo nano /etc/systemd/system/hearingdemo.service
```
아래 내용을 작성 후 저장:
```ini
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/bin/java -jar /home/ubuntu/hearing/hearingdemo.jar
Restart=always

[Install]
WantedBy=multi-user.target
```
서비스 활성화 및 시작
```bash
sudo systemctl enable hearingdemo
sudo systemctl start hearingdemo
```

## 3. DB 설정
### 3.1 RDS 데이터베이스 생성
AWS Management Console에서 RDS를 생성하고 MySQL 엔진을 선택합니다.

### 3.2 데이터베이스 초기화
EC2 인스턴스에서 MySQL 클라이언트를 사용해 데이터베이스를 초기화합니다:
```bash
mysql -h <RDS_ENDPOINT> -u <DB_USERNAME> -p
```

---

## API 문서 확인
해당 프로젝트에서 사용되는 REST API 명세서는 Swagger를 통해 제공됩니다. <br>
로컬 서버 실행 후 http://localhost:8080/swagger-ui.html 에서 확인하실 수 있습니다.
