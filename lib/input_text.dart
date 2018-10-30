import 'package:flutter/material.dart';

class InputTextPage extends StatefulWidget {

  @override
  State createState() => new InputTextState();
}

class InputTextState extends State<InputTextPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _iconVisibility = false;
  bool _autovalidate = false;
  final myController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void _validateText(String value) {
    setState(() {
      if (value.length >= 4)
        _iconVisibility = true;
      else
        _iconVisibility = false;
    });
  }

  void _handleSubmitted() {
    if (myController.text.isEmpty) {
      showInSnackBar('Please input text.');
    } else {
      showInSnackBar('Your phone number is ${myController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            title: const Text("Input Text")
        ),
        body: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: new BorderRadius.all(
                          Radius.circular(10.0)),
                      boxShadow: [new BoxShadow(
                        color: Colors.black,
                      ),
                      ]
                  ),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                            child: new TextField(
                                controller: myController,
                                maxLines: 1,
                                onChanged: (text) {
                                  _validateText(text);
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                )
                            )
                        ),
                      ),
                      _iconVisibility ? new Container(
                        child: Icon(Icons.phone),
                      ) : new Container()
                    ],
                  )
              ),
              new Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: new Container(
                        height: 50.0,
                        decoration: new BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: theme.primaryColor)
                            )
                        ),
                        child: new ListTile(
                          onTap: _handleSubmitted,
                          title: const Align(
                            alignment: Alignment.center,
                            child: const Text('Submit'),
                          ),
                        ),
                      )
                  )

              )

            ],
          ),
        )

    );
  }
}
