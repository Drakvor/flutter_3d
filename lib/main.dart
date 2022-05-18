import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as m;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  Matrix4 current = Matrix4.identity()
    //..setEntry(3, 2, 0.0005)
  ;
  Matrix4 change = Matrix4.identity();
  Matrix4 rotation = Matrix4.identity();

  m.Vector3 xAxis = m.Vector3(1, 0, 0);
  m.Vector3 yAxis = m.Vector3(0, 1, 0);
  m.Vector3 x = m.Vector3(1, 0, 0);
  m.Vector3 y = m.Vector3(0, 1, 0);
  m.Vector3 z = m.Vector3(0, 0, 1);

  Widget side1 = Transform(
    transform: Matrix4.identity()
      ..translate(0.0, 0.0, -50.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.blue,
    ),
  );
  Widget side2 = Transform(
    transform: Matrix4.identity()
      ..rotateX(pi/2)
      ..translate(0.0, -50.0, 0.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.green,
    ),
  );
  Widget side3 = Transform(
    transform: Matrix4.identity()
      ..rotateY(pi/2)
      ..translate(-50.0, 0.0, 0.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.red,
    ),
  );
  Widget side4 = Transform(
    transform: Matrix4.identity()
      ..rotateY(pi/2)
      ..translate(-50.0, 0.0, 100.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.yellow,
    ),
  );
  Widget side5 = Transform(
    transform: Matrix4.identity()
      ..rotateX(pi/2)
      ..translate(0.0, -50.0, -100.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.orange,
    ),
  );
  Widget side6 = Transform(
    transform: Matrix4.identity()
      ..translate(0.0, 0.0, 50.0)
    ,
    child:
    Container(
      height: 100,
      width: 100,
      color: Colors.purple,
    ),
  );

  List<Widget> children = [];

  @override
  void initState () {
    super.initState();
    children = [side6];
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (DragUpdateDetails details) {
        children = [];
        setState(() {
          change.rotate(xAxis, -details.delta.dy * 0.01);
          change.rotate(yAxis, details.delta.dx * 0.01);
          rotation = current.multiplied(change);
          if (rotation.rotated3(z)[2] > 0) {
            children.add(side6);
          }
          else if (rotation.rotated3(z)[2] < 0) {
            children.add(side1);
          }
          if (rotation.rotated3(y)[2] > 0) {
            children.add(side5);
          }
          else if (rotation.rotated3(y)[2] < 0) {
            children.add(side2);
          }
          if (rotation.rotated3(x)[2] > 0) {
            children.add(side4);
          }
          else if (rotation.rotated3(x)[2] < 0) {
            children.add(side3);
          }
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          current = rotation;
          change.invertRotation();
          xAxis = change.rotate3(xAxis);
          yAxis = change.rotate3(yAxis);
          change = Matrix4.identity();
        });
      },
      onTapDown: (TapDownDetails details) {
        //print(details.globalPosition);
        //print(details.localPosition);
        //print("--------------");
      },
      child: Scaffold(
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Transform(
            transform: rotation,
            alignment: Alignment.center,
            child: Stack(
              children: children,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), //
      ),
    );
  }
}
