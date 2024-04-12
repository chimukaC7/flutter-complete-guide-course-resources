import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
         //a header at the top of the drawer
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            //a decoration to it to style it basically,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            //a row as a child because I wanna have multiple items
            // next to each other inside of that DrawerHeader.
            child: Row(
              children: [
                Icon(Icons.fastfood,
                  size: 48,//actually change the size of this icon to make it quite big  by assigning 48 pixels as a size
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text('Cooking Up!',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          //then below that, a couple of clickable or tapable items that take us to different screens.
          //we could outsource this into a separate reusable widget,
          // but here I'll just go with copy and pasting.
          ListTile(
            leading: Icon(Icons.restaurant,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text( 'Meals',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('meals');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              // to go to a filters screen on which we can set various filters,
              // which will then impact which meals we see when we select a category.
              onSelectScreen('filters');
            },
          ),
        ],
      ),
    );
  }
}
