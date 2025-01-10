# 헤아Ring - [ HW ]  <img src="https://github.com/user-attachments/assets/9e733bda-5f85-4df4-9f66-af22c18c754d"  width="50" height="50"/> 라즈베리파이4 단말기 개발 

![](https://img.shields.io/badge/Raspberry%20Pi-A22846?style=for-the-badge&logo=Raspberry%20Pi&logoColor=white)
![](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)
![](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)



<img src="https://github.com/user-attachments/assets/0009cea5-94c5-41cd-b9d5-d48be550fa03"  width="400" height="300"/>





## <목차>
### 1.[개요](#1-개요) <br>
### 2.[개발 전 원격제어 환경 구성 ](#2-개발-전-원격제어-환경-구성)<br>
### 3.[개발시 사용한 부품 설명 및 적용](#3-개발시-사용한-부품-설명-및-적용) <br>
### 4.[하드웨어 로직 구성 및 이슈해결](#4-하드웨어-로직-구성-및-이슈해결)<br>
### 5.[결론](#5-결론)

----------------------------------------------
<br>

### 개발 전 원격제어 환경 구성 
- SD 카드 환경설정
- Putty 연결 
- VNC 설정 
- 자주 사용하는 Linux 명령어 
  

### 개발시 사용한 부품 설명 및 적용 
- 필요한 부품
- 부품 조립 후 사진 
- 적용 방법 참고 사이트




### 하드웨어 로직 & 코드 구성 및 이슈해결 
-  전체적인 하드웨어 로직 
-  병렬 구조 개발의 필요성과 접근 방식
-  병렬 구조 설계의 주요 고민 (asyncio 활용)
-  세부 로직 구성 
-  GPS 기능 구현 방법
-  Numpy를 활용한 정확한 음성 추출 기능 중 발견한 문제
-  pip 패키지 설치 불가 문제  
-  소형화 개발의 문제 



------------------------------------------------
**최종 단말기 개발 완료 사진**

- 충전 모듈 및, GPS 센서, 쿨링 팬 설치 된 최종 보드 사진 


<img src="https://github.com/user-attachments/assets/70962858-9c5e-4720-96e8-9acc6fc646f0"  width="400" height="300"/>


--------------------------------------------------
**최종 단말기 착용 사진** 

- 보드의 크기에 맞춰 인체에 부착 하기 위해 벨트 형식으로 개발 진행 함 

<img src="https://github.com/user-attachments/assets/488479ff-1be0-4b67-9084-1a0c1968e3f9"  width="300" height="300"/>

<img src="https://github.com/user-attachments/assets/1cca9848-616d-4c6c-b36c-8b1cdd5d5169"  width="400" height="300"/>






--------------------------------------------------


## 1. 개요 
- 개발 내용 :

본 기기는 치매 환자의 발화 패턴을 학습한 AI를 활용하여 위험 상황을 실시간으로 감지하고, 실종을 조기에 발견하는 기능을 제공하여 치매 환자가 위험에 처할 가능성을 줄이고, 사회적 안전망이 부족한 환경에서도 환자를 보호하는 데 기여한다   

  
- 개발에 필요한 기능과 구현 요소:

  - 소비자 편의를 고려한 소형 크기의 단말기
    - 치매 환자의 편의를 최우선으로 고려하여, 인체나 의류에 부담 없이 부착 가능한 소형 크기의 기기를 설계 진행
      <br>
      
  - 사용자의 정학한 음성 인식 및 녹음 후 원본 파일 자동 저장 후 데이터 파일 서버 전송 기능
    - 치매 환자의 발화를 정확히 인식하고, 녹음된 음성을 자동으로 저장 및 서버로 전송하는 시스템을 구현 진행
      <br>
      
  - 사용자의 실시간 위치 판단 및 APP 과 서버, 서버와 HW  상호간 양방향 데이터 통신 기능 구현
    - 사용자의 현재 위치를 정확히 판단하여, 애플리케이션(APP) 및 서버 간, 서버와 하드웨어(HW) 간의 양방향 데이터 통신을 지원
      <br>
      
  - Safe 존 벗어나는지 확인을 위한 수치 계산 기능
    - GPS 데이터를 기반으로 사용자가 지정된 Safe Zone을 벗어나는지를 확인하며, 이를 수치화하여 프로젝트 기반 앱을 통한 알림 및 대응 기능 제공 

<br> 
<br> 



## 2. 개발 전 원격제어 환경 구성 

-  보드 환경 설정 
### 1). SD 카드 환경설정 
  - RaspberryImager 어플리케이션에서 64Bit OS 설치 진행
<img src="https://github.com/user-attachments/assets/e4d4dcf7-9a37-4db1-af6b-70ce49265895"  width="550" height="300"/>

  - Ctrl + Shift + X 키를 통해 OS의 아이디와 비밀번호를 설정하고, 연결할 네트워크의 아이디를 설정


### 2). putty 연결
- 전원 연결 후 작성한 네트워크 설정했던 내용을 기반으로 네트워크 연결을 통해 보드의 IP 주소를 알아내기
  - 기존 Raspberrypi imager 을 설치 후 작성 했던 네트워크 아이디와 같은 네트워크를 연결 한다.
  - 연결 된 네트워크의 IP주소를 확인 한다
    - ex) 노트북의 핫스팟으로 연결 한다면, 노트북의 설정에서 "네트워크 및 인터넷" 메뉴에서 연결된 보드의 네트워크 IP를 확인 할 수 있다
   
      
      <img src="https://github.com/user-attachments/assets/c59c4f58-d87d-4a0c-97bb-43c789ef9b4c"  width="300" height="70"/>
      


    
- 확인된 IP 주소를 기반으로 Putty를 사용해 보드에 접속하고 로그인한다.<br>
<br> 
<img src="https://github.com/user-attachments/assets/b53d14a0-ce1e-4ce3-8462-73ba1eca0c3d"  width="350" height="300"/>
<br>
<img src="https://github.com/user-attachments/assets/57a9776b-6bc8-4ace-b9b3-e05494e261ca" width="550" height="300"/>
<br>
<img src="https://github.com/user-attachments/assets/ad019c5b-1a79-41c1-b147-82f507a99744"  width="550" height="300"/>


<br> 
- putty 접속 후 보드 업데이트 

```
>> 업데이트 코드 sudo apt-get update
>> 업데이트 목록 다운로드 sudo apt-get update
```


```
>> 종료 시 작성 코드 sudo shutdown –h now or sudo shutdown now
```


### 3) VNC 설정<br>

1) putty 환경에서 아래 명령어 입력 
```
sudo raspi-config
```
2) SSH 활성화 되어 있는지 확인
```
Interface Options 클릭 
```
<img src="https://github.com/user-attachments/assets/17f5c76b-c85b-4595-a303-3768386ba1e4"  width="550" height="300"/>
<br> 

<br> 



``` SSH ```  클릭 <br> 
<img src="https://github.com/user-attachments/assets/f6659cf1-95da-430c-9f7b-276095321b7d"  width="550" height="300"/>






<br> 

```yes``` 클릭 

<img src="https://github.com/user-attachments/assets/195918aa-eff9-4796-9924-78944d2e24ca"  width="550" height="300"/>


3) VNC 활성화
``` Interface Options  ``` 클릭

<img src="https://github.com/user-attachments/assets/7e207ffc-9a0b-47b1-bced-2117698895ed"  width="550" height="300"/>


``` VNC ``` 클릭 

<img src="https://github.com/user-attachments/assets/45c02440-8ea1-4615-95d1-0429e9b44dc0"  width="550" height="300"/>
<br> 
<br> 
<br>




- 한국어설정 
    
```
>> 한글 폰트 다운로드 명령어  입력  sudo apt install fonts-nanum

```

```
>> 한글 프로그램 설치 sudo apt install ibus-hangul

```
메뉴에서 Configuration 에서 Locale, Timezone 설정 후  Language와 Character Set 설정해주고 재부팅 
<img src="https://github.com/user-attachments/assets/e0475a3f-8997-41f4-bdcf-283a504f17f9"  width="550" height="300"/>



### 4) 자주 사용하는 linux 명령어
  -  라즈베리파이 시스템 정보 및 상태 확인<br>

```
hostname          # 라즈베리파이의 호스트 이름 확인
uname -a          # 커널 정보와 시스템 정보 확인
vcgencmd measure_temp  # CPU 온도 확인
vcgencmd get_mem arm   # 사용 가능한 ARM 메모리 확인
vcgencmd get_mem gpu   # GPU 메모리 확인
df -h             # 디스크 사용량 확인
free -h           # 메모리 사용량 확인
uptime            # 시스템 가동 시간 확인
whoami            # 현재 사용자 확인
```


  -  라즈베리파이 네트워크 관리 <br>
```
ifconfig          # 네트워크 인터페이스 정보 확인
iwconfig          # 무선 네트워크 설정 확인
ping <주소>       # 네트워크 연결 확인
sudo iwlist wlan0 scan  # 사용 가능한 Wi-Fi 네트워크 검색
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf  # Wi-Fi 설정 파일 편집
sudo systemctl restart dhcpcd  # 네트워크 서비스 재시작
```
  -  라즈베리파이 패키지 관리<br>
```
sudo apt update               # 패키지 목록 업데이트
sudo apt upgrade              # 설치된 패키지 업그레이드
sudo apt install <패키지명>   # 패키지 설치
sudo apt remove <패키지명>    # 패키지 제거
sudo apt autoremove           # 필요 없는 패키지 제거
dpkg -l                       # 설치된 패키지 목록 확인
```


  -  라즈베리파이 파일 및 디렉토리 관리<br>
```
ls                 # 현재 디렉토리의 파일 및 폴더 목록 확인
ls -la             # 숨김 파일 포함 자세한 정보 표시
cd <디렉토리명>    # 디렉토리 이동
pwd                # 현재 작업 디렉토리 확인
mkdir <디렉토리명> # 디렉토리 생성
rm <파일명>        # 파일 삭제
rm -r <폴더명>     # 폴더 및 하위 파일 삭제
cp <원본> <대상>   # 파일 복사
mv <원본> <대상>   # 파일 이동/이름 변경
```


  -  라즈베리파이 시스템 관리<br>
```
sudo reboot                 # 시스템 재부팅
sudo shutdown now           # 시스템 즉시 종료
sudo shutdown -r now        # 즉시 재부팅
sudo raspi-config           # 라즈베리파이 설정 메뉴 열기
sudo systemctl start <서비스>   # 서비스 시작
sudo systemctl stop <서비스>    # 서비스 중지
sudo systemctl restart <서비스> # 서비스 재시작
```

  -  라즈베리파이 개발 및 디버깅 <br>
```
python3 <스크립트명>.py  # Python3 스크립트 실행
sudo nano <파일명>       # 텍스트 파일 편집
cat <파일명>            # 파일 내용 확인
tail -f <로그 파일명>   # 실시간 로그 확인
dmesg                   # 부팅 및 커널 메시지 확인
```


## 3. 개발시 사용한 부품 설명 및 적용


### 1) 필요한 부품 :     


  - <라즈베리파이4>  라즈베리파이4보드 8GB 및 충전기, 쿨링 팬 케이스, SD 카드 32GB , SD 카드 리더기

    - 구매 사이트 :<a href="https://www.coupang.com/vp/products/7429911069?itemId=19294690189&vendorItemId=86409354176"> 라즈베리파이4 베이직 키트 8GB </a> 

  - <소형 마이크>
    - 구매 사이트 : <a href="https://ko.aliexpress.com/item/1005006411600203.html?src=google&pdp_npi=4%40dis%21KRW%211880%211471%21%21%21%21%21%40%2112000037070277039%21ppc%21%21%21&src=google&albch=shopping&acnt=298-731-3000&isdl=y&slnk=&plac=&mtctp=&albbt=Google_7_shopping&aff_platform=google&aff_short_key=UneMJZVf&gclsrc=aw.ds&&albagn=888888&&ds_e_adid=&ds_e_matchtype=&ds_e_device=c&ds_e_network=x&ds_e_product_group_id=&ds_e_product_id=ko1005006411600203&ds_e_product_merchant_id=516326659&ds_e_product_country=KR&ds_e_product_language=ko&ds_e_product_channel=online&ds_e_product_store_id=&ds_url_v=2&albcp=21445427499&albag=&isSmbAutoCall=false&needSmbHouyi=false&gad_source=1&gclid=EAIaIQobChMIh4m69pnWigMVRtEWBR2etj3sEAQYASABEgItRvD_BwE">슈퍼 미니 USB 2.0 마이크</a> 
       


  - <GPS 모듈>
    - 구매 사이트 : <a href="https://www.devicemart.co.kr/goods/view?no=1342149"> NT114990732 </a> 


  - <충전 모듈>
    - 구매 사이트 : <a href="https://www.devicemart.co.kr/goods/view?no=12497514"> SZH-RPI01 </a> 


  - <배터리>
    - 구매 사이트 :  <a href="https://www.devicemart.co.kr/goods/view?no=10889448"> 18650 보호회로 리튬이온 충전지(배터리)/2000mA </a>

  - <쿨링 케이스> <br>
    //튼튼하고 좋았던 케이스 쿨링팬이 두개나 들어가있어서 열회전률이 좋다. 최종 사진에는 사용하지않았음. <br>
    
    - 구매사이트 : <a href="https://www.icbanq.com/P008890303?utm_source=google&utm_medium=cpc&utm_campaign=%EC%87%BC%ED%95%91_%EC%A2%85%ED%95%A9&utm_id=%EC%87%BC%ED%95%91_%EC%A2%85%ED%95%A9&utm_term=notset&utm_content=%EC%87%BC%ED%95%91_%EC%A2%85%ED%95%A9&gad_source=1&gclid=CjwKCAiAm-67BhBlEiwAEVftNv5RHoXcFabAq3g__s4Hs3WGbJ2BSN4SGltQBqX32d5kHumnV80bwBoCJTUQAvD_BwE">쿨링 케이스 추천</a>


### 2) 부품 조립 후  사진 

<img src="https://github.com/user-attachments/assets/2391accf-6f26-4ee9-ae67-8f21f45865db"  width="400" height="300"/>
<br> 
- 라즈베리파이 베이직 키트 + gps 센서 조립 사진 

<br> 
<br> 

<img src="https://github.com/user-attachments/assets/154d7e51-22e2-44b6-95ca-ac5e447e2ff5"  width="400" height="300"/>

- 충전 모듈과 마이크 조립 사진 

<br> 
<br> 

<img src="https://github.com/user-attachments/assets/70962858-9c5e-4720-96e8-9acc6fc646f0"  width="400" height="300"/><br>
- 최종 단말기 사진 


  
### 3) 적용 방법 참고 사이트
_<a href ="https://youtu.be/qEsSK9WIRM4?si=EBuVo_umLaNIKF99">라즈베리파이 쿨링 팬 조립 영상 참고</a>_
      <br> 



## 4. 하드웨어 로직 구성 및 이슈해결

### 1) 전체적인 하드웨어 로직

 <img src="https://github.com/user-attachments/assets/6f619039-51af-437f-8851-9ff8ada647f5"  width="700" height="600"/>



  1.Safe존 검출<br>
  - 사용자가 직접 지정한 Safe Zone 반경을 기준으로  1분마다 사용자가 벗어난 상태인지 확인.
      - 사용자가 직접 지정한 Safe Zone 반경을 기준으로 사용자가 벗어난 상태인지 확인.
      -  GPS 모듈(gpsd)을 사용하여 현재 위치 데이터를 수집.
      -  geopy 라이브러리의 geodesic 함수를 이용해 현재 위치와 Safe Zone 중심의 거리를 계산.
      -  거리가 설정된 반경(SAFE_RADIUS)을 초과하면 Safe Zone을 벗어난 것으로 간주(is_outside_safe_zone).


  2.safe존 상태 업데이트 및 서버 전송 <br> 
  - 사용자의 현재 상태(Safe Zone 내부: 0, 외출: 1)를 EC2서버에 전송.
      - requests 라이브러리를 사용하여 서버 API(API_URL)에 상태를 JSON 형식으로 전송 (RestFul API 활용) 
      - Safe Zone 외부 상태에서는 외출로 판단 하여 사용자의 앱에 외출 알림을 전송 함
      - 1분마다 safe존 여부를 판단 할 때, 직전 상태값이 현재 상태값과 같다면 전송하지않음<br> 

<br> 

  3.음성 녹음 및 처리 <br>
  - Safe Zone을 벗어난 경우, 음성을 녹음하고 저장하여 클라우드(AWS S3)에 업로드
      - 녹음 시작: 음성 데이터 스트림에서 무음을 감지(is_silent 함수). 무음이 아닌 경우 녹음을 시작.
      - 녹음 종료1: 외부 소리가 감지되지않는다면 녹음을 진행하지않음. 소리를 계속 감지 
      - 녹음 종료2: 무음이 일정 시간 이상 지속되면 녹음을 중단<br>

      1.녹음된 데이터를 증폭(amplify_audio).<br> 
      2. WAV 파일로 저장 후 MP3 형식으로 변환(pydub). <br> 
      3. 클라우드 업로드 <br> 
      4. AWS S3에 녹음 파일을 업로드(upload_to_s3). <br> 
      5. 메타데이터로 녹음 당시의 시간 및 위치 정보 포함. <br>
<br> 


  4.실시간 위치 데이터 전송  <br> 
  - 사용자 위치를 실시간으로 서버 와 MQTT 웹소켓을 통해 전송.
      - 웹소켓 통신: <br>
          1. websockets 라이브러리를 활용하여 WebSocket 서버에 연결. <br>
          2. 주기적으로 현재 위치 데이터를 전송 및 중단(send_location_data). <br>
          3. MQTT 통신 <br>
          4. MQTT 클라이언트를 사용하여 브로커에 연결. <br>
          5. 특정 토픽(MQTT_TOPIC)에 데이터를 게시하거나 수신. <br>

<br> 

5. 종합적인 워크플로우
  - 위치 확인:
      - GPS 모듈에서 현재 위치를 가져옴.
      - Safe Zone 내부 여부를 확인.
  - 상태 전송:
      - Safe Zone 상태(내부: 0, 외부: 1)를 서버에 전송.
      - 기존 상태와 현재 상태값 비교 
  - 녹음 및 업로드:
      - Safe Zone 외부일 경우 음성을 녹음.
      - 녹음 데이터를 증폭 및 변환 후 AWS S3에 업로드.
  - 실시간 양방향 통신:
      - 서버에서 위치 데이터의 요청이 들어오면 start 명령을 받고 주기적으로 위치 데이터를 WebSocket 또는 MQTT를 통해 서버로 전송.
      - 서버에서 위치 데이터의 전송 중단 요청이 들어오면 stop명령을 받고 위치 데이터 전송 중지
<br> 




### 2) 병렬 구조 개발의 필요성과 접근 방식
- 본 프로젝트는 실시간 위치 추적, Safe Zone 검출, 음성 녹음 및 클라우드 전송과 같은 다양한 작업을 병렬적으로 수행해야 하는 복잡한 시스템이였다. <br>  이 과정에서 단일 스레드로 처리할 경우 작업 간 충돌이나 지연이 발생할 위험이 높아, 비동기적 병렬 구조를 적용하여 모든 작업이 독립적으로 수행될 수 있도록 설계 함

### 3) 병렬 구조 설계의 주요 고민
  - 실시간으로 데이터를 수집 및 전송하는 동안 음성 녹음과 같은 시간이 많이 소요되는 작업을 동시에 처리해야 함.
  - 작업 간 독립성을 유지하면서도 데이터 무결성을 보장해야 함.
  - CPU와 네트워크 리소스를 효율적으로 활용할 수 있는 구조 필요.


  -  전체적인 구조:<br>
    추가적으로 데이터 전송 과정에서 서로 다른 서버와의 병렬 처리가 요구 됨. 녹음 파일은 AWS S3로 업로드, safe존 여부 판단 후 외출 알림은 RESTful API를 통해 EC2 서버로 업로드되어야 하며 
    동시에, 실시간 위치 데이터는 AWS Gateway API와 웹소켓(WebSocket)을 활용하여 양방향 통신으로 처리되야함. 백그라운드에서는 MQTT와 웹소켓(WebSocket)이 활성화되어 서버로부터 실시간 위치 데이터를 요청하는 신호를 대기하고, 요청이 감지되면 해당 데이터를 전송하거나 중지하는 작업이 원활하게 이루어져야한다  <br>
    
- 구현 방식:
  - asyncio를 활용한 비동기 이벤트 루프를 중심으로 작업 관리.
  - threading을 통해 WebSocket, MQTT 통신 등의 네트워크 작업을 백그라운드에서 처리.
  - 작업의 우선순위를 설정하고, 충돌 방지를 위해 적절한 락(lock) 메커니즘을 사용.
 
### 4) 세부 로직 구성 
<br> 

- 1. Safe Zone 검출
  - 작업 흐름: 
    - GPS 모듈(gpsd)을 사용하여 현재 위치 데이터를 수집.
    - geopy 라이브러리의 geodesic 함수를 활용하여 사용자의 현재 위치와 Safe Zone 중심점 간의 거리를 계산.
    - 설정된 반경(SAFE_RADIUS)을 초과할 경우 Safe Zone을 벗어난 상태로 간주(is_outside_safe_zone).
    - Safe Zone 검출 작업은 1분 간격으로 실행하여 시스템 리소스 낭비를 최소화.
  <br> 
    
- 2. Safe Zone 상태 업데이트 및 서버 전송
  - 작업 흐름:
    - 사용자의 현재 상태(Safe Zone 내부: 0, 외출: 1)를 JSON 형식으로 변환하여 서버에 전송.
    - requests 라이브러리를 활용해 Restful API 엔드포인트(API_URL)로 상태를 전달.
    - Safe Zone 외부 상태가 감지되면 앱에 외출 알림을 실시간으로 전송.
    - 직전 상태와 현재 상태가 동일할 경우 중복 전송을 방지하여 서버 부하를 줄임.
   <br>

- 3. 음성 녹음 및 처리
  - 작업 흐름:
    - Safe Zone을 벗어난 경우, is_silent 함수로 외부 소음을 감지하여 음성 녹음을 시작.
  - 녹음 종료 조건:
    - 무음이 일정 시간 이상 지속될 경우 녹음을 중단.
    - 외부 소음이 감지되지 않을 경우 녹음 중지.
    - 녹음된 데이터를 증폭(amplify_audio)하고, WAV 형식으로 저장 후 MP3로 변환(pydub).
    - 녹음 파일을 AWS S3에 업로드(upload_to_s3)하며, 메타데이터로 녹음 시각과 위치 정보를 포함.

   <br> 
   
- 4. 실시간 위치 데이터 전송
     - 작업 흐름:
       - WebSocket 통신(websockets 라이브러리):
         - WebSocket 서버에 연결하여 위치 데이터를 주기적으로 전송.
         - 서버에서 stop 명령을 받을 경우 전송 중지.
        - MQTT 통신(paho-mqtt):
          - MQTT 브로커에 연결하여 특정 토픽(MQTT_TOPIC)에 데이터를 게시.
          - 양방향 통신을 통해 실시간으로 위치 데이터를 업데이트.
          - 사용자가 앱에서 GPS 화면에 접속하면 실시간 위치 데이터를 전송.
         <br>

- 5. 병렬 실행 로직
       - 구현 방식:
         - asyncio 기반의 비동기 작업으로 WebSocket 통신, 위치 검출 등을 백그라운드에서 실행
         - threading을 활용하여 MQTT 클라이언트와 메인 로직을 독립적으로 병렬 실행
         - 각 작업이 충돌하지 않도록 세부적으로 분리하고, 상태 동기화를 통해 데이터의 일관성을 유지



### 5) GPS 기능 구현 
- GPS 모듈의 한계점과 장점
  -  GPS 모듈의 한계점: 날씨가 흐리면 위치데이터를 잡기가 어렵고 실내에선 위치 데이터가 잡히지 않는다 ( 외출시에만 위치 데이터가 잡힌다 ) 
  -  GPS 모듈의 장점 : 저렴한 가격, 초심자가 사용하기 쉬운 기기 구성, 간단한 코드 작성으로 구현되는 위치 추출, gps 모듈의 선의 길이가 적당함 
<br>
<br>
구매 제품: https://www.devicemart.co.kr/goods/view?no=1342149
 
<br> USB 포트에 연결 가능 
<br> 
<img src="https://github.com/user-attachments/assets/997dc08c-eb9d-4e17-87ce-de90fb1726b5"  width="400" height="300"/>

-------------------

1. 라즈베리파이 업데이트 및 재부팅

```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

----------------------


2. GPS 사용을 위한 설정

```
sudo raspi-config
```


Interfacing options -> Serial -> No -> Yes 이후 재부팅


<img src="https://github.com/user-attachments/assets/29a161e2-0615-4e1d-a047-4327ec8a6341"  width="400" height="300"/>


<img src="https://github.com/user-attachments/assets/c6c3c5c1-22d1-4c82-826e-eb5df6a6d5d5"  width="400" height="300"/>


<img src="https://github.com/user-attachments/assets/ef2aff21-74ce-4929-b2a4-4d1586140f09"  width="400" height="300"/>


<img src="https://github.com/user-attachments/assets/47e69783-5629-4a1d-afe9-393c67396e71"  width="400" height="300"/>


3. GPS 데이터 표시 툴 (gpsd) 설치
----------------------------

```
sudo apt-get install gpsd-clients gpsd -y
```
<br> 

4. 초기 설정 변경

```
sudo nano /etc/default/gpsd
```
DEVICES=""를 사용할 포트로 수정 <br> 
ex) DEVICES="/dev/ttyUSB0" <br>
이후 재부팅 

-----------------

- GPS 데이터 보기

```
gpsmon 또는 cgps -s
```

<img src="https://github.com/user-attachments/assets/861fcf90-ea0c-4d7d-90aa-b84004fcd0a5"  width="400" height="300"/>


gps 센서 사용 방법 출처: https://github.com/ayj8655/RaspberryPi_wutchout?tab=readme-ov-file


- gps 위치추출 
gpsd 라이브러리를 사용하여 위치데이터 요청 후 처리 , 예외처리를 안정적으로 수행하기위해 try문 사용




```python 
import gpsd

def get_current_location():
    try:
        gpsd.connect()

        packet = gpsd.get_current()

        if packet.mode >= 2: 
            latitude, longitude = packet.position()
            print(f"현재 위치: 위도 {latitude}, 경도 {longitude}")
            return latitude, longitude

        print("유효한 GPS 데이터를 찾을 수 없습니다.")
        return None
    except Exception as e:
        print(f"GPS 모듈 오류: {e}")
        return None
```




### 6) Numpy를 활용한 정확한 음성 추출 기능 개발 중 발견한 문제 
-  녹음 중 무음이 삭제되어 음성이 끊겨 녹음이 진행되는 문제가 발생함
  -  해결 방안 :
    -  무음을 감지하는 is_silent() 함수의 사용 방법에 대해 문제를 바꿈<br>
    문제는 코드에서 is_silent() 함수는 오디오 데이터를 무음인지 판단하는 기준으로 사용되고 있었다 <br>

````python 
if is_silent(data):
    if recording:
        silent_chunks += 1
        if silent_chunks > int(RATE / CHUNK * SILENCE_DURATION):
            print("Silence detected. Stopping recording.")
            break
    continue
else:
    silent_chunks = 0
````





- 이 로직에서 무음 구간이 감지되면, silent_chunks를 증가시키며 무음이 지정된 기간 이상 지속될 경우 녹음을 종료한다 
- 무음 데이터(data)는 녹음 중인 프레임(frames)에 추가되지 않는다 따라서 녹음 파일에서는 무음 구간이 삭제된 결과가 나타난 것
  - 무음을 "녹음 중지"의 신호로 간주<br> 
    코드 구조상 무음 구간은 "녹음이 종료되는 신호"로 동작하고 있다 무음 데이터가 프레임에 추가되지 않으므로 무음 구간이 사라지게 되었던 것 

***문제해결 방법*** <br> 
무음 데이터도 프레임에 추가<br>
무음 데이터(data)를 삭제하지 않고, 항상 frames에 추가되도록 수정함. 이렇게 하면 무음 구간도 녹음 파일에 포함되어 무음까지 감지되어 원본 녹음 파일을 저장할 수 있게 됨




```python
if is_silent(data):
    if recording:
        silent_chunks += 1
        if silent_chunks > int(RATE / CHUNK * SILENCE_DURATION):
            print("Silence detected. Stopping recording.")
            break
    frames.append(data)  # 무음 데이터도 프레임에 추가
else:
    silent_chunks = 0
    if not recording:
        print("Sound detected. Starting recording.")
        recording = True
        recording_start_time = datetime.now()
    frames.append(data)  # 소음 데이터도 프레임에 추가
```

<br>


### 7) pip 패키지 설치 불가 문제 
*** 문제해결 방법 *** 
<br> 
  ex) pip Speech recognition 을 설치하고 싶은데 커널에서 작성 시 오류가 발생한다


  나타나는 오류메세지 
```
ERROR: Could not install packages due to an OSError: [Errno 13] Permission denied: '/usr/lib/python3/dist-packages/...'
Consider using the `--user` option or check your permissions.

```


```
ERROR: Package '...' requires a different Python version than the one installed.

```



  가상환경으로 변경하여 다운로드 진행


가상환경 만들기 


  ```
python3 -m venv myenv
  ```

가상환경 활성화 후 pip 관련 다운로드 진행 


```
source myenv/bin/activate

```

밑의 방식으로 진행하면 오류 해결 


```
python3 -m venv myenv
source myenv/bin/activate
pip install <package>
```



### 8) 소형화 개발의 문제 

- 추가적인 소형화 개발을 성공적으로 진행 하기 위한 Raspberry Pi Zero 2W를 도입하여 적용 시키려 했지만 
  - 제로 2W 부품은 소형화 개발의 목표에 크기가 매우 적합 하였지만 성능이 매우 떨어져 우리 팀이 구현해야하는 기능들이 원활하게 개발되어 작동될 것 같지 않다고 판단하였다<br>
<b> 
  <img src="https://github.com/user-attachments/assets/c0656d51-317a-461c-811a-fa7d4c78c6b4"  width="300" height="250"/>
  <img src="https://github.com/user-attachments/assets/6c2b7438-e6ec-4728-88fd-f8f390e07d5e"  width="600" height="250"/>
  



## 5. 결론 

이 프로젝트를 통해 라즈베리파이 기반의 실시간 데이터 처리 시스템을 성공적으로 개발할 수 있었다. 특히, 음성 녹음과 위치 데이터를 병렬적으로 처리하며, AWS S3와 EC2 서버를 활용한 데이터 업로드와 실시간 통신을 안정적으로 구현하였다.

<br> 
초기 단계에서 구현이 어려울 것이라고 예상했던 기능들을 완성하면서 많은 도전과 학습의 기회가 되었고, 이를 통해 실질적인 기술적 성장과 자신감을 얻게 되었다
비록 시스템의 소형화라는 초기 목표는 완전히 달성하지 못했지만, 이번 프로젝트는 앞으로의 개선과 발전 가능성을 확인할 수 있는 중요한 발판이 되었다고 생각한다 
<br> 

### 1) 하드웨어 부분에서의 핵심 성과 정리:
- Safe 존 기반 외출 여부 판단 및 녹음 데이터 처리.
- AWS 서비스를 활용한 효율적인 데이터 관리와 확장성 있는 구조 설계.
- 실시간 위치 데이터를 안정적으로 처리하는 임베디드 시스템 구현.
<br>

### 2) 앞으로의 추가적인 확장성과 한계점 보완 방법 계획: <br> 
- 시스템의 안정성을 더욱 강화하고, 추가적인 센서들을 도입하여, 단말기가 몸에서 떨어졌을 때 위험 상황의 자동 감지와 같은 기능을 추가할 계획
- 소형화 계획을 실패 하였으니 추후엔 소형화 계획을 성공 시킬 수 있도록 진행 할 예정
