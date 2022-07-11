import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../../auto_route.dart';

@immutable
class RouteMatch {
  final Parameters pathParams;
  final Parameters queryParams;
  final List<RouteMatch>? children;
  final String fragment;
  final List<String> segments;
  final String? redirectedFrom;
  final String name;
  final String path;
  final String stringMatch;
  final Object? args;
  final List<AutoRouteGuard> guards;
  final LocalKey key;
  final bool isBranch;

  const RouteMatch({
    required this.name,
    required this.segments,
    required this.path,
    required this.stringMatch,
    required this.key,
    this.isBranch = false,
    this.children,
    this.args,
    this.guards = const [],
    this.pathParams = const Parameters({}),
    this.queryParams = const Parameters({}),
    this.fragment = '',
    this.redirectedFrom,
  });

  @Deprecated("Renamed to 'name'")
  String get routeName => name;

  bool get hasChildren => children?.isNotEmpty == true;

  bool get fromRedirect => redirectedFrom != null;

  bool get hasEmptyPath => path == '';

  List<String> get allSegments =>
      [...segments, if (hasChildren) ...children!.last.allSegments];

  List<RouteMatch> get flattened {
    return [this, if (hasChildren) ...children!.last.flattened];
  }

  RouteMatch copyWith({
    String? path,
    String? stringMatch,
    Parameters? pathParams,
    Parameters? queryParams,
    List<RouteMatch>? children,
    String? fragment,
    List<String>? segments,
    String? redirectedFrom,
    String? routeName,
    Object? args,
    LocalKey? key,
    List<AutoRouteGuard>? guards,
  }) {
    return RouteMatch(
      path: path ?? this.path,
      stringMatch: stringMatch ?? this.stringMatch,
      name: routeName ?? this.name,
      segments: segments ?? this.segments,
      children: children ?? this.children,
      pathParams: pathParams ?? this.pathParams,
      queryParams: queryParams ?? this.queryParams,
      fragment: fragment ?? this.fragment,
      args: args ?? this.args,
      key: key ?? this.key,
      guards: guards ?? this.guards,
      redirectedFrom: redirectedFrom ?? this.redirectedFrom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteMatch &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          name == other.name &&
          stringMatch == other.stringMatch &&
          pathParams == other.pathParams &&
          key == other.key &&
          ListEquality().equals(guards, other.guards) &&
          queryParams == other.queryParams &&
          ListEquality().equals(children, other.children) &&
          fragment == other.fragment &&
          redirectedFrom == other.redirectedFrom &&
          ListEquality().equals(segments, other.segments);

  @override
  int get hashCode =>
      pathParams.hashCode ^
      queryParams.hashCode ^
      ListEquality().hash(children) ^
      ListEquality().hash(guards) ^
      fragment.hashCode ^
      redirectedFrom.hashCode ^
      path.hashCode ^
      stringMatch.hashCode ^
      name.hashCode ^
      key.hashCode ^
      ListEquality().hash(segments);

  @override
  String toString() {
    return 'RouteMatch{pathParams: $pathParams, queryParams: $queryParams, children: $children, fragment: $fragment, segments: $segments, redirectedFrom: $redirectedFrom, routeName: $name, path: $path, stringMatch: $stringMatch, args: $args, guards: $guards, key: $key}';
  }

  PageRouteInfo toRoute() => PageRouteInfo.fromMatch(this);
}
