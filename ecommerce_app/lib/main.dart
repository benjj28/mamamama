import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app/screens/auth_wrapper.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';


const Color kRichBlack = Color(0xFF1D1F24);
const Color kBrown = Color(0xFF8B5E3C);
const Color kLightBrown = Color(0xFFD2B48C);
const Color kOffWhite = Color(0xFFF8F4F0);

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eCommerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrown,
          brightness: Brightness.light,
          primary: kBrown,
          onPrimary: Colors.white,
          secondary: kLightBrown,
          background: kOffWhite,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: kOffWhite,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrown,
          brightness: Brightness.dark,
          primary: kBrown,
          onPrimary: Colors.white,
          secondary: kLightBrown,
          background: Colors.black,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      themeMode: themeProvider.themeMode, // <- controlled by provider
      home: const AuthWrapper(),
    );
  }
}
