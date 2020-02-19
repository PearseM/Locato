import 'package:flutter/material.dart';

class UserCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Your Reviews'),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: BodyLayout(),
      ),
    );
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Your reviews"),
//      ),
//    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {

  // backing data
  final userReviews = ['Pin 1', 'Pin 2', 'Pin 3', 'Pin 4', 'Pin 5', 'Pin 6', 'Pin 7',
    'Pin 8', 'Pin 9', 'Pin 10', 'Pin 11', 'Pin 12', 'Pin 13', 'Pin 14', 'Pin 15', 'Pin 16', 'Pin 17'
    , 'Pin 18', 'Pin 19', 'Pin 20', 'Pin 21', 'Pin 22', 'Pin 23', 'Pin 24', 'Pin 25', 'Pin 26', 'Pin 27'
    , 'Pin 28', 'Pin 29', 'Pin 30', 'Pin 31', 'Pin 32', 'Pin 33', 'Pin 34', 'Pin 35', 'Pin 36', 'Pin 37'
    , 'Pin 38', 'Pin 39', 'Pin 40', 'Pin 41', 'Pin 42', 'Pin 43', 'Pin 44'];

  return ListView.builder(
    itemCount: userReviews.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(userReviews[index]),
      );
    },
  );

}