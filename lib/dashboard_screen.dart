import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/octicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recase/recase.dart';

import 'database.dart';
import 'env.dart';
import 'product_details.dart';

String _selectedSortBy = 'name';
String _selectedShownBy = 'descending';
bool _isDescending = false;
bool _isGridView = true;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    hint: Text(ReCase(_selectedSortBy).titleCase),
                    items: <String>[
                      'name',
                      'category',
                      'created at',
                      'updated at'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: ReCase(value).titleCase,
                        child: Text(ReCase(value).titleCase),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedSortBy = selected;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    hint: Text(ReCase(_selectedShownBy).titleCase),
                    items:
                        <String>['descending', 'ascending'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: ReCase(value).titleCase,
                        child: Text(ReCase(value).titleCase),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        _isDescending = !_isDescending;
                        _selectedShownBy = selected;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.list,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.grid_on,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        _isGridView ? GridCardView() : ListCardView(),
      ],
    );
  }
}

class ListCardView extends StatelessWidget {
  const ListCardView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Database().getStreamCollection(
          collection: 'products',
          orderBy: _selectedSortBy.toLowerCase(),
          isDescending: _isDescending,
        ),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return snapshot.data.documents.length == 0
                  ? Center(
                      child: Text(ReCase('Let\'s add product into our stock.')
                          .sentenceCase),
                    )
                  : ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ProductDetails(
                                    document: document,
                                  ),
                                  type: PageTransitionType.rightToLeftWithFade,
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            document['image'],
                                            height: Environment()
                                                .getHeight(height: 3.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AutoSizeText(
                                                ReCase(document['name'])
                                                    .titleCase,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 20.0,
                                                maxFontSize: 128.0,
                                              ),
                                              AutoSizeText(
                                                document['category']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                                minFontSize: 18.0,
                                                maxFontSize: 128.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Octicons.getIconData(
                                                  'primitive-dot'),
                                              color: Colors.orange[500],
                                            ),
                                            Text(
                                              'In Use: ${document['in use'].toString()}',
                                              style: TextStyle(
                                                color: Colors.orange[500],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Octicons.getIconData(
                                                  'primitive-dot'),
                                              color: Colors.green[500],
                                            ),
                                            Text(
                                              'In Stock: ${document['in stock'].toString()}',
                                              style: TextStyle(
                                                color: Colors.green[500],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
          }
        },
      ),
    );
  }
}

class GridCardView extends StatelessWidget {
  const GridCardView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Database().getStreamCollection(
          collection: 'products',
          orderBy: _selectedSortBy.toLowerCase().trim(),
          isDescending: _isDescending,
        ),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return snapshot.data.documents.length == 0
                  ? Center(
                      child: Text(ReCase('Let\'s add product into our stock')
                          .sentenceCase),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document =
                            snapshot.data.documents[index];
                        return Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Image.network(
                                              document['image'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              child: AutoSizeText(
                                                ReCase(document['name'])
                                                    .titleCase,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 8.0,
                                                maxFontSize: 128.0,
                                              ),
                                            ),
                                            Flexible(
                                              child: AutoSizeText(
                                                document['category']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                minFontSize: 8.0,
                                                maxFontSize: 128.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Octicons
                                                                .getIconData(
                                                              'primitive-dot',
                                                            ),
                                                            color: Colors
                                                                .orange[500],
                                                          ),
                                                          AutoSizeText(
                                                            'In Use',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .orange[500],
                                                            ),
                                                            minFontSize: 8.0,
                                                            maxFontSize: 128.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: AutoSizeText(
                                                          document['in use']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .orange[500],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          minFontSize: 8.0,
                                                          maxFontSize: 128.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Octicons
                                                                .getIconData(
                                                              'primitive-dot',
                                                            ),
                                                            color: Colors
                                                                .green[500],
                                                          ),
                                                          AutoSizeText(
                                                            'In Stock',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[500],
                                                            ),
                                                            minFontSize: 8.0,
                                                            maxFontSize: 128.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: AutoSizeText(
                                                          document['in stock']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[500],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          minFontSize: 8.0,
                                                          maxFontSize: 128.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProductDetails(
                                        document: document,
                                      ),
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
          }
        },
      ),
    );
  }
}