import torch
import numpy as np
from fordanger1.preprocess import BERTDataset

def predict_sentence(text, tokenizer, vocab, model, device): 

    # config
    max_len = 64
    batch_size = 64 

    data = [text, '0']
    dataset_another = [data]

    another_test = BERTDataset(dataset_another, 0, 1, tokenizer, vocab, max_len, True, False) # 토큰화한 문장
    test_dataloader = torch.utils.data.DataLoader(another_test, batch_size = batch_size, num_workers = 5) # torch 형식 변환

    model.eval()

    for batch_id, (token_ids, valid_length, segment_ids, label) in enumerate(test_dataloader):
        token_ids = token_ids.long().to(device)
        segment_ids = segment_ids.long().to(device)

        valid_length = valid_length
        label = label.long().to(device)

        # 모델에 데이터 입력하여 출력값 얻기
        out = model(token_ids, valid_length, segment_ids)

        test_eval = []

        ### ===== 원래 코드 ====
        # for i in out: # out = model(token_ids, valid_length, segment_ids)
        #     logits = i
        #     logits = logits.detach().cpu().numpy()
        #     # print(logits)


        #     # 예측 결과에 따라 라벨 할당
        #     if np.argmax(logits) == 0:
        #         test_eval.append("normal")
        #     elif np.argmax(logits) == 1:
        #         test_eval.append("danger")
        #     # print(test_eval)
            
        # print(">> 입력하신 내용은 \"" + test_eval[0] + "\"으로 보여집니다. (logits : "+str(logits)+" )")
        # return test_eval[0]
    
    
        # ### ==== 10.10 소프트 맥스 적용을 위해 추가 =========
        for i in out: 
            logits = i.detach().cpu().numpy()

            # 소프트맥스 적용하여 확률값으로 변환
            probabilities = torch.nn.functional.softmax(torch.tensor(logits), dim=-1).numpy()

            # 예측 결과에 따라 라벨 할당
            if np.argmax(probabilities) == 0:
                test_eval.append("normal")
            elif np.argmax(probabilities) == 1:
                test_eval.append("danger")

        print(">> 입력하신 내용은 \"" + test_eval[0] + "\"으로 보여집니다. (logits : "+str(logits)+", probabilities : "+str(probabilities)+" )")
        return test_eval[0]