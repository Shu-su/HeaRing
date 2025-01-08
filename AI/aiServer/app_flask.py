from flask import Flask, request, json, jsonify
from model import ModelHandler

app = Flask(__name__)

# assign model handler as global variable
dl_handler = ModelHandler()

@app.route("/predict", methods=["POST"])
def predict():
    # handle request and body
    # 요청에서 JSON 데이터 추출
    body = request.get_json()

    # 요청 데이터에서 문장 리스트 추출
    sentences = body.get("sentences", [])

    # 결과를 저장할 리스트
    results = []
    is_dangerous = False

    # 각 문장에 대해 예측 수행
    for sentence in sentences:
        raw_sentence = sentence
        prediction = dl_handler.inference(sentence)
        
        results.append({
            "text": raw_sentence,
            "prediction": prediction
        })
        
        # 위험 상황이 하나라도 발견되면 isDangerous를 True로 설정
        if prediction == "danger":
            is_dangerous = True

    # 응답 JSON 구성
    response = {
        "sentences": results,
        "isDangerous": str(is_dangerous)  # bool형을 문자열로 변환함
    }

    # return jsonify(response)

    # json.dumps를 사용해 ensure_ascii=False로 설정
    return app.response_class(
        response=json.dumps(response, ensure_ascii=False),
        status=200,
        mimetype='application/json'
    )


if __name__ == "__main__":
    app.run(host='0.0.0.0', port='5000', debug=True)