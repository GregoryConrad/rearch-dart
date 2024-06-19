part of '../side_effects.dart';

// See https://github.com/flutter/flutter/issues/123712
class _CustomKeepAliveHandle with ChangeNotifier {
  void removeKeepAlive() => super.notifyListeners();
}

void _automaticKeepAlive(
  WidgetSideEffectRegistrar use, {
  bool keepAlive = true,
}) {
  final api = use.api();

  final handle = use.disposable(_CustomKeepAliveHandle.new, (h) => h.dispose());

  // Tracks whether or not we need to request/remove a keep alive
  // (if there's no change, there's nothing to do).
  // NOTE: this would make use of use.data,
  // but that'd trigger markNeedsBuild() in deactivate,
  // which then throws an assert.
  // See: https://github.com/GregoryConrad/rearch-dart/issues/199
  final lastKnownState = use.callonce(() {
    var value = false;
    return (() => value, (bool newValue) => value = newValue);
  });

  void requestKeepAliveIfNeeded() {
    if (lastKnownState.value) return;
    lastKnownState.value = true;
    KeepAliveNotification(handle).dispatch(api.context);
  }

  void removeKeepAliveIfNeeded() {
    if (!lastKnownState.value) return;
    lastKnownState.value = false;
    handle.removeKeepAlive();
  }

  // Remove keep alives on deactivate to prevent leaks per documentation
  use.effect(() {
    api.addDeactivateListener(removeKeepAliveIfNeeded);
    return () => api.removeDeactivateListener(removeKeepAliveIfNeeded);
  });

  // Request/remove the keep alive as necessary
  if (keepAlive) {
    requestKeepAliveIfNeeded();
  } else {
    removeKeepAliveIfNeeded();
  }
}
