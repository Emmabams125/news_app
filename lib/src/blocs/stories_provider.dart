import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key? key, required Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<StoriesProvider>();
    assert(provider != null, 'No StoriesProvider found in context');
    return provider!.bloc;
  }
}
