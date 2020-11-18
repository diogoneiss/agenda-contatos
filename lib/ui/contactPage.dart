import 'dart:io';
import '../helpers/db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _numController = TextEditingController();
  final _aptoController = TextEditingController();
  final _btdDController = TextEditingController();
  final _btdMController = TextEditingController();
  final _btdYController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  void armazenarDados() async {
    //sair se o cep estiver vazio
    if (_editedContact.cep == null) return;

    http.Response jsonCru = await pesquisarCep(_editedContact.cep);

    //erro na api
    if (jsonCru.statusCode != 200) return;

    Map<String, dynamic> mapa = jsonDecode(jsonCru.body);

    _editedContact.rua = mapa['logradouro'];
    _editedContact.cidade = mapa['localidade'];
  }

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
      _cepController.text = _editedContact.cep;
      _aptoController.text = _editedContact.apto;
      _numController.text = _editedContact.num;
      _btdDController.text = _editedContact.btdD;
      _btdMController.text = _editedContact.btdM;
      _btdYController.text = _editedContact.btdY;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard modifications?"),
              content: Text(
                  "Closing the page will result in modifications data loss"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<http.Response> pesquisarCep(String cep) async {
    return http.get('http://viacep.com.br/ws/$cep/json/');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo contato"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/no_image.png")),
                  ),
                ),
                onTap: () {
                  ImagePicker.pickImage(
                    source: ImageSource.gallery,
                  ).then((file) {
                    if (file == null) {
                      return;
                    }

                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (value) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name =
                        value.isEmpty ? "Novo contato" : value;
                  });
                },
                focusNode: _nameFocus,
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.email = value;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "CEP"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.cep = value;
                  if (value.length == 8) armazenarDados();
                },
                keyboardType: TextInputType.number,
                controller: _cepController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Número na rua"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.num = value;
                },
                keyboardType: TextInputType.number,
                controller: _numController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Apartamento ou casa"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.apto = value;
                },
                keyboardType: TextInputType.text,
                controller: _aptoController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Dia do aniversário"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.btdD = value;
                },
                keyboardType: TextInputType.number,
                controller: _btdDController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Mês do aniversário"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.btdM = value;
                },
                keyboardType: TextInputType.number,
                controller: _btdMController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Ano de nascimento"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.btdY = value;
                },
                keyboardType: TextInputType.number,
                controller: _btdYController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
