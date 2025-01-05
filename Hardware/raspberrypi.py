import time 
import json
import os
import sys
import asyncio
import pyaudio
import wave
import numpy as np
import pytz
import boto3
import requests
import paho.mqtt.client as mqtt
import websockets
from gpsdclient import GPSDClient  # GPSDClient 클래스를 임포트
from datetime import datetime
from geopy.distance import geodesic
from pydub import AudioSegment
import threading
import gpsd

# ---- Constants ----
# Safe Zone 좌표 및 반경 정의
SAFE_LATITUDE = 37.57302727371158
SAFE_LONGITUDE = 126.9773387671158
SAFE_RADIUS = 0.10  # Safe Zone 반경 (km)

# API 및 MQTT 설정
API_URL = "http://ec2 API 주소"
HEADERS = {'Content-Type': '지정된 Header 작성'}
WS_URI = "wss:/웹소캣 링크 작성/"
CLIENT_ID = "RASPBERRY"
MQTT_BROKER = "MQTT 브로커 주소 작성"  
MQTT_PORT = "포트주소 작성" 
MQTT_TOPIC = "토픽 작성"

# 음성 녹음 설정
SILENCE_THRESHOLD = 1000  # 무음 감지 임계값
SILENCE_DURATION = 2  # 무음 지속 시간 기준 (초)
CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
BUCKET_NAME = "handmadeai"

# Async Loop 설정
loop = asyncio.new_event_loop()

# ---- Utility Functions ----

def get_current_location():
    """
    GPS 모듈을 통해 현재 위치 데이터를 가져오기
    - 유효한 위치 데이터가 있으면 위도와 경도를 반환.
    - 없으면 None 반환.
    """
    try:
        gpsd.connect()
        packet = gpsd.get_current()
        if packet.mode >= 2:  # 2D fix available
            return packet.position()  # 위도, 경도 반환
        return None  # 유효하지 않은 데이터는 None
    except Exception as e:
        print(f"GPS 모듈 오류: {e}")
        return None

def is_outside_safe_zone(current_lat, current_lon):
    """
    현재 위치가 Safe Zone을 벗어났는지 판단,
    - 벗어난 경우 True 반환
    """
    safe_location = (SAFE_LATITUDE, SAFE_LONGITUDE)
    current_location = (current_lat, current_lon)
    distance = geodesic(safe_location, current_location).km  # 거리 계산
    return distance > SAFE_RADIUS

def send_status_to_server(status): 
    """
    Safe Zone 상태(0 또는 1)를 서버에 전송
    """
    try:
        response = requests.put(API_URL, data=json.dumps(status), headers=HEADERS, timeout=5)
        if response.status_code == 200:
            print(f"Server Response: {response.json()}")
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")

def upload_to_s3(local_file, bucket, s3_file, metadata):
    """
    녹음 파일을 AWS S3에 업로드합니다.
    """
    s3 = boto3.client('s3')
    try:
        s3.upload_file(Filename=local_file, Bucket=bucket, Key=s3_file, ExtraArgs={"Metadata": metadata})
    except Exception as e:
        print(f"S3 upload failed: {e}")

def is_silent(data):
    """
    주어진 오디오 데이터가 무음인지 확인
    """
    return np.abs(np.frombuffer(data, dtype=np.int16)).mean() < SILENCE_THRESHOLD

def amplify_audio(frames, factor):
    """
    오디오 데이터를 지정된 배율로 증폭
    """
    audio_data = np.frombuffer(b''.join(frames), dtype=np.int16)
    amplified_data = (audio_data * factor).astype(np.int16)
    return amplified_data.tobytes()

def record_audio(wav_filename, mp3_filename, amplify_factor=1):
    """
    음성을 녹음하여 지정된 파일(WAV 및 MP3)에 저장,
    - 무음이 감지되면 녹음을 중지.
    """
    audio = pyaudio.PyAudio()
    stream = audio.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True, frames_per_buffer=CHUNK)

    frames = []
    silent_chunks = 0
    recording = False

    while True:
        data = stream.read(CHUNK)
        if is_silent(data):  # 무음인지 확인
            if recording:
                silent_chunks += 1
                if silent_chunks > int(RATE / CHUNK * SILENCE_DURATION):
                    break  # 무음 지속 시간이 초과되면 녹음 중지
            frames.append(data)
        else:  # 소음이 감지되면 녹음 시작
            silent_chunks = 0
            recording = True
            frames.append(data)

    stream.stop_stream()
    stream.close()
    audio.terminate()

    # 녹음 데이터를 증폭하고 파일로 저장
    amplified_frames = amplify_audio(frames, amplify_factor)
    wf = wave.open(wav_filename, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(audio.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    wf.writeframes(amplified_frames)
    wf.close()

    # WAV 파일을 MP3로 변환
    audio_segment = AudioSegment.from_wav(wav_filename)
    audio_segment.export(mp3_filename, format="mp3")

    return datetime.now()


def start_loop():
    asyncio.set_event_loop(loop)
    loop.run_forever()


loop_thread = threading.Thread(target=start_loop, daemon=True)
loop_thread.start()

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT broker with result code {rc}")
    client.subscribe(MQTT_TOPIC) 


def on_message(client, userdata, msg):
    global send_data
    command = msg.payload.decode()
    print(f"=== Received MQTT command: {command} ===")

    if command == "start":
        send_data = True
        try:
            # 이벤트 루프 상태 확인
            if not loop.is_running():
                print("Error: 이벤트 루프가 실행 중이 아닙니다.")
                return

            # 비동기 작업을 루프에 등록
            future = asyncio.run_coroutine_threadsafe(start_websocket(), loop)

            # 결과 확인
            result = future.result(timeout=5)  # 5초 내 결과 대기
            print("start_websocket 실행 완료:", result)

        except Exception as e:
            print(f"start_websocket 실행 중 예외 발생: {e}")

        except Exception as e:
            print(f"Error during coroutine submission: {e}")

    elif command == "stop":
        send_data = False


async def send_location_data(websocket):
    print('====== (8) Send Location Data 코드 실행 ===== ')
    while send_data:
        location = get_current_location()
        if location:
            data = {
                "action": "sendLocation", 
                "latitude": location[0],
                "longitude": location[1]
            }
            await websocket.send(json.dumps(data))
            await asyncio.sleep(1)  # 1초마다 데이터 전송
        else:
            print("Unable to retrieve location data.")
            await asyncio.sleep(1)


async def start_websocket():
    try:
        print(f"Connecting to WebSocket at {WS_URI}")
        async with websockets.connect(WS_URI) as websocket:

            # 클라이언트 ID를 처음으로 전송
            client_id_data = {
                "action": "clientId",
                "clientId": CLIENT_ID,
            }
            await websocket.send(json.dumps(client_id_data))

            # 위치 데이터 전송 시작
            await send_location_data(websocket)
    except Exception as e:
        print(f"WebSocket 실행 중 예외 발생: {e}")


if __name__ == "__main__":
    loop_thread = threading.Thread(target=start_loop, daemon=True)      
    loop_thread.start()
    print(f"Loop initialized and running on thread: {loop_thread.name}")

    before_status = None
    mqtt_client = mqtt.Client(client_id=CLIENT_ID)
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message
    mqtt_client.connect(MQTT_BROKER, MQTT_PORT, 60)
    mqtt_client.loop_start()

    while True:
        location = get_current_location()  # GPS 위치 가져오기

        if location:  # 유효한 GPS 데이터 확인
            lat, lon = location
            print(f"Current location: Latitude {lat}, Longitude {lon}")

            # Safe Zone 확인
            is_safe = not is_outside_safe_zone(lat, lon)
            status = 0 if is_safe else 1  # Safe Zone 안은 0, 밖은 1

            # 상태가 변경되었을 때만 서버로 상태 전송
            if before_status != status:
                send_status_to_server(status)  # 서버로 상태 전송
                before_status = status  # 상태 업데이트

                if status == 1:  # Safe Zone 밖에서 녹음 시작
                    print("Outside Safe Zone. Starting recording.")
                    korea_tz = pytz.timezone('Asia/Seoul')
                    current_time = datetime.now().astimezone(korea_tz)
                    time_str = current_time.strftime('%Y-%m-%d_%H-%M-%S')
                    wav_file = f"{time_str}.wav"
                    mp3_file = f"{time_str}.mp3"              
                    
                    # 녹음 실행
                    recording_start_time = record_audio(wav_file, mp3_file, amplify_factor=2)

                    if recording_start_time:  # 녹음 시작 시간 정보가 있을 때만 실행
                        # 타임스탬프 기반 파일 이름 생성
                        korea_time = recording_start_time.astimezone(korea_tz)
                        time_str = korea_time.strftime('%Y-%m-%d_%H-%M-%S')
                        unique_wav_filename = f"{time_str}.wav"
                        unique_mp3_filename = f"{time_str}.mp3"
                        # 파일 이름 변경
                        os.rename(wav_file, unique_wav_filename)
                        os.rename(mp3_file, unique_mp3_filename)

                        # 녹음 후 파일 존재 여부 확인 및 S3 전송
                        if os.path.exists(unique_wav_filename) and os.path.exists(unique_mp3_filename):
                            print(f"{unique_wav_filename} and {unique_mp3_filename} successfully created.")
                            metadata = {
                                "recording_time": korea_time.strftime('%Y-%m-%d %H:%M:%S KST'),
                                "latitude": str(lat),
                                "longitude": str(lon)
                            }
                            upload_to_s3(unique_mp3_filename, BUCKET_NAME, unique_mp3_filename, metadata)
                            # 업로드 후 파일 삭제
                            os.remove(unique_mp3_filename)
                            os.remove(unique_wav_filename)
                            print(f"Local files {unique_wav_filename} and {unique_mp3_filename} deleted.")
                        else:
                            print("File creation failed, no upload performed.")
                    else:
                        print("Recording failed, no valid start time.")
            else:
                # 상태가 변경되지 않았을 때 외부인지 확인하고, 외부일 경우 녹음을 계속 진행
                if status == 1:  # Safe 존 밖
                    print("Continuing to record since still outside Safe Zone.")
                    recording_start_time = record_audio(wav_file, mp3_file, amplify_factor=2)

                    if recording_start_time:  # 녹음 시작 시간 정보가 있을 때만 실행
                        # 타임스탬프 기반 파일 이름 생성
                        korea_time = recording_start_time.astimezone(korea_tz) if recording_start_time else "unknown"
                        current_time_str = korea_time.strftime('%Y-%m-%d %H:%M:%S KST')
                        metadata = {
                            "recording_time": current_time_str,
                            "latitude": str(lat),
                            "longitude": str(lon)
                        }
                        upload_to_s3(mp3_file, BUCKET_NAME, mp3_file, metadata)

                        # 업로드 후 파일 삭제
                        os.remove(mp3_file)
                        os.remove(wav_file)
                        print(f"Local files {wav_file} and {mp3_file} deleted.")
                    else:
                        print("Recording failed, no valid start time.")
                else:
                    print("Inside Safe Zone. No recording or file creation, skipping upload and file deletion.")

        else:
            # GPS 데이터가 유효하지 않으면 상태 0 전송
            print("GPS unavailable or invalid, sending status 0 to server.")
            send_status_to_server(0)
            print("Exiting program due to invalid GPS data.")
            sys.exit(0)

        # 딜레이 설정 (원하는 주기에 따라 조정)
        time.sleep(30)  # 30초마다 체크 
