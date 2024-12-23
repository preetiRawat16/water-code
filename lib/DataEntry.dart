import 'package:flutter/material.dart';
import 'package:stock_market/shareList.dart';
import 'HomePage.dart';
import 'MarketCap.dart';
import 'NewShareDetail.dart';

class DataEntry extends StatelessWidget {
  const DataEntry({super.key,required this.suggest});

  final List<String> suggest;


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: screenHeight,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(0xFF262626),
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        "web/assets/stocklogo.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xFFf6ee9c),
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to another page without transition
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(title: 'Market',suggestionlist: suggest,),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return child; // Return empty widget to disable animation
                                },
                                transitionDuration: Duration(seconds: 0), // Set the transition duration to 0
                              ),
                            );
                          },
                          child: Text("General")),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.0, top: 15.0),
                          child: Text("Data Entry- Shares"),
                        ),
                        // Add space between text and box
                        Container(
                          width: 50,
                          height: 2,
                          color: Color(0xFFa46e2d),
                        ),
                      ],
                    ),
                    Text("Data Entry-Mutual Fund"),
                    Text("Report S")
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3, // Number of tabs
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        labelColor:Color(0xFFa46e2d),
                        indicatorColor: Color(0xFFa46e2d),
                        tabs: [
                          Tab(text: 'New Share Detail'),
                          Tab(text: 'Watch list share'),
                          Tab(text: 'Buy/Sell Watchlist'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            NewShareDetail(sList:suggest),
                            shareList(),
                            // MarketCategory(),
                            Center(
                              child: Text('Tab Content'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

