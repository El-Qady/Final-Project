import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/contact/presentation/cubits/contact_cubit/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubit extends Cubit<ContactState> {
     final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  ContactCubit() : super(ContactInitial());
    void clearForm() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }
  void addProblem() async {
    await FirebaseFirestore.instance.collection('contacts').add({
      'name': nameController.text,
      'email': emailController.text,
      'description': messageController.text,
    });
  }
}
