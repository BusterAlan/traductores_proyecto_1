import "package:flutter/material.dart";
import "package:flutter_flavor/flutter_flavor.dart";

import "core/routes/app_router.dart";
import "core/theme/material_theme.dart";
import "core/theme/util.dart";

final _appRouter = AppRouter();   

/// [TraductoresProyecto1App] is the entry point of the application.
class TraductoresProyecto1App extends StatelessWidget {
  /// [TraductoresProyecto1App] is the entry point of the application.
  const TraductoresProyecto1App({super.key});

  @override
  Widget build(BuildContext context) =>
     FlavorBanner(
      child: MaterialApp.router(
        title: "TraductoresProyecto1",
        debugShowCheckedModeBanner: false,

        //Theming  
        themeMode: ThemeMode.system,
            theme: MaterialTheme(createTextTheme(context, "Poppins", "Poppins"),)
                .light(),
            darkTheme:
                MaterialTheme(createTextTheme(context, "Poppins", "Poppins"),)
                    .dark(),


        routerConfig: _appRouter.config(),
      ),
    );
}
