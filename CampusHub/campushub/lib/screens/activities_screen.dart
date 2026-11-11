
import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/activity_category.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({
    super.key,
    required this.category,
  });

  final ActivityCategory category;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredActivities = dummyActivities.where((activity) {
      final matchesCategory =
          activity.categories.contains(widget.category.id);

      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          activity.title.toLowerCase().contains(query) ||
          activity.description.toLowerCase().contains(query) ||
          activity.venue.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          // Determine the layout based on available width.
          final isMobile = screenWidth < 600;
          final isTablet = screenWidth >= 600 && screenWidth < 1000;

          final crossAxisCount = isMobile
              ? 1
              : isTablet
                  ? 2
                  : 3;

          return Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search activities...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: filteredActivities.isEmpty
                    ? const Center(
                        child: Text('No activities found.'),
                      )
                    : isMobile
                        ? ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: filteredActivities.length,
                            itemBuilder: (context, index) {
                              final activity =
                                  filteredActivities[index];

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
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredActivities.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final activity =
                                  filteredActivities[index];

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
              ),
            ],
          );
        },
      ),
    );
  }
}
