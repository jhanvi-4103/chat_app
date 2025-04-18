import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_buttons.dart';
import 'package:kd_chat/components/my_text_field.dart';
import 'package:kd_chat/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage({super.key,  required this.onTap});

  void login(BuildContext context )  async{
      final authService = AuthService();
      try{
      await authService.signInWithEmailAndPassword(_emailController.text,_passwordController.text);
    }
    catch (e){
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }
   final void  Function()? onTap;

  @override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/kdChat.png', height: height * 0.15),
                  SizedBox(height: height * 0.05),
                  Text(
                    'Welcome back, You have Missed!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: height * 0.02,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  MyTextField(
                    hintText: "Email",
                    obsecureText: false,
                    controller: _emailController, 
                  ),
                  SizedBox(height: height * 0.015),
                  MyTextField(
                    hintText: "Password",
                    obsecureText: true,
                    controller: _passwordController, 
                  ),
                  SizedBox(height: height * 0.03),
                  MyButtons(
                    text: "Login",
                    onTap: () => login(context),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          "Register Now!!",
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
          ),
        ),
      ),
    ),
  );
}
}
