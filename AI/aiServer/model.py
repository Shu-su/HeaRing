import torch
import gluonnlp as nlp
# Hugging Face를 통한 모델 및 토크나이저 Import
from kobert_tokenizer import KoBERTTokenizer
from transformers import BertModel
from fordanger1.model import BERTClassifier
from fordanger1.preprocess import BERTSentenceTransform, BERTDataset
from fordanger1.predict_sentence import predict_sentence


class ModelHandler():
    def __init__(self):
        super().__init__()
        self.initialize()

    def initialize(self):
        # De-serializing model and loading vectorizer
        # 토크나이저와 BERT 모델 불러오기
        self.tokenizer = KoBERTTokenizer.from_pretrained('skt/kobert-base-v1')
        self.bert_model = BertModel.from_pretrained("skt/kobert-base-v1")
        self.vocab = nlp.vocab.BERTVocab.from_sentencepiece(self.tokenizer.vocab_file, padding_token='[PAD]')

        # BERTClassifier 초기화
        self.model = BERTClassifier(self.bert_model, dr_rate=0.5)
        load_state = './fordanger1/10.06_bert_classifier.pth'

        # 모델 가중치 로드
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model.load_state_dict(torch.load(load_state, map_location=self.device))
        self.model.to(self.device)
        self.model.eval()

    def inference(self, text):
        # get predictions from model as probabilities
        # 전처리 + 추론 + 결과 내는 것

        result = predict_sentence(text, self.tokenizer, self.vocab, self.model, self.device)
        # print(result)
        return result
