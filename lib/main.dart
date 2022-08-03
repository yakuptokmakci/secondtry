import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  runApp(const MyApp());
}

void savetodb(List<List<dynamic>> data) async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  box.put('id', data);
  box.put('Name', data);
  box.put('Age', data);
  var name = box.get('Name');
  print(name.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = [];

  // This function is triggered when the floating button is pressed
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString(
        "/Users/yakuptokmakci/Desktop/flutter_vscode/showtime/asset/kindacode.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });

    savetodb(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kindacode.com"),
      ),
      // Display the contents from the CSV file
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.all(3),
            color: index == 0 ? Colors.amber : Colors.white,
            child: ListTile(
              leading: Text(_data[index][0].toString()),
              title: Text(_data[index][1]),
              trailing: Text(_data[index][2].toString()),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: _loadCSV),
    );
  }
}
