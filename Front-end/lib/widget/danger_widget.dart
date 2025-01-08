// import 'package:flutter/material.dart';
//
// class DangerWidget extends StatelessWidget {
//   const DangerWidget({Key? key, required this.child}) : super(key: key);
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5,horizontal:0), // Bar랑 거리두기
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: SizedBox(
//             width: 400,
//             height: 80,
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF09E9E),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class DangerWidget extends StatelessWidget {
  const DangerWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0), // Bar랑 거리두기
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 400,  // 너비를 400으로 고정
              minHeight: 80,  // 최소 높이를 80으로 설정
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF09E9E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: child,  // 입력된 내용에 따라 자동으로 높이 조정
            ),
          ),
        ),
      ),
    );
  }
}
