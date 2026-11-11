import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';


class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>();
var _enteredName = '';
var _enteredQuantity = 1;
var _selectedCategory = categories[Categories.vegetables];


  void _saveItem(){
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
    }

    print(_enteredName);
    print(_enteredQuantity);
    print(_selectedCategory!.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formkey,
              child: Column(
            children: [
              TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(label: const Text('Name')),
                  onSaved: (value){
                     _enteredName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().length <= 1) {
                      return 'Name must not be empty';
                    }
                    return null;
                  }),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: const Text('Quantity')),
                    initialValue: '1',
                    onSaved: (value){
                      _enteredQuantity = int.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                        return 'Input must be a number';
                      }
                      return null;
                    },
                  )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: DropdownButtonFormField(items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.value,
                          child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: category.value.color,
                          ),
                          const SizedBox(width: 6,),
                          Text(category.value.title)
                        ],
                      ))
                  ], onChanged: (value){
                    setState(() {
                      _selectedCategory = value!;
                    });
                  }
                  ))
                ],
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Reset')),
                  ElevatedButton(onPressed: _saveItem, child: const Text('Add Item'))
                ],)
            ],
          ))),
    );
  }
}
