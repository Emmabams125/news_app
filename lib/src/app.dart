import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
        child: StoriesProvider(
          child: MaterialApp(
            title: 'News!',
            onGenerateRoute: routes,
          ),
        ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          // Safely parse itemId from the route name
          final itemId = int.parse(settings.name?.replaceFirst('/', '') ?? '0');

          commentsBloc.fetchItemWithComments(itemId);


          // Pass itemId to NewsDetail
          return NewsDetail(itemId: itemId);
        },
      );
    }
  }
}
