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
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com', 'shopping-list.json');

    //you should consider adding error handling like this with try-catch
    // in addition to handling error responses.
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //we wanna convert this JSON data back/ to regular Dart objects to Dart maps
      // with which we can work,
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {

        //I now wanna get a full category object again.
        //And this is of course, not something you have to do every time you are loading data with the HTTP request.
        // Instead, that's specific to this app here,where I sent only my category title to Firebase
        // and I now wanna match it to some local in-memory data again.
        final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        //to override that list.
        // And this should be done inside of setState here actually,
        // to make sure that the build method executes again and the UI is updated.
        _groceryItems = loadedItems;
        _isLoading = false;
      });

    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
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
    setState(() {
      //deleting locally
      _groceryItems.remove(item);
    });

    //instead of pointing at the overall shopping list. We wanna point at a specific item in there
    // because we don't wanna delete the entire shopping list but just one item in the shopping list.
    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');

    //deleting on the server
    final response = await http.delete(url);

    //un doing the delete in the event that something went wrong
    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        //instead of add, we could use insert to add item at a specific index.
        //insert is a method built into Dart that can be used on any list
        // to add an item at a specific index in that list.
        _groceryItems.insert(index, item);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

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
      body: content,
    );
  }
}
