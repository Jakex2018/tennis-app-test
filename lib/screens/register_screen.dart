import 'package:com.tennis.arshh/modules/auth/register/widget/register_footer.dart';
import 'package:com.tennis.arshh/modules/auth/register/widget/register_header.dart';
import 'package:com.tennis.arshh/modules/auth/register/widget/form_register.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterHeader(),
              FormRegister(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const RegisterFooter(),
    ));
  }
}
