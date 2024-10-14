import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Demo1 extends StatefulWidget{
  @override
  State<Demo1> createState()=> _Demo1State();
}
class _Demo1State extends State <Demo1>{
  List <Map<String,String>> _todoItems=[];
  TextEditingController title=TextEditingController();
  TextEditingController contentController=TextEditingController();

   @override
  void initState(){
    super.initState();
    _loadToDoItems();
  }
  _loadToDoItems() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? titles=prefs.getStringList('titleKey');
    List<String>? contents=prefs.getStringList('contentKey');
    if( titles !=null && contents !=null &&
    titles.length == contents.length){
      setState(() {
         _todoItems=List.generate(titles.length,(index){
          return{
            'titleKey':titles[index],
            'contentKey':contents[index],
          };
         });
      });
    }
  }

  _saveToDoItems()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List <String> titles=_todoItems.map((item)=>item['titleKey']!).toList();
    List<String> contents=_todoItems.map((item)=>item['contentsKey']!).toList();
  await   prefs.setStringList('titleKey', titles);
    await prefs.setStringList('contents', contents);
  }
  void _addToDoItem(String title,String content){
    if(title.isNotEmpty && content.isNotEmpty){

        setState(() {
          _todoItems.add({'titleKey':title,'contentKey':content});
        });
      _saveToDoItems();
    }
  }
  void _removeTodoItem(int index){
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveToDoItems();
  }
  
  @override
Widget build(BuildContext context){
 
  return Scaffold(
    appBar: AppBar(
      title: 
      Text('todo'),
    ),
    body: ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context ,index){
        return ListTile(
          title: Text(_todoItems[index]['titleKey']!),
          subtitle: Text(_todoItems[index]['contentKey']!),
          trailing: GestureDetector(
            onTap: () {
              _removeTodoItem(index);
            },
            child: Icon(Icons.delete),
          ),
        
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (BuildContext content){
          return Container(
            height: 350,
            child: Column(
              children: [
                Text('Title'),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextField(
                    controller: title,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                    labelText: 'Title'),
                  ),
                ),
                SizedBox(height: 20),
                 Text('Content'),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                    labelText: 'Content'),
                  ),
                ),
                SizedBox(height: 35),
                ElevatedButton(onPressed: (){
                  _addToDoItem(title.text, contentController.text);
                  Navigator.pop(context);
                }, child: Text('Add'))
              ],
            ),
          );
        });
      },
      
      child: Text('Add')),
  );
}
}