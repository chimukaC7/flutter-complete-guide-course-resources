import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends StatefulWidget {
    
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {

  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    //we need to find out whether this meal here is already part
    // of this list, in which case it should be removed,
    // or if it's not part, in which case, it should be added.
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });

      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });

      _showInfoMessage('Marked as a favorite!');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    //if we open the drawer from this tabs screen and we then selected meals in that drawer
    // we effectively just want to close the drawer because we already are on that meals screen
    // or in that meals area of the app already.
    Navigator.of(context).pop();

    if (identifier == 'filters') {

      //this will only be set once the user did navigate back.
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    final availableMeals = dummyMeals.where((meal) {
        //exclue what is not
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;//I don't want to include it, so then I'll return false.
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;// return true for the meals that I actually wanna keep
    }).toList();


    //we can use active page which contains one of these two screens as a value for body.
    Widget? activePage = null;
    var activePageTitle =  null;

    if(_selectedPageIndex == 0){
       activePage = CategoriesScreen( onToggleFavorite: _toggleMealFavoriteStatus, availableMeals: availableMeals,);

       activePageTitle = 'Categories';
    }


    if (_selectedPageIndex == 1) {
      activePage = MealsScreen( meals: _favoriteMeals,  onToggleFavorite: _toggleMealFavoriteStatus,  );

      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),//the text that is displayed as a title should depend on which tab is selected.
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      //this also will need to be set dynamically because that will be the active screen
      // which will depend on which tab is selected.
      body: activePage,

      //it's time to add a never very important navigation pattern to this app.
      // A pattern which you will likely need in many of the apps you're going to build in the future.
      // And that pattern would be tab based navigation, having a tab bar at the bottom
      // which can be used to switch between different screens.

      //tabs navigation requires its own screen which then loads other screens as embedded screens, you could say.
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,//ill be triggered automatically whenever the user selects a tab.
        currentIndex: _selectedPageIndex,//tell the bottom navigation bar which tab is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
