import 'package:com.tennis.arshh/api/api_data.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/reserve/services/reserve_services.dart';
import 'package:com.tennis.arshh/modules/reserve/widget/reserve_court_image.dart';
import 'package:com.tennis.arshh/modules/reserve/widget/reserve_details.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReverseCard extends StatefulWidget {
  final String username;

  final Map<String, dynamic> reserve;
  final Map<String, dynamic> courtDetails;
  const ReverseCard({
    super.key,
    required this.courtDetails,
    required this.username,
    required this.reserve,
  });

  @override
  State<ReverseCard> createState() => _ReverseCardState();
}

class _ReverseCardState extends State<ReverseCard> {
  @override
  Widget build(BuildContext context) {
    final courtId = widget.reserve['courtId'];
    final courtDetails = Provider.of<CourtsProvider>(context, listen: false)
        .getCourtDetailsById(courtId);
    final wheaterApi = WheaterService();

    return FutureBuilder(
      future: wheaterApi.rainProbability(
        courtDetails['latitude'], // Latitud de la cancha
        courtDetails['longitude'], // Longitud de la cancha
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al obtener el clima'));
        } else {
          final rainProbability = snapshot.data ?? 0;
          return Dismissible(
            key: Key(widget.reserve['reserveId']),
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
              bool confirmDelete =
                  await ReserveServices().showDeleteDialog(context);
              return confirmDelete;
            },
            onDismissed: (direction) {
              ReserveServices().deleteReservation(widget.reserve['reserveId']);

              final startTime = widget.reserve['startTime'];
              final endTime = widget.reserve['endTime'];

              if (startTime != null) {
                context
                    .read<ReserveProvider>()
                    .releaseReservedHour(courtId, startTime);
              }
              if (endTime != null) {
                context
                    .read<ReserveProvider>()
                    .releaseReservedHour(courtId, endTime);
              }

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  "Reserva eliminada con éxito",
                  style: TextStyle(color: Colors.white),
                ),
              ));
            },
            child: _buildCardContent(context, rainProbability),
          );
        }
      },
    );
  }

  Container _buildCardContent(BuildContext context, int rainProbability) {
    return Container(
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
            ReverseCourtImage(widget: widget),
            const SizedBox(width: 10),
            ReserveDetails(widget: widget, rainProbability: rainProbability),
          ],
        ),
      ),
    );
  }
}
