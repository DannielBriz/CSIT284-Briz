
import 'package:flutter/material.dart';

import '../models/activity.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Activity> _favorites = [];

  // Get all favorite activities
  List<Activity> get favorites {
    return [..._favorites];
  }

  // Check if an activity is already a favorite
  bool isFavorite(Activity activity) {
    return _favorites.contains(activity);
  }

  // Add or remove an activity from favorites
  void toggleFavorite(Activity activity) {
    final isExisting = _favorites.contains(activity);

    if (isExisting) {
      _favorites.remove(activity);
    } else {
      _favorites.add(activity);
    }

    notifyListeners();
  }

  // Add favorite activity
  void addFavorite(Activity activity) {
    if (!_favorites.contains(activity)) {
      _favorites.add(activity);
      notifyListeners();
    }
  }

  // Remove favorite activity
  void removeFavorite(Activity activity) {
    _favorites.remove(activity);
    notifyListeners();
  }
}
