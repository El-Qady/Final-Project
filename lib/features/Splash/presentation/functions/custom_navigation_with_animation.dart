import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/Auth/presentation/views/signin_view.dart';
import 'package:final_project/features/Splash/presentation/views/update_required_view.dart';
import 'package:final_project/features/home/presentation/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:developer';

Future<void> goToSignIn(BuildContext context) async {
  Widget nextView = const SignInView();
  try {
    // 1. Fetch current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersionStr = packageInfo.version;

    // 2. Fetch minimum allowed version from Firebase
    DocumentSnapshot versionDoc = await FirebaseFirestore.instance
        .collection('version_control')
        .doc('config')
        .get();

    if (versionDoc.exists && versionDoc.data() != null) {
      Map<String, dynamic> data = versionDoc.data() as Map<String, dynamic>;
      String minVersionStr = data['min_version'] ?? '0.0.0';

      // 3. Compare versions
      if (_isVersionOutdated(currentVersionStr, minVersionStr)) {
        nextView = const UpdateRequiredView();
      } else {
        // App is up to date, check Auth
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          nextView = const HomeView();
        }
      }
    } else {
      // If no config found, fallback to standard auth check
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        nextView = const HomeView();
      }
    }
  } catch (e) {
    log('Failed to check app version: $e');
    // On error, fallback to standard auth check
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
      nextView = const HomeView();
    }
  }

  if (!context.mounted) return;

  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return nextView;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}

// Simple semantic version comparison: returns true if current < min
bool _isVersionOutdated(String current, String min) {
  List<int> currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  List<int> minParts = min.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  for (int i = 0; i < 3; i++) {
    int curPart = i < currentParts.length ? currentParts[i] : 0;
    int minPart = i < minParts.length ? minParts[i] : 0;
    if (curPart < minPart) return true;
    if (curPart > minPart) return false;
  }
  return false;
}
