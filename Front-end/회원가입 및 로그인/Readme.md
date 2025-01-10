# 헤아Ring - [ Front-end ] 회원가입 및 로그인 개발
![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

현재 회원가입, 로그인은 화면단만 개발이 완료된 상태입니다. <br><br>

## 1. 필수 라이브러리 설치
회원 가입 화면에서 카메라를 통해 단말기에 부착된 QR 코드를 촬영합니다. QR 코드 인식을 위해 `barcode_scan2` 라이브러리를 사용하였습니다.

- `pubspec.yaml`에 다음 라이브러리를 설치합니다.
  - `barcode_scan2: ^4.1.6`
<br>

- `app/src/debug/AndroidManifest.xml`에 다음 코드를 작성하여 **카메라 권한을 요청**합니다.
```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.hearing">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
</manifest>
```

## 2. 화면 구성 

### 2-1. 처음 시작 화면 
앱을 처음 실행할 시 등장하는 화면입니다. 버튼을 눌러 회원가입, 로그인을 진행합니다.

| <img src="https://github.com/user-attachments/assets/fe2b7807-6e2b-41da-ab5a-e2cf7885631a" alt="처음 시작 화면" width="250" height="500"/> |
|---------------|
| <p align="center">처음 시작 화면</p> |

<br><br>

### 2-2. 회원가입 화면
회원 가입을 진행합니다. 멀티 스텝 로직을 통해 3단계로 구현되었습니다. <br>

- **회원가입 1단계**
  - 계정 정보를 입력하는 화면입니다. 아이디, 비밀번호, 돌봄 대상을 지칭할 별명, 이용약관 동의 항목이 있습니다.

<br>

- **회원가입 2단계**
  - 돌봄 대상의 상세 정보를 입력하는 화면입니다. 돌봄 대상의 생년월일, 중증도, 안전 지역을 설정합니다.
  - 안전 범위는 집 주소로부터 몇 m를 벗어나면 **'외출 알림'** 이 전송될지를 결정합니다.

| <img src="https://github.com/user-attachments/assets/2af7a246-7f50-4a2e-ad73-c4b31ef4b3ef" alt="회원가입-1단계" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/b88ead87-8a06-4c25-b711-d5563d9d67fe" alt="회원가입-2단계" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/7a5d316e-0c2c-4011-9813-c7ad0a375154" alt="회원가입-2단계-생년월일" width="250" height="500"/> |<img src="https://github.com/user-attachments/assets/54f04b46-c799-4d77-9d3d-6fee361543b6" alt="회원가입-2단계-안전범위" width="250" height="500"/> |
|---------------|---------------|---------------|---------------|
| <p align="center">회원가입1 - 계정정보 입력</p> | <p align="center">회원가입2 - 상세정보 입력</p> | <p align="center">회원가입2 #생년월일</p> | <p align="center">회원가입2 #안전범위 선택</p> |

<br><br>

- **회원가입 3단계**
  - 단말기 등록을 진행합니다. 버튼을 눌러 단말기에 부착된 QR 코드를 촬영합니다.
  - QR 코드 촬영이 되지 않으면, '미입력 상태'임을 알려줍니다. 미입력시 **`다음` 버튼이 활성화되지 않습니다.**
  - 올바른 QR 코드 등록이 완료되면, '등록 완료'를 알리고 `다음` 버튼이 활성화됩니다.
  - 올바른 QR 코드가 아닐 경우, '잘못된 QR 코드'라는 메시지가 뜹니다.

| <img src="https://github.com/user-attachments/assets/44bd3e1d-b1b3-4bd3-9ab2-5e30ad49338d" alt="바코드 등록gif" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/a1272446-387e-4adc-94ec-65276c6b16a4" alt="바코드 등록-미입력" width="250" height="500"/> | <img src="https://github.com/user-attachments/assets/944144fe-a049-4087-8584-0457df06ea3b" alt="바코드 등록-입력완료" width="250" height="500"/> |
|---------------|---------------|---------------|
| <p align="center">회원가입3 - 단말기 등록</p> | <p align="center">단말기 등록 #미입력</p> | <p align="center">단말기 등록 #입력 완료</p> |

<br><br>

### 2-3. 회원가입 완료 화면
3단계까지의 회원가입을 마치고, '다음' 버튼을 누르면 등장하는 완료 화면입니다. 버튼을 눌러 로그인을 진행할 수 있습니다.

| <img src="https://github.com/user-attachments/assets/3af3efb1-686e-492c-8c75-479dee4afd2b" alt="회원가입 완료 화면" width="250" height="500"/> |
|---------------|
| <p align="center">회원가입 완료 화면</p> |

<br><br>

### 2-4. 로그인 화면
로그인을 진행하는 화면입니다. 로그인이 완료되면 '메인 화면'으로 넘어갑니다.

| <img src="https://github.com/user-attachments/assets/ae1aa3f9-a176-4de1-b83a-1b5d6c5f6f3a" alt="로그인 화면" width="250" height="500"/> |
|---------------|
| <p align="center">로그인 화면</p> |

