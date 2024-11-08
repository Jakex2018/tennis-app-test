import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/screens/reserve/reserve_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesBody extends StatefulWidget {
  const FavoritesBody({super.key});

  @override
  State<FavoritesBody> createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final name = Provider.of<ReserveProvider>(context, listen: false)
        .getUserName(userId!);
    print('NOMBRE USUARIO $name');
    print(userId);

    return Consumer<ReserveProvider>(
        builder: (context, reserveProvider, child) {
      final favoriteReserve = reserveProvider.getFavorites(userId);
      if (favoriteReserve.isEmpty) {
        return const Center(
          child: Text('No tienes reservas en favorito'),
        );
      }
      return FutureBuilder(
        future: getFavoriteReserves(favoriteReserve, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No tienes reservas en favoritos.'));
          }
          final favorite = snapshot.data!;
          return Column(children: [
            const Text(
              'Reservas favoritas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: favoriteReserve.length,
                  itemBuilder: (context, index) {
                    final reserve = favorite[index];
                    final courtDetails = reserve['courtName'];
                    return Container(
                      height: MediaQuery.of(context).size.height * .26,
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  courtDetails['image'],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        '${courtDetails['name']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 90,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.cloud_queue_rounded,
                                          size: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text('30%'),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '${courtDetails['typeCourt']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  formatDate(reserve['dateReserve']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Row(children: [
                                  const Text(
                                    'Reservado por: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset(
                                        'public/asset/images/avatar.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    name!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${courtDetails['minimumDuration']} horas',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '\$${courtDetails['price']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]);
        },
      );
    });
  }

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
      print('Error al obtener las reservas favoritas: $e');
      return [];
    }
  }
}


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesBody extends StatefulWidget {
  const FavoritesBody({super.key});

  @override
  State<FavoritesBody> createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print(userId);

    return Consumer<ReserveProvider>(
        builder: (context, reserveProvider, child) {
      final favoriteReserve = reserveProvider.getFavorites(userId!);
      if (favoriteReserve.isEmpty) {
        return const Center(
          child: Text('No tienes reservas en favorito'),
        );
      }
      return FutureBuilder(
        future: getFavoriteReserves(favoriteReserve, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No tienes reservas en favoritos.'));
          }
          final favorite = snapshot.data!;
          return ListView.separated(
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: favoriteReserve.length,
              itemBuilder: (context, index) {
                final reserve = favorite[index];
                final courtDetails = reserve['courtName'];
                return ListTile(
                  title: Text(courtDetails['name']),
                );
              });
        },
      );
    });
  }

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
          final courtName =
              Provider.of<CourtsProvider>(context, listen: false)
                  .getCourtDetailsById(reserve['courtId']);

          reserves.add({
            ...reserve,
            'courtName': courtName,
          });
        }
      }

      return reserves;
    } catch (e) {
      print('Error al obtener las reservas favoritas: $e');
      return [];
    }
  }
}

 */