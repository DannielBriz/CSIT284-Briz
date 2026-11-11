
import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/activity_category.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({
    super.key,
    required this.category,
  });

  final ActivityCategory category;

  @override
  Widget build(BuildContext context) {
    final filteredActivities = dummyActivities
        .where((activity) {
          return activity.categories.contains(category.id);
        })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),

      body: filteredActivities.isEmpty
          ? const Center(
              child: Text(
                'No activities available in this category.',
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredActivities.length,
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];

                return ActivityCard(
                  activity: activity,
                  onSelectActivity: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ActivityDetailScreen(
                          activity: activity,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
