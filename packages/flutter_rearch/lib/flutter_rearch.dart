import 'package:flutter/widgets.dart';
import 'package:flutter_rearch/src/components.dart';
import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

export 'src/side_effects.dart';
export 'src/components.dart';

/// The API exposed to [RearchConsumer]s to extend their functionality.
///
/// New methods may be added to this interface on any new _minor_ release
/// (minor in terms of semver).
@experimental
abstract interface class WidgetSideEffectApi implements SideEffectApi {
  /// The [BuildContext] of the associated [RearchConsumer].
  BuildContext get context;

  /// Adds a deactivate lifecycle listener.
  void addDeactivateListener(SideEffectApiCallback callback);

  /// Removes the specified deactivate lifecycle listener.
  void removeDeactivateListener(SideEffectApiCallback callback);
}

/// Defines what a [WidgetSideEffect] should look like (a [Function]
/// that consumes a [WidgetSideEffectApi] and returns something).
///
/// If your side effect is more advanced or requires parameters,
/// simply make a callable class instead of just a regular [Function]!
typedef WidgetSideEffect<T> = T Function(WidgetSideEffectApi);

/// Represents an object that can [register] [WidgetSideEffect]s.
abstract interface class WidgetSideEffectRegistrar
    implements SideEffectRegistrar {
  @override
  T register<T>(WidgetSideEffect<T> sideEffect);
}

/// The [WidgetHandle] is to [Widget]s what a [CapsuleHandle] is to
/// [Capsule]s.
///
/// [WidgetHandle]s provide a mechanism to watch [Capsule]s and
/// register [SideEffect]s, so all Capsule-specific methodologies
/// carry over.
abstract interface class WidgetHandle
    implements CapsuleReader, WidgetSideEffectRegistrar {}
