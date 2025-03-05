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
              'Welcome back, You have Missed!',
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
              height: 25,
            ),
            MyButtons(
              text: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Register Now!!",style: TextStyle(
                      fontWeight: FontWeight.bold,
                       color: Theme.of(context).colorScheme.primary,
                    ),),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
