import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:hevy_smolov_jr/api/raw_hevy_api.dart';
import 'package:hevy_smolov_jr/widgets/warning_card.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openHevySettings() {
  return launchUrl(
    Uri.parse('https://hevy.com/settings?developer'),
    mode: LaunchMode.externalApplication,
  );
}

Future<void> _openSourceCode() {
  return launchUrl(
    Uri.parse(
      'https://github.com/GregoryConrad/rearch-dart/tree/main/examples/hevy_smolov_jr',
    ),
    mode: LaunchMode.externalApplication,
  );
}

/// The Hevy API key input step that requests the user's API key.
class ApiKeyInputStep extends RearchConsumer {
  /// The Hevy API key input step that requests the user's API key.
  const ApiKeyInputStep({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (apiKey, setApiKey) = use(apiKeyCapsule);
    return Column(
      children: [
        const Text('Please input your Hevy API key below.'),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextFormField(
            initialValue: apiKey,
            onChanged: setApiKey,
            decoration: const InputDecoration(
              hintText: 'Hevy API Key',
              suffixIcon: IconButton(
                icon: Icon(Icons.help_rounded),
                onPressed: _openHevySettings,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const WarningCard(
          title: 'Be careful with whom you give your API key!',
          details:
              'Someone can use your API key to act on your behalf in Hevy. '
              'In the interest of transparency, '
              'click here to view the source code of this tool.',
          onPressed: _openSourceCode,
        ),
      ],
    );
  }
}
