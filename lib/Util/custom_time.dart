import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomTime(),
  ));
}

class CustomTime extends StatefulWidget {
  @override
  createState() {
    return CustomTimeState();
  }
}

class CustomTimeState extends State<CustomTime> {
  List<RadioModel> sampleData = List<RadioModel>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(RadioModel(
      false,
      '8:00',
    ));
    sampleData.add(RadioModel(
      false,
      '9:30',
    ));
    sampleData.add(RadioModel(
      false,
      '11:00',
    ));
    sampleData.add(RadioModel(
      false,
      '13:30',
    ));
    sampleData.add(RadioModel(
      false,
      '15:30',
    ));
    sampleData.add(RadioModel(
      false,
      '17:00',
    ));
    sampleData.add(RadioModel(
      false,
      '18:00',
    ));
     sampleData.add(RadioModel(
      false,
      '18:45',
    ));
     sampleData.add(RadioModel(
      false,
      '19:15',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight:80,
        maxHeight:200,
      ),
      child: GridView.builder(
        itemCount: sampleData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:120,
              maxHeight:300,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0)),
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
