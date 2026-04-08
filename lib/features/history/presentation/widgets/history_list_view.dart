import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_diagnosis/history_diagnosis_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_diagnosis/history_diagnosis_state.dart';
import 'package:final_project/features/history/presentation/widgets/diagnosis_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class HistoryListView extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final Function(Map<String, dynamic>) onTap;

  const HistoryListView({
    super.key,
    required this.history,
    required this.onTap,
  });

  Future<File?> _downloadImageAsFile(String url) async {
    try {
      final tmpDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final filePath = '${tmpDir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) return file;

      await Dio().download(url, filePath);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = history[index];

        return Dismissible(
          key: UniqueKey(),
          onDismissed: (_) {
            context.read<HistoryCubit>().removeFromHistory(item['date']);
          },
          direction: DismissDirection.startToEnd,
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.error,
            ),
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,

            child: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onError,
              size: 28,
            ),
          ),
          child: DiagnosisHistoryCard(
            model: item,
            ontap: () async {
              //! ❌ امنع الضغط لو already loading
              if (context.read<HistoryDiagnosisCubit>().state
                  is DiangonosisHistoryLoading) {
                return;
              }

              onTap(item);

              if (item['image'] == null) return;

              final imageFile = await _downloadImageAsFile(
                item['image'] as String,
              );

              if (imageFile != null && context.mounted) {
                await context.read<HistoryDiagnosisCubit>().getPrediction(
                  imageFile,
                  item['name'],
                  item['age'],
                  item['gender'],
                );
              }
            },
          ),
        );
      },
    );
  }
}
