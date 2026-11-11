
import 'package:flutter/material.dart';
import '../models/activity_category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final ActivityCategory category;
  final void Function() onSelectCategory;

  IconData get categoryIcon {
    switch (category.id) {
      case 'c1':
        return Icons.computer;
      case 'c2':
        return Icons.science;
      case 'c3':
        return Icons.emoji_events;
      case 'c4':
        return Icons.work;
      case 'c5':
        return Icons.groups;
      case 'c6':
        return Icons.handshake;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category.color.withValues(alpha: 0.8),
              category.color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
