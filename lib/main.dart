import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:named_calcolator/modal/Items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart named Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController _name = TextEditingController();
  TextEditingController _value = TextEditingController();
  List<Item> items = [];
  int? update;
  void _incrementCounter() async{
    if(items.isEmpty)
      return;

    if(await myCustomAlert(context,"Clear all the list?"))
    setState(() {
      items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          children: [
            Expanded(
              flex: mainFlex(),
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                //
                // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                // action in the IDE, or press "p" in the console), to see the
                // wireframe for each widget.
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width/ 3,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Name"
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller:  _value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Price"
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              flex: MediaQuery.of(context).size.width >1000 ? 5 : 3,
                              child: SizedBox(
                                height: 70,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    )
                                  ),
                                    onPressed: update == null ? addToList : updateItem,
                                    icon: Icon(Icons.add),
                                  label: Text(update == null ? "Add to list" : "Update item"),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 70,

                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    primary: Colors.red,
                                    minimumSize: Size(70, 70)
                                  ),
                                    onPressed: update == null ? clearInputs : cancelUpdate,
                                    child: Icon(update == null ? Icons.delete : Icons.close,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(
                    left: BorderSide(color: Colors.grey[400]!,width: 1)
                  )
                ),
                height: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                        "Items list",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: List.generate(items.length, (index) => itemsTab(items[index])),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25,25,25,25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity),
                          Text("${items.length} Items"),
                          Text("Total: ${Total()} DH"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Clear all the list',
        child: const Icon(Icons.delete_forever),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget itemsTab(Item item){
    return Container(
      decoration: BoxDecoration(
        color: update != null && update == item.id ?  Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey[500]!,
          width: 1
        )
      ),
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: ListTile(
        onTap: (){
          if(update != null )
            return;

          setState(() {
            update = item.id;
            _name.text = item.name;
            _value.text = item.value.toString();
          });
        },
        title: Text(item.name),
        subtitle: Text(item.value.toString() + " DH"),
        trailing: IconButton(
            onPressed: () async {
              if(await myCustomAlert(context,"Delete ${item.name} ?"))
              setState(() {
                items.remove(item);
                if(update == item.id)
                  cancelUpdate();
              });
            },
            icon: Icon(Icons.delete)
        ),
      ),
    );
  }

  double Total(){
    double Price = 0;
    items.forEach((element) {
      Price += element.value;
    });
    return Price;
  }
  void addToList(){
    if(_name.text.isEmpty || _value.text.isEmpty)
      return;
    items.add(Item(id: items.length +1, name: _name.text, value: double.parse(_value.text)));
    setState(() {
      _name.text = '';
      _value.text = '';
    });
    print("Value added");
  }

  void updateItem(){
    if(update != null)
      update = (update! - 1)!;
      setState(() {
        items[update!] = Item(id: update! + 1, name: _name.text, value: double.parse(_value.text));
        _name.clear();
        _value.clear();
        update = null;
      });
  }

  void cancelUpdate(){
    setState(() {
      _name.clear();
      _value.clear();
      update = null;
    });
  }

  void clearInputs(){
    setState(() {
      _name.text = '';
      _value.text = '';
    });
  }

  Future<bool> myCustomAlert(BuildContext context, String title) async {
    bool result = false; // Initialize result to false by default

    await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: title,
      ),
    ).then((value) {
      result = value ?? false; // Assign true/false if value exists, otherwise remain false
    });

    return result;
  }

  int mainFlex() {
    return MediaQuery.of(context).size.width > 1200 ?  4 : MediaQuery.of(context).size.width >900 ? 3 : MediaQuery.of(context).size.width > 500 ? 2 :1;
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;

  const CustomAlertDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: const Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true), // Returns true
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Returns false
          child: const Text('No'),
        ),
      ],
    );
  }
}