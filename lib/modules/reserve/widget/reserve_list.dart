import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_list.dart';
import 'package:com.tennis.arshh/modules/reserve/widget/reverse_card.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReserveList extends StatefulWidget {
  final String userId;
  final String name;
  final ReserveProvider provider;
  const ReserveList(
      {super.key,
      required this.userId,
      required this.provider,
      required this.name});

  @override
  State<ReserveList> createState() => _ReserveListState();
}

class _ReserveListState extends State<ReserveList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .9,
      width: MediaQuery.of(context).size.width * .9,
      child: ReservationList(
          userId: widget.userId,
          itemBuilder: (context, reserve, userName) {
            final courtId = reserve['courtId'];

            final courtDetails = widget.provider.getCourtNameById(
              courtId,
              Provider.of<CourtsProvider>(context, listen: false).menu,
            );
            return ReverseCard(
                courtDetails: courtDetails,
                username: widget.name,
                reserve: reserve);
          }),
    );
  }
}
