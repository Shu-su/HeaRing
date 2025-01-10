import 'package:flutter/material.dart';
import 'package:hearing/src/init/joinComplete.dart';
import 'package:hearing/src/theme/MyColors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class joinPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _joinPage();
}

class _joinPage extends State<joinPage> {
  int _currentStep = 0;   // 회원가입 step 1 화면 인덱스
  bool _termsAgreed = false; // 이용약관 동의 여부
  bool _privacyPolicyAgreed = false; // 개인정보처리방침 동의 여부
  DateTime? _selectedDate;  // 생년월일
  String _severity = ''; // 중증도 상태를 추적하는 변수 ('경증', '중증')
  // 안전 범위 선택 변수
  final List<String> _ranges = ['50m (중증 환자 기본)', '100m', '150m (경증 환자 기본)', '200m', '250m', '300m'];
  // 선택된 범위 상태 (하나만 선택 가능하므로 int로 선택한 인덱스를 저장)
  int _selectedRangeIndex = -1;  // 선택된 범위가 없을 경우 -1로 초기화
  // QR 스캔용 변수
  String barcode = "";

  // 1단계: QR 코드 스캔 함수 정의
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent; // 스캔 결과 저장
      });
    } catch (e) {
      setState(() {
        barcode = "barcode 인식에 실패했습니다: $e"; // 오류 메시지 저장
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: greenStyle2),
        title: const Text(
          '회원 가입',
          style: TextStyle(
            color: greenStyle2,
          ),
        ),
      ),
      body: Theme(
          data: ThemeData(
          colorScheme: const ColorScheme.light(primary: greenStyle2),
          ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: _controlsBuilder,
          type: StepperType.horizontal,
          steps: _buildSteps(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();requestCameraPermission();
  }

  void requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Step _buildStep({
    required String title,
    required Widget content,
    required bool isActive,
    required bool isEditing,
  }) {
    return Step(
      title: Text(title),
      content: content,
      isActive: isActive,
      state: isEditing
          ? StepState.editing
          : isActive
          ? StepState.complete
          : StepState.disabled,
    );
  }

  List<Step> _buildSteps() {
    return [
      _buildStep(
        title: '계정',  // 버튼 옆 --> 이름
        content:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 전체적으로 왼쪽 정렬
            children: [
              const SizedBox(height: 5),
              // ==== 텍스트1 : 아이디 ====
              Row(
                children: [
                  const Text('아이디', style: TextStyle(fontSize:18)),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: '아이디 입력',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 23),

              // ===== 텍스트2 : 비밀번호 =====
              Row(
                children: [
                  const Text('비밀번호', style: TextStyle(fontSize:18)),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true, // 비밀번호 가리기
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  hintText: '비밀번호 입력',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              const SizedBox(height: 23),

              // ===== 텍스트3: 별명 =====
              Row(
                children: [
                  const Text('별명', style: TextStyle(fontSize:18)),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: '돌봄 대상을 지칭할 별명 입력',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),

              // ==== 선 하나 긋기 (회색) =====
              Divider(color: Colors.grey),

              const SizedBox(height: 15),

              // ==== 텍스트4 : 이용약관동의 ====
              Row(
                children: [
                  const Text('이용약관동의', style: TextStyle(fontSize:20)),
                  const SizedBox(width: 5),
                  const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
                ],
              ),
              const SizedBox(height: 2),
              // ====== 체크박스 1 : 이용약관에 전부 동의합니다 ======
              CheckboxListTile(
                title: const Text('이용약관에 전부 동의합니다', style: TextStyle(fontSize:17)),
                value: _termsAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _termsAgreed = value ?? false;
                  });
                },
              ),

              // ========= 체크박스 2 : 개인정보처리방침약관 (들여쓰기) ==========
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  title: const Text('●  개인정보처리방침약관 (필수)', style: TextStyle(fontSize:17)),
                  value: _termsAgreed,    //--> 이거 termsAgreed로 해주니까 작동
                  onChanged: (bool? value) {
                    setState(() {
                      _privacyPolicyAgreed = value ?? false;
                    });
                  },
                ),
              ),
              // ================ 체크박스 3 : 위치 정보 수집 약관 =================
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  title: const Text('●  위치 정보 수집 약관 (필수)', style: TextStyle(fontSize:17)),
                  value: _termsAgreed,    //--> 이거 termsAgreed로 해주니까 작동
                  onChanged: (bool? value) {
                    setState(() {
                      _privacyPolicyAgreed = value ?? false;
                    });
                  },
                ),
              ),
              // ================ 체크박스 4 : 서비스 이용 약관 =================
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  title: const Text('●  서비스 이용 약관 (필수)', style: TextStyle(fontSize:17)),
                  value: _termsAgreed,    //--> 이거 termsAgreed로 해주니까 작동
                  onChanged: (bool? value) {
                    setState(() {
                      _privacyPolicyAgreed = value ?? false;
                    });
                  },
                ),
              ),


              // // ==== 체크박스 1 : 개인정보처리약관 ====
              // CheckboxListTile(
              //   title: const Text('●  개인정보처리방침 약관 (필수)', style: TextStyle(fontSize:17)),
              //   value: _privacyPolicyAgreed,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _privacyPolicyAgreed = value ?? false;
              //     });
              //   },
              // ),
              //
              // // ==== 체크박스 2 : 위치정보약관 ====
              // CheckboxListTile(
              //   title: const Text('●  위치 정보 수집 약관 (필수)', style: TextStyle(fontSize:17)),
              //   value: _privacyPolicyAgreed,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _privacyPolicyAgreed = value ?? false;
              //     });
              //   },
              // ),
              //
              // // ==== 체크박스 3 : 서비스 이용 약관 ====
              // CheckboxListTile(
              //   title: const Text('●  서비스 이용 약관 (필수)', style: TextStyle(fontSize:17)),
              //   value: _privacyPolicyAgreed,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _privacyPolicyAgreed = value ?? false;
              //     });
              //   },
              // ),
            ], // children 끝
          ),
        isActive: _currentStep >= 0,
        isEditing: _currentStep == 0,
      ),
      _buildStep(
        title: '상세정보',
        content:
          Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 전체적으로 왼쪽 정렬
          children: [
            const SizedBox(height: 10),
            // ============== 텍스트1 : 환자 생년월일 ==========================
            Row(
              children: [
                const Text('생년월일', style: TextStyle(fontSize:20)),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
            children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black54,
                    elevation: 5.0,
                    side: BorderSide(color: Colors.grey, width: 1.0),
                    fixedSize: const Size(120, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async{
                    final selectedDate = await showDatePicker(
                      context: context, // 팝업으로 띄우기 때문에 context 전달
                      initialDate: DateTime(2000), // 달력을 띄웠을 때 선택된 날짜. 위에서 date 변수에 오늘 날짜를 넣었으므로 오늘 날짜가 선택돼서 나옴
                      firstDate: DateTime(1950), // 시작 년도
                      lastDate: DateTime.now(), // 마지막 년도. 오늘로 지정하면 미래의 날짜는 선택할 수 없음
                    ).then((selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    });
                  },
                  child: const Text("날짜 선택", style: TextStyle(fontSize:15 ,color: Colors.black54)),
                ),
                SizedBox(width: 20),
                Container(
                  width: 140, height: 36,
                  // color : Colors.black12,
                  decoration: BoxDecoration(border: Border(
                    // left: BorderSide(color: Colors.black, width: 1),
                    //                   // right: BorderSide(color: Colors.black, width: 1),
                    //                   // top: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1))),
                  child:
                    Text(_selectedDate != null
                        ? _selectedDate.toString().split(" ")[0]
                        : " ",
                        style: const TextStyle(fontSize: 22)),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // ============== 텍스트 : 중증도 ==========================
            Row(
              children: [
                const Text('중증도', style: TextStyle(fontSize:20)),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('중증도에 따라 기본 안전 범위가 달라집니다.', style: TextStyle(fontSize:15 ,color: Colors.grey)),
            const SizedBox(height: 8),

            // ============= 버튼 : 경증, 중증 선택 =======================
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey, width: 1.0),
                    shadowColor: Colors.white,
                    elevation: 5.0,
                    fixedSize: const Size(150, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: _severity == '경증'
                    ? greenStyle1
                        : _severity.isEmpty
                    ? Colors.white  // 아무것도 선택 안 한 경우
                        : Colors.white,
                    ),
                  onPressed: () {
                    setState(() {
                      _severity = '경증'; // 경증 선택
                    });
                  },
                  child: const Text('경증', style: TextStyle(fontSize:17 ,color: Colors.black54)),
                ),
                const SizedBox(width: 20), // 버튼 간 간격
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey, width: 1.0),
                    shadowColor: Colors.white,
                    elevation: 5.0,
                    fixedSize: const Size(150, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: _severity == '중증'
                        ? greenStyle1
                        : _severity.isEmpty
                        ? Colors.white  // 아무것도 선택 안 한 경우
                        : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _severity = '중증'; // 중증 선택
                    });
                  },
                  child: const Text('중증', style: TextStyle(fontSize:17 ,color: Colors.black54)),
                ),
              ],
            ),
              const SizedBox(height: 25),

            // ============ 선 =============
            Divider(color: Colors.grey),
            const SizedBox(height: 18),

            // ============ 텍스트 : 안전지역 설정 =============
            Row(
              children: [
                const Text('안전 지역 설정', style: TextStyle(fontSize:20)),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('외출 알림을 받기 위해 안전 지역을 설정합니다.', style: TextStyle(fontSize:15 ,color: Colors.grey)),
            const SizedBox(height: 20),

            // ==================== 집주소 입력 ====================
            Row(
              children: [
                const Text('●  집주소 입력', style: TextStyle(fontSize:18)),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child:
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: '돌봄 대상자의 집 주소 입력',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
            ),
            const SizedBox(height: 20),

            // ==================== 텍스트 : 안전 범위 설정 ====================
            Row(
              children: [
                const Text('●  안전 범위 설정', style: TextStyle(fontSize:18)),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),

            // ==================== 팝업 : 안전 범위 선택 ====================
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black54,
                    elevation: 5.0,
                    side: BorderSide(color: Colors.grey, width: 1.0),
                    fixedSize: const Size(180, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // 안전 범위 선택 모달 열기
                    _showSafetyRangeSelector(context);
                  },
                child: const Text('안전 범위 선택', style: TextStyle(fontSize:17 ,color: Colors.black54)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 10.0),
              child:
              // 선택된 범위 목록 보여주기 (선택 후 리스트에 보여줄 수도 있음)
                Text(
                  'ㄴ 선택된 범위: ${_getSelectedRangesText()}',
                  style: TextStyle(fontSize: 17, color: greenStyle2)),
              ),
            const SizedBox(height: 10),
            ],
          ),
        isActive: _currentStep >= 1,
        isEditing: _currentStep == 1,
      ),
      _buildStep(
        title: '단말기',
        content:
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start, // 전체적으로 왼쪽 정렬
            children: [
              SizedBox(height: 20),
              Text('단말기 등록을 위해 ', style: TextStyle(fontSize: 20, color: greenStylePoint)),
              Text('바코드를 찍어주세요!', style: TextStyle(fontSize: 20, color: greenStylePoint)),
              SizedBox(height: 20),
              Image.asset(
                  'assets/QRscan.png', width: 250, height: 200, fit: BoxFit.contain),
              SizedBox(height: 20),

              // ============= QR 코드 ==============
              // 화면이 빌드될 때 바로 QR 코드 스캔 시작
              ElevatedButton(
                onPressed: scanBarcode,
                child: Text('📷  바코드 찍기 ', style: TextStyle(fontSize:20 ,color: Colors.white)),
                style:
                  ElevatedButton.styleFrom(
                    backgroundColor: greenStylePoint,
                    fixedSize: const Size(190, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                  ),
              ),
              SizedBox(height: 20),

              // ============ 선 =============
              Divider(color: Colors.grey),
              const SizedBox(height: 18),

              // =========== 코드 스캔 =============
              Row(
                children: [
                  const Text('● 바코드를 통해 입력된 코드', style: TextStyle(fontSize:18)),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(fontSize:15 ,color: Colors.red)),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child:
                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      barcode.isEmpty ? '▷ 바코드 찍기 버튼을 눌러주세요' : '▷ $barcode',
                      textAlign: TextAlign.left, // 텍스트를 왼쪽 정렬
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                ),
              ),
              SizedBox(height: 10),

              // ============= 스캔 상태 ==============
              Align(
                alignment: Alignment.centerLeft, // 이 Padding만 왼쪽 정렬
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0, right: 10.0),
                  child: Text(
                    barcode.isEmpty
                        ? 'ㄴ 미입력 상태입니다.'
                        : (barcode == '804c0513-ec99-4e83-ab82-606d2cc85372'
                        ? 'ㄴ 등록 완료되었습니다. 다음 버튼을 눌러주세요.'
                        : 'ㄴ 바코드가 정확하지 않습니다. 단말기 바코드로 찍어주세요.'),
                    textAlign: TextAlign.left, // 텍스트 자체도 왼쪽 정렬
                    style: TextStyle(fontSize: 15, color: greenStyle2),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // ================================
            ],
          ),
        isActive: _currentStep >= 2,
        isEditing: _currentStep == 2,
      ),
    ];
  }

  Widget _controlsBuilder(BuildContext context, _) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _currentStep != 0
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    backgroundColor: Color(0xffE7E7E7),
                  ),
                  onPressed: _.onStepCancel,
                  child: const Text('이전', style: TextStyle(fontSize:17 ,color: Colors.black)),
                  )
              : Container(),
          _currentStep != 2
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    backgroundColor: greenStyle2,
                  ),
                  onPressed: _.onStepContinue,
                  child: const Text('다음', style: TextStyle(fontSize:17 ,color: Colors.white)),
                )
              // : ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       fixedSize: const Size(80, 40),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(11.0),
              //       ),
              //       backgroundColor: greenStyle2,
              //     ),
              //     onPressed: () {
              //       print('submit');
              //       Navigator.of(context).pushNamed('/qr');
              //     },
              //     child: const Text('다음', style: TextStyle(fontSize:17 ,color: Colors.white)),
              //   ),
              : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  backgroundColor: barcode.isNotEmpty ? greenStyle2 : Colors.black87,
                ),
                onPressed: barcode == '804c0513-ec99-4e83-ab82-606d2cc85372'
                    ? () {
                  print('submit');
                  Navigator.of(context).pushNamed('/joinComplete');
                }
                    : null, // 값이 없을 때는 onPressed를 null로 비활성화
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
        ],
      ),
    );
  }


  void _onStepCancel() {
    if (_currentStep <= 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  void _onStepContinue() {
    if (_currentStep >= 2) return;
    setState(() {
      _currentStep += 1;
    });
  }

  // 선택된 범위를 텍스트로 반환하는 함수
  String _getSelectedRangesText() {
    if (_selectedRangeIndex == -1) {
      return '선택된 범위 없음';
    } else {
      return _ranges[_selectedRangeIndex];
    }
  }

  // 안전 범위 선택 모달을 보여주는 함수 (라디오 버튼으로 변경)
  void _showSafetyRangeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('안전 범위 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_ranges.length, (index) {
              return RadioListTile<int>(
                title: Text(_ranges[index]),
                value: index,
                groupValue: _selectedRangeIndex,
                onChanged: (int? value) {
                  setState(() {
                    _selectedRangeIndex = value ?? -1;
                  });
                  Navigator.of(context).pop(); // 선택 후 팝업을 닫음
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }



}