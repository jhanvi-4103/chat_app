import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/components/my_buttons.dart';
import 'package:kd_chat/components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimpasswordController =
      TextEditingController();

  RegisterPage({super.key, required this.onTap});
  final void Function()? onTap;

  // password match -> create new user
  void register(BuildContext context) {
    final auth = AuthService();
    if (_passwordController.text == _confrimpasswordController.text) {
      try {
        auth.SignupWithEmailAndPassword(
            _emailController.text, _passwordController.text);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Account created successfully!"),
          ),
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
    // password doesn't match -> tell user to fix
    else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("password don't match!"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset('assets/chatapp.png', height: 100 ,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Lets create an account for You',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            MyTextField(
              hintText: "Email",
              obsecureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Password",
              obsecureText: true,
              controller: _passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: " Confrim Password",
              obsecureText: true,
              controller: _confrimpasswordController,
            ),
            const SizedBox(
              height: 25,
            ),
            MyButtons(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login  Now!!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
