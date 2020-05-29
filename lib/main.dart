import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 28.0;
  double resultFontSize = 48.0;
  int eq = 0;
  int op = 0;
  int point = 0;
  int obCount = 0;
  int cbCount = 0;

  bool isFloat(String str){
    RegExp _float = RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$');
    return _float.hasMatch(str);
  }

  Future sleep() {
    return new Future.delayed(const Duration(seconds: 0), () => equation = result);
  }

  buttonPressed(String buttonText) {
    setState(() {
      if(buttonText == "C"){
        eq = 0;
        equation = "0";
        result = "0";
        obCount = 0;
        cbCount = 0;
        equationFontSize = 28.0;
        resultFontSize = 48.0;
      }

      else if(buttonText == "back"){
        if(eq == 1) {
          eq = 0;
          return;
        }
        equationFontSize = 48.0;
        resultFontSize = 28.0;
        if(equation[equation.length-1] == "(") obCount--;
        else if(equation[equation.length-1] == ")") cbCount--;
        equation = equation.substring(0, equation.length - 1);
        eq = 0;
        if(equation == ""){
          equation = "0";
        }
      }

      else if(buttonText == "%"){
        if(equation[equation.length-1] == ")"){
          eq = 0;
          int i = 0, len = equation.length;
          int tempOB = 0, tempCB = 1;
          String temp = ")";
          for(i=len-2;i>=0;i--){
            if(equation[i] == ")") tempCB++;
            else if(equation[i] == "(") tempOB++;
            temp = equation[i] + temp;
            if(tempOB == tempCB) break;
          }
          expression = temp;
          expression = expression.replaceAll('x', '*');
          try {
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            temp = '${exp.evaluate(EvaluationType.REAL, cm)}';
          }catch(e){
            result = "Error!";
          }
          double val = double.parse(temp);
          print(val);
          val = val/100;
          print(val);
          if(i==0) equation = val.toString();
          else equation = equation.substring(0,i)+val.toString();
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        print(equation);
        int i = 0, flag = 0, len = equation.length;
        for(i=0;i<=len-1;i++){
            if(isFloat(equation.substring(i,len))){
              flag=1;
              break;
            }
        }
        if(flag == 1){
          eq = 0;
          double val = double.parse(equation.substring(i,len));
          print(val);
          val = val/100;
          print(val);
          if(i==0) equation = val.toString();
          else equation = equation.substring(0,i)+val.toString();
        }
        else result = "Error!";
      }

      else if(buttonText == "="){
        equationFontSize = 28.0;
        resultFontSize = 48.0;
        if(eq == 1) return;
        for(int i = 0; i <= equation.length-2; i++){
          if(equation[i] == "(" && equation[i+1] == ")"){
            result = "Error!";
            return;
          }
        }
        expression = equation;
        expression = expression.replaceAll('x', '*');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          equation = result;
          eq = 1;
        }catch(e){
          result = "Error!";
        }
      }

      else if(buttonText == "("){
        if(equation == "0") {
          equation = buttonText;
          obCount++;
          return;
        }
        if(isFloat(equation[equation.length-1]) == true) return;
        equation = equation + buttonText;
        obCount++;
      }

      else if(buttonText == ")"){
        if(equation[equation.length-1] == ")"){
          if(obCount <= cbCount) return;
          if(equation == "0") equation = buttonText;
          else equation = equation + buttonText;
          cbCount++;
          return;
        }
        if(equation[equation.length-1] == "("){
          equation = equation + buttonText;
          result = "Error!";
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        if(obCount <= cbCount) return;
        if(equation == "0") equation = buttonText;
        else equation = equation + buttonText;
        cbCount++;
      }

      else if(buttonText == "+"){
        if(equation[equation.length-1] == ")"){
          eq = 0;
          equation = equation + buttonText;
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        eq = 0;
        equation = equation + buttonText;
      }

      else if(buttonText == "-"){
        if(equation[equation.length-1] == ")"){
          eq = 0;
          equation = equation + buttonText;
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        eq = 0;
        equation = equation + buttonText;
      }

      else if(buttonText == "x"){
        if(equation[equation.length-1] == ")"){
          eq = 0;
          equation = equation + buttonText;
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        eq = 0;
        equation = equation + buttonText;
      }

      else if(buttonText == "/"){
        if(equation[equation.length-1] == ")"){
          eq = 0;
          equation = equation + buttonText;
          return;
        }
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        eq = 0;
        equation = equation + buttonText;
      }

      else if(buttonText == "."){
        if(isFloat(equation[equation.length-1]) == false) return;
        if(equation[equation.length-1] == ".") return;
        for(int i = equation.length-1; i >= 0; i --){
          if(equation[i] == "."){
            return;
          }
          if(isFloat(equation[i]) == false) break;
        }
        eq = 0;
        equation = equation + buttonText;
      }

      else{
        if(equation[equation.length-1] == ")") return;
        eq = 0;
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if(equation == "0"){
          equation = buttonText;
        }else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Future<bool> backPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit!'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
        appBar: AppBar(title: Text('Calculator')),
        body: Column(
          children: [
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Text(equation, style: TextStyle(fontSize: equationFontSize)),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                            child: Text(result, style: TextStyle(fontSize: resultFontSize),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Divider(),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyCustomButton("C",true),
                          MyCustomIconButton("back"),
                          MyCustomIconButton("%"),
                          MyCustomIconButton("/")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyCustomButton("7",false),
                          MyCustomButton("8",false),
                          MyCustomButton("9",false),
                          MyCustomIconButton("x"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyCustomButton("4",false),
                          MyCustomButton("5",false),
                          MyCustomButton("6",false),
                          MyCustomIconButton("-")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyCustomButton("1",false),
                          MyCustomButton("2",false),
                          MyCustomButton("3",false),
                          MyCustomIconButton("+")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //MyCustomButton("00",false),
                          Container(
                            height: 60,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44,
                                      child: MaterialButton(
                                        shape: CircleBorder(),
                                        onPressed: () => buttonPressed("("),
                                        height: 60,
                                        child: Text("(", style: TextStyle(fontSize: 32.0)),
                                        textColor: Colors.deepOrangeAccent,
                                        //color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    Container(
                                      width: 44,
                                      child: MaterialButton(
                                        shape: CircleBorder(),
                                        onPressed: () => buttonPressed(")"),
                                        height: 60,
                                        child: Text(")", style: TextStyle(fontSize: 32.0)),
                                        textColor: Colors.deepOrangeAccent,
                                        //color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          MyCustomButton("0",false),
                          MyCustomButton(".",false),
                          Container(
                            child: MaterialButton(
                              onPressed: () => buttonPressed("="),
                              height: 45,
                              shape: CircleBorder(),
                              elevation: 0.0,
                              color: Colors.deepOrangeAccent,
                              child: Icon(MaterialCommunityIcons.equal,size: 32,color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Container MyCustomButton (String value, bool isC){
    return Container(
        //color: Colors.blue,
        child: MaterialButton(
          shape: CircleBorder(),
          onPressed: () => buttonPressed(value),
          height: 60,
          child: isC ? Text(value, style: TextStyle(fontSize: 32.0,fontFamily: "Poppins")) : Text(value, style: TextStyle(fontSize: 32.0)),
          textColor: isC ? Colors.deepOrangeAccent : Colors.black,
          //color: Colors.lightBlueAccent,
        ),
    );
  }

  Container MyCustomIconButton (String value){
    return Container(
      child: MaterialButton(
        shape: CircleBorder(),
        onPressed: () => buttonPressed(value),
        height: 60,
        child: value == "+"
            ? Icon(AntDesign.plus,size: 30,color: Colors.deepOrangeAccent)
            : value == "-"
            ? Icon(AntDesign.minus,size: 30,color: Colors.deepOrangeAccent)
            : value == "x"
            ? Icon(Feather.x,size: 30,color: Colors.deepOrangeAccent)
            : value == "/"
              ? Image(image: AssetImage('Icons/divide1.png'),height: 30,width: 30,color: Colors.deepOrangeAccent)
              : value == "back"
                ? Icon(MaterialCommunityIcons.backspace_outline,size: 30,color: Colors.deepOrangeAccent)
                : Image(image: AssetImage('Icons/percent.png'),height: 30,width: 30,color: Colors.deepOrangeAccent)
      ),
    );
  }
}