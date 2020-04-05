import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Block/Theme_overall.dart';
import 'Block/block.dart';
import 'UI/home_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, Theme_overall>(
        builder: (_, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            home: CounterPage(theme.small,theme.medium,theme.large),
            theme: theme.theme,
          );
        },
      ),
    );
  }
}

