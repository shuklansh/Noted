// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_taker/detailed.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // to initialize widgets before app runs
  await Hive.initFlutter();
  //var box = Hive.box("NoteBox");
  await Hive.openBox("NoteBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //canvasColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController content = TextEditingController();
  final TextEditingController heading = TextEditingController();
  List<Map<String, dynamic>> listOfItemsAsMapInList = [];
  final NoteBox = Hive.box("NoteBox"); //reference to box

  @override
  void initState() {
    refreshitems();
    super.initState();
  }

  Future submitContent(Map<String, dynamic> contentAsMap) async {
    await NoteBox.add(contentAsMap);
    // the items are stored in the box as list of maps. each
    // map has 2 k-v pairs, keys are strings, values are dynamic, keys are
    // names 'heading' and 'content' (defined in the submit btn type)
    //print("Your content ${NoteBox.length}"); // to print the number of content entered
    //print("Your content ${NoteBox.values.elementAt(NoteBox.length-1)['content'].toString()}"); // to print the latest content
    refreshitems();
    //print("list of items : $listOfItemsAsMapInList"); //to see the list of maps which are storing content and heading
  }

  Future updateContent(
      keyofExistingItem, Map<String, dynamic> existingContentAsMap) async {
    await NoteBox.put(keyofExistingItem, existingContentAsMap);
    refreshitems();
  }

  Future DeleteContent(keyofExistingItem) async {
    await NoteBox.delete(keyofExistingItem);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Deleted item",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurple,
    ));
    refreshitems();
  }

  void refreshitems() {
    final data = NoteBox.keys.map((key) {
      final item = NoteBox.get(key);
      return {
        "key": key,
        "heading": item['heading'],
        "content": item['content']
      };
    }).toList();

    setState(() {
      listOfItemsAsMapInList = data.reversed.toList();
    });
  }

  void showBottomModal(BuildContext ctx, int? itemkeyInBox) async {
    if (itemkeyInBox != null) {
      final existingitem = listOfItemsAsMapInList
          .firstWhere((element) => element['key'] == itemkeyInBox);
      heading.text = existingitem['heading'];
      content.text = existingitem['content'];
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40))),
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: false,
        elevation: 8,
        context: ctx,
        builder: (_) => Container(


              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(ctx).viewInsets.bottom,
              //     top: 0,
              //     left: 0,
              //     right: 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration : BoxDecoration(
                            color: Color.fromRGBO(
                                248, 248, 248, 1.0),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: heading,
                            decoration: InputDecoration(
                                hintText: "Heading",

                                border: InputBorder.none,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(
                                248, 248, 248, 1.0),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: content,
                              decoration: InputDecoration(
                                  hintText: "content",
                                  border: InputBorder.none,
                                  )),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                          onPressed: () async {
                            itemkeyInBox == null
                                ? submitContent({
                                    'heading': heading.text,
                                    'content': content.text
                                  })
                                : updateContent(itemkeyInBox, {
                                    'heading': heading.text,
                                    'content': content.text
                                  });
                            heading.text = '';
                            content.text = '';
                            Navigator.of(context)
                                .pop(); // close bottommodalsheet
                          },
                          child: Text("submit"))
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Noted.",
            style: TextStyle(
                color: Colors.purpleAccent,
                letterSpacing: 2,
                fontSize: 40,
                fontWeight: FontWeight.w200)),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: ListView.builder(
          itemCount: listOfItemsAsMapInList.length,
          itemBuilder: (context, index) {
            final itemAsMapInList = listOfItemsAsMapInList[index];
            return InkWell(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailedScreen(itemAsMapInList['heading'],itemAsMapInList['content']))),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: Colors.purple,
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        itemAsMapInList['heading'],
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(itemAsMapInList['content'].toString(),
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.amber,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () =>
                                showBottomModal(context, itemAsMapInList['key']),
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () =>
                                DeleteContent(itemAsMapInList['key']),
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomModal(context, null),
        child: Icon(Icons.edit, color: Colors.black),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
