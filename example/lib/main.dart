import 'package:flutter/material.dart';
import 'package:flutter_validation/flutter_validation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        ...ValidationLocalizations.localizationsDelegates,
        AttributeLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  String? _gender;
  List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AttributeLocalizations.of(context)!.gender,
                ),
                items: _genders
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                value: _gender,
                onChanged: (gender) {
                  setState(() {
                    _gender = gender!;
                  });
                },
                validator: MultiValidator([
                  Validator.of(context)!
                      .required(AttributeLocalizations.of(context)!.gender),
                  Validator.of(context)!.contains(
                    AttributeLocalizations.of(context)!.gender,
                    _genders,
                  ),
                ]),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AttributeLocalizations.of(context)!.email,
                ),
                validator: MultiValidator([
                  Validator.of(context)!
                      .required(AttributeLocalizations.of(context)!.email),
                  Validator.of(context)!.email,
                ]),
              ),
              TextFormField(
                validator: MultiValidator([
                  Validator.of(context)!
                      .required(AttributeLocalizations.of(context)!.phone),
                  Validator.of(context)!.phone,
                ]),
                decoration: InputDecoration(
                  labelText: AttributeLocalizations.of(context)!.phone,
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Have fun (:')));
          }
        },
        tooltip: 'Submit',
        child: Icon(Icons.done),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
