import 'package:flutter/material.dart';
import 'package:hevy_smolov_jr/widgets/warning_card.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openSmolovJrInfo() {
  return launchUrl(
    Uri.parse('https://www.smolovjr.com/smolov-squat-program/'),
    mode: LaunchMode.externalApplication,
  );
}

Future<void> _openHevyProSubscription() {
  return launchUrl(
    Uri.parse('https://hevy.com/settings?subscription'),
    mode: LaunchMode.externalApplication,
  );
}

/// Displays the content of the Introduction step.
class IntroStep extends StatelessWidget {
  /// Displays the content of the Introduction step.
  const IntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Welcome to the Smolov Jr to Hevy importer!',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text(
          'Smolov Jr is a specialized program '
          'that can put upwards of 20 lb/10 kg '
          'onto a lift of your choice in only 3 weeks. '
          'Although originally designed for squats, Smolov Jr has been known '
          'to also work well on a variety of other lifts.',
        ),
        const SizedBox(height: 16),
        const OutlinedButton(
          onPressed: _openSmolovJrInfo,
          child: Text('More Smolov Jr Information'),
        ),
        const SizedBox(height: 16),
        const Text(
          'This tool creates a folder of routines in your Hevy account '
          'with the exact loads to follow, '
          'saving you a lot of additional time and effort.',
        ),
        const SizedBox(height: 16),
        const WarningCard(
          title: 'Hevy Pro Required',
          details: "If you don't already have Hevy Pro, "
              'the lifetime plan is well worth it and supports the Hevy devs!',
          onPressed: _openHevyProSubscription,
        ),
      ],
    );
  }
}
