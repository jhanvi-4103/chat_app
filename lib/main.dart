import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/onbording/splash_screen.dart';
import 'package:kd_chat/services/auth/auth_gate.dart';
import 'package:kd_chat/firebase_options.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://fzirwmmkenbbngmbutpl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6aXJ3bW1rZW5iYm5nbWJ1dHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NTE2MjQsImV4cCI6MjA1NTUyNzYyNH0.QZBjQNOf4TttAQ2_VOc0MlqM7B-U3raQe5EDrLldfXY',
  );

  // Add lifecycle observer for app
  WidgetsBinding.instance.addObserver(MyAppLifecycleObserver());

  // Request permissions
  await requestPermissions();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
  ].request();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _startSplashDelay();
  }

  void _startSplashDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kd Chat',
      home: _showSplash ? const SplashScreen() : const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}

class MyAppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userRef = FirebaseFirestore.instance
          .collection('NewUsers')
          .doc(user.uid);

      if (state == AppLifecycleState.resumed) {
        userRef.update({'isOnline': true});
      } else {
        userRef.update({
          'isOnline': false,
          'lastSeen': Timestamp.now(),
        });
      }
    }
  }
}
