import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomPayment(),
  ));
}

class CustomPayment extends StatefulWidget {
  @override
  createState() {
    return CustomPaymentState();
  }
}

class CustomPaymentState extends State<CustomPayment> {
  List<RadioModel> sampleData = List<RadioModel>();
  @override
  void initState() {
   
    super.initState();
    sampleData.add(RadioModel(
      false,
      'Credito',
    ));
    sampleData.add(RadioModel(
      false,
      'Debito',
    ));
    sampleData.add(RadioModel(
      false,
      'Dinheiro',
    ));
    sampleData.add(RadioModel(
      false,
      'PicPay',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: GridView.builder(
       physics: NeverScrollableScrollPhysics(),
        itemCount: sampleData.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
              ));
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
                      fontSize: 18.0)),
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

  RadioModel(
    this.isSelected,
    this.buttonText,
  );
}
