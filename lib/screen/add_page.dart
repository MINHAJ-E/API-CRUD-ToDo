import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
   AddTodoPage({super.key,this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller=TextEditingController();
  TextEditingController descriptioncontroller=TextEditingController();

  bool isEdit=false;

  @override
  void initState() {
    super.initState();

  final todo = widget.todo;

    if(todo != null){
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titlecontroller.text=title;
      descriptioncontroller.text=description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true, 
      title:  Text(isEdit ?"Edit Todo":"Add Todo"), 
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

          ElevatedButton(onPressed:isEdit? updateData:submitData, child:  Text(isEdit?"Update":"Submit"))
        ],
      ),
    );
  }
Future<void>updateData()async{
  // get the data from form

  final todo= widget.todo;
  if(todo==null){
    print('you can not call without todo datra');
    return;
  }
  final id=todo['_id'];
 final title=titlecontroller.text;
    final description=descriptioncontroller.text;

    final body={
      
  "title": title,
  "description":description ,
  "is_completed": false
     
    };

    //submitt the data
    // https:api.nstack.in/v1/todos/656d80b09e8c62d83515dffa
        final url = "https://api.nstack.in/v1/todos/$id";

    final uri = Uri.parse(url);
    final response = await http.put(uri,body: jsonEncode(body),
    headers: {'Content-Type': 'application/json'},
    );

    
      if(response.statusCode==200){
      titlecontroller.text="";
      descriptioncontroller.text="";
          showSuccessMessage("Updation Success");
      }else{
        // print("Creation Failed");
      showErrorMessage("Updation Failed");
      }

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