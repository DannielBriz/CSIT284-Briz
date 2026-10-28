import 'package:flutter_riverpod/legacy.dart';
import 'package:meals2/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal){
    final  mealisFavorite = state.contains(meal);
    if(mealisFavorite){
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else{
      state = [...state, meal];
      return true;
    }
  }
}

final FavoriteMealsProvider = StateNotifierProvider(ref)