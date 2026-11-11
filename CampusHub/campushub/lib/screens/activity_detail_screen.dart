
import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../widgets/favorite_button.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
        actions: [
          FavoriteButton(activity: activity),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: activity.id,
              child: Image.network(
                activity.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  _buildInfo(
                    Icons.location_on,
                    activity.venue,
                  ),
                  _buildInfo(
                    Icons.schedule,
                    '${activity.duration} minutes',
                  ),
                  _buildInfo(
                    Icons.bar_chart,
                    activity.skillLevel.name.toUpperCase(),
                  ),

                  const SizedBox(height: 20),

                  _buildSection(
                    context,
                    'Description',
                    activity.description,
                  ),
                  _buildSection(
                    context,
                    'Requirements',
                    activity.requirements.isEmpty
                        ? 'No specific requirements.'
                        : activity.requirements
                            .map((item) => '• $item')
                            .join('\n'),
                  ),
                  _buildSection(
                    context,
                    'Benefits',
                    activity.benefits.isEmpty
                        ? 'No benefits listed.'
                        : activity.benefits
                            .map((item) => '• $item')
                            .join('\n'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
