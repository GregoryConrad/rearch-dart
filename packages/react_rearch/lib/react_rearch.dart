import 'package:meta/meta.dart';
import 'package:rearch/rearch.dart';

export 'src/components.dart';
export 'src/side_effects.dart';

/// The API exposed to [RearchConsumer]s to extend their functionality.
///
/// New methods may be added to this interface on any new _minor_ release
/// (minor in terms of semver).
@experimental
abstract interface class ComponentSideEffectApi implements SideEffectApi {
  /// Adds a deactivate lifecycle listener.
  // void addDeactivateListener(SideEffectApiCallback callback);

  /// Removes the specified deactivate lifecycle listener.
  // void removeDeactivateListener(SideEffectApiCallback callback);
}

/// Defines what a [ComponentSideEffect] should look like (a [Function]
/// that consumes a [ComponentSideEffectApi] and returns something).
///
/// If your side effect is more advanced or requires parameters,
/// simply make a callable class instead of just a regular [Function]!
typedef ComponentSideEffect<T> = T Function(ComponentSideEffectApi);

/// Represents an object that can [register] [ComponentSideEffect]s.
abstract interface class ComponentSideEffectRegistrar
    implements SideEffectRegistrar {
  @override
  T register<T>(ComponentSideEffect<T> sideEffect);
}

/// The [ComponentHandle] is to [Widget]s what a [CapsuleHandle] is to
/// [Capsule]s.
///
/// [ComponentHandle]s provide a mechanism to watch [Capsule]s and
/// register [SideEffect]s, so all Capsule-specific methodologies
/// carry over.
abstract interface class ComponentHandle
    implements CapsuleReader, ComponentSideEffectRegistrar {}
