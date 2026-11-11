import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals2/data/dummy_data.dart';

final mealsProvider = Provider((ref) {
  // Return the list of meals from your data source
  return dummyMeals;
});