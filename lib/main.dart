import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:home_heal/screens/homepage.dart';
import 'package:home_heal/screens/auth_screen.dart';
import 'package:home_heal/screens/loading_screen.dart';
import 'package:home_heal/screens/error_screen.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(seedColor: Colors.green.shade600);
ColorScheme kDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.green.shade900, brightness: Brightness.dark);

late SupabaseClient supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pojurjhvelyqpcunvlpo.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvanVyamh2ZWx5cXBjdW52bHBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU5MTM0NTUsImV4cCI6MjA3MTQ4OTQ1NX0.gUfCJIths8RWmMmFAvoS2PUK_Sdu2HNiYmFjYePFAO8'
  );

  supabase = Supabase.instance.client;
  runApp(MaterialApp(
      theme: ThemeData.light().copyWith(
        colorScheme: kColorScheme,
        textTheme: GoogleFonts.loraTextTheme()
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        textTheme: GoogleFonts.loraTextTheme()
      ),
      home: StreamBuilder(stream: supabase.auth.onAuthStateChange, builder: (ctx, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return LoadingScreen();
        }
        else if (snapshot.hasData){
          final AuthChangeEvent event = snapshot.data!.event;

          if (event == AuthChangeEvent.signedIn || (supabase.auth.currentSession != null && supabase.auth.currentUser != null)){
            return HomePage();
          }
          else {
            return AuthPage();
          }
        }
        else {
          return ErrorScreen();
        }
      })
    ));
}