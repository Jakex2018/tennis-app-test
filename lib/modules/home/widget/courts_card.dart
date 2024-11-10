import 'package:com.tennis.arshh/api/api_data.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/screens/reservation_screen.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';

class CourtsCard extends StatelessWidget {
  const CourtsCard({
    super.key,
    required this.courts,
    required this.index,
    required this.context,
  });

  final CourtsProvider courts;
  final int index;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final wheaterApi = WheaterService();
    return FutureBuilder(
        future: wheaterApi.rainProbability(
          courts.menu[index].latitude, // Latitud de la cancha
          courts.menu[index].longitude, // Longitud de la cancha
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al obtener el clima'));
          } else {
            final rainProbability = snapshot.data ?? 0;
            return Container(
              width: 270,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
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
                                  rainProbability > 50
                                      ? Icons.cloudy_snowing
                                      : Icons.sunny,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('$rainProbability%'),
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
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
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
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Colors.grey)),
                              ],
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            const Icon(Icons.timer, size: 12),
                            Text(courts.menu[index].timePlay,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12)),
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
                                          onPressed: () =>
                                              Navigator.pop(context),
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
        });
  }
}
