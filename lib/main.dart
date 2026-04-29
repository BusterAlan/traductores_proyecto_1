import "package:flutter/material.dart";
import "package:flutter_common_classes/config/environment_config.dart";

import "traductores_proyecto_1_app.dart";

void main() async {
  EnvironmentConfig.init(
    flavor: Flavor.production,
  );

  runApp(const TraductoresProyecto1App());
}
