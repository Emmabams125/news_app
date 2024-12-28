import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  // Corrected constructor to handle null safety
  CommentsProvider({Key? key, required Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  // Updated method to use the correct API for InheritedWidgets
  static CommentsBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CommentsProvider>();
    if (provider == null) {
      throw FlutterError('CommentsProvider not found in context');
    }
    return provider.bloc;
  }
}
