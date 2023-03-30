import 'package:delicious_vendor/controller/auth_controller.dart';
import 'package:delicious_vendor/model/firebaseOperation.dart';
import 'package:delicious_vendor/model/global_helper.dart';
import 'package:delicious_vendor/model/product_provider.dart';
import 'package:delicious_vendor/views/auth/log_in_screen.dart';
import 'package:delicious_vendor/views/auth/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FirebaseOperations()),
        ChangeNotifierProvider.value(value: GlobalHelper()),
        ChangeNotifierProvider.value(value: ProductProvider()),
      ],
      child: MaterialApp(
          title: 'Desichikken Vendor',
          theme: ThemeData(
            primarySwatch: Colors.blue,

            //
            //scaffoldBackgroundColor: const Color.fromRGBO(50, 50, 50, 0.8),
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
          home: const SplashScreen()),
    );
  }
}
