import 'package:final_project/features/Auth/presentation/cubit/auth_cubit.dart';

void resetForm(AuthCubit cubit) {
    cubit.formKeySignUp.currentState!.reset();
    cubit.email = null;
    cubit.password = null;
    cubit.confirmPassword = null;
    cubit.name = null;
  }