
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context);

    final favoriteActivities = favoritesProvider.favorites;

    Widget content;

    if (favoriteActivities.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No favorite activities yet.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Start exploring activities!',
            ),
          ],
        ),
      );
    } else {
      content = GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favoriteActivities.length,
        gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final activity = favoriteActivities[index];

          return ActivityCard(
            activity: activity,
            onSelectActivity: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ActivityDetailScreen(activity: activity),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: content,
    );
  }
}
