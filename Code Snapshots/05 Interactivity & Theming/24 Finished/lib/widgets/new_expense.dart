import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _displayDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);//y m d

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
	//convert the test to a double
    final enteredAmount = double.tryParse(_amountController.text); 
    // tryParse('Hello') => null, tryParse('1.12') => 1.12

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;//true or false will be derived

    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please ensure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);//close the dialog
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );

      return;
    }

	//receicing a function defined in another class
	//for stateful use widget.
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

	//when the modal is closed
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,//receives entered value
            maxLength: 50,
						keyboardType: TextInputType.name,//default, which virtual keyboard should be opened
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : formatter.format(_selectedDate!),//force that the value will not be value
                    ),
                    IconButton(
                      onPressed: _displayDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
