import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/cart_provider.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/payment_success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // ROUTES
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),

        // Stripe redirect after successful payment
        '/payment-success': (context) => const PaymentSuccessScreen(),

        // Temporary home route (change later)
        '/home': (context) => const LoginScreen(),
      },
    );
  }
}