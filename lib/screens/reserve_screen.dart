import 'package:com.tennis.arshh/modules/auth/providers/user_provider.dart';
import 'package:com.tennis.arshh/modules/reserve/widget/reserve_button.dart';
import 'package:com.tennis.arshh/modules/reserve/widget/reserve_list.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReserveScreen extends StatefulWidget {
  const ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ReserveProvider>(builder: (context, provider, child) {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final username =
            Provider.of<UserProvider>(context).getUserName(userId!);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ReserveButton(),
            const SizedBox(
              height: 30,
            ),
            ReserveList(userId: userId, provider: provider, name: username!),
          ],
        );
      }),
    );
  }
}