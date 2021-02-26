import 'package:flutter/material.dart';

class ShrineLoginScreen extends StatefulWidget {
  @override
  _ShrineLoginScreenState createState() => _ShrineLoginScreenState();
}

class _ShrineLoginScreenState extends State<ShrineLoginScreen> {
  final _usernameCOntroller = TextEditingController();
  final _passwordCOntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          SizedBox(height: 80.0),
          Column(
            children: <Widget>[
              Image.asset('assets/mdc_codelab/diamond.png'),
              SizedBox(height: 16.0),
              Text('SHRINE'),
            ],
          ),
          SizedBox(height: 120.0),
          // TODO: Wrap Username with AccentColorOverride (103)
          // TODO: Remove filled: true values (103)
          // TODO: Wrap Password with AccentColorOverride (103)
          TextField(
            controller: _usernameCOntroller,
            decoration: InputDecoration(filled: true, labelText: "Username"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _passwordCOntroller,
            decoration: InputDecoration(filled: true, labelText: "Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          ButtonBar(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    _usernameCOntroller.clear();
                    _passwordCOntroller.clear();
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Next"))
            ],
          )
        ],
      )),
    );
  }
}
