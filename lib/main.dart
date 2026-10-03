import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:celestial_forge/models/perk_model.dart';
import 'package:celestial_forge/screens/home_page.dart';

/// Seed color used throughout the app for theming consistency
const Color seed = Color(0xFF240046);

void main(List<String> args) async {
  // Configure system UI overlays globally (status bar, nav bar colors/icons)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: seed, // Deep purple background
      statusBarIconBrightness: Brightness.light, // Light icons
      systemNavigationBarColor: Colors.black12,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Ensure binding before running async setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive in app's document directory
  // final appDir = await getApplicationDocumentsDirectory();
  // Hive.init(appDir.path);

  // 👇 This automatically handles initialization for web + mobile
  await Hive.initFlutter();

  // Register custom Hive adapter for the PerkModel
  Hive.registerAdapter(PerkModelAdapter());

  // Open Hive boxes for persistent state
  await Hive.openBox<PerkModel>('ownedPerks');
  await Hive.openBox<PerkModel>('remainingPerks');
  await Hive.openBox<int>('cpBox');

  // Wrap app with Riverpod's ProviderScope
  runApp(const ProviderScope(child: CelestialForgeApp()));
}

/// Root widget for Celestial Forge App
///
/// Applies a custom dark theme using Material 3,
/// sets font styling, and defines the home screen.
class CelestialForgeApp extends StatelessWidget {
  const CelestialForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Celestial Forge v3',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: seed,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: GoogleFonts.ralewayTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}
