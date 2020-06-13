import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home:  CustomDate(),
  ));
}

class CustomDate extends StatefulWidget {
  @override
  createState() {
    return  CustomDateState();
  }
}

class CustomDateState extends State<CustomDate> {
  List<RadioModel> sampleData =  List<RadioModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add( RadioModel(false, '15', 'SEGUNDA'));
    sampleData.add( RadioModel(false, '16', 'TERÇA'));
    sampleData.add( RadioModel(false, '17', 'QUARTA'));
    sampleData.add( RadioModel(false, '18', 'QUINTA'));
    sampleData.add( RadioModel(false, '19', 'SEXTA'));
    sampleData.add( RadioModel(false, '20', 'SÁBADO'));
    sampleData.add( RadioModel(false, '21', 'DOMINGO'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sampleData.length,
          itemBuilder: (BuildContext context, int index) {
            return  InkWell(
              borderRadius: BorderRadius.circular(10),
              //highlightColor: Colors.red,
              splashColor: Theme.of(context).primaryColor,
              onTap: () {
                setState(() {
                  sampleData.forEach((element) => element.isSelected = false);
                  sampleData[index].isSelected = true;
                });
              },
              child:  RadioItem(sampleData[index]),
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(_item.text,style: TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,)),
                ),
                 Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              ],
            ),

            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Theme.of(context).accentColor
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
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
