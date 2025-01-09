# 위험 상황 판단 AI 개발

![](https://img.shields.io/badge/Colab-F9AB00?style=for-the-badge&logo=googlecolab&color=525252)
![](https://img.shields.io/badge/PyCharm-000000.svg?&style=for-the-badge&logo=PyCharm&logoColor=white)
![](https://img.shields.io/badge/Python-14354C?style=for-the-badge&logo=python&logoColor=white)
<img src="https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=PyTorch&logoColor=white"><br>
![](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
<img src="https://img.shields.io/badge/HuggingFace-FFD21E?style=for-the-badge&logo=HuggingFace&logoColor=black">
![](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)

AI 개발은 다음 단계로 진행되었습니다. 잘 정리된 PPT 이미지를 함께 첨부합니다.<br>
- 데이터 수집
- 데이터 전처리
- 데이터 수작업 정제
- 데이터 증강
- KoBert 모델을 이용한 훈련 진행
- 완성된 모델 Hugging Face Hub에 탑재
- AWS 딥러닝 EC2 생성 & 서버에 모델 배포
<br>

---

## 위험 상황 판단 위해 NLP 분류 'Bert' 모델 선택
<img width='80%' src='https://github.com/user-attachments/assets/32ee022c-433f-417a-8b0b-8ba38f36d1ee'>
<br><br>

---

## 발화 데이터셋 구축
<img width='80%' src='https://github.com/user-attachments/assets/149247f3-8345-4a90-859b-dfbb7254fa5b'><br><br>

### 1️⃣ 데이터 수집
> 데이터 수집은 AI Hub에서 제공하는 데이터로 정상 발화 데이터셋을 구축하였습니다. <br>
> 위험 발화의 경우, **치매 환자의 발화를 수집**하는 것이 어려웠기에 논문 및 유튜브를 통해 수집하며 직접 구축하였습니다.
<br>

### 2️⃣ 데이터 전처리 & 수작업 정제
> (첨부된 코드 **'1_텍스트 데이터 전처리.ipynb'를 통해 1차 전처리**로 진행) <br>
> ⇒ 사용한 라이브러리 : 중복제거(drop_duplicates), 띄어쓰기 처리(PyKoSpacing), 맞춤법 검사(py-hanspell), 불용어 제거(정규표현식) <br>
> 전처리된 결과물을 **직접 검토하며 적절한 데이터를 선별**하고, 전처리되지 않은 문장들을 전처리해주었습니다.
<br>

### 3️⃣ 위험 발화 데이터 증강
> (첨부된 코드  **'2_데이터 증강(KorEDA).ipynb'로 진행**) <br>
> 수집된 위험 발화 데이터 개수가 '1,340개'로 매우 적었기에 증강 작업을 거쳤습니다. <br>
> 데이터의 길이가 짧은 것도 많았기에 바로 라이브러리를 이용한 증강을 진행하지 않고, **ChatGPT를 이용한 수작업 증강**을 진행하였습니다. <br>
> 이후 **KorEDA**를 이용하여 2차 증강을 진행해주었습니다. <br>
> 그 결과, **4.5배**로 데이터의 개수를 늘릴 수 있었습니다.
<br>

---
## 모델 훈련
<img width='80%' src='https://github.com/user-attachments/assets/fdb09a9f-a6d5-49d3-b67e-0462c6cf60a0'>
<br><br>

> (첨부된 코드 **'3_위험상황판단AI_KoBERT.ipynb'로 진행**) <br>
> 구축된 데이터를 KoBert 모델에 넣고, 파인튜닝하여 위험상황 판단 AI 모델을 만들었습니다. <br>
> 직접 문장을 넣어 테스트해볼 때도 잘 작동하는 걸 볼 수 있었습니다. <br>
> 훈련 중 과적합이 발생하였기에, **드롭아웃 비율을 0.7로 높이고 초기 학습률을 낮추어 해결**하였습니다.
<br>

---

## 모델 성능
<img width='80%' src='https://github.com/user-attachments/assets/beba0029-9b57-4cd2-9c81-2bda0d018473'>
<br><br>

> 테스트를 하다 보니 위험발화 데이터에 과적합된 양상을 보이기에 **정상발화 데이터를 추가**하여 해결하였습니다.
<br>

---

# 서버에서 모델 이용

## 1️⃣ 허깅페이스 허브에 모델 탑재
> (첨부된 코드 **'3_위험상황판단AI_KoBERT.ipynb'로 진행**) <br>
> AWS EC2 딥러닝 서버에 직접 모델을 올릴까 했으나, 모델 용량이 커 허깅페이스 허브에 먼저 모델을 업로드하였습니다. <br>
> 모델과 함께 전처리 & 모델 정의 & 예측 소스코드를 업로드하였습니다. 
<br>

## 2️⃣ AWS EC2 딥러닝 서버 생성
> 아래 사양으로 인스턴스 생성과 기본 라이브러리 설치 진행하였습니다. 
> - 인스턴스 유형 : g4dn.xlarge (GPU 사용)
> - Ubuntu 기반 인스턴스 사용
> - AMI : Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.4.1 (Ubuntu 22.04) <br>
<br>

```
pip install mxnet
pip install gluonnlp
pip install sentencepiece
pip install transformers
pip install torch
pip install pandas
pip install boto3

pip install numpy==1.23.1
pip install gluonnlp==0.8.0
pip install 'git+https://github.com/SKTBrain/KoBERT.git#egg=kobert_tokenizer&subdirectory=kobert_hf'
git clone https://huggingface.co/WarrWang/fordanger1
```

<br>

> 마지막 줄에서 서버 인스턴스 내로 Clone 되지만 직접 다운 받고 싶을 땐 아래 링크를 이용하면 됩니다. <br>
> - [허깅페이스허브에서 모델 다운로드](https://huggingface.co/WarrWang/fordanger1/tree/main)

<br>

## 3️⃣ 딥러닝 서버에 모델 배포
<p align='center'><img width='60%' src='https://github.com/user-attachments/assets/3ea10949-0e9f-4657-9ccf-e74bb547408f'></p><br>

> 단말기에서 수집된 녹음 파일 ⇒ STT 처리 ⇒ 발화 문장의 위험도 판단 <br>
> 'aiServer' 디렉터리 내의 소스코드를 통해 발화 문장이 위험 발화인지를 예측합니다. <br>
> - app_flask.py : Flask 서버 시작, 예측 결과 반환 <br>
> - model.py : 모델 핸들러 역할 (모델 초기화, 추론 메서드 존재) <br>
> - predicct_sentence.py : 전처리, 모델 추론, 결과 생성

<br>

# 한계
## 1. 위험 발화 데이터 수집의 한계
> 이번 프로젝트는 처음 진행하는 AI 프로젝트로, 데이터 수집 및 처리 과정에서 부족함이 있습니다. <br>
> 수집된 위험 발화 데이터 개수가 충분하지 않아, 과적합 문제 해결과 실제 응용 단계에서 어려움이 있었습니다. <br>
> 단일 모델 기반으로는 높은 성능을 보였지만, 새로운 위험 발화 단어나 예외적인 발화가 입력될 경우 모델 예측이 부정확해지는 한계가 드러나기도 했습니다. <br>
> 또한, 데이터 전처리에 많은 노력을 기울였지만, 데이터 수집 단계에서 보다 다양한 상황과 고품질 데이터를 확보하지 못한 점이 아쉬움으로 남습니다.<br>
> 다음 프로젝트에서는 **데이터를 보다 체계적이고 다양한 상황에서 수집하여, 모델이 더 넓은 범위의 발화 패턴을 학습**하도록 진행해보고 싶습니다.
<br>

## 2. 기능 확장 및 하드웨어 연동의 한계
> 헤아Ring은 하드웨어와 AI 모델을 연동하여 위험 발화를 이진 분류로 판단하는 기능을 구현했지만, 이 과정에서 몇 가지 한계가 있습니다. <br>
> 처음 설계 당시 발화 분석 외에 감정 분석, GPS 트래킹 등 다양한 기능을 추가하려는 계획이 있었으나, 시간과 경험 부족으로 인해 구현하지 못했습니다. <br>
> 위험 상황을 보다 정교하게 판단하려면, 발화 외에도 비언어적 신호나 외부 데이터(GPS, 주변 소음 등)를 결합할 필요성이 있습니다. <br>
> 다음 프로젝트를 진행할 땐 이번 프로젝트에서 얻은 경험을 바탕으로 **초기 설계를 보다 꼼꼼히 진행하고, 일정 관리와 기능 개발 속도를 개선**하여 더 실용적이고 확장성 있는 시스템을 개발해보고 싶습니다. <br>
