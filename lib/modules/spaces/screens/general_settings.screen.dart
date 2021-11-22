import 'package:flutter/material.dart';
import 'package:demos_app/config/themes/cubit/theme_cubit.dart';
import 'package:demos_app/widgets/scaffolds/demos_scaffold.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return DemosScaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Column(children: [
        SwitchListTile(
            secondary: Icon(Icons.dark_mode_sharp),
            title: Text('Modo oscuro'),
            value: themeCubit.isDark,
            onChanged: (v) => themeCubit.toggleTheme())
      ]),
    );
  }
}
