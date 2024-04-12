import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/category.dart';

class CategoriesScreen extends StatelessWidget {
    
  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.availableMeals,
  });

  //We are adding a method to a stateless widget.
  //But here, we don't want to update state.
  // Instead, I want to load a different screen.
  void _selectCategory(BuildContext context, Category category) {
    //where is a method available on every list on flutter
    final filteredMeals = availableMeals
        .where((item) => item.categories.contains(category.id))//filter the list , only contains the items that match a certain condition.
        .toList();// convert this iterable return by where to a real list

    //since I'm in a stateless widget here, context is not globally available.
    //You might recall that in the state objects that belonged to stateful widgets,
    // a context property was globally available
    //Therefore, here, we indeed must accept a context value which must be of type BuildContext
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen( title: category.title, meals: filteredMeals, onToggleFavorite: onToggleFavorite,),
      ),
    );
    //alternative approach
    // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        //alternative approach
        // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              //to make sure that if we tap a category
              // we're navigated to that category MealsScreen,
              // which then only shows the meals for that category.
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
