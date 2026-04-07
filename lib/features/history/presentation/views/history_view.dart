import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_state.dart';
import 'package:final_project/features/history/presentation/cubits/history_diagnosis/history_diagnosis_cubit.dart';
import 'package:final_project/features/history/presentation/cubits/history_diagnosis/history_diagnosis_state.dart';
import 'package:final_project/features/history/presentation/widgets/custom_appbar.dart';
import 'package:final_project/features/history/presentation/widgets/custom_loading_skeletonizer.dart';
import 'package:final_project/features/history/presentation/widgets/history_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final TextEditingController _controller = TextEditingController();
  bool isSearchActive = false;
  DateTime? selectedDate;

  Map<String, dynamic>? selectedItem; // ✅ مهم

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryAppBar(
        isSearchActive: isSearchActive,
        controller: _controller,
        selectedDate: selectedDate,
        onSearchChanged: (val) {
          context.read<HistoryCubit>().updateSearch(val);
        },
        onToggleSearch: () {
          setState(() {
            isSearchActive = !isSearchActive;
            if (!isSearchActive) {
              _controller.clear();
              context.read<HistoryCubit>().updateSearch('');
            }
          });
        },
        onPickDate: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );

          if (picked != null) {
            setState(() => selectedDate = picked);
            context.read<HistoryCubit>().updateDate(picked);
          }
        },
        onClearDate: () {
          setState(() => selectedDate = null);
          context.read<HistoryCubit>().updateDate(null);
        },
      ),

      //! ✅ هنا المهم
      body: BlocConsumer<HistoryDiagnosisCubit, HistoryDiagnosisState>(
        listener: (context, state) {
          if (state is DiangonosisHistorySuccess) {
            Navigator.pushNamed(
              context,
              '/diagnosisView',
              arguments: {'diagnosis': DiagnosisModel.fromMap(selectedItem!)},
            );
          }
        },

        builder: (context, diagnosisState) {
          return Stack(
            children: [
              //! 👇 UI الأساسي
              BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return CustomLoadingSkeletonizer();
                  }

                  if (state is HistorySuccess) {
                    return HistoryListView(
                      history: state.history,
                      onTap: (item) {
                        selectedItem = item;
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),

              //! 🔥 loading overlay فوق الشاشة
              if (diagnosisState is DiangonosisHistoryLoading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
