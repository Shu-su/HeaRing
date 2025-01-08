## 헤아Ring - [ Front-end ] Readme :seedling:

![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
   
### 1. App 구성도


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
- `cupertino_icons`: iOS 스타일의 아이콘을 제공하는 라이브러리
- `googleapis`: Google API 사용을 위한 라이브러리
- `intl`: 날짜와 숫자의 국제화 처리를 위한 라이브러리

### 3. 주요 기능
