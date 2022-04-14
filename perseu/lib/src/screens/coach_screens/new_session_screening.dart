import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NewSessionScreen extends StatefulWidget {
  const NewSessionScreen({Key? key}) : super(key: key);

  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSessionScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> _phoneWidgets = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nova sessão'),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              onTap: () => setState(() {
                _phoneWidgets.add(Phone(
                  fieldName: 'Exercícios',
                ));
              }),
              label: 'Adicionar exercício',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        body: ListView(children: [
          const Text('Nome do exercício'),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                children: List.generate(_phoneWidgets.length, (i) {
                  return _phoneWidgets[i];
                }),
              )),
        ]));
  }
}

//https://www.youtube.com/watch?v=HMqye4R-4c4&t=119s

// ignore: must_be_immutable
class Phone extends StatelessWidget {
  String fieldName;
  Phone({Key? key, this.fieldName = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 0.1),
          ),
          filled: true,
          icon: const Icon(
            Icons.fitness_center_sharp,
            color: Colors.black,
            size: 20.0,
          ),
          labelText: fieldName,
          labelStyle: const TextStyle(
              fontSize: 15.0,
              height: 1.5,
              color: Color.fromRGBO(61, 61, 61, 1)),
          fillColor: const Color(0xffD2E8E6),
        ),
        maxLines: 1,
      ),
    );
  }
}
