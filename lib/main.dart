import 'package:flutter/material.dart';
import 'splash_screen.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

//Define supabase key
const String SUPABASE_URL = 'https://hpjtjnbbbhungyglpnmu.supabase.co';
const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhwanRqbmJiYmh1bmd5Z2xwbm11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NjE0NDUsImV4cCI6MjA4MTAzNzQ0NX0.RDgM7P1tTEH8cBpJt9F-IajOQtMYtJx8WRYqpS_4XTQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KnowNas Mart App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B5F3F)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with splash screen
      debugShowCheckedModeBanner: false,
    );
  }
}