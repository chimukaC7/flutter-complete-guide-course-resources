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

  //a global key here then also gives us easy access to the underlying widget
  // to which it is connected.
  //this will simply give us some extra type checking
  // and auto completion suggestions.
  // So we want to add this annotation here.
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {

      //when calling the save method,
      // a special function will be triggered
      // on all these form field widgets inside the form,
      //The special function that will be triggered is the onSaved function.
      _formKey.currentState!.save();

      //passing data back to the other screen
      //This pops this screen off the stack of screen
      // and navigates the user back to the previous screen,
      // just as the back button on the device or in the app bar does.
      Navigator.of(context).pop(
        //But we can now pass some data to pop here.
        // The data that has been entered and validated.
        // And the data that I do want to pass along here is a grocery item.
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
          key: _formKey,//It'll be a key that we should create as a property .
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

                  //Alternatively, you could also add an extra check,
                  // and for example, return if value should be null.
                  //In that case, this code would not execute.
                  // But this is redundant and not needed here because we already have our validation logic
                  // where we check if value is null.
                  // if (value == null) {
                  //   return;
                  // }

                  //we must add an exclamation mark
                  // to make it clear that value will not be null.
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
                        //This is required because selectedCategory is used
                        // to set the currently visible value,
                        // and of course that should stay in sync
                        // with what we selected in the dropdown
                        // and should update whenever we change our selection.
                        // So that the currently selected value is reflected on the screen.
                        // That's why setState is needed here.
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
                      //We could also create a standalone method here
                      // or do it in this anonymous function here,
                      _formKey.currentState!.reset();
                      //these input fields are set back
                      // to their initial values.
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
