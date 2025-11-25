import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_rearch_example/capsules/filter_capsule.dart';

/// {@template CustomSearchBar}
/// Displays the search bar at the top of the application
/// and mutates the [filterCapsule].
/// {@endtemplate}
class CustomSearchBar extends RearchConsumer {
  /// {@macro CustomSearchBar}
  const CustomSearchBar({required this.close, super.key});

  /// Callback that will close the search bar.
  final void Function() close;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final textController = use.textEditingController();

    final (filter: _, :setQueryString, toggleCompletionStatus: _) = use(
      filterCapsule,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: TextField(
        controller: textController,
        onChanged: setQueryString,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.cancel_rounded),
                onPressed: () {
                  if (textController.text != '') {
                    textController.text = '';
                    setQueryString('');
                  } else {
                    close();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
