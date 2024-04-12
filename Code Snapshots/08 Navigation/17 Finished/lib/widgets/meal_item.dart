import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:meals/widgets/meal_item_trait.dart';
import 'package:meals/models/meal.dart';

class MealItem extends StatelessWidget {
	
  final Meal meal;
  // a Function here,which gets the meal on which I tapped as an input,
  final void Function(Meal meal) onSelectMeal;

  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(8),
      //set the shape to a RoundedRectangleBorded
      // which, in the end, allows me to give this Card rounded corners
      // or change the border radius with the border radius of my choice.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
      //ensures that any content that would go out of the shape is simply cut off.
      //this simply clips this widget,removing any content of child widgets
      // that would go outside of the shape boundaries of this Card widget.
      clipBehavior: Clip.hardEdge,
      //
      elevation: 2,
      //we wanna be able to select meals from that list of meals here
      // and then be taken to the meals detail screen.
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
        },
        //rendering a widget directly above each other
        child: Stack(
          children: [
            //we then add all the widgets that should be Positioned on top of each other,
            // starting with the one that's on the bottom of the Stack.So that's in the background, so to say.
            FadeInImage(// simply a utility widget that displays an image that's being faded in
              //will use another package, Flutter transparent image, which simply gives us a dummy image
              // which we can use as a placeholder
              placeholder: MemoryImage(kTransparentImage),//load images from memory.
              image: NetworkImage(meal.imageUrl),//I wanna load the images from these URLs , an image fetched from the internet.
              fit: BoxFit.cover,
              height: 200,//to make sure that the entire width is used,
              width: double.infinity,
            ),
            //for positioning a widget on top of another widget inside of a Stack,
            // Flutter gives us a another very useful widget.
            Positioned(
              //to define how this child widget should be positioned on top of the other widget.
              //with these coordinates, I'm making sure that this container will be added
              // on top of the bottom of this image.

              //it'll span from the very left to the very right
              //so that it starts at the beginning of the left border of this image
              // and it ends at the right border.
              bottom: 0,
              left: 0,
              right: 0,//it'll span from the very left to the very right
              child: Container(
                color: Colors.black54,//which is a transparent black color. So it's not fully opaque. instead, it has some transparency added to it.
                padding:  const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text( meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,// ensure that the text is centered.
                      softWrap: true,//to make sure that the text is wrapped in a good looking way if it should need wrapping.
                      overflow: TextOverflow.ellipsis, // controls how the text will be cut off  if it needs to be cut off, because it's too long,
                      //, I'll define a brand new style. I'll not use my theme here.
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration} min',
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.work,
                          label: complexityText,
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
