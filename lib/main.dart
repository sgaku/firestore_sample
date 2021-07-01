import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference training =
        FirebaseFirestore.instance.collection('training');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'fireStore sample',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: training.orderBy('menu').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading'),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((training) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.black38,
                  ))),
                  child: ListTile(
                    title: Text(training['menu']),
                    onLongPress: () {
                      training.reference.delete();
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(
                    'メニューを追加',
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        controller: textController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                training.add({'menu': textController.text});
                                Navigator.pop(context);
                              },
                              child: Text('はい')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('いいえ')),
                        ),
                      ],
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
