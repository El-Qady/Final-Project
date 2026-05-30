import 'package:final_project/core/functions/show_toast.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:final_project/features/Auth/presentation/cubit/auth_state.dart';
import 'package:final_project/features/Auth/presentation/widgets/custom_button.dart';
import 'package:final_project/features/Auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({super.key});
  @override
  Widget build(BuildContext context) {
    AuthCubit cubit = context.read<AuthCubit>();
    double h = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
          FocusScope.of(context).unfocus();
        }
        if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigate to the main app screen
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is LoginFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          showToast(
            context,
            message: state.errorMessage,
            backgroundColor: Colors.red.shade500,
            shadowColor: Colors.red.shade200,
            icon: Icons.error,
          );
        }
        if (state is LoginEmailNotVerified) {
          Navigator.of(context, rootNavigator: true).pop();
          showToast(
            context,
            message: "Email not verified. Please verify your email.",
            backgroundColor: Colors.orange.shade500,
            shadowColor: Colors.orange.shade200,
            icon: Icons.warning_rounded,
          );
        }
      },
      builder: (context, state) {
        AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
        if (state is AuthAutoValidate) {
          autoValidateMode = state.autovalidateMode;
        }
        return Form(
          key: cubit.formKeyLogin,
          autovalidateMode: autoValidateMode,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                CustomTextField(
                  hintText: AppStrings.enterYourEmail,
                  icon: Icons.email,
                  onChanged: (email) => cubit.email = email,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                SizedBox(height: 8),
                CustomTextField(
                  hintText: AppStrings.enterYourPassword,
                  icon: Icons.lock,
                  obscureText: true,
                  onChanged: (password) => cubit.password = password,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h * 0.1),

                CustomButton(
                  label: AppStrings.loginButton,
                  onPressed: () {
                    if (cubit.formKeyLogin.currentState!.validate()) {
                      cubit.login();
                    } else {
                      cubit.enableAutoValidate();
                    }
                  },
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
