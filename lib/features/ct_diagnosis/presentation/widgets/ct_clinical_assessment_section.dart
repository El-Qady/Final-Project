import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_question_toggle.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_section_card.dart';
import 'package:flutter/material.dart';

class CtClinicalAssessmentSection extends StatelessWidget {
  const CtClinicalAssessmentSection({
    super.key,
    required this.answers,
    required this.onAnswerChanged,
  });

  final Map<String, bool> answers;
  final void Function(String question, bool answer) onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return CtSectionCard(
      title: 'Clinical Assessment',
      topAccent: true,
      children: answers.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CtQuestionToggle(
            question: entry.key,
            value: entry.value,
            onChanged: (value) => onAnswerChanged(entry.key, value),
          ),
        );
      }).toList(),
    );
  }
}
