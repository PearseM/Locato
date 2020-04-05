import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/comment_tile.dart';

class StarredCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Favourite Reviews'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              semanticLabel: "Back",
            ),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Account.getDEF(context),
      builder: (context, snapshot) => (snapshot.hasData)
          ? StreamBuilder<List<Review>>(
              stream: snapshot.data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Review review = snapshot.data[index];
                        return StarredReviewsListItem(review);
                      },
                    );
                  } else {
                    return Center(
                      child: Text("You have no favourite reviews."),
                    );
                  }
                }
              },
            )
          : Center(
              child: Column(
                children: <Widget>[
                  Text("Loading user data"),
                  CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
