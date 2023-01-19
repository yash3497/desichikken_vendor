import 'package:delicious_vendor/controller/auth_controller.dart';
import 'package:delicious_vendor/views/auth/log_in_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((event) {
      FlutterRingtonePlayer.play(
        fromAsset: 'assets/images/Buzzerrr.mp3',
        looping: true,
      );
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const InitializerFirebaseUser()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ShaderMask(
            child: const Image(
              image: AssetImage("assets/images/splash1.png"),
            ),
            shaderCallback: (Rect bounds) {
              return const LinearGradient(colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.5)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  .createShader(bounds);
            },
          ),
          addVerticalSpace(height(context) * 0.14),
          SizedBox(
            height: height(context) * 0.18,
            child: Image.asset('assets/images/LOGO.png'),
          ),
        ],
      ),
    );
  }
}
