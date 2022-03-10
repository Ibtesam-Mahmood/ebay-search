
import 'dart:math';

import 'package:flutter/animation.dart';

/// Helper for animated over the end of an animation
class AnimationOverLast<T extends double> extends Animation<T> with AnimationWithParentMixin<T> {

  ///The minimum value
  final T last;

  ///The parent
  @override
  final Animation<T> parent;

  /// Creates an [AnimationOverLast].
  ///
  /// Both arguments must be non-null. Either can be an [AnimationOverLast] itself
  /// to combine multiple animations.
  AnimationOverLast(this.parent, this.last) : assert(last != null && last < 1.0), assert(parent != null);

  @override
  T get value{
    Object output = (parent.value - (1.0 - last)) / (last);
    return max((0.0 as T), output as T);
  }
}

/// Helper for animated over the start of an animation
class AnimationOverFirst<T extends double> extends Animation<T> with AnimationWithParentMixin<T> {

  ///The minimum value
  final T first;

  ///The parent
  @override
  final Animation<T> parent;

  /// Creates an [AnimationOverFirst].
  ///
  /// Both arguments must be non-null. Either can be an [AnimationOverFirst] itself
  /// to combine multiple animations.
  AnimationOverFirst(this.parent, this.first) : assert(first != null && first < 1.0), assert(parent != null);

  @override
  T get value{
    Object output = parent.value / first;
    return min((1.0 as T), output as T);
  }
}