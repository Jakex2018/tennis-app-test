import 'package:com.tennis.arshh/modules/reserve/widget/reverse_card.dart';
import 'package:com.tennis.arshh/utils/data_utils.dart';
import 'package:flutter/material.dart';

class ReserveDetails extends StatelessWidget {
  const ReserveDetails({
    super.key,
    required this.widget,
    required this.rainProbability,
  });
  final int rainProbability;
  final ReverseCard widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                '${widget.courtDetails['name']}',
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
                Text('$rainProbability%'),
              ],
            ),
          ],
        ),
        Text(
          '${widget.courtDetails['typeCourt']}',
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          DataUtils().formatDate(widget.reserve['dateReserve']),
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
            widget.username,
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
              '${widget.courtDetails['minimumDuration']} horas',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '\$${widget.courtDetails['price']}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }
}
