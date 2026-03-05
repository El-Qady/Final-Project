import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  const CustomButtons({super.key,required this.onPress});
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(w * 0.9, h * 0.05),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download, size: 27),
            const SizedBox(width: 12),
            Text(
              AppStrings.downloadReport,
              style: AppTextStyles.inter800style40shadow.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
