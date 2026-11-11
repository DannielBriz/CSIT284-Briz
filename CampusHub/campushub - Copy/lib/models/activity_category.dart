import 'package:flutter/material.dart';

class ActivityCategory {
  const ActivityCategory({
    required this.id,
    required this.title,
    required this.color}
  );

  final String id;
  final String title;
  final Color color;
}