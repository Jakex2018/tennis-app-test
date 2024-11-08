import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/screens/reservation/widgets/reservation_list.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReserveBody extends StatefulWidget {
  const ReserveBody({super.key});

  @override
  State<ReserveBody> createState() => _ReserveBodyState();
}

class _ReserveBodyState extends State<ReserveBody> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('ID del usuario: $userId');
    return SingleChildScrollView(
      child: Consumer<ReserveProvider>(builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonOne(
                fontSize: 20,
                title: 'Programar reserva',
                color: Theme.of(context).colorScheme.primary,
                width: .9),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              width: MediaQuery.of(context).size.width * .9,
              child: ReservationList(
                  userId: userId!,
                  itemBuilder: (context, reserve, userName) {
                    final courtId = reserve['courtId'];
      
                    // Obtener detalles de la cancha para cada reserva
                    final courtDetails = getCourtDetailsById(
                      courtId,
                      Provider.of<CourtsProvider>(context, listen: false).menu,
                    );
                    return reserveListCard(courtDetails, reserve, userName);
                  }),
            )
          ],
        );
      }),
    );
  }

  Widget reserveListCard(courtDetails, reserve, userName) {
    return Dismissible(
      key: Key(reserve['reserveId']),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        bool confirmDelete = await showDeleteDialog(context);
        return confirmDelete;
      },
      onDismissed: (direction) {
        // Si se confirma, eliminar la reserva de Firestore
        _deleteReservation(reserve['reserveId']);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Reserva eliminada con éxito",
          style: TextStyle(backgroundColor: Colors.green, color: Colors.white),
        )));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .26,
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
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
                            color: Theme.of(context).colorScheme.secondary,
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
                      '$userName',
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
                            fontWeight: FontWeight.w700, color: Colors.grey),
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
      ),
    );
  }

  Future<bool> showDeleteDialog(BuildContext context) async {
    // Aseguramos que el resultado del showDialog sea un bool
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
                Navigator.of(context).pop(false); // Cancelar la eliminación
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar la eliminación
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si result es null (por alguna razón el diálogo no devuelve nada), se retorna 'false'
    return result ?? false;
  }

  Future<void> _deleteReservation(String reserveId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reserveId) // Identificador único de la reserva
          .delete();
      print('Reserva eliminada correctamente');
    } catch (e) {
      print('Error al eliminar la reserva: $e');
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
}

String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate(); // Convierte el Timestamp a DateTime
  final formatter = DateFormat('dd/MM/yyyy'); // El formato que deseas
  return formatter.format(date); // Devuelve la fecha formateada
}




/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReserveBody extends StatefulWidget {
  const ReserveBody({super.key});

  @override
  State<ReserveBody> createState() => _ReserveBodyState();
}

class _ReserveBodyState extends State<ReserveBody> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('ID del usuario: $userId');
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        // El StreamBuilder escucha los cambios en la colección 'reservations'
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: userId) // Filtra por el userId
            .snapshots(),
        builder: (context, snapshot) {
          // Manejo del estado de la conexión
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOne(
                  fontSize: 20,
                  title: 'Programar reserva',
                  color: Theme.of(context).colorScheme.primary,
                  width: .9),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .9,
                width: MediaQuery.of(context).size.width * .9,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemCount: reserves.length,
                  itemBuilder: (context, index) {
                    final reserve = reserves[index];
                    final courtId = reserve['courtId'];

                    // Obtener detalles de la cancha para cada reserva
                    final courtDetails = getCourtDetailsById(
                      courtId,
                      Provider.of<CourtsProvider>(context, listen: false).menu,
                    );

                    return FutureBuilder<String>(
                      future: getUserNameFromFirestore(reserve['userId']),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (userSnapshot.hasError) {
                          return const Center(
                              child: Text(
                                  'Error al cargar el nombre del usuario'));
                        }

                        final userName =
                            userSnapshot.data ?? 'Usuario desconocido';
                        return reserveListCard(courtDetails, reserve, userName);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget reserveListCard(courtDetails, reserve, userName) {
    return Dismissible(
      key: Key(reserve['reserveId']),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        bool confirmDelete = await showDeleteDialog(context);
        return confirmDelete;
      },
      onDismissed: (direction) {
        // Si se confirma, eliminar la reserva de Firestore
        _deleteReservation(reserve['reserveId']);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Reserva eliminada con éxito",
          style: TextStyle(backgroundColor: Colors.green, color: Colors.white),
        )));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .26,
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
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
                            color: Theme.of(context).colorScheme.secondary,
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
                      '$userName',
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
                            fontWeight: FontWeight.w700, color: Colors.grey),
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
      ),
    );
  }

  Future<bool> showDeleteDialog(BuildContext context) async {
    // Aseguramos que el resultado del showDialog sea un bool
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
                Navigator.of(context).pop(false); // Cancelar la eliminación
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar la eliminación
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si result es null (por alguna razón el diálogo no devuelve nada), se retorna 'false'
    return result ?? false;
  }

  Future<void> _deleteReservation(String reserveId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reserveId) // Identificador único de la reserva
          .delete();
      print('Reserva eliminada correctamente');
    } catch (e) {
      print('Error al eliminar la reserva: $e');
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
}

String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate(); // Convierte el Timestamp a DateTime
  final formatter = DateFormat('dd/MM/yyyy'); // El formato que deseas
  return formatter.format(date); // Devuelve la fecha formateada
}


 */