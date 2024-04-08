import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  List<GroceryItem> _groceryItems = [];

  //tells Dart that we have no initial value for loadedItems, but we will have a value
  // before it's being used the first time.
  late Future<List<GroceryItem>> _loadedItems;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }


  //Instead of returning void here, we could say
  // that this function should return a list of grocery items
  //since we're using async here, this will automatically return a future
  //This async keyword basically ensures that the function that's decorated with it
  // will always produce a future, automatically.
  //Therefore, the correct type annotation for this function here, for this method,
  // is that we'll get back a future which will eventually resolve to a list of grocery items,
  //So now loadItems should be a method that returns a future,
  // which it will do automatically because of async, as you learned,
  // which will then in turn resolve to a list of grocery items.
  Future<List<GroceryItem>> _loadItems() async {

    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com', 'shopping-list.json');

    //I will get rid of this overall try-catch block because with FutureBuilder, as you will see,
    // we can handle errors in a different way, in a way that requires less code from our side,
    // which can be quite convenient.
    final response = await http.get(url);

    //if status is greater than 400, there is a problem
    if (response.statusCode >= 400) {
      //if we throw an exception or if any other code in there throws an exception.
      // In that case, as mentioned, the future will be rejected
      // and that would lead to this hasError property
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    //check if we got no data from the backend
    //this depends on the backend
    if (response.body == 'null') {
      return [];
    }

    //to access the data,we have to decode it
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];//temp list

    for (final item in listData.entries) {

      //looking a category object based on the name
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;

      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    // get rid of  setState action here
    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    //implemented remove from
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com','shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // Optional: Show error message
      //add it back if an error occurred
      setState(() {
        _groceryItems.insert(index, item);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //there's one special widget I want to show you. A widget you don't have to use, but a widget that can help
      // with loading data through HTTP requests or with working with futures in general.
      // And keep in mind that of course when sending an HTTP request like here with get,
      // we are getting such a future as a result.
      // And that widget would be the FutureBuilder widget, a widget which listens to a future
      // and automatically updates the UI as the future resolves.
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {

          // a snapshot, which in the end gives you access to the current state
          // of the future and the data that might have been produced.

          //use this snapshot to evaluate the current state of that future.

          //the initial state when we sent the request and we're still waiting for the response.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //not waiting ,now we have a result with data, error or no data

          //use this snapshot object again to check whether we might have an error
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),),
            );
          }

          //check if snapshot data, which is the data we will have in the end,
          // if that is not empty.
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No items added yet.'));
          }

          // if we also make it past this if check, we know that data is not empty,
          // that it is a list of grocery items,
          return ListView.builder(
            //this builder function in the end exposes the state and the data produced by that future
            // through this snapshot object.

            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![index].category.color,
                ),
                trailing: Text(
                  snapshot.data![index].quantity.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
