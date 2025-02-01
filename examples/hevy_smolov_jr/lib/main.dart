import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hevy_smolov_jr/shared_prefs.dart';
import 'package:hevy_smolov_jr/smolov_jr_config/config.dart';
import 'package:hevy_smolov_jr/steps/api_key.dart';
import 'package:hevy_smolov_jr/steps/confirmation_creation.dart';
import 'package:hevy_smolov_jr/steps/exercise_selection.dart';
import 'package:hevy_smolov_jr/steps/intro.dart';
import 'package:hevy_smolov_jr/steps/program_config.dart';
import 'package:rearch/rearch.dart';

void main() {
  runApp(const HevySmolovJrApp());
}

/// Represents the root of the application.
class HevySmolovJrApp extends StatelessWidget {
  /// Represents the root of the application.
  const HevySmolovJrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RearchBootstrapper(
      child: MaterialApp(
        title: 'Smolov Jr Calculator for Hevy',
        theme: ThemeData(colorSchemeSeed: Colors.deepPurpleAccent),
        home: const SharedPrefsWarmUp(child: HomePage()),
      ),
    );
  }
}

/// Displays the home page of the application.
class HomePage extends RearchConsumer {
  /// Displays the home page of the application.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final currStep = use.data(0);
    final steps = [
      Step(
        title: const Text('Introduction'),
        content: const IntroStep(),
        isActive: currStep.value == 0,
      ),
      Step(
        title: const Text('API Key'),
        content: const ApiKeyInputStep(),
        isActive: currStep.value == 1,
      ),
      Step(
        title: const Text('Exercise Selection'),
        content: const ExerciseSelectionStep(),
        isActive: currStep.value == 2,
      ),
      Step(
        title: const Text('Program Configuration'),
        content: const ProgramConfigInputStep(),
        isActive: currStep.value == 3,
      ),
      Step(
        title: const Text('Confirmation & Creation'),
        content: const ConfirmationAndCreationStep(),
        isActive: currStep.value == 4,
      ),
    ];
    final isFirstStep = currStep.value == 0;
    final isLastStep = currStep.value == steps.length - 1;

    return Scaffold(
      body: SmolovJrConfigInjection(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Stepper(
              steps: steps,
              currentStep: currStep.value,
              onStepTapped: currStep.$2,
              onStepCancel: isFirstStep ? null : () => currStep.value--,
              onStepContinue: isLastStep ? null : () => currStep.value++,
              controlsBuilder: _stepperControlsBuilder,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _stepperControlsBuilder(BuildContext context, ControlsDetails details) {
  final ControlsDetails(:stepIndex, :onStepContinue, :onStepCancel) = details;
  const numSteps = 5;
  final isFirstStep = stepIndex == 0;
  final isLastStep = stepIndex == numSteps - 1;
  final theme = Theme.of(context);

  return ElevatedButtonTheme(
    data: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          if (!isFirstStep) ...[
            TextButton(
              onPressed: onStepCancel,
              child: const Text('Go Back'),
            ),
            const SizedBox(width: 16),
          ],
          if (!isLastStep)
            ElevatedButton.icon(
              onPressed: onStepContinue,
              label: const Text('Continue'),
            ),
          if (isLastStep) const SaveProgramButton(),
        ],
      ),
    ),
  );
}
