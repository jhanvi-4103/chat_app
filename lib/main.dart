import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_gate.dart';
import 'package:kd_chat/firebase_options.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
WidgetsBinding.instance.addObserver(MyAppLifecycleObserver());



  await requestPermissions(); 
  runApp(
    ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
    )
  );
}
Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
   // Permission.notification,
  ].request();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kd Chat',
  
      home:  const AuthGate(),
      theme:Provider.of<ThemeProvider>(context).themedata,
    );
  }
}
class MyAppLifecycleObserver extends WidgetsBindingObserver {
  final userRef = FirebaseFirestore.instance
      .collection('NewUsers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
