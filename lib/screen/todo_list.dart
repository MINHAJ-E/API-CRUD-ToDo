import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api/screen/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Center(child: Text("Todo List")),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'];

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title'] ?? ''),
                subtitle: Text(item['description'] ?? ''),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "Edit") {
                      navigateToEditPage(item);
                    } else if (value == "Delete" && id != null) {
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "Edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "Delete",
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add Todo"),
      ),
    );
  }

  Future<void> navigateToAddPage()async {
    final route = MaterialPageRoute(builder: (context) =>  AddTodoPage());
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }
  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context) =>  AddTodoPage(todo: item));
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);
      print(response.statusCode);
print(response.statusCode);
print(response.body);
      if (response.statusCode == 200) {
        final filtered = items.where((element) => element['_id'] != id).toList();
        print(response.statusCode);
print(response.body);
        setState(() {
          items = filtered;
        });
      } else {
        showErrorMessage("Deletion Failed");
        print(response.statusCode);
print(response.body);
      }
    } catch (e) {
       print("Error fetching todos: $e");
  // showErrorMessage("Error fetching todos");
      print("Error deleting todo: $e");
      showErrorMessage("Error deleting todo");
    }
  }

  Future<void> fetchTodo() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['items'] as List;

        setState(() {
          items = result;
        });
      } else {
        showErrorMessage("Failed to fetch todos");
      }
    } catch (e) {
      // print("Error fetching todos: $e");
      showErrorMessage("Error fetching todos");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
