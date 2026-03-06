import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_cubit.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_state.dart';
import 'package:final_project/features/history/presentation/widgets/custom_loading_skeletonizer.dart';
import 'package:final_project/features/history/presentation/widgets/diagnosis_history_card.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_state.dart';
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  Map<String, dynamic>? item;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().getHistory();
    });
  }

  /// Downloads an image from [url] to a temporary file and returns the [File].
  /// Returns null if the download fails.
  Future<File?> _downloadImageAsFile(String url) async {
    try {
      final tmpDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final filePath = '${tmpDir.path}/$fileName';
      final file = File(filePath);

      // Reuse cached file if it already exists
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
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Diagnosis History',
          style: AppTextStyles.inter700style20.copyWith(
            color: isDark ? theme.colorScheme.onSurface.withOpacity(0.7) : null,
          ),
        ),
      ),
      body: BlocConsumer<DiagnosisCubit, DiagnosisState>(
        listener: (context, state) {
          if (state is DiangonosisHistorySuccess) {
            Navigator.pushNamed(
              context,
              '/diagnosisView',
              arguments: {'diagnosis': DiagnosisModel.fromMap(item!)},
            );
          }
        },
        builder: (context, state) {
          return state is DiangonosisHistoryLoading
              ? Center(child: CircularProgressIndicator())
              : BlocBuilder<HistoryCubit, HistoryState>(
                  builder: (context, state) {
                    return state is HistorySuccess
                        ? ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: state.history.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    alignment: Alignment.centerLeft,
                                    color: theme.colorScheme.error,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: theme.colorScheme.onError,
                                      size: 28,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    context
                                        .read<HistoryCubit>()
                                        .removeFromHistory(
                                          state.history[index]['date'],
                                        );
                                  },
                                  child: DiagnosisHistoryCard(
                                    ontap: () async {
                                      item = state.history[index];
                                      final imageFile =
                                          await _downloadImageAsFile(
                                            item!['image'] as String,
                                          );
                                      if (imageFile != null &&
                                          context.mounted) {
                                        await context
                                            .read<DiagnosisCubit>()
                                            .getPrediction(
                                              imageFile,
                                              item!['name'],
                                              item!['age'],
                                              item!['gender'],
                                              isFromHistory: true,
                                            );
                                      }
                                    },
                                    model: state.history[index],
                                  ),
                                ),
                              );
                            },
                          )
                        : CustomLoadingSkeletonizer();
                  },
                );
        },
      ),
    );
  }
}
