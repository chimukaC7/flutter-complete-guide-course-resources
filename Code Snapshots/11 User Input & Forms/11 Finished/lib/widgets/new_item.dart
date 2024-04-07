import 'package:flutter/material.dart';

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

      //passing data back to the other screen
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(//useful to display multiple user input elements
          key: _formKey,
          child: Column(
            children: [
              TextField(),//This is a widget we can use for displaying an input field where users can type and enter some values.
              //when using the form widget, you should instead use the TextFormField widget.
              // So instead of text field, which we used before, it should now be TextFormField
              // because this is a widget that integrates with Form widget and this set of features provided by Form.
              //TextFormField is basically an extended version of the regular text field that provides extra features
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                //some special parameters available. For example, the validator parameter
                // the validator parameter, allows you to add a function
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _enteredName = value!;
                },
              ), // instead of TextField()
              //a row which allows me to display two other widgets next to each other horizontally.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // text field,also is unconstrained horizontally, as is the row,
                  // and that's why we're getting an error here.
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      //will also set an initial value here, which is another special parameter I can add
                      // on this text form field, which is not available on the regular text field
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            //as you learned, it's always a string, but I wanna treat it
                            // as a number and handle it as a number
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        //categories, if you take a look at it, is actually a map, not a list.
                        // it's quite easy to convert it to a list though,
                        // by using the special entries property that is available on all Dart maps.
                        //entries gives you an Iterable, which in the end contains all your map key value pairs
                        //very entry item will have a key value that in the end gives us the key we had
                        // for that item in the map and the value, which as you might guess,
                        // is the value for that key in the map
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            // the child here, in my case, here, will be a row for every dropdown menu item because I wanna have two items next to each other
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
