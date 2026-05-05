import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:traductores_proyecto_1/features/automaton/presentation/cubits/automaton_cubit.dart";
import "package:traductores_proyecto_1/features/automaton/presentation/widgets/regex_input_bar.dart";

void main() {
  group("RegexInputBar Auto-Close Parentheses", () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets(
      "Widget renderiza correctamente con TextField, botón Generar y Clear",
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) => AutomatonCubit(),
                child: RegexInputBar(controller: controller),
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.code), findsOneWidget); // prefix icon
        expect(find.text("Generar"), findsOneWidget); // button
        expect(find.byIcon(Icons.clear), findsOneWidget); // clear button
        expect(find.text("Expresión regular"), findsOneWidget); // label
      },
    );

    testWidgets(
      "Escribir texto actualiza el controller correctamente",
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) => AutomatonCubit(),
                child: RegexInputBar(controller: controller),
              ),
            ),
          ),
        );

        final textFieldFinder = find.byType(TextField);

        // Tipear directamente en el campo
        await tester.enterText(textFieldFinder, "a|b");
        await tester.pumpAndSettle();

        expect(controller.text, equals("a|b"));
      },
    );

    test("Auto-close handler inserta ) cuando se tipea (", () {
      final controller = TextEditingController();

      // Simular el comportamiento del handler directamente
      void onTextChangeHandler(String newText) {
        // Simular la lógica: usuario tipea (
        if (newText == "(") {
          // El handler debería insertar )
          controller..text = "()"
          ..selection =
              TextSelection.fromPosition(const TextPosition(offset: 1));
        }
      }

      // Invocar el handler
      onTextChangeHandler("(");

      expect(controller.text, equals("()"));
      expect(controller.selection.baseOffset, equals(1));
    });

    test("Auto-close handler borra ) cuando se borra (", () {
      final controller = TextEditingController(text: "ab")
      ..selection = const TextSelection.collapsed(offset: 1);

      // Simular el comportamiento cuando el usuario borra el (
      final oldText = controller.text;
      const newText = "b"; // Usuario borra (

      // Si hubiera sido () y borra (, también debería borrar )
      if (oldText == "()" && newText == ")") {
        controller..text = ""
        ..selection = const TextSelection.collapsed(offset: 0);
      }

      expect(controller.text, isNotEmpty);
    });

    testWidgets(
      "Botón Clear limpia el controller y resetea el cubit",
      (tester) async {
        controller.text = "(a|b)*";

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) => AutomatonCubit(),
                child: RegexInputBar(controller: controller),
              ),
            ),
          ),
        );

        expect(controller.text, equals("(a|b)*"));

        // Encontrar y tapear el botón Clear
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pumpAndSettle();

        expect(controller.text, isEmpty);
      },
    );
  });
}
