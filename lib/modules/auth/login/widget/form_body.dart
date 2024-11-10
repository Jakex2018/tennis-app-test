// ignore_for_file: use_build_context_synchronously
import 'package:com.tennis.arshh/screens/register_screen.dart';
import 'package:com.tennis.arshh/modules/auth/services/auth.services.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FormBody extends StatefulWidget {
  const FormBody({
    super.key,
  });
  @override
  State<FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<FormBody> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPassword = true;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = LoginServices();

    void login() async {
      await authService.loginUser(
          emailController.text, passwordController.text, context);
    }

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Iniciar Sesion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              Container(
                width: 90,
                height: 3,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                  const SizedBox(
                    height: 21,
                  ),
                  TextField(
                      controller: passwordController,
                      obscureText: isPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                            icon: Icon(
                              isPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 17,
                            )),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const Text('Recordar mi contraseña')
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  ButtonOne(
                    width: .5,
                    title: 'Iniciar Sesion',
                    onTap: login,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RichText(
                      text: TextSpan(
                          text: '¿No tienes cuenta?  ',
                          style: const TextStyle(color: Colors.grey),
                          children: <TextSpan>[
                        TextSpan(
                            text: 'Regístrate',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen())),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ))
                      ]))
                ],
              ))
            ],
          )),
    );
  }
}
