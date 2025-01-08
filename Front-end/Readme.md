## 헤아Ring - [ Front-end ] Readme :seedling:

![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
   
### 1. App 구성도
![app구성도](https://github.com/user-attachments/assets/1f5c792f-bcb7-4a5a-b516-ebcca10c25eb)

### 2. 필수 라이브러리

프로젝트를 시작하기 전에 다음 라이브러리를 반드시 설치해야 합니다. <br>   
지도는 네이버 지도 API를, 알림 서비스는 **Firebase Cloud Messaging(FCM)**을 사용합니다. <br>
+지도와 알림 서비스를 사용하기 위해 별도로 API 키 발급과 FCM 토큰 생성 작업이 필요로 합니다. <br>

##### 지도 및 위치 관련
- `flutter_naver_map`: 네이버 지도 API 연동을 위한 라이브러리
- `geocoding`: 주소 및 좌표 변환을 위한 라이브러리

##### 알림 및 메시징
- `flutter_local_notifications`: 로컬 푸시 알림 기능 구현
- `firebase_messaging`: Firebase Cloud Messaging(FCM)을 통한 푸시 알림 처리

##### Firebase 관련
- `firebase_core`: Firebase와 기본적으로 연결하기 위한 필수 라이브러리
- `firebase_analytics`: Firebase Analytics를 통해 앱 분석 데이터를 수집

##### 오디오 및 비디오 관련
- `just_audio`: 오디오 재생 기능 제공
- `audio_video_progress_bar`: 오디오/비디오 진행 상황을 표시하는 프로그레스 바

##### HTTP 통신
- `http`: HTTP 요청을 보내고 서버에서 응답을 받기 위한 라이브러리
- `web_socket_channel`: 실시간 통신을 위한 웹소켓 라이브러리

##### 상태 관리 및 데이터 저장
- `provider`: 상태 관리를 위한 라이브러리
- `shared_preferences`: 로컬 저장소에 간단한 데이터를 저장하고 불러오기 위한 라이브러리

##### 기타
- `intl`: 날짜와 숫자의 국제화 처리를 위한 라이브러리

### 3. 주요 기능

#### 3.1 메인화면 및 알림 목록
**메인화면** <br>
메인화면에서 치매 환자의 외출, 귀가, 위험 상태를 정보를 제공합니다. <br>
정보를 제공하기 위해 Fcm 에서 수신한 메세지를 provider 및 shared_preferences 라이브러리를 활용하여 UI를 즉각 업데이트합니다.<br> 
위험 상황으로 돌아가기를 버튼을 누르면 알림 목록 팝업이 열리며 원하는 위험 상황을 확인할 수 있습니다.<br>
이전기록 다시보기 및 GPS 화면으로 이동할 수 있습니다. 

**알림 목록**<br>
수신한 메세지의 data가 있으면 recodeid 및 notificationId, timestamp 값을 저장합니다. <br>
provider 및 shared_preferences 라이브러리를 활용되며, 사용자가 열람한 데이터는 회색, 미확인 데이터는 하늘색배경으로 표시됩니다. <br>
* recodeid - 서버에 데이터 조회 요청을 하기 위해 사용
* notificationId - 읽음 처리 작업에 사용
* timestamp - 사용자 편의

알림 목록

|               |               |
|---------------|---------------|
| <img src="https://github.com/user-attachments/assets/a3d34466-7c52-411e-a99d-dbb744537ebe" alt="메인화면" width="250" height="550"/> | <img src="https://github.com/user-attachments/assets/d251da22-61ed-427b-80ce-631f424df9e2" alt="알림목록" width="250" height="550"/> |
| <p align="center">메인 화면</p> | <p align="center">알림 목록</p> |

#### 3.2 위험감지 화면 및 녹음 화면
**위험 감지 화면** <br>
위험 감지 화면에서는 <br> 
_위험 발생 시간 확인, 발화위치(지도 및 텍스트), 발화 문장, 녹음 듣기 (녹음 화면으로 이동), 현재 위치 확인 (GPS 화면으로 이동)_ 기능을 제공합니다. <br>

**녹음 듣기 화면** <br>
치매 환자의 실제 발화 내용을 녹음 파일을 통해 들어볼 수 있습니다.

**위험 상황 종료 팝업** <br>
위험 상황을 종료할 때 사용자가 실제 위험 상황이었는지 확인하여 해당 정보를 저장할 수 있습니다.<br>
저장된 정보는 이전기록 다시보기에서 확인할 수 있습니다. 

| <img src="https://github.com/user-attachments/assets/884a733a-3e79-41f4-8f3d-595458cfd5a5" alt="위험감지" width="250" height="550"/>    | 셀 1,2 내용    |  <img src="https://github.com/user-attachments/assets/335abb78-c93c-45f1-a8cd-83d5123bcdb1" alt="팝업1" width="250" height="550"/>   | <img src="https://github.com/user-attachments/assets/451a3361-cb2c-4259-ad43-1d2ff8bb96b0" alt="팝업2" width="250" height="550"/>    |
|----------------|----------------|----------------|----------------|
| <p align="center">위험 감지 화면</p> | <p align="center">녹음 화면</p> | <p align="center">상황 종료 팝업_1</p> | <p align="center">상황 종료 팝업_2</p> |




<img src="https://github.com/user-attachments/assets/d251da22-61ed-427b-80ce-631f424df9e2" alt="알림목록" width="200" height="550"/>


