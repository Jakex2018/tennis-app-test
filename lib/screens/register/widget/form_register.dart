import 'package:com.tennis.arshh/services/auth.services.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final authService = LoginServices();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void register() async {
      await authService.registerUser(
          nameController.text,
          emailController.text,
          passwordController.text,
          confirmController.text,
          phoneController.text,
          context);
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Registro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Container(
              width: 90,
              height: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.supervised_user_circle_outlined),
                      labelText: 'Nombre y Apellido',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: phoneController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Telefono',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible =
                                  !isPasswordVisible; // Alternar visibilidad
                            });
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 17,
                          )),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: confirmController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible; // Alternar visibilidad
                            });
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 17,
                          )),
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Confirmar Contraseña',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                ButtonOne(
                  width: .5,
                  title: 'Registrarme',
                  onTap: register,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ))
          ],
        ));
  }
}
