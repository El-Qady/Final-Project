import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_cubit.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_gender_dropdown.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_labeled_text_field.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CtPatientDetailsSection extends StatelessWidget {
  const CtPatientDetailsSection({super.key, required this.gender});

  final String gender;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CtDiagnosisCubit>();

    return CtSectionCard(
      title: 'Patient Details',
      children: [
        CtLabeledTextField(
          label: 'Full Name',
          controller: cubit.nameController,
          hintText: 'John Doe',
          validator: cubit.validateName,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CtLabeledTextField(
                label: 'Age',
                controller: cubit.ageController,
                hintText: '45',
                keyboardType: TextInputType.number,
                validator: cubit.validateAge,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CtGenderDropdown(
                value: gender,
                onChanged: cubit.changeGender,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
