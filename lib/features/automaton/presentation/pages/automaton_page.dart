import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../cubits/automaton_cubit.dart";
import "../widgets/automaton_view.dart";

/// Página principal del visualizador de autómatas.
@RoutePage()
class AutomatonPage extends StatelessWidget {
  /// Página principal del visualizador de autómatas.
  const AutomatonPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AutomatonCubit(),
        child: const AutomatonView(),
      );
}
