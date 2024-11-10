import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_list.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/utils/data_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CourtsBooking extends StatelessWidget {
  const CourtsBooking({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
                                DataUtils().formatDate(reserve['dateReserve']),
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
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 30,
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
}
