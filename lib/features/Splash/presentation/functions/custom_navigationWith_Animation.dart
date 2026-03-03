import 'package:final_project/features/Auth/presentation/views/signin_view.dart';
import 'package:final_project/features/home/presentation/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void goToSignIn(context) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            if(FirebaseAuth.instance.currentUser != null&& FirebaseAuth.instance.currentUser!.emailVerified){
          return const HomeView();
        }else{
          return const SignInView();
        }
          },
              
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300), 
        ),
  );
}
