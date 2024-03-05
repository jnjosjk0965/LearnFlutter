import 'package:flutter/material.dart';
import 'package:toonflix/screen/home_screen.dart';
import 'dart:io';

// 403 에러
// 따로 User-Agent 값을 추가하지 않으면 기본값으로 `Dart/<version> (dart:io)` 가 들어갑니다.
// (https://api.flutter.dev/flutter/dart-io/HttpClient/userAgent.html)

// 이 값을 지우고 브라우저에서 사용하는 값으로 바꿔줍니다.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFFCF6F5),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF2BAE66),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
