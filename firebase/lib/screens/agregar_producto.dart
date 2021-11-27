// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AgregarProductoScreen extends StatefulWidget
{
  ProductDAO? product;
  AgregarProductoScreen({Key? key}) : super(key: key);

  @override
  _AgregarProductoScreenState createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen>
{
  File? imageFile;
  String? randNombre;
  String? urlArchivo;

  _getFromGallery() async
  {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null)
    {
      setState(()
      {
        imageFile = File(pickedFile.path);
      });
    }
  }

  String url = "";

  guardar() async
  {
    File file = imageFile!;

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
    String.fromCharCodes(
      Iterable.generate(
        length, (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length)
        )
      )
    );

    randNombre = getRandomString(15);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('image/' + randNombre!);
    UploadTask uploadTask = ref.putFile(file);
    uploadTask.whenComplete(() async
    {
      url = await ref.getDownloadURL();

      ProductDAO product = ProductDAO(
        cve_product: _controllerCve.text,
        description: _controllerDescription.text,
        img: url
      );

      _firebaseProvider.saveProduct(product).then(
        (value)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registro insertado correctamente')
            )
          );

          Navigator.of(context).pushNamed('/inicio');
        }
      );
    }).catchError((onError)
    {
      print(onError);
    });
  }
  
  TextEditingController _controllerCve = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();

  late FirebaseProvider _firebaseProvider;
  var storage = FirebaseStorage.instance;

  @override
  void initState()
  {
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar producto'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.0
            ),
          ),
          _crearTextFieldCve(),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(
              top: 20.0
            ),
          ),
          _crearTextFieldDescription(),
          Padding(
            padding: EdgeInsets.only(
              top: 20.0
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    imageFile == null ?
                    (
                      Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: new ExactAssetImage('assets/nada.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      )
                    )
                    :
                    (
                      Container(
                        child: Image.file(imageFile!),
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        )
                      )
                    ),
                  ]
                ),

                Padding(
                  padding: EdgeInsets.only(top: 90.0, left: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 25.0,
                        child: IconButton(
                          icon: Icon(Icons.photo),
                          color: Colors.white,
                          onPressed: ()
                          {
                            print("Selecciono foto");
                            _getFromGallery();
                          },
                        ),
                      )
                    ],
                  )
                ),
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20.0
            ),
          ),
          ElevatedButton(
            onPressed: ()
            {
              guardar();
            },
            child: Text('Guardar Producto'),
          )
        ],
      ),
    );
  }

  Widget _crearTextFieldCve()
  {
    return TextField(
      controller: _controllerCve,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Clave del producto",
        errorText: "Este campo es obligatorio"
      ),
      onChanged: (value)
      {

      },
    );
  }

  Widget _crearTextFieldDescription()
  {
    return TextField(
      controller: _controllerDescription,
      maxLines: 3,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Descripcion del producto",
        errorText: "Este campo es obligatorio"
      ),
      onChanged: (value)
      {
        
      },
    );
  }
}