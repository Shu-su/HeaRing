import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) {
        try {
            // 서버 URL 설정
            String serverUrl = "http://localhost:8080/api/device";

            // URL 생성
            URL url = new URL(serverUrl);

            // HTTP 연결 설정
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            // 응답 코드 확인
            int responseCode = conn.getResponseCode();
            System.out.println("Response Code: " + responseCode);

            // 응답 내용 읽기
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // 응답 출력
            System.out.println("Response: " + response.toString());

            // 연결 해제
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}