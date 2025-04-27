import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/components/my_buttons.dart';
import 'package:kd_chat/components/my_text_field.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  int _selectedAvatarIndex = 0;
  bool _isAvatarSelected = false;
  final List<String> _avatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
  ];
void register() async {
  final auth = AuthService();

  if (_passwordController.text != _confirmPasswordController.text) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Passwords don't match!"),
      ),
    );
    return;
  }

  try {
    await auth.signupWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
      _contactController.text.trim(),
      _avatars[_selectedAvatarIndex],
      _bioController.text.trim(),
    );

    // Show success Toastification
    if (mounted) {
      toastification.show(
        context: context,
        title: const Text(
            'Verification link sent to your email. Please verify!'),
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
      );
    }

    // Wait for toast to show before navigating
    await Future.delayed(const Duration(seconds: 3));

    // Then navigate to Login manually
    if (mounted) {
      widget.onTap?.call();
    }
  } catch (e) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset('assets/main.png', height: 80),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Let's create an account for You",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Avatar Selector
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(_avatars[_selectedAvatarIndex]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Choose an Avatar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _avatars.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAvatarIndex = index;
                                  _isAvatarSelected = true;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: _selectedAvatarIndex == index
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          // ignore: deprecated_member_use
                                          .withOpacity(0.5)
                                      // ignore: deprecated_member_use
                                      : Colors.grey.withOpacity(0.3),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        AssetImage(_avatars[index]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form fields
                        MyTextField(
                          hintText: "Name",
                          obsecureText: false,
                          controller: _nameController,
                        ),
                        MyTextField(
                          hintText: "Email",
                          obsecureText: false,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        MyTextField(
                          hintText: "Contact Number",
                          obsecureText: false,
                          controller: _contactController,
                          keyboardType: TextInputType.phone,
                        ),
                        MyTextField(
                          hintText: "Password",
                          obsecureText: true,
                          controller: _passwordController,
                          isPasswordField: true,
                        ),
                        MyTextField(
                          hintText: "Confirm Password",
                          obsecureText: true,
                          controller: _confirmPasswordController,
                          isPasswordField: true,
                        ),
                        MyTextField(
                          hintText: "Bio",
                          obsecureText: false,
                          controller: _bioController,
                          keyboardType: TextInputType.text,
                          // Allow multiple lines for bio
                        ),

                        const SizedBox(height: 25),
                        MyButtons(text: "Register", onTap: register),
                        const SizedBox(height: 25),

                        // Login redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                " Login Now!!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _contactController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   _bioController.dispose();
  //   super.dispose();
  // }
}
