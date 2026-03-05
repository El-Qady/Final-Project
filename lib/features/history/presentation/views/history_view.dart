import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/history/presentation/widgets/custom_loading_skeletonizer.dart';
import 'package:final_project/features/history/presentation/widgets/diagnosis_history_card.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_state.dart';
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().getHistory();
    });
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
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return state is HistorySuccess
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                          context.read<HistoryCubit>().removeFromHistory(
                            state.history[index]['date'],
                          );
                        },
                        child: DiagnosisHistoryCard(
                          ontap: () {
                            Navigator.pushNamed(
                              context,
                              '/diagnosisView',
                              arguments: {
                                'diagnosis': DiagnosisModel.fromMap(
                                  state.history[index],
                                ),
                              },
                            );
                          },
                          model: state.history[index],
                        ),
                      ),
                    );
                  },
                )
              : CustomLoadingSkeletonizer();
        },
      ),
    );
  }
}
