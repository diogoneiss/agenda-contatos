import 'package:flutter/material.dart';
import 'ui/homePage.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:firebase_core/firebase_core.dart';

//final Future<FirebaseApp> _initialization = Firebase.initializeApp();

void main() {
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      )));
}
