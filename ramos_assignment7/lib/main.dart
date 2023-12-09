import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expense {
  String itemName;
  String description;
  double amount;

  Expense({required this.itemName, required this.description, required this.amount});
}

class ExpensesListApp extends StatefulWidget {
  @override
  _ExpensesListAppState createState() => _ExpensesListAppState();
}

class _ExpensesListAppState extends State<ExpensesListApp> {
  List<Expense> expenses = [];
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(),
      ).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Expenses List App'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(labelText: 'Item Name'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Amount'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addItem();
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return _buildExpenseItem(expenses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    return Dismissible(
      key: Key(expense.itemName),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Are you sure you want to delete this item?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _removeItem(expense);
      },
      child: ListTile(
        title: Text(expense.itemName),
        subtitle: Text(expense.description),
        trailing: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: '\$').format(expense.amount),
          ),
        ),
      ),
    );
  }

  void _addItem() {
    if (itemNameController.text.isEmpty || descriptionController.text.isEmpty || amountController.text.isEmpty) {
      // Show a snackbar or alert for validation error
      return;
    }

    double amount = double.tryParse(amountController.text) ?? 0.0;

    if (amount <= 0) {
      // Show a snackbar or alert for invalid amount
      return;
    }

    setState(() {
      expenses.insert(
        0,
        Expense(
          itemName: itemNameController.text,
          description: descriptionController.text,
          amount: amount,
        ),
      );
      itemNameController.clear();
      descriptionController.clear();
      amountController.clear();
    });
  }

  void _removeItem(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
  }
}

void main() {
  runApp(ExpensesListApp());
}
