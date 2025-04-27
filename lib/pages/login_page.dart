import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_buttons.dart';
import 'package:kd_chat/components/my_text_field.dart';
import 'package:kd_chat/pages/home_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void login(BuildContext context) async {
  final authService = AuthService();
  try {
    await authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    // Show success Toastification
    toastification.show(
      // ignore: use_build_context_synchronously
      context: context,
      title: const Text("Logged in successfully ✅"),
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
    );

    // Wait for toast to show before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to HomePage
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } catch (e) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/main.png', height: height * 0.2),
                const SizedBox(height: 30),
                Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have been missed!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    // ignore: deprecated_member_use
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 30),

                // Email field
                MyTextField(
                  hintText: "Email",
                  obsecureText: false,
                  controller: _emailController,
                ),

                // Password field
                MyTextField(
                  hintText: "Password",
                  obsecureText: true,
                  controller: _passwordController,
                  isPasswordField: true,
                ),

                const SizedBox(height: 20),

                // Login Button
                MyButtons(
                  text: "Login",
                  onTap: () => login(context),
                ),

                const SizedBox(height: 20),

                // Register prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
