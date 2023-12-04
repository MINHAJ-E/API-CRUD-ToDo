import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller=TextEditingController();
  TextEditingController descriptioncontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true, 
      title: const Text("Add Todo"), 
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children:  [
           TextField(
            controller: titlecontroller,
            decoration: InputDecoration(hintText: 'Title'),
          ),
           TextField(
            controller: descriptioncontroller,
            decoration:  InputDecoration(
              hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
          ),
          const SizedBox(height: 20,),

          ElevatedButton(onPressed: submitData, child: const Text("Submit"))
        ],
      ),
    );
  }

  Future<void> submitData()async{

    final title=titlecontroller.text;
    final description=descriptioncontroller.text;

    final body={
      
  "title": title,
  "description":description ,
  "is_completed": false
     
    };

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,body: jsonEncode(body),
    headers: {'Content-Type': 'application/json'},
    );

      if(response.statusCode==201){
      titlecontroller.text="";
      descriptioncontroller.text="";
          showSuccessMessage("creation Success");
      }else{
        // print("Creation Failed");
      showErrorMessage("Creation Failed");
      }

  }

  void showSuccessMessage(String meassage){
    final snackBar = SnackBar(content: Text(meassage),backgroundColor: Colors.white,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String meassage){
    final snackBar = SnackBar(content: Text(meassage),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}