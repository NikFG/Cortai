import 'package:flutter/material.dart';
import '';

class TesteTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            onStretchTrigger: () {
              return;
            },
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              title:  Text(
                'Salao O BAUM',
                style: Theme.of(context).textTheme.display1.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Color(0xCCFFFFFF),
                    fontFamily: 'Poppins'),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.0),
                        end: Alignment(0.9, 0.9),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),


// POde apagar daqui pra baixoo !

               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TesteTile())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Corte",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.0,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "breve descricao",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "R\$10",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomCenter,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TesteTile())),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              
// Ate aqui !!! kkkk coloquei pra ver o funcionamento 


              
            ]),
          ),
        ],
      ),
    );
  }
}
