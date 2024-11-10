import 'package:com.tennis.arshh/api/api_data.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/dropdown_body.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_content.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:flutter/material.dart';

class ReservationCourtInfo extends StatefulWidget {
  const ReservationCourtInfo({
    super.key,
    required this.widget,
    required this.context,
  });

  final ReservationContent widget;
  final BuildContext context;

  @override
  State<ReservationCourtInfo> createState() => _ReservationCourtInfoState();
}

class _ReservationCourtInfoState extends State<ReservationCourtInfo> {
  late Future<int> rainProbability;

  @override
  void initState() {
    super.initState();
    rainProbability = _fetchRainProbability();
  }

  Future<int> _fetchRainProbability() async {
    final wheaterApi = WheaterService();

    return await wheaterApi.rainProbability(
      widget.widget.court.latitude,
      widget.widget.court.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rainProbability,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al obtener el clima'));
        } else {
          final rainProbability = snapshot.data ?? 0;
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.27,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.widget.court.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.widget.court.typeCourt,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.widget.court.timePlay,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                            ),
                            Text(
                              widget.widget.court.direction,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownBody(
                          provider: InstructorProvider(),
                          height: 40,
                          width: .4,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${widget.widget.court.price.toString()}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const Text(
                          'Por Hora',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
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
                            Text('$rainProbability%'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
