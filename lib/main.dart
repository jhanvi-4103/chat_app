import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_gate.dart';
import 'package:kd_chat/firebase_options.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://fzirwmmkenbbngmbutpl.supabase.co',  
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6aXJ3bW1rZW5iYm5nbWJ1dHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NTE2MjQsImV4cCI6MjA1NTUyNzYyNH0.QZBjQNOf4TttAQ2_VOc0MlqM7B-U3raQe5EDrLldfXY',  
  );
  runApp(
    ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
    )
  );
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
