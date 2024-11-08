import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/screens/reservation/reservation_screen.dart';
import 'package:com.tennis.arshh/screens/reservation/widgets/reservation_list.dart';
import 'package:com.tennis.arshh/screens/reserve/reserve_body.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 0, left: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.1), width: 2)),
                ),
                child: Text(
                  userProvider.isLogged
                      ? 'Hola ${userProvider.userName}!'
                      : 'User',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Canchas',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    courtsSlider(),
                    courtsBooking(context)
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget courtsBooking(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final reserveProvider =
        Provider.of<ReserveProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reservas Programadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Consumer<CourtsProvider>(builder: (context, courts, child) {
              return ReservationList(
                userId: userId,
                itemBuilder: (context, reserve, userName) {
                  final courtId = reserve['courtId'];
                  print(courtId);

                  // Obtener detalles de la cancha
                  final courtDetails =
                      Provider.of<CourtsProvider>(context, listen: false)
                          .getCourtDetailsById(courtId);
                  final isFavorite =
                      reserveProvider.isFavorite(userId, reserve['reserveId']);

                  return Container(
                    color: const Color(0xFFF4F7FC),
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 50,
                              child: Image.asset(
                                courtDetails['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courtDetails['name'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                formatDate(reserve['dateReserve']),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Reservado por $userName',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${courtDetails['minimumDuration']} horas',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('\$ ${courtDetails['price']}'),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (isFavorite) {
                                reserveProvider.removeFromFavorites(
                                    userId, reserve['reserveId']);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Reserva eliminada de favoritos",
                                  style: TextStyle(color: Colors.white),
                                )));
                              } else {
                                reserveProvider.addToFavorites(
                                    userId, reserve['reserveId']);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Reserva agregada a favoritos",
                                  style: TextStyle(color: Colors.white),
                                )));
                              }
                            },
                            icon: Icon(
                              color:
                                  isFavorite ? Colors.red : Colors.grey,size: 30,
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Container courtsSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      constraints: const BoxConstraints(maxHeight: 410, maxWidth: 400),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 2)),
      ),
      child: Consumer<CourtsProvider>(builder: (context, courts, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 15,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: courts.menu.length,
          itemBuilder: (context, index) {
            return courtsCard(courts, index, context);
          },
        );
      }),
    );
  }

  Container courtsCard(CourtsProvider courts, int index, BuildContext context) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            courts.menu[index].image,
            fit: BoxFit.contain,
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      courts.menu[index].name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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
                        Text('${courts.menu[index].temp.toString()}%'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  courts.menu[index].typeCourt,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  courts.menu[index].date,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          courts.menu[index].isAvailable
                              ? 'Disponible'
                              : 'No disponible',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: courts.menu[index].isAvailable
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey)),
                      ],
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    const Icon(Icons.timer, size: 12),
                    Text(courts.menu[index].timePlay,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ButtonOne(
                    onTap: () {
                      if (courts.menu[index].isAvailable) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationScreen(
                                      court: courts.menu[index],
                                    )));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Cancha no disponible'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    width: .4,
                    title: 'Reservar',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



/*
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/screens/reservation/reservation_screen.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 0, left: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.1), width: 2)),
                ),
                child: Text(
                  userProvider.isLogged
                      ? 'Hola ${userProvider.userName}!'
                      : 'User',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Canchas',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    courtsSlider(),
                    courtsBooking(context)
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget courtsBooking(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reservas Programadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Consumer<CourtsProvider>(builder: (context, courts, child) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                scrollDirection: Axis.vertical,
                itemCount: courts.menu.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: const Color(0xFFF4F7FC),
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                  height: 50,
                                  child: Image.asset(
                                    courts.menu[index].image,
                                    fit: BoxFit.contain,
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courts.menu[index].name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                courts.menu[index].date,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Text(
                                  style: TextStyle(fontSize: 12),
                                  'Reservado por Jose Perez'),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${courts.menu[index].minimumDuration.toString()} hora',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                      '\$ ${courts.menu[index].price.toString()}'),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Container courtsSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      constraints: const BoxConstraints(maxHeight: 410, maxWidth: 400),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 2)),
      ),
      child: Consumer<CourtsProvider>(builder: (context, courts, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 15,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: courts.menu.length,
          itemBuilder: (context, index) {
            return courtsCard(courts, index, context);
          },
        );
      }),
    );
  }

  Container courtsCard(CourtsProvider courts, int index, BuildContext context) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            courts.menu[index].image,
            fit: BoxFit.contain,
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      courts.menu[index].name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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
                        Text('${courts.menu[index].temp.toString()}%'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  courts.menu[index].typeCourt,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  courts.menu[index].date,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          courts.menu[index].isAvailable
                              ? 'Disponible'
                              : 'No disponible',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: courts.menu[index].isAvailable
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey)),
                      ],
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    const Icon(Icons.timer, size: 12),
                    Text(courts.menu[index].timePlay,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ButtonOne(
                    onTap: () {
                      if (courts.menu[index].isAvailable) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationScreen(
                                      court: courts.menu[index],
                                    )));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Cancha no disponible'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    width: .4,
                    title: 'Reservar',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

 */