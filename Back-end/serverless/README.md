# 헤아Ring - [ BE ] AWS Lambda 업로드 소스
해당 디렉토리에 있는 extract-data.zip, GPS WebSocket.zip 파일을 서버가 있는 AWS 프로젝트 내 Lambda에 업로드하여 사용합니다.

## 1. 메타데이터 추출 (S3 Event Handler)
- 단말기에서 S3로 업로드한 .mp3 파일로부터 메타데이터를 추출하고 DB에 저장할 수 있는 형태로 변환, API를 호출하는 함수입니다.

1. **AWS Lambda 콘솔**에서 새로운 함수를 생성한다.
   - **함수 이름**: `extract-data`
   - **런타임**: Python 3.13
   - **아키텍처**: x86_64

2. 녹음 파일이 업로드될 S3 인스턴스의 **생성 이벤트**를 함수 트리거로 등록한다.

3. extract-data.zip 파일을 업로드한다.

4. `Deploy` (Ctrl+Shift+U)를 눌러 함수를 배포한다.

---

## 2. 실시간 위치 확인 (GPS-WebSocket)
- 안드로이드 앱에서 GPS 화면을 열었을 때 단말기로 MQTT 메시지를 전송하여 실시간 위치 정보를 전달하도록 하는 함수 및 WebSocket API입니다.

1. **AWS Lambda 콘솔**에서 새로운 함수를 생성한다.
   - **함수 이름**: `GPS-WebSocket`
   - **런타임**: Python 3.13
   - **아키텍처**: x86_64

2. `GPS WebSocket.zip` 파일을 업로드한다.

3. `Deploy` (Ctrl+Shift+U)를 눌러 함수를 배포한다.

4. **AWS API Gateway 콘솔**에서 새로운 WebSocket API를 생성한다.
   - **API 이름**: `GPS`
   - **라우팅 선택 표현식**: `$request.body.action`

5. **미리 정의된 경로**를 추가한다.
   - `$connect`
   - `$disconnect`
   - `$default`

6. **사용자 지정 경로**를 추가한다.
   - `sendLocation`

7. 각 경로에 `GPS-WebSocket` 함수를 통합한다.

8. **스테이지 이름**을 설정하고 API를 배포한다.
