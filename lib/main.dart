import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '';

  get eval => null;

  void _updateDisplay(String value) {
    setState(() {
      _displayText += value;
    });
  }

  void _clearDisplay() {
    setState(() {
      _displayText = '';
    });
  }

  void _evaluateExpression() {
    setState(() {
      try {
        final result = eval.evaluate(_displayText);
        _displayText = result.toString();
      } catch (e) {
        _displayText = 'Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _displayText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Divider(height: 1.0),
          Row(
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('*'),
            ],
          ),
          Row(
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            children: [
              buildButton('0'),
              buildButton('.'),
              buildButton('='),
              buildButton('+'),
            ],
          ),
          RaisedButton(
            child: Text('Clear'),
            onPressed: _clearDisplay,
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value) {
    return Expanded(
      child: RaisedButton(
        child: Text(
          value,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (value == '=') {
            _evaluateExpression();
          } else {
            _updateDisplay(value);
          }
        },
      ),
    );
  }
}

class Eval {
  double evaluate(String expression) {
    try {
      return eval(expression);
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  double eval(String expression) {
    return Function.apply(
      evalArithmeticExpression,
      [expression],
    );
  }

  double evalArithmeticExpression(String expression) {
    return Function.apply(
      evalLogicalExpression,
      [expression.replaceAll(' ', '')],
    );
  }

  double evalLogicalExpression(String expression) {
    final terms = expression.split(RegExp(r'[+\-]'));

    double value = 0;
    String operator = '+';

    for (final term in terms) {
      if (term.contains('*')) {
        final factors = term.split('*');
        double product = 1;

        for (final factor in factors) {
          product *= double.parse(factor);
        }

        if (operator == '+') {
          value += product;
        } else if (operator == '-') {
          value -= product;
        }
      } else if (term.contains('/')) {
        final divisors = term.split('/');

        if (divisors.length != 2) {
          throw Exception('Invalid expression');
        }

        final dividend = double.parse(divisors[0]);
        final divisor = double.parse(divisors[1]);

        if (divisor == 0) {
          throw Exception('Division by zero');
        }

        if (operator == '+') {
          value += dividend / divisor;
        } else if (operator == '-') {
          value -= dividend / divisor;
        }
      } else {
        final number = double.parse(term);

        if (operator == '+') {
          value += number;
        } else if (operator == '-') {
          value -= number;
        }
      }

      if (term.endsWith('+')) {
        operator = '+';
      } else if (term.endsWith('-')) {
        operator = '-';
      }
    }

    return value;
  }
}