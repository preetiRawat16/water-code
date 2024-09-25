import 'package:flutter/material.dart';
import 'package:stock_market/DataEntry.dart';
import 'MarketCap.dart';
import 'MarketCategory.dart';
import 'MarketType.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title, required this.suggestionlist}) : super(key: key);

  final String title;
  final List<String> suggestionlist;

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.0, top: 15.0),
                          child: Text("General"),
                        ),
                        // Add space between text and box
                        Container(
                          width: 50,
                          height: 2,
                          color: Color(0xFFa46e2d),
                        ),
                      ],
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to another page without transition
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => DataEntry(suggest:suggestionlist),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return child; // Return empty widget to disable animation
                                },
                                transitionDuration: Duration(seconds: 0), // Set the transition duration to 0
                              ),
                            );
                          },
                          child: Text("Data Entry- Shares")),
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
                          Tab(text: 'Share-Market Cap'),
                          Tab(text: 'Share-Category'),
                          Tab(text: 'Share-Type'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            MarketCap(),
                            AddDocumentScreen(),
                            shareTypePage(),
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

