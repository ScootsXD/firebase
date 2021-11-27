import 'package:firebase/screens/agregar_producto.dart';
import 'package:firebase/screens/products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      routes:
      {
        '/agregar' : (BuildContext context) => AgregarProductoScreen(),
        '/inicio' : (BuildContext context) => MyHome(),
      },

      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
        actions: [
          IconButton(
            onPressed: ()
            {
              Navigator.of(context).pushNamed('/agregar');
            },
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: ListProducts(),
    );
  }
}