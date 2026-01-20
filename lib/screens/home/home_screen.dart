import 'package:ecommerce_app/screens/admin/admin_dashboard.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      setState(() {
        role = 'customer';
        isLoading = false;
      });
      return;
    }

    setState(() {
      role = doc['role'] ?? 'customer';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (role == 'admin') {
      return const AdminDashboard();
    } else {
      return const ShopScreen();
    }
  }
}