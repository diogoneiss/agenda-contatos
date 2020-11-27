import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'componenteCalendario.dart';

class CalendarioAniversarios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Próximos aniversários"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ComponenteCalendario(),
            ],
          ),
          ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Voltar'),
                ),
              ],
            ),

    );
  }
}
