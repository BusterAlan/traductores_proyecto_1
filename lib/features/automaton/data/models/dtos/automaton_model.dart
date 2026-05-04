import "../../../business/entities/automaton_graph_entity.dart";
import "../../../business/entities/dfa_state_entity.dart";
import "../../../business/entities/nfa_state_entity.dart";
import "../../../business/entities/transition_entity.dart";

/// DTO para representar un autómata (NFA o DFA) en almacenamiento.
class AutomatonModel {
  /// Constructor del modelo de autómata.
  AutomatonModel({
    required this.type,
    required this.initialStateId,
    required this.acceptingStateIds,
    required this.alphabet,
    required this.nfaStates,
    required this.dfaStates,
  });

  /// Crea un modelo desde JSON.
  factory AutomatonModel.fromJson(Map<String, dynamic> json) => AutomatonModel(
        type: json["type"] as String? ?? "NFA",
        initialStateId: json["initialStateId"] as String? ?? "",
        acceptingStateIds: List<String>.from(
          json["acceptingStateIds"] as List<dynamic>? ?? [],
        ),
        alphabet: List<String>.from(
          json["alphabet"] as List<dynamic>? ?? [],
        ),
        nfaStates:
            (json["nfaStates"] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
        dfaStates:
            (json["dfaStates"] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      );

  /// Crea un modelo desde la entidad de negocio.
  factory AutomatonModel.fromEntity(AutomatonGraphEntity entity) =>
      AutomatonModel(
        type: entity.isNfa ? "NFA" : "DFA",
        initialStateId: entity.initialStateId,
        acceptingStateIds: entity.acceptingStateIds.toList(),
        alphabet: entity.alphabet.toList(),
        nfaStates: entity.isNfa
            ? entity.nfaStates
                .map(
                  (state) => {
                    "id": state.id,
                    "isAccepting": state.isAccepting,
                    "transitions": state.transitions
                        .map(
                          (t) => {
                            "fromStateId": t.fromStateId,
                            "toStateId": t.toStateId,
                            "symbol": t.symbol,
                          },
                        )
                        .toList(),
                  },
                )
                .toList()
            : null,
        dfaStates: !entity.isNfa
            ? entity.dfaStates
                .map(
                  (state) => {
                    "id": state.id,
                    "isAccepting": state.isAccepting,
                    "nfaStateIds": state.nfaStateIds.toList(),
                    "transitions": state.transitions
                        .map(
                          (t) => {
                            "fromStateId": t.fromStateId,
                            "toStateId": t.toStateId,
                            "symbol": t.symbol,
                          },
                        )
                        .toList(),
                  },
                )
                .toList()
            : null,
      );

  /// Tipo: "NFA" o "DFA".
  final String type;

  /// ID del estado inicial.
  final String initialStateId;

  /// IDs de los estados aceptantes.
  final List<String> acceptingStateIds;

  /// Alfabeto del autómata.
  final List<String> alphabet;

  /// Estados NFA (solo si type == "NFA").
  final List<Map<String, dynamic>>? nfaStates;

  /// Estados DFA (solo si type == "DFA").
  final List<Map<String, dynamic>>? dfaStates;

  /// Convierte el modelo a JSON.
  Map<String, dynamic> toJson() => {
        "type": type,
        "initialStateId": initialStateId,
        "acceptingStateIds": acceptingStateIds,
        "alphabet": alphabet,
        if (nfaStates != null) "nfaStates": nfaStates,
        if (dfaStates != null) "dfaStates": dfaStates,
      };

  /// Convierte el modelo a entidad de negocio.
  AutomatonGraphEntity toEntity() {
    if (type == "NFA" && nfaStates != null) {
      final states = (nfaStates ?? [])
          .map(
            (stateJson) => NfaStateEntity(
              id: stateJson["id"] as String? ?? "",
              isAccepting: stateJson["isAccepting"] as bool? ?? false,
              transitions: (stateJson["transitions"] as List<dynamic>? ?? [])
                  .cast<Map<String, dynamic>>()
                  .map(
                    (tJson) => TransitionEntity(
                      fromStateId: tJson["fromStateId"] as String? ?? "",
                      toStateId: tJson["toStateId"] as String? ?? "",
                      symbol: tJson["symbol"] as String?,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      return AutomatonGraphEntity.nfa(
        initialStateId: initialStateId,
        acceptingStateIds: acceptingStateIds.toSet(),
        alphabet: alphabet.toSet(),
        nfaStates: states,
      );
    } else if (type == "DFA" && dfaStates != null) {
      final states = (dfaStates ?? [])
          .map(
            (stateJson) => DfaStateEntity(
              id: stateJson["id"] as String? ?? "",
              isAccepting: stateJson["isAccepting"] as bool? ?? false,
              nfaStateIds: (stateJson["nfaStateIds"] as List<dynamic>? ?? [])
                  .cast<String>()
                  .toSet(),
              transitions: (stateJson["transitions"] as List<dynamic>? ?? [])
                  .cast<Map<String, dynamic>>()
                  .map(
                    (tJson) => TransitionEntity(
                      fromStateId: tJson["fromStateId"] as String? ?? "",
                      toStateId: tJson["toStateId"] as String? ?? "",
                      symbol: tJson["symbol"] as String?,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      return AutomatonGraphEntity.dfa(
        initialStateId: initialStateId,
        acceptingStateIds: acceptingStateIds.toSet(),
        alphabet: alphabet.toSet(),
        dfaStates: states,
      );
    }

    // Fallback: retornar un autómata vacío.
    // Usamos el constructor NFA porque todos los campos NFA están disponibles.
    return AutomatonGraphEntity.nfa(
      initialStateId: initialStateId,
      acceptingStateIds: acceptingStateIds.toSet(),
      alphabet: alphabet.toSet(),
      nfaStates: const [],
    );
  }
}
