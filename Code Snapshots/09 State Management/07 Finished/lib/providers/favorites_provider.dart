import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {

  // when using StateNotifier, you're not allowed to edit an existing value in memory,
  // instead you must always create a new one.

  // we're not allowed to reach out to this list and call add or remove as we did before.
  // This would not be allowed.
  // Instead we have to replace it.

    //initial state
  //we must set an initial state
  // by adding the constructor function and then the initializer list, where we call super
  // and where we then pass our initial state to the parent class.
  FavoriteMealsNotifier() : super([]);

  //add any methods we want to this class that allow us to edit this data.
  //instead of returning nothing, we can return a Boolean here where we maybe return false
  // if the item was removed and true if it was added.
  bool toggleMealFavoriteStatus(Meal meal) {

    //Now to replace it, there is this globally available state property.
    // This property is made available by the StateNotifier class.
    // Now this state property holds your data,
    //so in this case a list of meals.
    //And, again, calling add or remove on that would not be allowed.

    // Instead, you have to reassign it
    // by using the assignment operator to a new list.

    //a new list, no matter if you are adding a meal or removing a meal.
    final mealIsFavorite = state.contains(meal);//that will not edit the state it will just look into the state, and that of course is allowed.

    if (mealIsFavorite) {
      //with where we filter a list and we get a new list or a new iterable, which we can convert to a list by calling toList
      //where gives us a new list, and that's of course exactly what we need here
      state = state.where((item) => item.id != meal.id).toList();//we have to return true to keep it or false to drop it,
      return false;//we maybe return false  if the item was removed
      } else {
      //for adding a meal I can use a different syntax and set my state equal to a new list,
      // where I simply wanna keep all the existing items but then also add a new one.

      //we can use the spread operator,
      // You can use it on a list, so in this case on state, which is a list of meals,
      //to pull out all the elements that are stored in that list and add them as individual elements to this new list,
      // and then separated by a comma we can add yet another new element,
      //So that we pull out and keep all the existing meals and add them to a new list,

      //with that, we're updating this state in a immutable way.So without mutating, without editing the existing state in memory.
      state = [...state, meal];
      return true;// true if it was added.
    }
  }
}

//The first one is FavoriteMealsNotifier,
// but the second one then is the data that will be yielded by the FavoriteMealsNotifier in the end.
// And here that will be a list of meals.
final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();//so that we have this class for editing the state and for retrieving the state.
  //now we can use it in our widgets.
  // We can use it to get our list of favorites, but then also to trigger this method and change our favorites.
});
