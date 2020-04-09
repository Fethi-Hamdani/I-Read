import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Back-end/block.dart';
import 'Front-end/home_page.dart';

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
  //precacheImage(provider, context);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/my_logo.png"), context);
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, Theme_overall>(
        builder: (_, theme) {
         // context.bloc<ThemeBloc>().intilize();
          return MaterialApp(
            title: 'Flutter Demo',
            home: CounterPage(theme),
            theme: theme.theme,
          );
        },
      ),
    );
  }
}