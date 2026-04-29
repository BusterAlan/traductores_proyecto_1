import "dart:convert";

/// Model that transforms the Automaton data from the API to the
/// application entity
class AutomatonModel {
  /// Model that transforms the Automaton data from the API to the
  /// application entity
  // const AutomatonModel();

  /*
  The model is responsible for converting the data into a format that the rest of the application can use. 
  This could involve deserializing JSON from an API into objects, or mapping database rows to objects.
  */

  /// Factory method to create a Home model instance from a JSON
  // factory AutomatonModel.fromJson({required String json}) => AutomatonModel.fromMap(map: jsonDecode(json));

  /// Factory method to create a Automaton model instance from a map
  // factory AutomatonModel.fromMap() => const AutomatonModel();

  /// Factory method to create a Automaton model instance from an
  /// entity
  // factory AutomatonModel.fromEntity() => const AutomatonModel();

  /// Converts the Automaton model instance to a map
  Map<String, dynamic> toMap() => {};

  /// Converts the Home model instance to a JSON
  String toJson() => jsonEncode(toMap());

  /// Converts the Automaton model instance to an entity
  // AutomatonGraphEntity toEntity() => const AutomatonGraphEntity();
}
