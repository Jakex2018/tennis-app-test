// ignore_for_file: use_build_context_synchronously
import 'package:com.tennis.arshh/modules/auth/providers/user_provider.dart';
import 'package:com.tennis.arshh/modules/favorites/services/favorite_services.dart';
import 'package:com.tennis.arshh/modules/favorites/widget/favorite_card.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final name = Provider.of<UserProvider>(context, listen: false)
        .getUserName(userId!);

    return Consumer<ReserveProvider>(
        builder: (context, reserveProvider, child) {
      final favoriteReserve = reserveProvider.getFavorites(userId);
      if (favoriteReserve.isEmpty) {
        return const Center(
          child: Text('No tienes reservas en favorito'),
        );
      }
      return FutureBuilder(
        future:
            FavoriteServices().getFavoriteReserves(favoriteReserve, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No tienes reservas en favoritos.'));
          }
          final favorite = snapshot.data!;
          return _buildFavoriteList(favoriteReserve, favorite, name);
        },
      );
    });
  }

  Widget _buildFavoriteList(List<String> favoriteReserve,
      List<Map<String, dynamic>> favorite, String? name) {
    return SingleChildScrollView(
      child: Column(children: [
        const Text(
          'Reservas favoritas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: favoriteReserve.length,
              itemBuilder: (context, index) {
                final reserve = favorite[index];
                final courtDetails = reserve['courtName'];
                return FavoriteCard(
                    courtDetails: courtDetails, reserve: reserve, name: name!);
              }),
        ),
      ]),
    );
  }
}




