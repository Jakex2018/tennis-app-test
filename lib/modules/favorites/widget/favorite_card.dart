import 'package:com.tennis.arshh/utils/data_utils.dart';
import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.courtDetails,
    required this.reserve,
    required this.name,
  });
  final String name;
  final dynamic courtDetails;
  final Map<String, dynamic> reserve;

  @override
  Widget build(BuildContext context) {
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
                  DataUtils().formatDate(reserve['dateReserve']),
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
                    name,
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
    );
  }
}
