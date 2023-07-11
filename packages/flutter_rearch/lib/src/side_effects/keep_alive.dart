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

  final handle = use.memo(_CustomKeepAliveHandle.new);
  use.effect(() => handle.dispose, [handle]);

  // Dirty tracks whether or not we will need to request a new keep alive
  // in case keepAlive == true
  final (getDirty, setDirty) = use.rawValueWrapper(() => true);
  final requestKeepAlive = use.memo(
    () => () {
      // It is only safe to dispatch a notification when dirty is true
      if (getDirty()) {
        setDirty(false);
        KeepAliveNotification(handle).dispatch(api.context);
      }
    },
    [getDirty, setDirty, handle, api.context],
  );
  final removeKeepAlive = use.memo(
    () => () {
      // It is always safe to remove keep alives
      handle.removeKeepAlive();
      setDirty(true);
    },
    [handle, setDirty],
  );

  // Remove keep alives on deactivate to prevent leaks per documentation
  use.effect(
    () {
      api.addDeactivateListener(removeKeepAlive);
      return () => api.removeDeactivateListener(removeKeepAlive);
    },
    [api, removeKeepAlive],
  );

  // Request/remove the keep alive as necessary
  if (keepAlive) {
    requestKeepAlive();
  } else {
    removeKeepAlive();
  }
}
