import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../services/class_rep_service.dart';
import '../../models/class_rep.dart';

final loginProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginProvider);

    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.verified_user,
                  size: 90,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 20),

                Text(
                  "Class Rep Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Enter your unique class rep code",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // Input
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: -2,
                        offset: Offset(0, 4),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: "e.g. GIMPA-CIS-003",
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Login button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? Colors.grey.shade400
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: MaterialButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final code = codeController.text.trim();
                            if (code.isEmpty) {
                              _error(context, "Please enter your code");
                              return;
                            }

                            ref.read(loginProvider.notifier).state = true;

                            final service = ClassRepService();
                            ClassRep? rep = await service.getByCode(code);

                            await Future.delayed(const Duration(
                                seconds: 1)); // smooth loading feel

                            ref.read(loginProvider.notifier).state = false;

                            if (rep == null) {
                              _error(context, "Invalid Code");
                              return;
                            }

                            // Navigate to dashboard
                            Navigator.pushReplacementNamed(
                                context, "/dashboard",
                                arguments: rep);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Opacity(
                  opacity: 0.7,
                  child: Text(
                    "Powered by WA BOA ME TECHNOLOGIES",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }
}
