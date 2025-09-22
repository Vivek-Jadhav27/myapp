import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:myapp/services/auth_provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use debug for dev, switch later
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastel & Friendly Theme Colors
    const Color primaryColor = Color(0xFF6EE7B7); // Soft Mint Green
    const Color secondaryColor = Color(0xFFFCA5A5); // Soft Coral Red
    const Color accentColor = Color(0xFF93C5FD); // Pastel Blue
    const Color backgroundColor = Color(0xFFFDFDFD); // Off-white
    const Color textColor = Color(0xFF374151); // Neutral Grey

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.nunito(
          fontSize: 57, fontWeight: FontWeight.bold, color: textColor),
      titleLarge: GoogleFonts.nunito(
          fontSize: 22, fontWeight: FontWeight.w700, color: textColor),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, color: textColor),
      labelLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle:
            GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF1F2937), // Dark grey
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF111827), // Dark app bar
        foregroundColor: Colors.white,
        titleTextStyle:
            GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        color: Color(0xFF374151), // Dark card color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    return StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Finance Tracker',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            home: const Wrapper(),
          );
        },
      ),
    );
  }
}
