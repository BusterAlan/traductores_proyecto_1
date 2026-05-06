# TraductoresProyecto1

Aplicación Flutter para construir, visualizar y exportar autómatas a partir de expresiones regulares.

## Overview

Esta aplicación convierte expresiones regulares en autómatas finitos no deterministas (NFA) y deterministas (DFA), mostrando ambos grafos de estados en una interfaz interactiva. El proyecto incluye:

- análisis léxico y sintáctico de expresiones regulares.
- construcción de NFA con Thompson.
- conversión a DFA mediante el algoritmo de subconjuntos.
- cálculo de posiciones de estado para el renderizado en pantalla.
- exportación de la representación DOT para compartir o visualizar con Graphviz.

## Features

- Ingreso de expresiones regulares con validación y error en línea.
- Soporte para operadores: `|`, concatenación implícita, `*`, `+`, `?` y paréntesis.
- Visualizador interactivo de NFA y DFA.
- Alternancia entre vista NFA/DFA.
- Exportación y compartición del autómata en formato DOT.
- Arquitectura modular con separación clara entre presentación, lógica de negocio y datos.
- Cobertura de pruebas unitarias y de widgets.

## Installation

1. Clona el repositorio:

```bash
git clone <repositorio> traductores_proyecto_1
cd traductores_proyecto_1
```

2. Instala dependencias de Flutter:

```bash
flutter pub get
```

3. Si modificas las rutas o generas código nuevo, ejecuta:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Ejecuta la app:

```bash
flutter run
```

## Usage

- Ingresa una expresión regular válida en el campo de texto.
- Presiona `Generar` o envía el formulario.
- Cambia entre `NFA` y `DFA` usando el switch en la barra superior.
- Presiona el ícono de compartir para exportar el autómata en formato DOT.
- Usa `Limpiar` para restablecer el formulario y el estado.

### Comandos útiles

```bash
flutter run
flutter test
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Configuration

El proyecto usa Flutter SDK `>=3.2.3 <4.0.0` y depende de los siguientes paquetes principales:

- `auto_route` para navegación.
- `flutter_bloc` para estado.
- `fpdart` para manejo de resultados `Either`.
- `interactive_graph_view` para mostrar grafos de estado.
- `path_provider` y `share_plus` para compartir archivos DOT.
- `flutter_common_classes` como dependencia git para configuraciones y utilidades compartidas.

### Flavors

La aplicación inicializa `EnvironmentConfig` con `Flavor.production` en `lib/main.dart`.

No se requieren variables de entorno externas para ejecutar la aplicación localmente.

## Architecture

La aplicación sigue una organización por características y capas:

- `lib/main.dart`: punto de entrada y configuración de ambiente.
- `lib/traductores_proyecto_1_app.dart`: configuración de `MaterialApp` y router.
- `lib/core/routes`: definición de rutas de navegación.
- `lib/features/automaton`: funcionalidad principal de análisis y visualización de autómatas.
  - `presentation`: UI, widgets, páginas y cubit.
  - `business`: lógica de negocio, entidades y casos de uso.
  - `data`: parámetros y repositorios.

### Flujo principal

1. El usuario ingresa una expresión regular en `RegexInputBar`.
2. `AutomatonCubit.buildAutomaton()` ejecuta el pipeline:
   - análisis sintáctico con `AnalyzeRegex` y `RegexParser`.
   - construcción de NFA con `BuildNfa`.
   - conversión a DFA con `ConvertToDfa`.
   - cálculo de layout con `LayoutAutomaton`.
3. El resultado se visualiza en `AutomatonGraphView`.
4. `AutomatonCubit.generateDot()` crea la representación DOT para compartir.

## API Reference

### Clases principales

#### `TraductoresProyecto1App`

Entry point de la aplicación Flutter. Configura temas y router.

#### `AutomatonPage`

Página principal que provee `AutomatonCubit` y muestra `AutomatonView`.

#### `AutomatonCubit`

Principal controlador de estado:

- `void buildAutomaton(String rawRegex)` — construye el autómata desde la expresión regular.
- `void reset()` — restablece el estado al inicial.
- `Either<Failure, String> generateDot(AutomatonGraphEntity graph)` — genera DOT para un autómata.

#### `RegexParser`

Parser recursivo descendente para expresiones regulares.

- `RegexNode parse()` — parsea la lista de tokens producida por el lexer.

#### `AutomatonGraphEntity`

Modelo del grafo de autómata usado por la UI y el generador DOT.

- `AutomatonGraphEntity.nfa(...)`
- `AutomatonGraphEntity.dfa(...)`
- `bool get isNfa`
- `bool get isDfa`

### Flujo interno relevante

- `BuildNfa` — crea un NFA usando Thompson's Construction.
- `ConvertToDfa` — convierte un NFA a DFA mediante el algoritmo de subconjuntos.
- `LayoutAutomaton` — calcula las posiciones de los nodos para el renderizado.
- `GenerateDot` — exporta el grafo a un string DOT.

## Tests

El proyecto incluye pruebas unitarias y de widgets en `test/`:

- `test/compiler/parser/parser_precedence_test.dart`
- `test/compiler/semantic_analyzer_test.dart`
- `test/compiler/build_nfa_test.dart`
- `test/compiler/convert_to_dfa_test.dart`
- `test/compiler/layout_automaton_test.dart`
- `test/widgets/regex_input_bar_test.dart`

Ejecuta todas las pruebas con:

```bash
flutter test
```

## Contributing

1. Crea una rama con un nombre descriptivo.
2. Ejecuta `flutter pub get` y `flutter test` antes de enviar cambios.
3. Si agregas o modificas rutas generadas, ejecuta `flutter pub run build_runner build --delete-conflicting-outputs`.
4. Envía cambios mediante pull request con descripción clara y evidencia de pruebas.

## License

No se ha especificado una licencia en este repositorio. Añade un archivo `LICENSE` si deseas exponer la licencia oficial del proyecto.
