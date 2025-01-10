# 헤아Ring - [ Front-end ] 회원가입 및 로그인 개발

현재 회원가입, 로그인은 화면단만 개발이 완료된 상태입니다. <br><br>

## 1. 필수 라이브러리 설치
회원 가입 화면에서 카메라를 통해 단말기에 부착된 QR 코드를 촬영합니다. QR 코드 인식을 위해 `barcode_scan2` 라이브러리를 사용하였습니다.

- `pubspec.yaml`에 다음 라이브러리를 설치합니다.
  - `barcode_scan2: ^4.1.6`
<br>

- `app/src/debug/AndroidManifest.xml`에 다음 코드를 작성하여 **카메라 권한을 요청**합니다.
  - ```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.hearing">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  </manifest>


## 2. 화면 구성 

### 2-1. 처음 시작 화면 
앱을 처음 실행할 시 등장하는 화면입니다. 버튼을 눌러 회원가입, 로그인을 진행합니다.

| <img src="https://github.com/user-attachments/assets/fe2b7807-6e2b-41da-ab5a-e2cf7885631a" alt="처음 시작 화면" width="250" height="500"/> |
|---------------|
| <p align="center">처음 시작 화면</p> |

<br><br>

### 2-2. 회원가입 화면
회원 가입을 진행합니다. 멀티 스텝 로직을 통해 3단계로 구현되었습니다. <br>
| <img src="https://github.com/user-attachments/assets/2af7a246-7f50-4a2e-ad73-c4b31ef4b3ef" alt="회원가입-1단계" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/b88ead87-8a06-4c25-b711-d5563d9d67fe" alt="회원가입-2단계" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/7a5d316e-0c2c-4011-9813-c7ad0a375154" alt="회원가입-2단계-생년월일" width="250" height="500"/> |<img src="https://github.com/user-attachments/assets/54f04b46-c799-4d77-9d3d-6fee361543b6" alt="회원가입-2단계-안전범위" width="250" height="500"/> |
|---------------|---------------|---------------|---------------|
| <p align="center">회원가입1-계정정보 입력</p> | <p align="center">회원가입2-상세정보 입력</p> | <p align="center">회원가입2-생년월일</p> | <p align="center">회원가입2-안전범위 선택</p> |
