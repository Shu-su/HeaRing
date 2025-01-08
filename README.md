# 헤아Ring
<p align='center'>
<img width='300' src='https://github.com/user-attachments/assets/a52ab25a-7ea0-475a-9e44-27f1d7586c6d'>
<img width='300' src='https://github.com/user-attachments/assets/5582a2e6-4ef8-44b7-93f7-4fe249de1714'><br><br>
<b>치매 환자 발화패턴 학습 AI를 이용한 위험 상황 감지 및 실종 예방 도우미</b><br><br></p>

> 한양여자대학교 스마트IT과 캡스톤디자인 졸업작품 수제지능팀입니다.<br>
> 개발기간 : 2024.04 ~ 2024.11
<br>

## 팀원 소개 🧑🏻‍🧑‍🧒🏽
|황혜진|오지현|전희주|옥지원|
|------|---|---|---|
|<p align='center'><img width="150" src="https://github.com/user-attachments/assets/4af55385-6c9a-4264-a943-2d40b5022462"></p>|<p align='center'><img width="150" src="https://github.com/user-attachments/assets/e9a46cb4-4612-4b84-be03-013c4489f766"></p>|<p align='center'><img width="150" src="https://github.com/user-attachments/assets/81ec2841-f5c0-4c3c-b315-bb45716281bc"></p>|<p align='center'><img width="150" src="https://github.com/user-attachments/assets/b05a0bb5-62c8-4c09-bf6b-e331f6521b9d"></p>|
|<p align='center'>[@Shu-su](https://github.com/Shu-su)</p>|<p align='center'>[@hynzio](https://github.com/hynzio)</p>|<p align='center'>[@heeeeeeee2](https://github.com/heeeeeeee2)</p>|<p align='center'>[@jiwon102](https://github.com/jiwon102)</p>
|<p align='center'>[PM] AI, App 일부 전담</p>|<p align='center'>백엔드 및 서버 전담</p>|<p align='center'>App 전담</p>|<p align='center'>하드웨어 전담</p>|
<br>

## 참여 경력 🏆
- 2024년 프로보노 ICT 멘토링 수행
- 캡스톤디자인 은상 수상
- 교내 AI융합혁신 경진대회 최우수상 수상
<br>

## 프로젝트 목적 ✅ 
<헤아Ring>은 **치매 환자의 발화 패턴을 학습한 AI 음성 분석 모델을 통해 환자의 위험 가능성을 실시간으로 판단하는 시스템**입니다. 환자의 발화가 감지되면 자동으로 녹음 후 이를 분석하여, 위험으로 판정된 내용과 위치·시간 정보를 보호자에게 전송합니다. 이를 통해 보호자가 실종이나 위험 상황을 조기에 파악할 수 있도록 지원합니다. <헤아Ring>은‘경고를 울린다(Ring)'와 '환자 및 보호자의 마음을 헤아린다'는 의미를 담은 이름이며, 치매 환자의 안전을 지키고자 합니다. 
<br><br>

## Demo 🎞️
[헤아Ring 시연 동영상 보기](https://www.youtube.com/watch?v=xleeRUj7p3w, "시연 동영상 유튜브")
<br><br>

## 주요 기능 📦
<img width='70%' src='https://github.com/user-attachments/assets/9e4d0af0-75a9-4432-affd-263ee6379cf2'>
<br><br>

## 화면 구성 🖥️
|회원가입|회원가입 및 로그인|
|------|---|
|<p align='center'><img width="" src="https://github.com/user-attachments/assets/4ac7421c-d9e0-43c5-916d-63281f8e274b"></p>|<p align='center'><img width="80%" src="https://github.com/user-attachments/assets/ba927368-6591-40fe-805c-0e5a97cab00b"></p>|
|<p align='center'>**메인화면**</p>|<p align='center'>**위험감지화면**</p>|
|<p align='center'><img width="70%" src="https://github.com/user-attachments/assets/676c8941-2935-473d-afda-888058e48b13"></p>|<p align='center'><img width="110%" src="https://github.com/user-attachments/assets/14c43bcd-f8b4-42b6-9446-a4e021d2c0ef"></p>|
|<p align='center'>**GPS화면**</p>|<p align='center'>**이전기록 다시보기 화면**</p>|
|<p align='center'><img width="70%" src="https://github.com/user-attachments/assets/8fbc68b4-e7c3-48a3-b7ae-7a4711dd1dbb"></p>|<p align='center'><img width="60%" src="https://github.com/user-attachments/assets/c61de56e-91cb-4879-a705-ce6e84bc6e04"></p>|
<br>

## 위험상황 판단 AI 📊
- Bert 모델을 파인튜닝하여 위험 상황과 정상 상황의 발화를 분류
- 한국어로 훈련된 SKT의 ‘KoBert’ 모델 선택해 파인튜닝 진행
- 정상상황 발화 13,000개 + 위험상황 발화 6,016개 ⇒ 총 19,016개 데이터 사용
- 훈련 결과 : loss 0.10, accuracy 0.98
<p align='center'><img width='70%' src='https://github.com/user-attachments/assets/beba0029-9b57-4cd2-9c81-2bda0d018473'></p>
<br>

## 프로젝트 구조 🧱
### 시나리오
<img width='70%' src='https://github.com/user-attachments/assets/cbdf45b5-1088-4560-bc03-f900b2cd524a'>
<br>

### 아키텍처
<img width='70%' src='https://github.com/user-attachments/assets/8b9415a1-44d9-4ed5-80a7-1063f3d066c3'>
<br>

### 알고리즘 시나리오
<img width='70%' src='https://github.com/user-attachments/assets/48a9dc0c-9731-482d-838f-e421e365b106'>
<br>

### 디렉터리 구조

<br>

## 기술 스택 🔧
### 공통
![](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)
![](https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=google-sheets&logoColor=white)
![](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)
![](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)
![](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

### 백엔드
![](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
<br>

### 프론트엔드
![](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)
<br>

### AI
![](https://img.shields.io/badge/Colab-F9AB00?style=for-the-badge&logo=googlecolab&color=525252)
![](https://img.shields.io/badge/PyCharm-000000.svg?&style=for-the-badge&logo=PyCharm&logoColor=white)
![](https://img.shields.io/badge/Python-14354C?style=for-the-badge&logo=python&logoColor=white)
<img src="https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=PyTorch&logoColor=white"><br>
![](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
<img src="https://img.shields.io/badge/HuggingFace-FFD21E?style=for-the-badge&logo=HuggingFace&logoColor=black">
![](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)

<br>

### 하드웨어

<br>
