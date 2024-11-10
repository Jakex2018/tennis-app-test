import 'package:com.tennis.arshh/common/button_icon.dart';
import 'package:com.tennis.arshh/common/hero_tag.dart';
import 'package:com.tennis.arshh/common/hero_widget.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:flutter/material.dart';


class ReservationImage extends StatelessWidget {
  const ReservationImage({
    super.key,
    required this.court,
  });

  final Courts court;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.expand(
            child: HeroWidget(
              tag: HeroTag.image(court.image),
              child: Image.asset(
                court.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 20,
              left: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .89,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ButtonIcon(),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
