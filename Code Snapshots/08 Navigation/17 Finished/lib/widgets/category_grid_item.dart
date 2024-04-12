import 'package:flutter/material.dart';

import 'package:meals/models/category.dart';

class CategoryGridItem extends StatelessWidget {

  //should also accept some external data that will be required
  // to output the actual category information.
  final Category category;
  final void Function() onSelectCategory;

  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    //making any widget tappable with InkWell
    //you get a visual feedback as compared to Gesture Detator
    //But in addition, you get a nice visual feedback, If a user taps the item.
    // With GestureDetector you would get no feedback.
    return InkWell(
      //So the goal is to go to a different screen if one of these items is tapped.
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,//for this visual tapping effect that we get.
      borderRadius: BorderRadius.circular(16),
      // I'm using container because the container widget gives me a lot
      // of options for setting the background color or background decoration in general for this widget.
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            //a linear gradient that uses the category color to transition
            // from one variation of that color, which is simply to colo
            // with some opacity to a different variation.
            gradient: LinearGradient(//to transist from one colour to another
              colors: [
                category.color.withOpacity(0.55),
                category.color.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
