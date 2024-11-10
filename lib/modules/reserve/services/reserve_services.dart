import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReserveServices {
  Future<bool> showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta reserva?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> deleteReservation(String reserveId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reserveId)
          .delete();
    } catch (e) {
      return;
    }
  }

  Future<String> getUserNameFromFirestore(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'Usuario desconocido';
      } else {
        return 'Usuario desconocido';
      }
    } catch (e) {
      return 'Usuario desconocido';
    }
  }
}
