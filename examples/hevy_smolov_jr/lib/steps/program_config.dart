import 'package:flutter/material.dart';
import 'package:hevy_smolov_jr/smolov_jr_config/config.dart';
import 'package:rearch/experimental.dart';
import 'package:rearch/rearch.dart';

/// Displays the program configuration step/
class ProgramConfigInputStep extends StatelessWidget {
  /// Displays the program configuration step/
  const ProgramConfigInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    final smolovJrConfig = ScopedSmolovJrConfig.of(context);
    return Column(
      children: [
        Row(
          children: [
            const Text('Rest Between Sets'),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: smolovJrConfig.value.restSeconds.toString(),
                onChanged: (s) => smolovJrConfig.updateWith(
                  (config) => config.copyWith(restSeconds: int.tryParse(s)),
                ),
                decoration: const InputDecoration(
                  hintText: 'rest',
                  suffixIcon: Text('seconds'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Unit'),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownMenu(
                initialSelection: smolovJrConfig.value.unit,
                onSelected: (unit) {
                  if (unit == null) return;
                  smolovJrConfig.updateWith((c) => c.copyWith(unit: unit));
                },
                dropdownMenuEntries: [
                  for (final unit in WeightUnit.values)
                    DropdownMenuEntry(
                      value: unit,
                      label: unit.name,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Weekly Increment'),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: smolovJrConfig.value.increment.toString(),
                onChanged: (s) => smolovJrConfig.updateWith(
                  (config) => config.copyWith(increment: num.parse(s)),
                ),
                decoration: InputDecoration(
                  hintText: 'weight',
                  suffixIcon: Text(smolovJrConfig.value.unit.name),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('1RM'),
            if (smolovJrConfig.value.isBodyWeight)
              const Text(' (Excluding Body Weight)'),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: smolovJrConfig.value.oneRepMax.toString(),
                onChanged: (s) => smolovJrConfig.updateWith(
                  (config) => config.copyWith(oneRepMax: num.parse(s)),
                ),
                decoration: InputDecoration(
                  hintText: 'weight',
                  suffixIcon: Text(smolovJrConfig.value.unit.name),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (smolovJrConfig.value.isBodyWeight)
          Row(
            children: [
              const Text('Body Weight'),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  initialValue: smolovJrConfig.value.bodyWeight.toString(),
                  onChanged: (s) => smolovJrConfig.updateWith(
                    (config) => config.copyWith(bodyWeight: num.parse(s)),
                  ),
                  decoration: InputDecoration(
                    hintText: 'weight',
                    suffixIcon: Text(smolovJrConfig.value.unit.name),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
