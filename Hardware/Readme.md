# 라즈베리파이 기반 소형 하드웨어 개발 프로젝트 진행과정 


<img src="https://github.com/user-attachments/assets/fe76ecc5-ce4a-4b61-8515-3b4dd8951b2f"  width="300" height="300"/>



### 1. 소형 하드웨어 개발 동기
- 개발 동기
- 개발 내용
- 개발에 필요한 기능과 구현 해야 하는 기능 


### 2. 개발 전 원격제어 환경 구성 
- SD 카드 환경설정
- 전원연결
- VNC 접속 방법
- Linux 환경 환경설정
- 자주 사용하는 Linux 명령어 
  

### 3. 사용한 센서 및 부가적인 부품 & 적용 방법 
- 필요한 부품
- 부품 조립 참조 사이트
- 부품 조립 후 완성 사진 

### 4. 하드웨어 로직 & 코드 구성 및 이슈해결 방법 
-  전체적인 하드웨어 Logic  
-  병렬 처리 로직 구현 방법
-  비동기식 양방향 통신 기능 구현 방법
-  GPS 구현 방법
-  Numpy를 활용한 명확한 음성 추출 방법 


### 5. 결론 


## 1. 하드웨어 소형화 개발의 동기 및 구성 부품  (feat. Raspberrypi4, RaspberrypiZero2W) 
-  개발 동기 :

    사회적 약자의 치매환자 사용자 대상 기반 인체나, 옷에 부착 할 수 있는 소형 기기가 효과적일것으로 예상히여 개발 전 소형으로 계획 함. 기존 배회감지기는 치매환자들이 불편해 한다는 기사를 접했었음 
   
- 개발 내용 :

    치매환자 발화 패턴을 학습한 AI를 활용하여 위험 상황을 판단 후 실종을 조기감지 하는 기능을 개발하여 아직까지 안전이 보장되지않은 사회적 약자인 치매환자를 위험 사각지대에서 구조한다 
  
- 개발에 필요한 기능과 구현 해야 하는 부분 :

  - 소비자 편의를 고려한 소형 크기의 단말기 
  - 사용자의 정학한 음성 인식 및 녹음 후 원본 파일 자동 저장 후 데이터 파일 서버 전송 기능 
  - 사용자의 실시간 위치 판단 및 APP 과 서버, 서버와 HW  상호간 양방향 데이터 통신 기능 구현
  - Safe 존 벗어나는지 확인을 위한 수치 계산 기능 



- 추가적인 소형화 개발을 성공적으로 진행 하기 위한 Raspberry Pi Zero 2W 
  - 제로 2W 부품은, 소형화 개발의 목표에 매우 적합한 장비였지만 성능이 떨어져 우리 팀이 개발해야하는 기능들이 원활하게 개발되어 작동될 것 같지 않다고 판단하였다
  <img src="https://github.com/user-attachments/assets/c0656d51-317a-461c-811a-fa7d4c78c6b4"  width="300" height="250"/>
  <img src="https://github.com/user-attachments/assets/6c2b7438-e6ec-4728-88fd-f8f390e07d5e"  width="600" height="250"/>
  

## 2. 개발 전 원격제어 환경 구성 방법 
1. SD 카드 환경설정 
  - RaspberryImager 어플리케이션에서 64Bit OS 설치 진행
  - Ctrl + Shift + X 키를 통해 OS의 아이디와 비밀번호를 설정하고, 연결할 네트워크의 아이디를 설정 ** 중요 ** 
<br>
<img src="https://github.com/user-attachments/assets/e4d4dcf7-9a37-4db1-af6b-70ce49265895"  width="550" height="300"/>
<br>
<br>

2. 보드 전원 연결 
- 전원 연결 후 작성한 네트워크 설정했던 내용을 기반으로 네트워크 연결을 통해 보드의 IP 주소를 알아내기
- IP 주소를 기반으로 Putty를 사용해 보드에 접속하고 로그인한다.<br>

<br> 
<img src="https://github.com/user-attachments/assets/b53d14a0-ce1e-4ce3-8462-73ba1eca0c3d"  width="350" height="300"/>


## 3. 개발 시 사용한 부품 & 적용 방법 


- 필요한 부품 :     


  - <라즈베리파이4>  라즈베리파이4보드 8GB 및 충전기, 쿨링 팬 케이스, SD 카드 32GB , SD 카드 리더기

    - 구매 사이트 : https://www.coupang.com/vp/products/7429911069?itemId=19294690189&vendorItemId=86409354176
    
  - <소형 마이크>
    - 구매 사이트 : 슈퍼 미니 USB 2.0 마이크, 휴대용 스튜디오 음성 마이크, 오디오 어댑터 드라이버, 노트북, PC, MSN, 스카이프용, 신제품
       
      
    https://ko.aliexpress.com/item/1005006411600203.html?src=google&pdp_npi=4%40dis%21KRW%211880%211471%21%21%21%21%21%40%2112000037070277039%21ppc%21%21%21&src=google&albch=shopping&acnt=298-731-3000&isdl=y&slnk=&plac=&mtctp=&albbt=Google_7_shopping&aff_platform=google&aff_short_key=UneMJZVf&gclsrc=aw.ds&&albagn=888888&&ds_e_adid=&ds_e_matchtype=&ds_e_device=c&ds_e_network=x&ds_e_product_group_id=&ds_e_product_id=ko1005006411600203&ds_e_product_merchant_id=516326659&ds_e_product_country=KR&ds_e_product_language=ko&ds_e_product_channel=online&ds_e_product_store_id=&ds_url_v=2&albcp=21445427499&albag=&isSmbAutoCall=false&needSmbHouyi=false&gad_source=1&gclid=EAIaIQobChMIh4m69pnWigMVRtEWBR2etj3sEAQYASABEgItRvD_BwE


  - <GPS 모듈>
    - 구매 사이트 : https://www.devicemart.co.kr/goods/view?no=1342149


  - <충전 모듈>
    - 구매 사이트 : https://www.devicemart.co.kr/goods/view?no=12497514


  - <배터리>
    - 구매 사이트 :  https://www.devicemart.co.kr/goods/view?no=10889448

- 부품 조립 후 사진 

<img src="https://github.com/user-attachments/assets/70962858-9c5e-4720-96e8-9acc6fc646f0"  width="400" height="300"/>
<img src="https://github.com/user-attachments/assets/154d7e51-22e2-44b6-95ca-ac5e447e2ff5"  width="400" height="300"/>




## 4. 하드웨어 로직 & 코드 작성 

- 전체적인 하드웨어 Logic  
 <img src="https://github.com/user-attachments/assets/09d35f88-b28a-4177-b155-022fbe457235"  width="600" height="600"/>



  1.Safe존 검출<br>
  - 사용자가 직접 지정한 Safe Zone 반경을 기준으로  1분마다 사용자가 벗어난 상태인지 확인.
      - 사용자가 직접 지정한 Safe Zone 반경을 기준으로 사용자가 벗어난 상태인지 확인.
      -  GPS 모듈(gpsd)을 사용하여 현재 위치 데이터를 수집.
      -  geopy 라이브러리의 geodesic 함수를 이용해 현재 위치와 Safe Zone 중심의 거리를 계산.
         
        - 거리가 설정된 반경(SAFE_RADIUS)을 초과하면 Safe Zone을 벗어난 것으로 간주(is_outside_safe_zone).


  2.safe존 상태 업데이트 및 서버 전송 <br> 
  - 사용자의 현재 상태(Safe Zone 내부: 0, 외출: 1)를 EC2서버에 전송.
      - requests 라이브러리를 사용하여 서버 API(API_URL)에 상태를 JSON 형식으로 전송 (RestFul API 활용) 
      - Safe Zone 외부 상태에서는 외출로 판단 하여 사용자의 앱에 외출 알림을 전송 함
      - 1분마다 safe존 여부를 판단 할 때, 직전 상태값이 현재 상태값과 같다면 전송하지않음<br> 


  3.음성 녹음 및 처리 <br>
  - Safe Zone을 벗어난 경우, 음성을 녹음하고 저장하여 클라우드(AWS S3)에 업로드
      - 녹음 시작: 음성 데이터 스트림에서 무음을 감지(is_silent 함수). 무음이 아닌 경우 녹음을 시작.
      - 녹음 종료1: 외부 소리가 감지되지않는다면 녹음을 진행하지않음. 소리를 계속 감지 
      - 녹음 종료2: 무음이 일정 시간 이상 지속되면 녹음을 중단.


  
  - 데이터 처리: <br>
      1.녹음된 데이터를 증폭(amplify_audio).<br> 
      2. WAV 파일로 저장 후 MP3 형식으로 변환(pydub). <br> 
      3. 클라우드 업로드 <br> 
      4. AWS S3에 녹음 파일을 업로드(upload_to_s3). <br> 
      5. 메타데이터로 녹음 당시의 시간 및 위치 정보 포함. <br>


  4.실시간 위치 데이터 전송  <br> 
  - 사용자 위치를 실시간으로 서버 와 MQTT 웹소켓을 통해 전송.
      - 웹소켓 통신: <br>
          1. websockets 라이브러리를 활용하여 WebSocket 서버에 연결. <br>
          2. 주기적으로 현재 위치 데이터를 전송(send_location_data). <br>
          3. MQTT 통신 <br>
          4. MQTT 클라이언트를 사용하여 브로커에 연결. <br>
          5. 특정 토픽(MQTT_TOPIC)에 데이터를 게시하거나 수신. <br>


          
-  앱에서 GPS화면을 들어오면, 실시간 위치 데이터 전송 <br> 


  5. 병렬 실행  <br> 
  - 여러 작업(녹음, 위치 전송, 서버 통신 등)을 동시에 수행. 
      - asyncio와 threading을 활용해 비동기 작업(WebSocket 통신 등)을 백그라운드에서 실행.
      - MQTT 클라이언트와 메인 로직은 독립적으로 실행.



6. 종합적인 워크플로우
  - 위치 확인:
      - GPS 모듈에서 현재 위치를 가져옴.
      - Safe Zone 내부 여부를 확인.
  - 상태 전송:
      - Safe Zone 상태(내부: 0, 외부: 1)를 서버에 전송.
      - 기존 상태와 현재 상태값 비교 
  - 녹음 및 업로드:
      - Safe Zone 외부일 경우 음성을 녹음.
      - 녹음 데이터를 증폭 및 변환 후 AWS S3에 업로드.
  - 실시간 통신:
      - 서버에서 위치 데이터의 요청이 들어오면 start 명령을 받고 주기적으로 위치 데이터를 WebSocket 또는 MQTT를 통해 서버로 전송.
      - 서버에서 위치 데이터의 전송 중단 요청이 들어오면 stop명령을 받고 위치 데이터 전송 중지
   
  

## 병렬처리 로직구현 방법 
- 로직이 하나로 끝날 수 없는 구조, 병렬적으로 많은 기능을 한번에 유연하게 처리해야하는 문제가 있었다 ( 구조를 나누어야 했다 ) 
- 



## GPS 기능 구현 방법
- GPS 모듈의 한계점과 장점
  -  GPS 모듈의 한계점: 날씨가 흐리면 위치데이터를 잡기가 어렵다, 실내에선 위치 데이터가 잡히지 않는다 ( 외부에 있을 때 데이터가 잡힌다 ) 
  -  GPS 모듈의 장점 : 저렴한 가격, 초심자가 사용하기 쉬운 기기 구성, 간단한 코드 작성으로 구현되는 위치 추출, gps 모듈의 선의 길이가 적당함 



## 비동기식 양방향 통신 기능 구현 방법 
-  개발 중 가장 어렵게 느꼈던 기능 중 하나
  -  MQTT를 사용하여 AWS GateWay Endpoint에  AWS EC2 서버와 동시에 양방향 통신 기능 구현

- 비동기식으로 개발 한 이유 



## Numpy를 활용한 정확한 음성 추출 방법 
-  녹음 중 무음이 삭제되어 음성이 끊겨 녹음이 진행되는 문제가 발생함
  -  해결 방안
    -  무음을 감지하는 is_silent() 함수의 사용 방법에 대해 문제를 바꿈<br>
    문제는 코드에서 is_silent() 함수는 오디오 데이터를 무음인지 판단하는 기준으로 사용되고 있었다 <br>

````
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
- 무음 데이터(data)는 녹음 중인 프레임(frames)에 추가되지 않습니다. 따라서 녹음 파일에서는 무음 구간이 삭제된 결과가 나타난 것
  - 무음을 "녹음 중지"의 신호로 간주<br> 
    코드 구조상 무음 구간은 "녹음이 종료되는 신호"로 동작하고 있습니다. 무음 데이터가 프레임에 추가되지 않으므로 무음 구간이 사라지게 된다. 

-  문제해결 방법
  - < 무음 데이터도 프레임에 추가><br>
    - 무음 데이터(data)를 삭제하지 않고, 항상 frames에 추가되도록 수정함. 이렇게 하면 무음 구간도 녹음 파일에 포함되어 무음까지 감지되어 원본 녹음 파일을 저장할 수 있게 됨

````
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

```` 

