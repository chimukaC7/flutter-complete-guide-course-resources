import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

//this map, of course, should have filter keys and then Boolean values
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {

  //initial state
  //we must set an initial state
  // by adding the constructor function and then the initializer list, where we call super
  // and where we then pass our initial state to the parent class.

  //Now, for the favorites provider, the initial state was an empty list.
  // For the filtersProvider, it should be a map of filters where every filter is set to false initially.
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  //with that state defined,
  // we can then add a method that allows us to manipulate that state in an immutable way as you learned.
  //where I expect to get the filter that should be set as an input.

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  //where I expect to get the filter that should be set as an input.
  // So a value of type filter to identify which filter should be set to a different value.
  // And then I get a Boolean value isActive could be a fitting name, which defines whether this filter is now set to true or false.
  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // not allowed! => mutating state

    //Therefore, what you should do instead is you should set the state to a new map.
    // And that should, in the end, be your old map with the updated key.
    state = {
      ...state,//one way of creating such a new map here is to copy the existing map and its existing key-value pairs with the spread operator just as we did it for the list. So this copies the existing maps key-value pairs into this new map.
      filter: isActive,
      // we can explicitly set one key, like here this filter to a new value, isActive.
      // So that will then override the key-value pair with the same filter identifier that has been copied
      // and all the other key value pairs will be kept along with this new setting here.
    };
  }
}

final filtersProvider =  StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
