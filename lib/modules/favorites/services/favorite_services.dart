// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteServices {
  Future<List<Map<String, dynamic>>> getFavoriteReserves(
      List<String> favoriteReserve, BuildContext context) async {
    try {
      final reserves = <Map<String, dynamic>>[];

      for (String reserveId in favoriteReserve) {
        final doc = await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reserveId)
            .get();

        if (doc.exists) {
          final reserve = doc.data()!;
          final courtName = Provider.of<CourtsProvider>(context, listen: false)
              .getCourtDetailsById(reserve['courtId']);

          reserves.add({
            ...reserve,
            'courtName': courtName,
          });
        }
      }

      return reserves;
    } catch (e) {
      return [];
    }
  }
}