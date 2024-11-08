import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationList extends StatelessWidget {
  final String userId; // El ID del usuario para filtrar las reservas
  final Widget Function(BuildContext, Map<String, dynamic>, String) itemBuilder;

  const ReservationList({
    super.key,
    required this.userId,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las reservas'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay reservas'));
        }

        final reserves = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: reserves.length,
          itemBuilder: (context, index) {
            final reserve = reserves[index];
            

            return FutureBuilder<String>(
              future: getUserNameFromFirestore(reserve['userId']),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar el nombre del usuario'));
                }

                final userName = userSnapshot.data ?? 'Usuario desconocido';
                return itemBuilder(context, reserve, userName,);
              },
            );
          },
        );
      },
    );
  }

  Map<String, dynamic> getCourtDetailsById(
      String courtId, List<Courts> courts) {
    try {
      final court = courts.firstWhere((court) => court.id == courtId);
      return {
        'name': court.name,
        'image': court.image,
        'typeCourt': court.typeCourt,
        'temp': court.temp,
        'price': court.price,
        'minimumDuration': court.minimumDuration,
      };
    } catch (e) {
      return {
        'name': 'Cancha desconocida',
        'image': '',
        'typeCourt': '',
        'temp': 0,
        'price': 0,
        'minimumDuration': 0,
        'direction': '',
        'availableDates': []
      };
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
      print('Error al obtener el nombre del usuario: $e');
      return 'Usuario desconocido';
    }
  }
}
