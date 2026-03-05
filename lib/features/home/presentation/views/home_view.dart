import 'package:final_project/core/functions/show_toast.dart';
import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/core/widgets/no_intenet_view.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_cubit.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_state.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/home/presentation/widgets/custom_home_body.dart';
import 'package:final_project/features/home/presentation/widgets/drawer.dart';
import 'package:final_project/features/home/presentation/widgets/sub_logo_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return OfflineBuilder(
      connectivityBuilder:
          (
            BuildContext context,
            List<ConnectivityResult> connectivity,
            Widget child,
          ) {
            final bool connected = !connectivity.contains(
              ConnectivityResult.none,
            );

            return connected ? child : const Center(child: NoInternetView());
          },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
          clipBehavior: Clip.none,
          title: Text(
            AppStrings.brainMriDiagnosis,
            style: AppTextStyles.inter700style20.copyWith(
              color: isDark
                  ? theme.colorScheme.onSurface.withOpacity(0.7)
                  : null,
            ),
          ),
          centerTitle: true,
          actions: const [SubLogoHome()],
        ),
        body: BlocConsumer<DiagnosisCubit, DiagnosisState>(
          listener: (context, state) {
            if (state is DiagnosisFailure) {
              showToast(
                context,
                message: state.message,
                backgroundColor: theme.colorScheme.error,
                shadowColor: theme.colorScheme.error.withOpacity(0.4),
                icon: Icons.error,
              );
            } else if (state is DiagnosisSuccess) {
              context.read<HistoryCubit>().addToHistory(state.diagnosisModel);

              Navigator.pushNamed(
                context,
                '/diagnosisView',
                arguments: {'diagnosis': state.diagnosisModel},
              );

              showToast(
                context,
                message: "Completed Successfully 😊",
                backgroundColor: theme.colorScheme.primary,
                shadowColor: theme.colorScheme.primary.withOpacity(0.4),
              );
            }
          },
          builder: (context, state) {
            if (state is DiagnosisLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            return const CustomHomeBody();
          },
        ),
      ),
    );
  }
}
