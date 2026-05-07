# Visualizador de Autómatas Finitos

> **Proyecto de Traductores (Ingeniería en Sistemas Computacionales)**  
> Universidad de Montemorelos · Mayo 2026

Aplicación Flutter que convierte expresiones regulares en autómatas finitos (NFA y DFA) y los visualiza de forma interactiva. Implementa el pipeline clásico de compiladores: análisis léxico → análisis sintáctico → análisis semántico → Construcción de Thompson → Construcción de Subconjuntos.

---

## Contenido

- [¿Qué hace?](#qué-hace)
- [Pipeline interno](#pipeline-interno)
- [Operadores soportados](#operadores-soportados)
- [Instalación](#instalación)
- [Uso](#uso)
- [Arquitectura](#arquitectura)
- [API Reference](#api-reference)
- [Pruebas](#pruebas)
- [Áreas de mejora](#áreas-de-mejora)
- [Dependencias](#dependencias)

---

## ¿Qué hace?

1. Recibes una expresión regular como `(a|b)*abb`
2. El compilador interno la tokeniza, la parsea y construye un AST
3. Se construye el **NFA** con el algoritmo de Thompson
4. El NFA se convierte al **DFA** equivalente por construcción de subconjuntos
5. Ambos grafos se muestran de forma **interactiva** en pantalla
6. Puedes **exportar el grafo en formato DOT** para usarlo con Graphviz

---

## Pipeline interno

```
String (expresión regular)
        │
        ▼
   RegexLexer              →  List<Token>
        │
        ▼
   RegexParser             →  RegexNode (AST)
        │
        ▼
RegexSemanticAnalyzer      →  RegexSemanticAnalysis
        │                     (alfabeto, firstpos, lastpos, followpos)
        ▼
     BuildNfa              →  AutomatonGraphEntity (NFA)
        │
        ▼
   ConvertToDfa            →  AutomatonGraphEntity (DFA)
        │
        ▼
  LayoutAutomaton          →  Map<String, Offset> (coordenadas 2D por BFS)
        │
        ▼
AutomatonGraphView         →  Visualización interactiva
```

---

## Operadores soportados

| Operador | Símbolo | Ejemplo | Significado |
|---|---|---|---|
| Unión | `\|` | `a\|b` | `a` o `b` |
| Concatenación | implícita | `ab` | `a` seguido de `b` |
| Kleene star | `*` | `a*` | cero o más `a` |
| Cerradura positiva | `+` | `a+` | una o más `a` |
| Opcionalidad | `?` | `a?` | cero o una `a` |
| Agrupación | `()` | `(a\|b)*` | subexpresión |

> **Limitaciones actuales:** no se soportan rangos `[a-z]`, clases POSIX (`\d`, `\w`), escape de metacaracteres (`\*`) ni el punto (`.`) como "cualquier carácter". Ver [Áreas de mejora](#áreas-de-mejora).

---

## Instalación

### Requisitos

- Flutter SDK `>=3.35.6`
- Dart SDK `>=3.9.0`

### Pasos

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio> traductores_proyecto_1
cd traductores_proyecto_1

# 2. Instalar dependencias
flutter pub get

# 3. Generar código de rutas (auto_route)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar la aplicación
flutter run
```

---

## Uso

1. Escribe una expresión regular en el campo de texto (ej: `(a|b)*abb`)
2. Presiona **Generar** o envía con Enter
3. Usa el switch **NFA / DFA** en la barra superior para alternar entre vistas
4. Presiona el ícono de compartir para exportar el autómata en formato DOT
5. Presiona **Limpiar** para restablecer

### Ejemplos para sugeridos para probar

```
(a|b)*abb       → Caso clásico del Dragon Book — 5 estados DFA
a+b*c?          → Concatenación con los tres operadores unarios
(0|1)*101       → Binarios que terminan en 101
a**             → Error controlado: operador doble rechazado
```

### Exportación DOT

El archivo `.dot` exportado se puede visualizar con:

```bash
# Con Graphviz instalado localmente
dot -Tpng automaton_dfa.dot -o automaton_dfa.png

# En línea (sin instalación)
# https://dreampuf.github.io/GraphvizOnline
```

---

## Arquitectura

El proyecto sigue **Clean Architecture** organizada por features:

```
lib/
├── main.dart                          # Punto de entrada y flavor
├── traductores_proyecto_1_app.dart    # MaterialApp + router
├── core/
│   ├── errors/     # AppException, Failure, LanguageFailures
│   ├── routes/     # AppRouter (auto_route)
│   └── theme/      # MaterialTheme
└── features/
    └── automaton/
        ├── business/
        │   ├── compiler/
        │   │   ├── ast/        # RegexNode, CharNode, ConcatNode...
        │   │   ├── lexer/      # RegexLexer, Token, TokenType
        │   │   ├── parser/     # RegexParser (recursivo descendente)
        │   │   └── semantic/   # RegexSemanticAnalyzer
        │   ├── entities/       # NfaStateEntity, DfaStateEntity, TransitionEntity...
        │   ├── repositories/   # AutomatonRepository (interfaz)
        │   └── use_cases/      # AnalyzeRegex, BuildNfa, ConvertToDfa,
        │                       # GenerateDot, LayoutAutomaton
        ├── data/
        │   ├── data_sources/   # AutomatonLocalDataSource
        │   ├── models/         # DTOs y Params
        │   └── repositories/   # AutomatonRepositoryImpl
        └── presentation/
            ├── cubits/         # AutomatonCubit (BLoC)
            ├── pages/          # AutomatonPage
            └── widgets/
                ├── views/      # AutomatonView, AutomatonGraphView,
                │               # ErrorView, PlaceholderView
                ├── components/ # RegexInputBar
                └── mixins/     # AutomatonGraphMixin

test/
├── compiler/
│   ├── parser/parser_precedence_test.dart
│   ├── build_nfa_test.dart
│   ├── convert_to_dfa_test.dart
│   ├── layout_automaton_test.dart
│   └── semantic_analyzer_test.dart
└── widgets/
    └── regex_input_bar_test.dart
```

### Separación por capas

| Capa | Responsabilidad | Depende de Flutter |
|---|---|---|
| Dominio (`business/`) | Lógica pura, entidades, use cases, compilador | ❌ No |
| Datos (`data/`) | Repositorios, DTOs, fuentes de datos | Mínimo |
| Presentación (`presentation/`) | UI, widgets, Cubit | ✅ Sí |

El compilador vive completamente en la capa de dominio y puede probarse sin instanciar ningún widget.

### Flujo principal

1. El usuario ingresa una expresión regular en `RegexInputBar`
2. `AutomatonCubit.buildAutomaton()` ejecuta el pipeline secuencial de use cases
3. El resultado se visualiza en `AutomatonGraphView`
4. `AutomatonCubit.generateDot()` genera la representación DOT para compartir

---

## API Reference

### `AutomatonCubit`

Controlador principal de estado. Orquesta el pipeline completo.

```dart
// Ejecuta el pipeline completo: regex → NFA → DFA → offsets
void buildAutomaton(String rawRegex)

// Restablece al estado inicial
void reset()

// Genera el string DOT para el autómata dado
Either<Failure, String> generateDot(AutomatonGraphEntity graph)
```

**Estados emitidos:** `StateMixin.initial` · `StateMixin.loading` · `StateMixin.success` · `StateMixin.failure`

---

### `RegexParser`

Parser recursivo descendente. Implementa la gramática:

```
expression  →  term ( '|' term )*
term        →  factor ( factor )*
factor      →  primary ( '*' | '+' | '?' )?
primary     →  CHAR | '(' expression ')'
```

```dart
// Recibe tokens del lexer y retorna el AST
// Lanza FormatException ante sintaxis inválida
RegexNode parse()
```

---

### `AutomatonGraphEntity`

Modelo del grafo consumido por la UI y el generador DOT.

```dart
AutomatonGraphEntity.nfa({ initialStateId, acceptingStateIds, alphabet, nfaStates })
AutomatonGraphEntity.dfa({ initialStateId, acceptingStateIds, alphabet, dfaStates })

bool get isNfa
bool get isDfa
Set<String> get allStateIds
```

---

### Use cases del compilador

| Use case | Entrada | Salida |
|---|---|---|
| `AnalyzeRegex` | `ParseRegexParams(rawRegex)` | `Either<LanguageFailure, RegexSemanticAnalysis>` |
| `BuildNfa` | `BuildNfaParams(expression, ast)` | `Either<LanguageFailure, AutomatonGraphEntity>` |
| `ConvertToDfa` | `ConvertToDfaParams(graph)` | `Either<DfaConversionFailure, AutomatonGraphEntity>` |
| `GenerateDot` | `GenerateDotParams(graph)` | `Either<DotGenerationFailure, String>` |
| `LayoutAutomaton` | `LayoutAutomatonParams(graph)` | `Either<DotGenerationFailure, Map<String, Offset>>` |

Todos los use cases retornan `Either<Failure, T>` — nunca lanzan excepciones directamente a la capa de presentación.

---

## Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Una suite específica
flutter test test/compiler/convert_to_dfa_test.dart

# Con output detallado
flutter test --reporter expanded
```

### Cobertura actual

| Archivo | Componente | Aspectos cubiertos |
|---|---|---|
| `parser_precedence_test.dart` | `RegexParser` | Precedencia, asociatividad izquierda, errores sintácticos |
| `build_nfa_test.dart` | `BuildNfa` | Estructura NFA por tipo de nodo, caso Dragon Book |
| `convert_to_dfa_test.dart` | `ConvertToDfa` | Aceptación de cadenas, 5 estados para `(a|b)*abb` |
| `layout_automaton_test.dart` | `LayoutAutomaton` | Cobertura de offsets, spacing, unicidad de posiciones |
| `semantic_analyzer_test.dart` | `RegexSemanticAnalyzer` | nullable, followpos, firstpos/lastpos |
| `regex_input_bar_test.dart` | `RegexInputBar` | Auto-cierre de paréntesis, render, botón limpiar |

> ⚠️ `test/widget_test.dart` es el placeholder generado por `flutter create` — busca un contador que no existe. Debe reemplazarse por un test de integración real de la pantalla principal.

---

## Áreas de mejora

### Funcionalidades pendientes

- **Minimización del DFA** — aplicar el algoritmo de Hopcroft para reducir estados equivalentes
- **Rangos de caracteres** — soporte para `[a-z]`, `[0-9]` en el Lexer
- **Escape de metacaracteres** — reconocer `\*`, `\(`, etc. como literales
- **Punto como metacarácter** — `.` debería representar "cualquier carácter del alfabeto"
- **Simulación paso a paso** — ingresar una cadena y ver el recorrido de estados resaltado visualmente
- **Método directo de construcción de DFA** — usar la tabla `followpos` del análisis semántico para construir el DFA sin pasar por NFA

### Deuda técnica

- `AutomatonLocalDataSource` tiene interfaz e implementación vacías — remover si no hay persistencia planificada
- `error_handler.dart` importa `CacheException` pero no se usa en ningún flujo activo
- `pubspec.yaml` declara `sdk: ">=3.2.3"` pero el lockfile requiere `>=3.9.0` — alinear la restricción

---

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| `flutter_bloc` | 9.1.1 | Gestión de estado (AutomatonCubit) |
| `fpdart` | 1.2.0 | Manejo funcional de errores (`Either`) |
| `auto_route` | 9.3.0 | Navegación declarativa |
| `equatable` | 2.0.8 | Comparación estructural de entidades |
| `interactive_graph_view` | 0.3.0+1 | Visualización interactiva del grafo |
| `google_fonts` | 6.3.3 | Tipografía Poppins |
| `share_plus` | 12.0.2 | Exportación del archivo DOT |
| `path_provider` | 2.1.5 | Directorio temporal para el archivo DOT |
| `flutter_common_classes` | 1.0.21 (git) | UseCase, Params, Failure, StateMixin |

---

## Contribuir

1. Crea una rama con nombre descriptivo (`feature/minimizacion-dfa`, `fix/lexer-rangos`)
2. Ejecuta `flutter pub get` y `flutter test` antes de enviar cambios
3. Si modificas rutas o generas código: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Envía un pull request con descripción clara y evidencia de pruebas

---

## Configuración de flavor

La app inicializa `EnvironmentConfig` con `Flavor.production` en `lib/main.dart`. No se requieren variables de entorno externas para ejecutar localmente.
