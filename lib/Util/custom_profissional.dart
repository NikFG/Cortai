import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomProfissional(),
  ));
}

class CustomProfissional extends StatefulWidget {
  @override
  createState() {
    return CustomProfissionalState();
  }
}

class CustomProfissionalState extends State<CustomProfissional> {
  List<RadioModel> sampleData = List<RadioModel>();
  @override
  void initState() {
    super.initState();
    sampleData.add(RadioModel(
      false,
      'Fernando',
    ));
      sampleData.add(RadioModel(
      false,
      'Joao',
    ));
      sampleData.add(RadioModel(
      false,
      'Maria',
    ));
      sampleData.add(RadioModel(
      false,
      'Nicolas',
    ));
      sampleData.add(RadioModel(
      false,
      'Aroldu',
    ));
      sampleData.add(RadioModel(
      false,
      'Marcos',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight:80,
        maxHeight:100,
      ),
      child: ListView.builder(
        itemCount: sampleData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:120,
              maxHeight:120,
            ),
           child: InkWell(
            borderRadius: BorderRadius.circular(10),
            //highlightColor: Colors.red,
            splashColor: Theme.of(context).accentColor,
            onTap: () {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
              });
            },
            child: RadioItem(sampleData[index]),
          )
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 80.0,
            child: Center(
              child: Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(
    this.isSelected,
    this.buttonText,
  );
}
