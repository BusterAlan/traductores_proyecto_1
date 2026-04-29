import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../cubits/automaton_cubit.dart";

/// Automaton page
@RoutePage()
class AutomatonPage extends StatelessWidget
{
  /// Automaton page
  const AutomatonPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: BlocProvider(
        create: (context) => AutomatonCubit(),
        child: const Center(
          child: Text("Created with clean arq brick"),
        ),
      ),
    );
}
