import 'package:flutter/material.dart';

import '../presenter/MvpPresenter.dart';
import '../view/MvpView.dart';

class MvpPage extends StatefulWidget {
  const MvpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MvpPage> createState() => _MvpPageState();
}

class _MvpPageState extends State<MvpPage> implements MvpView {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _weight = "";
  String _height = "";
  var _message = '';
  var _mvpString = '';
  var _value = 0;
  var _heightMessage = '';
  var _weightMessage = '';
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _heightFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();
  late MvpPresenter presenter;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    presenter = BasicMvpPresenter(this);
    presenter.view = this;
  }

  void handleRadioValueChanged(int? value) {
    presenter.onOptionChanged(value!,
        heightString: _height, weightString: _weight);
  }

  void _calculator() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      presenter.onCalculateClicked(_weight, _height);
    }
  }

  @override
  void updateValue(String mvpValue, String mvpMessage) {
    setState(() {
      _mvpString = mvpValue;
      _message = mvpMessage;
    });
  }

  @override
  void updateWeight({required String? weight}) {
    setState(() {
      _weightController.text = weight ?? '';
    });
  }

  @override
  void updateHeight({required String? height}) {
    setState(() {
      _heightController.text = height ?? '';
    });
  }

  @override
  void updateUnit(int value, String heightMessage, String weightMessage) {
    setState(() {
      _value = value;
      _heightMessage = heightMessage;
      _weightMessage = weightMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    var unitView = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: Colors.lightBlue,
          value: 0,
          groupValue: _value,
          onChanged: handleRadioValueChanged,
        ),
        const Text(
          'Imperial Unit',
          style: TextStyle(color: Colors.blue),
        ),
        Radio(
          activeColor: Colors.lightBlue,
          value: 1,
          groupValue: _value,
          onChanged: handleRadioValueChanged,
        ),
        const Text(
          'Metric Unit',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );

    var mainPartView = Container(
      color: Colors.grey.shade300,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ageFormField(context),
              heightFormField(context),
              weightFormField(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: calculateButton(),
              ),
            ],
          ),
        ),
      ),
    );

    var resultView = Column(
      children: <Widget>[
        Center(
          child: Text(
            'Your BIM: $_mvpString',
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic),
          ),
        ),
        const Padding(padding: EdgeInsets.all(2.0)),
        Center(
          child: Text(
            _message,
            style: const TextStyle(
                color: Colors.lightGreen,
                fontSize: 24.0,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('MVP'),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/ic_menu.png',
              width: 100.0,
              height: 100.0,
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            unitView,
            const Padding(padding: EdgeInsets.all(5.0)),
            mainPartView,
            const Padding(padding: EdgeInsets.all(5.0)),
            resultView
          ],
        ));
  }

  RaisedButton calculateButton() {
    return RaisedButton(
      onPressed: _calculator,
      color: Colors.purpleAccent,
      textColor: Colors.white,
      child: const Text(
        'Calculate',
        style: TextStyle(fontSize: 16.9),
      ),
    );
  }

  TextFormField weightFormField() {
    return TextFormField(
      controller: _weightController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      focusNode: _weightFocus,
      onFieldSubmitted: (value) {
        _weightFocus.unfocus();
        _calculator();
      },
      validator: (value) {
        if (value!.isEmpty || double.parse(value) == 0.0) {
          return ('Weight is not valid. Weight > 0.0');
        }
        return null;
      },
      onSaved: (value) {
        _weight = value!;
      },
      decoration: InputDecoration(
          hintText: _weightMessage,
          labelText: _weightMessage,
          icon: const Icon(Icons.menu),
          fillColor: Colors.white),
    );
  }

  TextFormField heightFormField(BuildContext context) {
    return TextFormField(
      controller: _heightController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _heightFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _heightFocus, _weightFocus);
      },
      validator: (value) {
        if (value!.isEmpty || double.parse(value) == 0.0) {
          return ('Height is not valid. Height > 0.0');
        }
        return null;
      },
      onSaved: (value) {
        _height = value!;
      },
      decoration: InputDecoration(
        hintText: _heightMessage,
        icon: const Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField ageFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _ageFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _ageFocus, _heightFocus);
      },
      validator: (value) {
        if (value!.isEmpty || double.parse(value) <= 15) {
          return ('Age should be over 15 years old');
        }
        return null;
      },
      onSaved: (value) {},
      decoration: const InputDecoration(
        hintText: 'Age',
        icon: Icon(Icons.person_outline),
        fillColor: Colors.white,
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
