import 'package:final_project/features/contact/presentation/cubits/contact_cubit/contact_cubit.dart';
import 'package:final_project/features/contact/presentation/cubits/contact_cubit/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/contact/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  void showSuccessDialog(ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/animations/success.json", height: 120),
              const SizedBox(height: 10),
              Text(
                "Message Sent Successfully!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ContactCubit>().clearForm();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔵 Gradient Header
            Builder(
              builder: (context) => Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff4a78b8), Color(0xff2e4f9e)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.support_agent, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "We’re here to help you",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🧾 Form Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocListener<ContactCubit, ContactState>(
                    listener: (context, state) {},
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: 'Your Name',
                            controller: context
                                .read<ContactCubit>()
                                .nameController,
                            maxLines: 1,
                            icon: Icons.person,
                          ),

                          const SizedBox(height: 15),

                          CustomTextFormField(
                            label: 'Your Email',
                            controller: context
                                .read<ContactCubit>()
                                .emailController,
                            maxLines: 1,
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 15),

                          CustomTextFormField(
                            label: 'Describe Your Issue',
                            controller: context
                                .read<ContactCubit>()
                                .messageController,
                            maxLines: 5,
                            icon: Icons.message,
                          ),

                          const SizedBox(height: 25),

                          /// 🚀 Gradient Button
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ContactCubit>().addProblem();
                                  showSuccessDialog(theme);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff4a78b8),
                                      Color(0xff2e4f9e),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "Send Message",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
