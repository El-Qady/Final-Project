import 'package:final_project/features/home/presentation/widgets/patient_diagnosis_form.dart';
import 'package:flutter/material.dart';

class CustomHomeBody extends StatelessWidget {
  const CustomHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: const [PatientDiagnosisForm()]);
  }
}
