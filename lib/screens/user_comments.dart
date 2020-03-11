import 'package:flutter/material.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';


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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,

              ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                      child: Text('\nOn this page are all the reviews you have made so far.\n'
                        '\nYou can click on each one to take you to the pin they were written about\n'),
                  ),
                ]
            )
          ],
        ),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  _BodyLayoutState createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: Account.getReviewsForUser(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("No comments available"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Review review = snapshot.data.elementAt(index);
              return YourReviewsListItem(
                name: review.pin.name,
                date: review.timestamp,
                comment: review.body,
                location: review.pin.location,
                imgURL: review.pin.imageUrl,
              );
            },
          );
        }
      },
    );
  }
}
