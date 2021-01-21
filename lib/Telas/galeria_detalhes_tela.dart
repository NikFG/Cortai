import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DetalhesGaleria extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String details;
  final int index;
  DetalhesGaleria(
      {@required this.imagePath,
      @required this.title,
      @required this.price,
      @required this.details,
      @required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nome do Salao'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: 'logo$index',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(1.0.h, 1.0.h, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Text(
                              details,
                              style: TextStyle(
                                fontSize: 12.0.sp,
                              ),
                            ),
                          ),
                          Container(
                            child: FlatButton(
                              onPressed: () {},
                              child: Icon(Icons.share_outlined),
                            ),
                          ),
                          Container(height: 2.0.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
