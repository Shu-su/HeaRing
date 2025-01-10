import 'package:flutter/material.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 50), // Bar랑 거리두기
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 400,
            height: 200,
            child: Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD0DD97),
                borderRadius: BorderRadius.circular(30),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class MainWidget_mini extends StatelessWidget {
  final Widget child;
  final Color backgroundColor ;
  const MainWidget_mini({Key? key, required this.child, this.backgroundColor = const Color(0xFFE7EDCA)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 400,
          height: 100,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
            decoration: BoxDecoration(
              color: backgroundColor, // backgroundColor 사용
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}