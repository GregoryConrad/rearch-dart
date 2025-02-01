import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hevy_smolov_jr/api/wrapped_hevy_api.dart';
import 'package:hevy_smolov_jr/smolov_jr_config/config.dart';
import 'package:rearch/rearch.dart';

/// Displays the confirmation and creation step contents.
class ConfirmationAndCreationStep extends StatelessWidget {
  /// Displays the confirmation and creation step contents.
  const ConfirmationAndCreationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final smolovJrConfig = SmolovJrConfigInjection.of(context).value;
    if (smolovJrConfig.exercise == null) {
      return const Text('Select an exercise in the previous step to continue');
    }
    final (:programName, :routines) = smolovJrConfig.toProgram();
    return Column(
      children: [
        Text(programName, style: Theme.of(context).textTheme.titleMedium),
        for (final routine in routines)
          Builder(
            builder: (context) {
              var routineText = routine.title;
              if (routine.notes != null) routineText += ' (${routine.notes})';
              return Text(routineText);
            },
          ),
      ],
    );
  }
}

/// Displays an animated button that saves the current [SmolovJrConfig]
/// to the user's Hevy account.
class SaveProgramButton extends RearchConsumer {
  /// Displays an animated button that saves the current [SmolovJrConfig]
  /// to the user's Hevy account.
  const SaveProgramButton({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (:mutate, :state, clear: _) = use.mutation<void>();
    final config = SmolovJrConfigInjection.of(context).value;
    final rawCreateProgram = use(createProgramAction);
    final createProgram = use.memo(
      () {
        if (config.exercise == null) return null;
        final (:programName, :routines) = config.toProgram();
        return () => mutate(
              rawCreateProgram(programName: programName, routines: routines),
            );
      },
      [config, rawCreateProgram],
    );
    if (state is AsyncError) {
      log('Error saving program: ${state.error}\n${state.stackTrace}');
    }

    return switch (state) {
      AsyncLoading<void>() => ElevatedButton.icon(
          icon: const CircularProgressIndicator(),
          onPressed: null,
          label: const Text('Save Program'),
        ),
      AsyncError<void>() => ElevatedButton.icon(
          icon: const Icon(Icons.error),
          onPressed: createProgram,
          label: const Text('Retry Save Program'),
        ),
      AsyncData<void>() => ElevatedButton.icon(
          icon: const Icon(Icons.check),
          onPressed: createProgram,
          label: const Text('Save Program'),
        ),
      null => ElevatedButton.icon(
          icon: const Icon(Icons.save),
          onPressed: createProgram,
          label: const Text('Save Program'),
        ),
    };
  }
}
