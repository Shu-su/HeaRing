# 소형 하드웨어 개발 진행과정 
### 1. 소형 하드웨어 장비 개발 동기 및 부품
- 개발 동기
- 개발 내용
- 개발에 필요한 기능과 구현 해야 하는 부분  
- 필요한 부품 

### 2. 개발 전 원격제어 환경 구성 

### 3. 사용한 센서 및 부가적인 부품 & 적용 방법 

### 4. 겪었던 문제점과 해결 방법 

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
    
   
- 필요한 부품 :     


  - <라즈베리파이4>  라즈베리파이4보드 8GB 및 충전기, 쿨링 팬 케이스, SD 카드 32GB , SD 카드 리더기

    - 구매 사이트 : https://www.coupang.com/vp/products/7429911069?itemId=19294690189&vendorItemId=86409354176
    
  - <소형 마이크>
    - 구매 사이트 : 슈퍼 미니 USB 2.0 마이크, 휴대용 스튜디오 음성 마이크, 오디오 어댑터 드라이버, 노트북, PC, MSN, 스카이프용, 신제품
       
            
    https://ko.aliexpress.com/item/1005006411600203.html?src=google&pdp_npi=4%40dis%21KRW%211880%211471%21%21%21%21%21%40%2112000037070277039%21ppc%21%21%21&src=google&albch=shopping&acnt=298-731-3000&isdl=y&slnk=&plac=&mtctp=&albbt=Google_7_shopping&aff_platform=google&aff_short_key=UneMJZVf&gclsrc=aw.ds&&albagn=888888&&ds_e_adid=&ds_e_matchtype=&ds_e_device=c&ds_e_network=x&ds_e_product_group_id=&ds_e_product_id=ko1005006411600203&ds_e_product_merchant_id=516326659&ds_e_product_country=KR&ds_e_product_language=ko&ds_e_product_channel=online&ds_e_product_store_id=&ds_url_v=2&albcp=21445427499&albag=&isSmbAutoCall=false&needSmbHouyi=false&gad_source=1&gclid=EAIaIQobChMIh4m69pnWigMVRtEWBR2etj3sEAQYASABEgItRvD_BwE


- 추가적인 소형화 개발을 성공적으로 진행 하기 위한 Raspberry Pi Zero 2W  사용 고려
  - 제로 2W 부품은, 소형화 개발의 목표에 매우 적합한 장비였지만 성능이 떨어져 우리 팀이 개발해야하는 기능들이 원활하게 개발되어 작동될 것 같지 않다고 판단하였다
  <img src="https://github.com/user-attachments/assets/c0656d51-317a-461c-811a-fa7d4c78c6b4"  width="300" height="250"/>
  <img src="https://github.com/user-attachments/assets/6c2b7438-e6ec-4728-88fd-f8f390e07d5e"  width="600" height="250"/>
  

## 2. 개발 전 원격제어 환경 구성 방법 
- SD 카드 리더기를 통한 SD 카드에 RaspberryImager 을 사용하여 64Bit OS 설치 진행
  - RaspberryImager 어플리케이션에서 Ctrl + Shift + X 키를 통해 OS의 아이디와 비밀번호를 설정하고, 연결할 네트워크의 아이디를 설정 한다.
<br>
<img src="https://github.com/user-attachments/assets/e4d4dcf7-9a37-4db1-af6b-70ce49265895"  width="550" height="300"/>
<br>
<br>
- 설치 후 SD 카드를 보드에 삽입 후 전원 연결
- 전원 연결 후
  -  네트워크 연결을 통해 보드의 IP 주소를 알아내야 함 
-  IP 주소를 알아냈다면, Putty를 사용해 접속하고 로그인한다.<br>

<br> 
<img src="https://github.com/user-attachments/assets/b53d14a0-ce1e-4ce3-8462-73ba1eca0c3d"  width="350" height="300"/>


## 3. 사용한 센서 및 부가적인 부품 & 적용 방법 
<br> 
사용자의 위치를 실시간으로 판단하기위한 GPS <br> 

<GPS 모듈><br> 
구매 사이트 : https://www.devicemart.co.kr/goods/view?no=1342149
<br>

휴대용 기기 개발을 위한 충전 모듈 <br> 
<충전 모듈> <br> 
구매 사이트 : https://www.devicemart.co.kr/goods/view?no=12497514
<br>

충전 모듈에 맞는 배터리 <br>
<배터리><br> 
구매 사이트 : https://www.devicemart.co.kr/goods/view?no=10889448
     <br> 
    


