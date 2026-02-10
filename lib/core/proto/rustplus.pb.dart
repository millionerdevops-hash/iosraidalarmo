// This is a generated file - do not edit.
//
// Generated from rustplus.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'rustplus.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'rustplus.pbenum.dart';

class Vector2 extends $pb.GeneratedMessage {
  factory Vector2({
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  Vector2._();

  factory Vector2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vector2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vector2',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector2 copyWith(void Function(Vector2) updates) =>
      super.copyWith((message) => updates(message as Vector2)) as Vector2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vector2 create() => Vector2._();
  @$core.override
  Vector2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vector2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vector2>(create);
  static Vector2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

class Vector3 extends $pb.GeneratedMessage {
  factory Vector3({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (z != null) result.z = z;
    return result;
  }

  Vector3._();

  factory Vector3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vector3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vector3',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'z', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector3 copyWith(void Function(Vector3) updates) =>
      super.copyWith((message) => updates(message as Vector3)) as Vector3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vector3 create() => Vector3._();
  @$core.override
  Vector3 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vector3 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vector3>(create);
  static Vector3? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => $_clearField(3);
}

class Vector4 extends $pb.GeneratedMessage {
  factory Vector4({
    $core.double? x,
    $core.double? y,
    $core.double? z,
    $core.double? w,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (z != null) result.z = z;
    if (w != null) result.w = w;
    return result;
  }

  Vector4._();

  factory Vector4.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vector4.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vector4',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'z', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'w', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vector4 copyWith(void Function(Vector4) updates) =>
      super.copyWith((message) => updates(message as Vector4)) as Vector4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vector4 create() => Vector4._();
  @$core.override
  Vector4 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vector4 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vector4>(create);
  static Vector4? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get w => $_getN(3);
  @$pb.TagNumber(4)
  set w($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasW() => $_has(3);
  @$pb.TagNumber(4)
  void clearW() => $_clearField(4);
}

class Half3 extends $pb.GeneratedMessage {
  factory Half3({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (z != null) result.z = z;
    return result;
  }

  Half3._();

  factory Half3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Half3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Half3',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'z', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Half3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Half3 copyWith(void Function(Half3) updates) =>
      super.copyWith((message) => updates(message as Half3)) as Half3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Half3 create() => Half3._();
  @$core.override
  Half3 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Half3 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Half3>(create);
  static Half3? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => $_clearField(3);
}

class Color extends $pb.GeneratedMessage {
  factory Color({
    $core.double? r,
    $core.double? g,
    $core.double? b,
    $core.double? a,
  }) {
    final result = create();
    if (r != null) result.r = r;
    if (g != null) result.g = g;
    if (b != null) result.b = b;
    if (a != null) result.a = a;
    return result;
  }

  Color._();

  factory Color.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Color.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Color',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'r', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'g', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'b', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'a', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color copyWith(void Function(Color) updates) =>
      super.copyWith((message) => updates(message as Color)) as Color;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Color create() => Color._();
  @$core.override
  Color createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Color getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Color>(create);
  static Color? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get r => $_getN(0);
  @$pb.TagNumber(1)
  set r($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasR() => $_has(0);
  @$pb.TagNumber(1)
  void clearR() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get g => $_getN(1);
  @$pb.TagNumber(2)
  set g($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasG() => $_has(1);
  @$pb.TagNumber(2)
  void clearG() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get b => $_getN(2);
  @$pb.TagNumber(3)
  set b($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasB() => $_has(2);
  @$pb.TagNumber(3)
  void clearB() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get a => $_getN(3);
  @$pb.TagNumber(4)
  set a($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasA() => $_has(3);
  @$pb.TagNumber(4)
  void clearA() => $_clearField(4);
}

class Ray extends $pb.GeneratedMessage {
  factory Ray({
    Vector3? origin,
    Vector3? direction,
  }) {
    final result = create();
    if (origin != null) result.origin = origin;
    if (direction != null) result.direction = direction;
    return result;
  }

  Ray._();

  factory Ray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ray',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOM<Vector3>(1, _omitFieldNames ? '' : 'origin',
        subBuilder: Vector3.create)
    ..aOM<Vector3>(2, _omitFieldNames ? '' : 'direction',
        subBuilder: Vector3.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ray copyWith(void Function(Ray) updates) =>
      super.copyWith((message) => updates(message as Ray)) as Ray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ray create() => Ray._();
  @$core.override
  Ray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ray getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ray>(create);
  static Ray? _defaultInstance;

  @$pb.TagNumber(1)
  Vector3 get origin => $_getN(0);
  @$pb.TagNumber(1)
  set origin(Vector3 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrigin() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrigin() => $_clearField(1);
  @$pb.TagNumber(1)
  Vector3 ensureOrigin() => $_ensure(0);

  @$pb.TagNumber(2)
  Vector3 get direction => $_getN(1);
  @$pb.TagNumber(2)
  set direction(Vector3 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => $_clearField(2);
  @$pb.TagNumber(2)
  Vector3 ensureDirection() => $_ensure(1);
}

class ClanActionResult extends $pb.GeneratedMessage {
  factory ClanActionResult({
    $core.int? requestId,
    $core.int? result,
    $core.bool? hasClanInfo,
    ClanInfo? clanInfo_4,
  }) {
    final result$ = create();
    if (requestId != null) result$.requestId = requestId;
    if (result != null) result$.result = result;
    if (hasClanInfo != null) result$.hasClanInfo = hasClanInfo;
    if (clanInfo_4 != null) result$.clanInfo_4 = clanInfo_4;
    return result$;
  }

  ClanActionResult._();

  factory ClanActionResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanActionResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanActionResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requestId',
        protoName: 'requestId', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'result', fieldType: $pb.PbFieldType.Q3)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'hasClanInfo', $pb.PbFieldType.QB,
        protoName: 'hasClanInfo')
    ..aOM<ClanInfo>(4, _omitFieldNames ? '' : 'clanInfo',
        protoName: 'clanInfo', subBuilder: ClanInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanActionResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanActionResult copyWith(void Function(ClanActionResult) updates) =>
      super.copyWith((message) => updates(message as ClanActionResult))
          as ClanActionResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanActionResult create() => ClanActionResult._();
  @$core.override
  ClanActionResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanActionResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanActionResult>(create);
  static ClanActionResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get result => $_getIZ(1);
  @$pb.TagNumber(2)
  set result($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasClanInfo => $_getBF(2);
  @$pb.TagNumber(3)
  set hasClanInfo($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasClanInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasClanInfo() => $_clearField(3);

  @$pb.TagNumber(4)
  ClanInfo get clanInfo_4 => $_getN(3);
  @$pb.TagNumber(4)
  set clanInfo_4(ClanInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClanInfo_4() => $_has(3);
  @$pb.TagNumber(4)
  void clearClanInfo_4() => $_clearField(4);
  @$pb.TagNumber(4)
  ClanInfo ensureClanInfo_4() => $_ensure(3);
}

class ClanInfo_Role extends $pb.GeneratedMessage {
  factory ClanInfo_Role({
    $core.int? roleId,
    $core.int? rank,
    $core.String? name,
    $core.bool? canSetMotd,
    $core.bool? canSetLogo,
    $core.bool? canInvite,
    $core.bool? canKick,
    $core.bool? canPromote,
    $core.bool? canDemote,
    $core.bool? canSetPlayerNotes,
    $core.bool? canAccessLogs,
  }) {
    final result = create();
    if (roleId != null) result.roleId = roleId;
    if (rank != null) result.rank = rank;
    if (name != null) result.name = name;
    if (canSetMotd != null) result.canSetMotd = canSetMotd;
    if (canSetLogo != null) result.canSetLogo = canSetLogo;
    if (canInvite != null) result.canInvite = canInvite;
    if (canKick != null) result.canKick = canKick;
    if (canPromote != null) result.canPromote = canPromote;
    if (canDemote != null) result.canDemote = canDemote;
    if (canSetPlayerNotes != null) result.canSetPlayerNotes = canSetPlayerNotes;
    if (canAccessLogs != null) result.canAccessLogs = canAccessLogs;
    return result;
  }

  ClanInfo_Role._();

  factory ClanInfo_Role.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInfo_Role.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInfo.Role',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'roleId',
        protoName: 'roleId', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'rank', fieldType: $pb.PbFieldType.Q3)
    ..aQS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.bool>(4, _omitFieldNames ? '' : 'canSetMotd', $pb.PbFieldType.QB,
        protoName: 'canSetMotd')
    ..a<$core.bool>(5, _omitFieldNames ? '' : 'canSetLogo', $pb.PbFieldType.QB,
        protoName: 'canSetLogo')
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'canInvite', $pb.PbFieldType.QB,
        protoName: 'canInvite')
    ..a<$core.bool>(7, _omitFieldNames ? '' : 'canKick', $pb.PbFieldType.QB,
        protoName: 'canKick')
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'canPromote', $pb.PbFieldType.QB,
        protoName: 'canPromote')
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'canDemote', $pb.PbFieldType.QB,
        protoName: 'canDemote')
    ..a<$core.bool>(
        10, _omitFieldNames ? '' : 'canSetPlayerNotes', $pb.PbFieldType.QB,
        protoName: 'canSetPlayerNotes')
    ..a<$core.bool>(
        11, _omitFieldNames ? '' : 'canAccessLogs', $pb.PbFieldType.QB,
        protoName: 'canAccessLogs');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Role clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Role copyWith(void Function(ClanInfo_Role) updates) =>
      super.copyWith((message) => updates(message as ClanInfo_Role))
          as ClanInfo_Role;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInfo_Role create() => ClanInfo_Role._();
  @$core.override
  ClanInfo_Role createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInfo_Role getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanInfo_Role>(create);
  static ClanInfo_Role? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get roleId => $_getIZ(0);
  @$pb.TagNumber(1)
  set roleId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rank => $_getIZ(1);
  @$pb.TagNumber(2)
  set rank($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRank() => $_has(1);
  @$pb.TagNumber(2)
  void clearRank() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get canSetMotd => $_getBF(3);
  @$pb.TagNumber(4)
  set canSetMotd($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanSetMotd() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanSetMotd() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get canSetLogo => $_getBF(4);
  @$pb.TagNumber(5)
  set canSetLogo($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCanSetLogo() => $_has(4);
  @$pb.TagNumber(5)
  void clearCanSetLogo() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get canInvite => $_getBF(5);
  @$pb.TagNumber(6)
  set canInvite($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCanInvite() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanInvite() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get canKick => $_getBF(6);
  @$pb.TagNumber(7)
  set canKick($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCanKick() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanKick() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get canPromote => $_getBF(7);
  @$pb.TagNumber(8)
  set canPromote($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCanPromote() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanPromote() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get canDemote => $_getBF(8);
  @$pb.TagNumber(9)
  set canDemote($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCanDemote() => $_has(8);
  @$pb.TagNumber(9)
  void clearCanDemote() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get canSetPlayerNotes => $_getBF(9);
  @$pb.TagNumber(10)
  set canSetPlayerNotes($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCanSetPlayerNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearCanSetPlayerNotes() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get canAccessLogs => $_getBF(10);
  @$pb.TagNumber(11)
  set canAccessLogs($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCanAccessLogs() => $_has(10);
  @$pb.TagNumber(11)
  void clearCanAccessLogs() => $_clearField(11);
}

class ClanInfo_Member extends $pb.GeneratedMessage {
  factory ClanInfo_Member({
    $fixnum.Int64? steamId,
    $core.int? roleId,
    $fixnum.Int64? joined,
    $fixnum.Int64? lastSeen,
    $core.String? notes,
    $core.bool? online,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    if (roleId != null) result.roleId = roleId;
    if (joined != null) result.joined = joined;
    if (lastSeen != null) result.lastSeen = lastSeen;
    if (notes != null) result.notes = notes;
    if (online != null) result.online = online;
    return result;
  }

  ClanInfo_Member._();

  factory ClanInfo_Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInfo_Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInfo.Member',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(2, _omitFieldNames ? '' : 'roleId',
        protoName: 'roleId', fieldType: $pb.PbFieldType.Q3)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'joined', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'lastSeen', $pb.PbFieldType.Q6,
        protoName: 'lastSeen', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..aOB(6, _omitFieldNames ? '' : 'online');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Member copyWith(void Function(ClanInfo_Member) updates) =>
      super.copyWith((message) => updates(message as ClanInfo_Member))
          as ClanInfo_Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInfo_Member create() => ClanInfo_Member._();
  @$core.override
  ClanInfo_Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInfo_Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanInfo_Member>(create);
  static ClanInfo_Member? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get roleId => $_getIZ(1);
  @$pb.TagNumber(2)
  set roleId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get joined => $_getI64(2);
  @$pb.TagNumber(3)
  set joined($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJoined() => $_has(2);
  @$pb.TagNumber(3)
  void clearJoined() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get lastSeen => $_getI64(3);
  @$pb.TagNumber(4)
  set lastSeen($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastSeen() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastSeen() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get online => $_getBF(5);
  @$pb.TagNumber(6)
  set online($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOnline() => $_has(5);
  @$pb.TagNumber(6)
  void clearOnline() => $_clearField(6);
}

class ClanInfo_Invite extends $pb.GeneratedMessage {
  factory ClanInfo_Invite({
    $fixnum.Int64? steamId,
    $fixnum.Int64? recruiter,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    if (recruiter != null) result.recruiter = recruiter;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  ClanInfo_Invite._();

  factory ClanInfo_Invite.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInfo_Invite.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInfo.Invite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'recruiter', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Invite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo_Invite copyWith(void Function(ClanInfo_Invite) updates) =>
      super.copyWith((message) => updates(message as ClanInfo_Invite))
          as ClanInfo_Invite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInfo_Invite create() => ClanInfo_Invite._();
  @$core.override
  ClanInfo_Invite createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInfo_Invite getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanInfo_Invite>(create);
  static ClanInfo_Invite? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recruiter => $_getI64(1);
  @$pb.TagNumber(2)
  set recruiter($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecruiter() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecruiter() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
}

class ClanInfo extends $pb.GeneratedMessage {
  factory ClanInfo({
    $fixnum.Int64? clanId,
    $core.String? name,
    $fixnum.Int64? created,
    $fixnum.Int64? creator,
    $core.String? motd,
    $fixnum.Int64? motdTimestamp,
    $fixnum.Int64? motdAuthor,
    $core.List<$core.int>? logo,
    $core.int? color,
    $core.Iterable<ClanInfo_Role>? roles,
    $core.Iterable<ClanInfo_Member>? members,
    $core.Iterable<ClanInfo_Invite>? invites,
    $core.int? maxMemberCount,
  }) {
    final result = create();
    if (clanId != null) result.clanId = clanId;
    if (name != null) result.name = name;
    if (created != null) result.created = created;
    if (creator != null) result.creator = creator;
    if (motd != null) result.motd = motd;
    if (motdTimestamp != null) result.motdTimestamp = motdTimestamp;
    if (motdAuthor != null) result.motdAuthor = motdAuthor;
    if (logo != null) result.logo = logo;
    if (color != null) result.color = color;
    if (roles != null) result.roles.addAll(roles);
    if (members != null) result.members.addAll(members);
    if (invites != null) result.invites.addAll(invites);
    if (maxMemberCount != null) result.maxMemberCount = maxMemberCount;
    return result;
  }

  ClanInfo._();

  factory ClanInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'clanId', $pb.PbFieldType.Q6,
        protoName: 'clanId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'created', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'creator', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'motd')
    ..aInt64(6, _omitFieldNames ? '' : 'motdTimestamp',
        protoName: 'motdTimestamp')
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'motdAuthor', $pb.PbFieldType.OU6,
        protoName: 'motdAuthor', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(
        8, _omitFieldNames ? '' : 'logo', $pb.PbFieldType.OY)
    ..aI(9, _omitFieldNames ? '' : 'color', fieldType: $pb.PbFieldType.OS3)
    ..pPM<ClanInfo_Role>(10, _omitFieldNames ? '' : 'roles',
        subBuilder: ClanInfo_Role.create)
    ..pPM<ClanInfo_Member>(11, _omitFieldNames ? '' : 'members',
        subBuilder: ClanInfo_Member.create)
    ..pPM<ClanInfo_Invite>(12, _omitFieldNames ? '' : 'invites',
        subBuilder: ClanInfo_Invite.create)
    ..aI(13, _omitFieldNames ? '' : 'maxMemberCount',
        protoName: 'maxMemberCount');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInfo copyWith(void Function(ClanInfo) updates) =>
      super.copyWith((message) => updates(message as ClanInfo)) as ClanInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInfo create() => ClanInfo._();
  @$core.override
  ClanInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClanInfo>(create);
  static ClanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clanId => $_getI64(0);
  @$pb.TagNumber(1)
  set clanId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get created => $_getI64(2);
  @$pb.TagNumber(3)
  set created($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get creator => $_getI64(3);
  @$pb.TagNumber(4)
  set creator($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreator() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreator() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get motd => $_getSZ(4);
  @$pb.TagNumber(5)
  set motd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMotd() => $_has(4);
  @$pb.TagNumber(5)
  void clearMotd() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get motdTimestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set motdTimestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMotdTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearMotdTimestamp() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get motdAuthor => $_getI64(6);
  @$pb.TagNumber(7)
  set motdAuthor($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMotdAuthor() => $_has(6);
  @$pb.TagNumber(7)
  void clearMotdAuthor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get logo => $_getN(7);
  @$pb.TagNumber(8)
  set logo($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLogo() => $_has(7);
  @$pb.TagNumber(8)
  void clearLogo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get color => $_getIZ(8);
  @$pb.TagNumber(9)
  set color($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasColor() => $_has(8);
  @$pb.TagNumber(9)
  void clearColor() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<ClanInfo_Role> get roles => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<ClanInfo_Member> get members => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<ClanInfo_Invite> get invites => $_getList(11);

  @$pb.TagNumber(13)
  $core.int get maxMemberCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set maxMemberCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMaxMemberCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaxMemberCount() => $_clearField(13);
}

class ClanLog_Entry extends $pb.GeneratedMessage {
  factory ClanLog_Entry({
    $fixnum.Int64? timestamp,
    $core.String? eventKey,
    $core.String? arg1,
    $core.String? arg2,
    $core.String? arg3,
    $core.String? arg4,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (eventKey != null) result.eventKey = eventKey;
    if (arg1 != null) result.arg1 = arg1;
    if (arg2 != null) result.arg2 = arg2;
    if (arg3 != null) result.arg3 = arg3;
    if (arg4 != null) result.arg4 = arg4;
    return result;
  }

  ClanLog_Entry._();

  factory ClanLog_Entry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanLog_Entry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanLog.Entry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'eventKey', protoName: 'eventKey')
    ..aOS(3, _omitFieldNames ? '' : 'arg1')
    ..aOS(4, _omitFieldNames ? '' : 'arg2')
    ..aOS(5, _omitFieldNames ? '' : 'arg3')
    ..aOS(6, _omitFieldNames ? '' : 'arg4');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanLog_Entry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanLog_Entry copyWith(void Function(ClanLog_Entry) updates) =>
      super.copyWith((message) => updates(message as ClanLog_Entry))
          as ClanLog_Entry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanLog_Entry create() => ClanLog_Entry._();
  @$core.override
  ClanLog_Entry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanLog_Entry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanLog_Entry>(create);
  static ClanLog_Entry? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get eventKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get arg1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set arg1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArg1() => $_has(2);
  @$pb.TagNumber(3)
  void clearArg1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get arg2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set arg2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArg2() => $_has(3);
  @$pb.TagNumber(4)
  void clearArg2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get arg3 => $_getSZ(4);
  @$pb.TagNumber(5)
  set arg3($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasArg3() => $_has(4);
  @$pb.TagNumber(5)
  void clearArg3() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get arg4 => $_getSZ(5);
  @$pb.TagNumber(6)
  set arg4($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArg4() => $_has(5);
  @$pb.TagNumber(6)
  void clearArg4() => $_clearField(6);
}

class ClanLog extends $pb.GeneratedMessage {
  factory ClanLog({
    $fixnum.Int64? clanId,
    $core.Iterable<ClanLog_Entry>? logEntries,
  }) {
    final result = create();
    if (clanId != null) result.clanId = clanId;
    if (logEntries != null) result.logEntries.addAll(logEntries);
    return result;
  }

  ClanLog._();

  factory ClanLog.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanLog.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanLog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'clanId', $pb.PbFieldType.Q6,
        protoName: 'clanId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<ClanLog_Entry>(2, _omitFieldNames ? '' : 'logEntries',
        protoName: 'logEntries', subBuilder: ClanLog_Entry.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanLog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanLog copyWith(void Function(ClanLog) updates) =>
      super.copyWith((message) => updates(message as ClanLog)) as ClanLog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanLog create() => ClanLog._();
  @$core.override
  ClanLog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanLog getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClanLog>(create);
  static ClanLog? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clanId => $_getI64(0);
  @$pb.TagNumber(1)
  set clanId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ClanLog_Entry> get logEntries => $_getList(1);
}

class ClanInvitations_Invitation extends $pb.GeneratedMessage {
  factory ClanInvitations_Invitation({
    $fixnum.Int64? clanId,
    $fixnum.Int64? recruiter,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (clanId != null) result.clanId = clanId;
    if (recruiter != null) result.recruiter = recruiter;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  ClanInvitations_Invitation._();

  factory ClanInvitations_Invitation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInvitations_Invitation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInvitations.Invitation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'clanId', $pb.PbFieldType.Q6,
        protoName: 'clanId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'recruiter', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInvitations_Invitation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInvitations_Invitation copyWith(
          void Function(ClanInvitations_Invitation) updates) =>
      super.copyWith(
              (message) => updates(message as ClanInvitations_Invitation))
          as ClanInvitations_Invitation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInvitations_Invitation create() => ClanInvitations_Invitation._();
  @$core.override
  ClanInvitations_Invitation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInvitations_Invitation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanInvitations_Invitation>(create);
  static ClanInvitations_Invitation? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clanId => $_getI64(0);
  @$pb.TagNumber(1)
  set clanId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recruiter => $_getI64(1);
  @$pb.TagNumber(2)
  set recruiter($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecruiter() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecruiter() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
}

class ClanInvitations extends $pb.GeneratedMessage {
  factory ClanInvitations({
    $core.Iterable<ClanInvitations_Invitation>? invitations,
  }) {
    final result = create();
    if (invitations != null) result.invitations.addAll(invitations);
    return result;
  }

  ClanInvitations._();

  factory ClanInvitations.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClanInvitations.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClanInvitations',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..pPM<ClanInvitations_Invitation>(1, _omitFieldNames ? '' : 'invitations',
        subBuilder: ClanInvitations_Invitation.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInvitations clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClanInvitations copyWith(void Function(ClanInvitations) updates) =>
      super.copyWith((message) => updates(message as ClanInvitations))
          as ClanInvitations;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClanInvitations create() => ClanInvitations._();
  @$core.override
  ClanInvitations createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClanInvitations getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClanInvitations>(create);
  static ClanInvitations? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClanInvitations_Invitation> get invitations => $_getList(0);
}

class AppRequest extends $pb.GeneratedMessage {
  factory AppRequest({
    $core.int? seq,
    $fixnum.Int64? playerId,
    $core.int? playerToken,
    $core.int? entityId,
    AppEmpty? getInfo,
    AppEmpty? getTime,
    AppEmpty? getMap,
    AppEmpty? getTeamInfo,
    AppEmpty? getTeamChat,
    AppSendMessage? sendTeamMessage,
    AppEmpty? getEntityInfo,
    AppSetEntityValue? setEntityValue,
    AppEmpty? checkSubscription,
    AppFlag? setSubscription,
    AppEmpty? getMapMarkers,
    AppPromoteToLeader? promoteToLeader,
    AppEmpty? getClanInfo,
    AppSendMessage? setClanMotd,
    AppEmpty? getClanChat,
    AppSendMessage? sendClanMessage,
    AppGetNexusAuth? getNexusAuth,
    AppCameraSubscribe? cameraSubscribe,
    AppEmpty? cameraUnsubscribe,
    AppCameraInput? cameraInput,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (playerId != null) result.playerId = playerId;
    if (playerToken != null) result.playerToken = playerToken;
    if (entityId != null) result.entityId = entityId;
    if (getInfo != null) result.getInfo = getInfo;
    if (getTime != null) result.getTime = getTime;
    if (getMap != null) result.getMap = getMap;
    if (getTeamInfo != null) result.getTeamInfo = getTeamInfo;
    if (getTeamChat != null) result.getTeamChat = getTeamChat;
    if (sendTeamMessage != null) result.sendTeamMessage = sendTeamMessage;
    if (getEntityInfo != null) result.getEntityInfo = getEntityInfo;
    if (setEntityValue != null) result.setEntityValue = setEntityValue;
    if (checkSubscription != null) result.checkSubscription = checkSubscription;
    if (setSubscription != null) result.setSubscription = setSubscription;
    if (getMapMarkers != null) result.getMapMarkers = getMapMarkers;
    if (promoteToLeader != null) result.promoteToLeader = promoteToLeader;
    if (getClanInfo != null) result.getClanInfo = getClanInfo;
    if (setClanMotd != null) result.setClanMotd = setClanMotd;
    if (getClanChat != null) result.getClanChat = getClanChat;
    if (sendClanMessage != null) result.sendClanMessage = sendClanMessage;
    if (getNexusAuth != null) result.getNexusAuth = getNexusAuth;
    if (cameraSubscribe != null) result.cameraSubscribe = cameraSubscribe;
    if (cameraUnsubscribe != null) result.cameraUnsubscribe = cameraUnsubscribe;
    if (cameraInput != null) result.cameraInput = cameraInput;
    return result;
  }

  AppRequest._();

  factory AppRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.QU3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'playerId', $pb.PbFieldType.QU6,
        protoName: 'playerId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'playerToken',
        protoName: 'playerToken', fieldType: $pb.PbFieldType.Q3)
    ..aI(4, _omitFieldNames ? '' : 'entityId',
        protoName: 'entityId', fieldType: $pb.PbFieldType.OU3)
    ..aOM<AppEmpty>(8, _omitFieldNames ? '' : 'getInfo',
        protoName: 'getInfo', subBuilder: AppEmpty.create)
    ..aOM<AppEmpty>(9, _omitFieldNames ? '' : 'getTime',
        protoName: 'getTime', subBuilder: AppEmpty.create)
    ..aOM<AppEmpty>(10, _omitFieldNames ? '' : 'getMap',
        protoName: 'getMap', subBuilder: AppEmpty.create)
    ..aOM<AppEmpty>(11, _omitFieldNames ? '' : 'getTeamInfo',
        protoName: 'getTeamInfo', subBuilder: AppEmpty.create)
    ..aOM<AppEmpty>(12, _omitFieldNames ? '' : 'getTeamChat',
        protoName: 'getTeamChat', subBuilder: AppEmpty.create)
    ..aOM<AppSendMessage>(13, _omitFieldNames ? '' : 'sendTeamMessage',
        protoName: 'sendTeamMessage', subBuilder: AppSendMessage.create)
    ..aOM<AppEmpty>(14, _omitFieldNames ? '' : 'getEntityInfo',
        protoName: 'getEntityInfo', subBuilder: AppEmpty.create)
    ..aOM<AppSetEntityValue>(15, _omitFieldNames ? '' : 'setEntityValue',
        protoName: 'setEntityValue', subBuilder: AppSetEntityValue.create)
    ..aOM<AppEmpty>(16, _omitFieldNames ? '' : 'checkSubscription',
        protoName: 'checkSubscription', subBuilder: AppEmpty.create)
    ..aOM<AppFlag>(17, _omitFieldNames ? '' : 'setSubscription',
        protoName: 'setSubscription', subBuilder: AppFlag.create)
    ..aOM<AppEmpty>(18, _omitFieldNames ? '' : 'getMapMarkers',
        protoName: 'getMapMarkers', subBuilder: AppEmpty.create)
    ..aOM<AppPromoteToLeader>(20, _omitFieldNames ? '' : 'promoteToLeader',
        protoName: 'promoteToLeader', subBuilder: AppPromoteToLeader.create)
    ..aOM<AppEmpty>(21, _omitFieldNames ? '' : 'getClanInfo',
        protoName: 'getClanInfo', subBuilder: AppEmpty.create)
    ..aOM<AppSendMessage>(22, _omitFieldNames ? '' : 'setClanMotd',
        protoName: 'setClanMotd', subBuilder: AppSendMessage.create)
    ..aOM<AppEmpty>(23, _omitFieldNames ? '' : 'getClanChat',
        protoName: 'getClanChat', subBuilder: AppEmpty.create)
    ..aOM<AppSendMessage>(24, _omitFieldNames ? '' : 'sendClanMessage',
        protoName: 'sendClanMessage', subBuilder: AppSendMessage.create)
    ..aOM<AppGetNexusAuth>(25, _omitFieldNames ? '' : 'getNexusAuth',
        protoName: 'getNexusAuth', subBuilder: AppGetNexusAuth.create)
    ..aOM<AppCameraSubscribe>(30, _omitFieldNames ? '' : 'cameraSubscribe',
        protoName: 'cameraSubscribe', subBuilder: AppCameraSubscribe.create)
    ..aOM<AppEmpty>(31, _omitFieldNames ? '' : 'cameraUnsubscribe',
        protoName: 'cameraUnsubscribe', subBuilder: AppEmpty.create)
    ..aOM<AppCameraInput>(32, _omitFieldNames ? '' : 'cameraInput',
        protoName: 'cameraInput', subBuilder: AppCameraInput.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppRequest copyWith(void Function(AppRequest) updates) =>
      super.copyWith((message) => updates(message as AppRequest)) as AppRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppRequest create() => AppRequest._();
  @$core.override
  AppRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppRequest>(create);
  static AppRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get playerId => $_getI64(1);
  @$pb.TagNumber(2)
  set playerId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get playerToken => $_getIZ(2);
  @$pb.TagNumber(3)
  set playerToken($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get entityId => $_getIZ(3);
  @$pb.TagNumber(4)
  set entityId($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityId() => $_clearField(4);

  @$pb.TagNumber(8)
  AppEmpty get getInfo => $_getN(4);
  @$pb.TagNumber(8)
  set getInfo(AppEmpty value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGetInfo() => $_has(4);
  @$pb.TagNumber(8)
  void clearGetInfo() => $_clearField(8);
  @$pb.TagNumber(8)
  AppEmpty ensureGetInfo() => $_ensure(4);

  @$pb.TagNumber(9)
  AppEmpty get getTime => $_getN(5);
  @$pb.TagNumber(9)
  set getTime(AppEmpty value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGetTime() => $_has(5);
  @$pb.TagNumber(9)
  void clearGetTime() => $_clearField(9);
  @$pb.TagNumber(9)
  AppEmpty ensureGetTime() => $_ensure(5);

  @$pb.TagNumber(10)
  AppEmpty get getMap => $_getN(6);
  @$pb.TagNumber(10)
  set getMap(AppEmpty value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasGetMap() => $_has(6);
  @$pb.TagNumber(10)
  void clearGetMap() => $_clearField(10);
  @$pb.TagNumber(10)
  AppEmpty ensureGetMap() => $_ensure(6);

  @$pb.TagNumber(11)
  AppEmpty get getTeamInfo => $_getN(7);
  @$pb.TagNumber(11)
  set getTeamInfo(AppEmpty value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasGetTeamInfo() => $_has(7);
  @$pb.TagNumber(11)
  void clearGetTeamInfo() => $_clearField(11);
  @$pb.TagNumber(11)
  AppEmpty ensureGetTeamInfo() => $_ensure(7);

  @$pb.TagNumber(12)
  AppEmpty get getTeamChat => $_getN(8);
  @$pb.TagNumber(12)
  set getTeamChat(AppEmpty value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGetTeamChat() => $_has(8);
  @$pb.TagNumber(12)
  void clearGetTeamChat() => $_clearField(12);
  @$pb.TagNumber(12)
  AppEmpty ensureGetTeamChat() => $_ensure(8);

  @$pb.TagNumber(13)
  AppSendMessage get sendTeamMessage => $_getN(9);
  @$pb.TagNumber(13)
  set sendTeamMessage(AppSendMessage value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendTeamMessage() => $_has(9);
  @$pb.TagNumber(13)
  void clearSendTeamMessage() => $_clearField(13);
  @$pb.TagNumber(13)
  AppSendMessage ensureSendTeamMessage() => $_ensure(9);

  @$pb.TagNumber(14)
  AppEmpty get getEntityInfo => $_getN(10);
  @$pb.TagNumber(14)
  set getEntityInfo(AppEmpty value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGetEntityInfo() => $_has(10);
  @$pb.TagNumber(14)
  void clearGetEntityInfo() => $_clearField(14);
  @$pb.TagNumber(14)
  AppEmpty ensureGetEntityInfo() => $_ensure(10);

  @$pb.TagNumber(15)
  AppSetEntityValue get setEntityValue => $_getN(11);
  @$pb.TagNumber(15)
  set setEntityValue(AppSetEntityValue value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSetEntityValue() => $_has(11);
  @$pb.TagNumber(15)
  void clearSetEntityValue() => $_clearField(15);
  @$pb.TagNumber(15)
  AppSetEntityValue ensureSetEntityValue() => $_ensure(11);

  @$pb.TagNumber(16)
  AppEmpty get checkSubscription => $_getN(12);
  @$pb.TagNumber(16)
  set checkSubscription(AppEmpty value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCheckSubscription() => $_has(12);
  @$pb.TagNumber(16)
  void clearCheckSubscription() => $_clearField(16);
  @$pb.TagNumber(16)
  AppEmpty ensureCheckSubscription() => $_ensure(12);

  @$pb.TagNumber(17)
  AppFlag get setSubscription => $_getN(13);
  @$pb.TagNumber(17)
  set setSubscription(AppFlag value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasSetSubscription() => $_has(13);
  @$pb.TagNumber(17)
  void clearSetSubscription() => $_clearField(17);
  @$pb.TagNumber(17)
  AppFlag ensureSetSubscription() => $_ensure(13);

  @$pb.TagNumber(18)
  AppEmpty get getMapMarkers => $_getN(14);
  @$pb.TagNumber(18)
  set getMapMarkers(AppEmpty value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasGetMapMarkers() => $_has(14);
  @$pb.TagNumber(18)
  void clearGetMapMarkers() => $_clearField(18);
  @$pb.TagNumber(18)
  AppEmpty ensureGetMapMarkers() => $_ensure(14);

  @$pb.TagNumber(20)
  AppPromoteToLeader get promoteToLeader => $_getN(15);
  @$pb.TagNumber(20)
  set promoteToLeader(AppPromoteToLeader value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasPromoteToLeader() => $_has(15);
  @$pb.TagNumber(20)
  void clearPromoteToLeader() => $_clearField(20);
  @$pb.TagNumber(20)
  AppPromoteToLeader ensurePromoteToLeader() => $_ensure(15);

  @$pb.TagNumber(21)
  AppEmpty get getClanInfo => $_getN(16);
  @$pb.TagNumber(21)
  set getClanInfo(AppEmpty value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasGetClanInfo() => $_has(16);
  @$pb.TagNumber(21)
  void clearGetClanInfo() => $_clearField(21);
  @$pb.TagNumber(21)
  AppEmpty ensureGetClanInfo() => $_ensure(16);

  @$pb.TagNumber(22)
  AppSendMessage get setClanMotd => $_getN(17);
  @$pb.TagNumber(22)
  set setClanMotd(AppSendMessage value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasSetClanMotd() => $_has(17);
  @$pb.TagNumber(22)
  void clearSetClanMotd() => $_clearField(22);
  @$pb.TagNumber(22)
  AppSendMessage ensureSetClanMotd() => $_ensure(17);

  @$pb.TagNumber(23)
  AppEmpty get getClanChat => $_getN(18);
  @$pb.TagNumber(23)
  set getClanChat(AppEmpty value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasGetClanChat() => $_has(18);
  @$pb.TagNumber(23)
  void clearGetClanChat() => $_clearField(23);
  @$pb.TagNumber(23)
  AppEmpty ensureGetClanChat() => $_ensure(18);

  @$pb.TagNumber(24)
  AppSendMessage get sendClanMessage => $_getN(19);
  @$pb.TagNumber(24)
  set sendClanMessage(AppSendMessage value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasSendClanMessage() => $_has(19);
  @$pb.TagNumber(24)
  void clearSendClanMessage() => $_clearField(24);
  @$pb.TagNumber(24)
  AppSendMessage ensureSendClanMessage() => $_ensure(19);

  @$pb.TagNumber(25)
  AppGetNexusAuth get getNexusAuth => $_getN(20);
  @$pb.TagNumber(25)
  set getNexusAuth(AppGetNexusAuth value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasGetNexusAuth() => $_has(20);
  @$pb.TagNumber(25)
  void clearGetNexusAuth() => $_clearField(25);
  @$pb.TagNumber(25)
  AppGetNexusAuth ensureGetNexusAuth() => $_ensure(20);

  @$pb.TagNumber(30)
  AppCameraSubscribe get cameraSubscribe => $_getN(21);
  @$pb.TagNumber(30)
  set cameraSubscribe(AppCameraSubscribe value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasCameraSubscribe() => $_has(21);
  @$pb.TagNumber(30)
  void clearCameraSubscribe() => $_clearField(30);
  @$pb.TagNumber(30)
  AppCameraSubscribe ensureCameraSubscribe() => $_ensure(21);

  @$pb.TagNumber(31)
  AppEmpty get cameraUnsubscribe => $_getN(22);
  @$pb.TagNumber(31)
  set cameraUnsubscribe(AppEmpty value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasCameraUnsubscribe() => $_has(22);
  @$pb.TagNumber(31)
  void clearCameraUnsubscribe() => $_clearField(31);
  @$pb.TagNumber(31)
  AppEmpty ensureCameraUnsubscribe() => $_ensure(22);

  @$pb.TagNumber(32)
  AppCameraInput get cameraInput => $_getN(23);
  @$pb.TagNumber(32)
  set cameraInput(AppCameraInput value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasCameraInput() => $_has(23);
  @$pb.TagNumber(32)
  void clearCameraInput() => $_clearField(32);
  @$pb.TagNumber(32)
  AppCameraInput ensureCameraInput() => $_ensure(23);
}

class AppMessage extends $pb.GeneratedMessage {
  factory AppMessage({
    AppResponse? response,
    AppBroadcast? broadcast,
  }) {
    final result = create();
    if (response != null) result.response = response;
    if (broadcast != null) result.broadcast = broadcast;
    return result;
  }

  AppMessage._();

  factory AppMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOM<AppResponse>(1, _omitFieldNames ? '' : 'response',
        subBuilder: AppResponse.create)
    ..aOM<AppBroadcast>(2, _omitFieldNames ? '' : 'broadcast',
        subBuilder: AppBroadcast.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMessage copyWith(void Function(AppMessage) updates) =>
      super.copyWith((message) => updates(message as AppMessage)) as AppMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMessage create() => AppMessage._();
  @$core.override
  AppMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppMessage>(create);
  static AppMessage? _defaultInstance;

  @$pb.TagNumber(1)
  AppResponse get response => $_getN(0);
  @$pb.TagNumber(1)
  set response(AppResponse value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearResponse() => $_clearField(1);
  @$pb.TagNumber(1)
  AppResponse ensureResponse() => $_ensure(0);

  @$pb.TagNumber(2)
  AppBroadcast get broadcast => $_getN(1);
  @$pb.TagNumber(2)
  set broadcast(AppBroadcast value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBroadcast() => $_has(1);
  @$pb.TagNumber(2)
  void clearBroadcast() => $_clearField(2);
  @$pb.TagNumber(2)
  AppBroadcast ensureBroadcast() => $_ensure(1);
}

class AppResponse extends $pb.GeneratedMessage {
  factory AppResponse({
    $core.int? seq,
    AppSuccess? success,
    AppError? error,
    AppInfo? info,
    AppTime? time,
    AppMap? map,
    AppTeamInfo? teamInfo,
    AppTeamChat? teamChat,
    AppEntityInfo? entityInfo,
    AppFlag? flag,
    AppMapMarkers? mapMarkers,
    AppClanInfo? clanInfo,
    AppClanChat? clanChat,
    AppNexusAuth? nexusAuth,
    AppCameraInfo? cameraSubscribeInfo,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (info != null) result.info = info;
    if (time != null) result.time = time;
    if (map != null) result.map = map;
    if (teamInfo != null) result.teamInfo = teamInfo;
    if (teamChat != null) result.teamChat = teamChat;
    if (entityInfo != null) result.entityInfo = entityInfo;
    if (flag != null) result.flag = flag;
    if (mapMarkers != null) result.mapMarkers = mapMarkers;
    if (clanInfo != null) result.clanInfo = clanInfo;
    if (clanChat != null) result.clanChat = clanChat;
    if (nexusAuth != null) result.nexusAuth = nexusAuth;
    if (cameraSubscribeInfo != null)
      result.cameraSubscribeInfo = cameraSubscribeInfo;
    return result;
  }

  AppResponse._();

  factory AppResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.QU3)
    ..aOM<AppSuccess>(4, _omitFieldNames ? '' : 'success',
        subBuilder: AppSuccess.create)
    ..aOM<AppError>(5, _omitFieldNames ? '' : 'error',
        subBuilder: AppError.create)
    ..aOM<AppInfo>(6, _omitFieldNames ? '' : 'info', subBuilder: AppInfo.create)
    ..aOM<AppTime>(7, _omitFieldNames ? '' : 'time', subBuilder: AppTime.create)
    ..aOM<AppMap>(8, _omitFieldNames ? '' : 'map', subBuilder: AppMap.create)
    ..aOM<AppTeamInfo>(9, _omitFieldNames ? '' : 'teamInfo',
        protoName: 'teamInfo', subBuilder: AppTeamInfo.create)
    ..aOM<AppTeamChat>(10, _omitFieldNames ? '' : 'teamChat',
        protoName: 'teamChat', subBuilder: AppTeamChat.create)
    ..aOM<AppEntityInfo>(11, _omitFieldNames ? '' : 'entityInfo',
        protoName: 'entityInfo', subBuilder: AppEntityInfo.create)
    ..aOM<AppFlag>(12, _omitFieldNames ? '' : 'flag',
        subBuilder: AppFlag.create)
    ..aOM<AppMapMarkers>(13, _omitFieldNames ? '' : 'mapMarkers',
        protoName: 'mapMarkers', subBuilder: AppMapMarkers.create)
    ..aOM<AppClanInfo>(15, _omitFieldNames ? '' : 'clanInfo',
        protoName: 'clanInfo', subBuilder: AppClanInfo.create)
    ..aOM<AppClanChat>(16, _omitFieldNames ? '' : 'clanChat',
        protoName: 'clanChat', subBuilder: AppClanChat.create)
    ..aOM<AppNexusAuth>(17, _omitFieldNames ? '' : 'nexusAuth',
        protoName: 'nexusAuth', subBuilder: AppNexusAuth.create)
    ..aOM<AppCameraInfo>(20, _omitFieldNames ? '' : 'cameraSubscribeInfo',
        protoName: 'cameraSubscribeInfo', subBuilder: AppCameraInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppResponse copyWith(void Function(AppResponse) updates) =>
      super.copyWith((message) => updates(message as AppResponse))
          as AppResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppResponse create() => AppResponse._();
  @$core.override
  AppResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppResponse>(create);
  static AppResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(4)
  AppSuccess get success => $_getN(1);
  @$pb.TagNumber(4)
  set success(AppSuccess value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(4)
  void clearSuccess() => $_clearField(4);
  @$pb.TagNumber(4)
  AppSuccess ensureSuccess() => $_ensure(1);

  @$pb.TagNumber(5)
  AppError get error => $_getN(2);
  @$pb.TagNumber(5)
  set error(AppError value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);
  @$pb.TagNumber(5)
  AppError ensureError() => $_ensure(2);

  @$pb.TagNumber(6)
  AppInfo get info => $_getN(3);
  @$pb.TagNumber(6)
  set info(AppInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasInfo() => $_has(3);
  @$pb.TagNumber(6)
  void clearInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  AppInfo ensureInfo() => $_ensure(3);

  @$pb.TagNumber(7)
  AppTime get time => $_getN(4);
  @$pb.TagNumber(7)
  set time(AppTime value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTime() => $_has(4);
  @$pb.TagNumber(7)
  void clearTime() => $_clearField(7);
  @$pb.TagNumber(7)
  AppTime ensureTime() => $_ensure(4);

  @$pb.TagNumber(8)
  AppMap get map => $_getN(5);
  @$pb.TagNumber(8)
  set map(AppMap value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMap() => $_has(5);
  @$pb.TagNumber(8)
  void clearMap() => $_clearField(8);
  @$pb.TagNumber(8)
  AppMap ensureMap() => $_ensure(5);

  @$pb.TagNumber(9)
  AppTeamInfo get teamInfo => $_getN(6);
  @$pb.TagNumber(9)
  set teamInfo(AppTeamInfo value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTeamInfo() => $_has(6);
  @$pb.TagNumber(9)
  void clearTeamInfo() => $_clearField(9);
  @$pb.TagNumber(9)
  AppTeamInfo ensureTeamInfo() => $_ensure(6);

  @$pb.TagNumber(10)
  AppTeamChat get teamChat => $_getN(7);
  @$pb.TagNumber(10)
  set teamChat(AppTeamChat value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTeamChat() => $_has(7);
  @$pb.TagNumber(10)
  void clearTeamChat() => $_clearField(10);
  @$pb.TagNumber(10)
  AppTeamChat ensureTeamChat() => $_ensure(7);

  @$pb.TagNumber(11)
  AppEntityInfo get entityInfo => $_getN(8);
  @$pb.TagNumber(11)
  set entityInfo(AppEntityInfo value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasEntityInfo() => $_has(8);
  @$pb.TagNumber(11)
  void clearEntityInfo() => $_clearField(11);
  @$pb.TagNumber(11)
  AppEntityInfo ensureEntityInfo() => $_ensure(8);

  @$pb.TagNumber(12)
  AppFlag get flag => $_getN(9);
  @$pb.TagNumber(12)
  set flag(AppFlag value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasFlag() => $_has(9);
  @$pb.TagNumber(12)
  void clearFlag() => $_clearField(12);
  @$pb.TagNumber(12)
  AppFlag ensureFlag() => $_ensure(9);

  @$pb.TagNumber(13)
  AppMapMarkers get mapMarkers => $_getN(10);
  @$pb.TagNumber(13)
  set mapMarkers(AppMapMarkers value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasMapMarkers() => $_has(10);
  @$pb.TagNumber(13)
  void clearMapMarkers() => $_clearField(13);
  @$pb.TagNumber(13)
  AppMapMarkers ensureMapMarkers() => $_ensure(10);

  @$pb.TagNumber(15)
  AppClanInfo get clanInfo => $_getN(11);
  @$pb.TagNumber(15)
  set clanInfo(AppClanInfo value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasClanInfo() => $_has(11);
  @$pb.TagNumber(15)
  void clearClanInfo() => $_clearField(15);
  @$pb.TagNumber(15)
  AppClanInfo ensureClanInfo() => $_ensure(11);

  @$pb.TagNumber(16)
  AppClanChat get clanChat => $_getN(12);
  @$pb.TagNumber(16)
  set clanChat(AppClanChat value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasClanChat() => $_has(12);
  @$pb.TagNumber(16)
  void clearClanChat() => $_clearField(16);
  @$pb.TagNumber(16)
  AppClanChat ensureClanChat() => $_ensure(12);

  @$pb.TagNumber(17)
  AppNexusAuth get nexusAuth => $_getN(13);
  @$pb.TagNumber(17)
  set nexusAuth(AppNexusAuth value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasNexusAuth() => $_has(13);
  @$pb.TagNumber(17)
  void clearNexusAuth() => $_clearField(17);
  @$pb.TagNumber(17)
  AppNexusAuth ensureNexusAuth() => $_ensure(13);

  @$pb.TagNumber(20)
  AppCameraInfo get cameraSubscribeInfo => $_getN(14);
  @$pb.TagNumber(20)
  set cameraSubscribeInfo(AppCameraInfo value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasCameraSubscribeInfo() => $_has(14);
  @$pb.TagNumber(20)
  void clearCameraSubscribeInfo() => $_clearField(20);
  @$pb.TagNumber(20)
  AppCameraInfo ensureCameraSubscribeInfo() => $_ensure(14);
}

class AppBroadcast extends $pb.GeneratedMessage {
  factory AppBroadcast({
    AppTeamChanged? teamChanged,
    AppNewTeamMessage? teamMessage,
    AppEntityChanged? entityChanged,
    AppClanChanged? clanChanged,
    AppNewClanMessage? clanMessage,
    AppCameraRays? cameraRays,
  }) {
    final result = create();
    if (teamChanged != null) result.teamChanged = teamChanged;
    if (teamMessage != null) result.teamMessage = teamMessage;
    if (entityChanged != null) result.entityChanged = entityChanged;
    if (clanChanged != null) result.clanChanged = clanChanged;
    if (clanMessage != null) result.clanMessage = clanMessage;
    if (cameraRays != null) result.cameraRays = cameraRays;
    return result;
  }

  AppBroadcast._();

  factory AppBroadcast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppBroadcast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppBroadcast',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOM<AppTeamChanged>(4, _omitFieldNames ? '' : 'teamChanged',
        protoName: 'teamChanged', subBuilder: AppTeamChanged.create)
    ..aOM<AppNewTeamMessage>(5, _omitFieldNames ? '' : 'teamMessage',
        protoName: 'teamMessage', subBuilder: AppNewTeamMessage.create)
    ..aOM<AppEntityChanged>(6, _omitFieldNames ? '' : 'entityChanged',
        protoName: 'entityChanged', subBuilder: AppEntityChanged.create)
    ..aOM<AppClanChanged>(7, _omitFieldNames ? '' : 'clanChanged',
        protoName: 'clanChanged', subBuilder: AppClanChanged.create)
    ..aOM<AppNewClanMessage>(8, _omitFieldNames ? '' : 'clanMessage',
        protoName: 'clanMessage', subBuilder: AppNewClanMessage.create)
    ..aOM<AppCameraRays>(10, _omitFieldNames ? '' : 'cameraRays',
        protoName: 'cameraRays', subBuilder: AppCameraRays.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppBroadcast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppBroadcast copyWith(void Function(AppBroadcast) updates) =>
      super.copyWith((message) => updates(message as AppBroadcast))
          as AppBroadcast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppBroadcast create() => AppBroadcast._();
  @$core.override
  AppBroadcast createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppBroadcast getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppBroadcast>(create);
  static AppBroadcast? _defaultInstance;

  @$pb.TagNumber(4)
  AppTeamChanged get teamChanged => $_getN(0);
  @$pb.TagNumber(4)
  set teamChanged(AppTeamChanged value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTeamChanged() => $_has(0);
  @$pb.TagNumber(4)
  void clearTeamChanged() => $_clearField(4);
  @$pb.TagNumber(4)
  AppTeamChanged ensureTeamChanged() => $_ensure(0);

  @$pb.TagNumber(5)
  AppNewTeamMessage get teamMessage => $_getN(1);
  @$pb.TagNumber(5)
  set teamMessage(AppNewTeamMessage value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTeamMessage() => $_has(1);
  @$pb.TagNumber(5)
  void clearTeamMessage() => $_clearField(5);
  @$pb.TagNumber(5)
  AppNewTeamMessage ensureTeamMessage() => $_ensure(1);

  @$pb.TagNumber(6)
  AppEntityChanged get entityChanged => $_getN(2);
  @$pb.TagNumber(6)
  set entityChanged(AppEntityChanged value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEntityChanged() => $_has(2);
  @$pb.TagNumber(6)
  void clearEntityChanged() => $_clearField(6);
  @$pb.TagNumber(6)
  AppEntityChanged ensureEntityChanged() => $_ensure(2);

  @$pb.TagNumber(7)
  AppClanChanged get clanChanged => $_getN(3);
  @$pb.TagNumber(7)
  set clanChanged(AppClanChanged value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasClanChanged() => $_has(3);
  @$pb.TagNumber(7)
  void clearClanChanged() => $_clearField(7);
  @$pb.TagNumber(7)
  AppClanChanged ensureClanChanged() => $_ensure(3);

  @$pb.TagNumber(8)
  AppNewClanMessage get clanMessage => $_getN(4);
  @$pb.TagNumber(8)
  set clanMessage(AppNewClanMessage value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasClanMessage() => $_has(4);
  @$pb.TagNumber(8)
  void clearClanMessage() => $_clearField(8);
  @$pb.TagNumber(8)
  AppNewClanMessage ensureClanMessage() => $_ensure(4);

  @$pb.TagNumber(10)
  AppCameraRays get cameraRays => $_getN(5);
  @$pb.TagNumber(10)
  set cameraRays(AppCameraRays value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCameraRays() => $_has(5);
  @$pb.TagNumber(10)
  void clearCameraRays() => $_clearField(10);
  @$pb.TagNumber(10)
  AppCameraRays ensureCameraRays() => $_ensure(5);
}

class AppEmpty extends $pb.GeneratedMessage {
  factory AppEmpty() => create();

  AppEmpty._();

  factory AppEmpty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEmpty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEmpty',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEmpty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEmpty copyWith(void Function(AppEmpty) updates) =>
      super.copyWith((message) => updates(message as AppEmpty)) as AppEmpty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEmpty create() => AppEmpty._();
  @$core.override
  AppEmpty createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEmpty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEmpty>(create);
  static AppEmpty? _defaultInstance;
}

class AppSendMessage extends $pb.GeneratedMessage {
  factory AppSendMessage({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  AppSendMessage._();

  factory AppSendMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppSendMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppSendMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'message');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSendMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSendMessage copyWith(void Function(AppSendMessage) updates) =>
      super.copyWith((message) => updates(message as AppSendMessage))
          as AppSendMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppSendMessage create() => AppSendMessage._();
  @$core.override
  AppSendMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppSendMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppSendMessage>(create);
  static AppSendMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class AppSetEntityValue extends $pb.GeneratedMessage {
  factory AppSetEntityValue({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppSetEntityValue._();

  factory AppSetEntityValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppSetEntityValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppSetEntityValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSetEntityValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSetEntityValue copyWith(void Function(AppSetEntityValue) updates) =>
      super.copyWith((message) => updates(message as AppSetEntityValue))
          as AppSetEntityValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppSetEntityValue create() => AppSetEntityValue._();
  @$core.override
  AppSetEntityValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppSetEntityValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppSetEntityValue>(create);
  static AppSetEntityValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppPromoteToLeader extends $pb.GeneratedMessage {
  factory AppPromoteToLeader({
    $fixnum.Int64? steamId,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    return result;
  }

  AppPromoteToLeader._();

  factory AppPromoteToLeader.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppPromoteToLeader.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppPromoteToLeader',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppPromoteToLeader clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppPromoteToLeader copyWith(void Function(AppPromoteToLeader) updates) =>
      super.copyWith((message) => updates(message as AppPromoteToLeader))
          as AppPromoteToLeader;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppPromoteToLeader create() => AppPromoteToLeader._();
  @$core.override
  AppPromoteToLeader createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppPromoteToLeader getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppPromoteToLeader>(create);
  static AppPromoteToLeader? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);
}

class AppGetNexusAuth extends $pb.GeneratedMessage {
  factory AppGetNexusAuth({
    $core.String? appKey,
  }) {
    final result = create();
    if (appKey != null) result.appKey = appKey;
    return result;
  }

  AppGetNexusAuth._();

  factory AppGetNexusAuth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppGetNexusAuth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppGetNexusAuth',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'appKey', protoName: 'appKey');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppGetNexusAuth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppGetNexusAuth copyWith(void Function(AppGetNexusAuth) updates) =>
      super.copyWith((message) => updates(message as AppGetNexusAuth))
          as AppGetNexusAuth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppGetNexusAuth create() => AppGetNexusAuth._();
  @$core.override
  AppGetNexusAuth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppGetNexusAuth getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppGetNexusAuth>(create);
  static AppGetNexusAuth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set appKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppKey() => $_clearField(1);
}

class AppSuccess extends $pb.GeneratedMessage {
  factory AppSuccess() => create();

  AppSuccess._();

  factory AppSuccess.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppSuccess.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppSuccess',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSuccess clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppSuccess copyWith(void Function(AppSuccess) updates) =>
      super.copyWith((message) => updates(message as AppSuccess)) as AppSuccess;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppSuccess create() => AppSuccess._();
  @$core.override
  AppSuccess createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppSuccess getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppSuccess>(create);
  static AppSuccess? _defaultInstance;
}

class AppError extends $pb.GeneratedMessage {
  factory AppError({
    $core.String? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  AppError._();

  factory AppError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'error');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppError copyWith(void Function(AppError) updates) =>
      super.copyWith((message) => updates(message as AppError)) as AppError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppError create() => AppError._();
  @$core.override
  AppError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppError getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppError>(create);
  static AppError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
}

class AppFlag extends $pb.GeneratedMessage {
  factory AppFlag({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppFlag._();

  factory AppFlag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppFlag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppFlag',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppFlag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppFlag copyWith(void Function(AppFlag) updates) =>
      super.copyWith((message) => updates(message as AppFlag)) as AppFlag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppFlag create() => AppFlag._();
  @$core.override
  AppFlag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppFlag getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppFlag>(create);
  static AppFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppInfo extends $pb.GeneratedMessage {
  factory AppInfo({
    $core.String? name,
    $core.String? headerImage,
    $core.String? url,
    $core.String? map,
    $core.int? mapSize,
    $core.int? wipeTime,
    $core.int? players,
    $core.int? maxPlayers,
    $core.int? queuedPlayers,
    $core.int? seed,
    $core.int? salt,
    $core.String? logoImage,
    $core.String? nexus,
    $core.int? nexusId,
    $core.String? nexusZone,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (headerImage != null) result.headerImage = headerImage;
    if (url != null) result.url = url;
    if (map != null) result.map = map;
    if (mapSize != null) result.mapSize = mapSize;
    if (wipeTime != null) result.wipeTime = wipeTime;
    if (players != null) result.players = players;
    if (maxPlayers != null) result.maxPlayers = maxPlayers;
    if (queuedPlayers != null) result.queuedPlayers = queuedPlayers;
    if (seed != null) result.seed = seed;
    if (salt != null) result.salt = salt;
    if (logoImage != null) result.logoImage = logoImage;
    if (nexus != null) result.nexus = nexus;
    if (nexusId != null) result.nexusId = nexusId;
    if (nexusZone != null) result.nexusZone = nexusZone;
    return result;
  }

  AppInfo._();

  factory AppInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'name')
    ..aQS(2, _omitFieldNames ? '' : 'headerImage', protoName: 'headerImage')
    ..aQS(3, _omitFieldNames ? '' : 'url')
    ..aQS(4, _omitFieldNames ? '' : 'map')
    ..aI(5, _omitFieldNames ? '' : 'mapSize',
        protoName: 'mapSize', fieldType: $pb.PbFieldType.QU3)
    ..aI(6, _omitFieldNames ? '' : 'wipeTime',
        protoName: 'wipeTime', fieldType: $pb.PbFieldType.QU3)
    ..aI(7, _omitFieldNames ? '' : 'players', fieldType: $pb.PbFieldType.QU3)
    ..aI(8, _omitFieldNames ? '' : 'maxPlayers',
        protoName: 'maxPlayers', fieldType: $pb.PbFieldType.QU3)
    ..aI(9, _omitFieldNames ? '' : 'queuedPlayers',
        protoName: 'queuedPlayers', fieldType: $pb.PbFieldType.QU3)
    ..aI(10, _omitFieldNames ? '' : 'seed', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'salt', fieldType: $pb.PbFieldType.OU3)
    ..aOS(12, _omitFieldNames ? '' : 'logoImage', protoName: 'logoImage')
    ..aOS(13, _omitFieldNames ? '' : 'nexus')
    ..aI(14, _omitFieldNames ? '' : 'nexusId', protoName: 'nexusId')
    ..aOS(15, _omitFieldNames ? '' : 'nexusZone', protoName: 'nexusZone');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppInfo copyWith(void Function(AppInfo) updates) =>
      super.copyWith((message) => updates(message as AppInfo)) as AppInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppInfo create() => AppInfo._();
  @$core.override
  AppInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppInfo>(create);
  static AppInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get headerImage => $_getSZ(1);
  @$pb.TagNumber(2)
  set headerImage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeaderImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeaderImage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get map => $_getSZ(3);
  @$pb.TagNumber(4)
  set map($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMap() => $_has(3);
  @$pb.TagNumber(4)
  void clearMap() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get mapSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set mapSize($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMapSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearMapSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get wipeTime => $_getIZ(5);
  @$pb.TagNumber(6)
  set wipeTime($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWipeTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearWipeTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get players => $_getIZ(6);
  @$pb.TagNumber(7)
  set players($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlayers() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlayers() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get maxPlayers => $_getIZ(7);
  @$pb.TagNumber(8)
  set maxPlayers($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMaxPlayers() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxPlayers() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get queuedPlayers => $_getIZ(8);
  @$pb.TagNumber(9)
  set queuedPlayers($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasQueuedPlayers() => $_has(8);
  @$pb.TagNumber(9)
  void clearQueuedPlayers() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get seed => $_getIZ(9);
  @$pb.TagNumber(10)
  set seed($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSeed() => $_has(9);
  @$pb.TagNumber(10)
  void clearSeed() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get salt => $_getIZ(10);
  @$pb.TagNumber(11)
  set salt($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSalt() => $_has(10);
  @$pb.TagNumber(11)
  void clearSalt() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get logoImage => $_getSZ(11);
  @$pb.TagNumber(12)
  set logoImage($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLogoImage() => $_has(11);
  @$pb.TagNumber(12)
  void clearLogoImage() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get nexus => $_getSZ(12);
  @$pb.TagNumber(13)
  set nexus($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNexus() => $_has(12);
  @$pb.TagNumber(13)
  void clearNexus() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get nexusId => $_getIZ(13);
  @$pb.TagNumber(14)
  set nexusId($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNexusId() => $_has(13);
  @$pb.TagNumber(14)
  void clearNexusId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get nexusZone => $_getSZ(14);
  @$pb.TagNumber(15)
  set nexusZone($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNexusZone() => $_has(14);
  @$pb.TagNumber(15)
  void clearNexusZone() => $_clearField(15);
}

class AppTime extends $pb.GeneratedMessage {
  factory AppTime({
    $core.double? dayLengthMinutes,
    $core.double? timeScale,
    $core.double? sunrise,
    $core.double? sunset,
    $core.double? time,
  }) {
    final result = create();
    if (dayLengthMinutes != null) result.dayLengthMinutes = dayLengthMinutes;
    if (timeScale != null) result.timeScale = timeScale;
    if (sunrise != null) result.sunrise = sunrise;
    if (sunset != null) result.sunset = sunset;
    if (time != null) result.time = time;
    return result;
  }

  AppTime._();

  factory AppTime.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTime.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTime',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'dayLengthMinutes',
        protoName: 'dayLengthMinutes', fieldType: $pb.PbFieldType.QF)
    ..aD(2, _omitFieldNames ? '' : 'timeScale',
        protoName: 'timeScale', fieldType: $pb.PbFieldType.QF)
    ..aD(3, _omitFieldNames ? '' : 'sunrise', fieldType: $pb.PbFieldType.QF)
    ..aD(4, _omitFieldNames ? '' : 'sunset', fieldType: $pb.PbFieldType.QF)
    ..aD(5, _omitFieldNames ? '' : 'time', fieldType: $pb.PbFieldType.QF);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTime clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTime copyWith(void Function(AppTime) updates) =>
      super.copyWith((message) => updates(message as AppTime)) as AppTime;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTime create() => AppTime._();
  @$core.override
  AppTime createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTime getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppTime>(create);
  static AppTime? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get dayLengthMinutes => $_getN(0);
  @$pb.TagNumber(1)
  set dayLengthMinutes($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDayLengthMinutes() => $_has(0);
  @$pb.TagNumber(1)
  void clearDayLengthMinutes() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get timeScale => $_getN(1);
  @$pb.TagNumber(2)
  set timeScale($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeScale() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeScale() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sunrise => $_getN(2);
  @$pb.TagNumber(3)
  set sunrise($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSunrise() => $_has(2);
  @$pb.TagNumber(3)
  void clearSunrise() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get sunset => $_getN(3);
  @$pb.TagNumber(4)
  set sunset($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSunset() => $_has(3);
  @$pb.TagNumber(4)
  void clearSunset() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get time => $_getN(4);
  @$pb.TagNumber(5)
  set time($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearTime() => $_clearField(5);
}

class AppMap_Monument extends $pb.GeneratedMessage {
  factory AppMap_Monument({
    $core.String? token,
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  AppMap_Monument._();

  factory AppMap_Monument.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMap_Monument.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMap.Monument',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token')
    ..aD(2, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.QF)
    ..aD(3, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.QF);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMap_Monument clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMap_Monument copyWith(void Function(AppMap_Monument) updates) =>
      super.copyWith((message) => updates(message as AppMap_Monument))
          as AppMap_Monument;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMap_Monument create() => AppMap_Monument._();
  @$core.override
  AppMap_Monument createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMap_Monument getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppMap_Monument>(create);
  static AppMap_Monument? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get x => $_getN(1);
  @$pb.TagNumber(2)
  set x($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasX() => $_has(1);
  @$pb.TagNumber(2)
  void clearX() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get y => $_getN(2);
  @$pb.TagNumber(3)
  set y($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasY() => $_has(2);
  @$pb.TagNumber(3)
  void clearY() => $_clearField(3);
}

class AppMap extends $pb.GeneratedMessage {
  factory AppMap({
    $core.int? width,
    $core.int? height,
    $core.List<$core.int>? jpgImage,
    $core.int? oceanMargin,
    $core.Iterable<AppMap_Monument>? monuments,
    $core.String? background,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (jpgImage != null) result.jpgImage = jpgImage;
    if (oceanMargin != null) result.oceanMargin = oceanMargin;
    if (monuments != null) result.monuments.addAll(monuments);
    if (background != null) result.background = background;
    return result;
  }

  AppMap._();

  factory AppMap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMap',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.QU3)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'jpgImage', $pb.PbFieldType.QY,
        protoName: 'jpgImage')
    ..aI(4, _omitFieldNames ? '' : 'oceanMargin',
        protoName: 'oceanMargin', fieldType: $pb.PbFieldType.Q3)
    ..pPM<AppMap_Monument>(5, _omitFieldNames ? '' : 'monuments',
        subBuilder: AppMap_Monument.create)
    ..aOS(6, _omitFieldNames ? '' : 'background');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMap copyWith(void Function(AppMap) updates) =>
      super.copyWith((message) => updates(message as AppMap)) as AppMap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMap create() => AppMap._();
  @$core.override
  AppMap createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMap getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppMap>(create);
  static AppMap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get jpgImage => $_getN(2);
  @$pb.TagNumber(3)
  set jpgImage($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJpgImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearJpgImage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get oceanMargin => $_getIZ(3);
  @$pb.TagNumber(4)
  set oceanMargin($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOceanMargin() => $_has(3);
  @$pb.TagNumber(4)
  void clearOceanMargin() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<AppMap_Monument> get monuments => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get background => $_getSZ(5);
  @$pb.TagNumber(6)
  set background($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBackground() => $_has(5);
  @$pb.TagNumber(6)
  void clearBackground() => $_clearField(6);
}

class AppEntityInfo extends $pb.GeneratedMessage {
  factory AppEntityInfo({
    AppEntityType? type,
    AppEntityPayload? payload,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (payload != null) result.payload = payload;
    return result;
  }

  AppEntityInfo._();

  factory AppEntityInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEntityInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEntityInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aE<AppEntityType>(1, _omitFieldNames ? '' : 'type',
        fieldType: $pb.PbFieldType.QE, enumValues: AppEntityType.values)
    ..aQM<AppEntityPayload>(3, _omitFieldNames ? '' : 'payload',
        subBuilder: AppEntityPayload.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityInfo copyWith(void Function(AppEntityInfo) updates) =>
      super.copyWith((message) => updates(message as AppEntityInfo))
          as AppEntityInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEntityInfo create() => AppEntityInfo._();
  @$core.override
  AppEntityInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEntityInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEntityInfo>(create);
  static AppEntityInfo? _defaultInstance;

  @$pb.TagNumber(1)
  AppEntityType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(AppEntityType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(3)
  AppEntityPayload get payload => $_getN(1);
  @$pb.TagNumber(3)
  set payload(AppEntityPayload value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField(3);
  @$pb.TagNumber(3)
  AppEntityPayload ensurePayload() => $_ensure(1);
}

class AppEntityPayload_Item extends $pb.GeneratedMessage {
  factory AppEntityPayload_Item({
    $core.int? itemId,
    $core.int? quantity,
    $core.bool? itemIsBlueprint,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (quantity != null) result.quantity = quantity;
    if (itemIsBlueprint != null) result.itemIsBlueprint = itemIsBlueprint;
    return result;
  }

  AppEntityPayload_Item._();

  factory AppEntityPayload_Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEntityPayload_Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEntityPayload.Item',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'itemId',
        protoName: 'itemId', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'quantity', fieldType: $pb.PbFieldType.Q3)
    ..a<$core.bool>(
        3, _omitFieldNames ? '' : 'itemIsBlueprint', $pb.PbFieldType.QB,
        protoName: 'itemIsBlueprint');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityPayload_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityPayload_Item copyWith(
          void Function(AppEntityPayload_Item) updates) =>
      super.copyWith((message) => updates(message as AppEntityPayload_Item))
          as AppEntityPayload_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEntityPayload_Item create() => AppEntityPayload_Item._();
  @$core.override
  AppEntityPayload_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEntityPayload_Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEntityPayload_Item>(create);
  static AppEntityPayload_Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itemId => $_getIZ(0);
  @$pb.TagNumber(1)
  set itemId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get itemIsBlueprint => $_getBF(2);
  @$pb.TagNumber(3)
  set itemIsBlueprint($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemIsBlueprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemIsBlueprint() => $_clearField(3);
}

class AppEntityPayload extends $pb.GeneratedMessage {
  factory AppEntityPayload({
    $core.bool? value,
    $core.Iterable<AppEntityPayload_Item>? items,
    $core.int? capacity,
    $core.bool? hasProtection,
    $core.int? protectionExpiry,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (items != null) result.items.addAll(items);
    if (capacity != null) result.capacity = capacity;
    if (hasProtection != null) result.hasProtection = hasProtection;
    if (protectionExpiry != null) result.protectionExpiry = protectionExpiry;
    return result;
  }

  AppEntityPayload._();

  factory AppEntityPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEntityPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEntityPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..pPM<AppEntityPayload_Item>(2, _omitFieldNames ? '' : 'items',
        subBuilder: AppEntityPayload_Item.create)
    ..aI(3, _omitFieldNames ? '' : 'capacity')
    ..aOB(4, _omitFieldNames ? '' : 'hasProtection', protoName: 'hasProtection')
    ..aI(5, _omitFieldNames ? '' : 'protectionExpiry',
        protoName: 'protectionExpiry', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityPayload copyWith(void Function(AppEntityPayload) updates) =>
      super.copyWith((message) => updates(message as AppEntityPayload))
          as AppEntityPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEntityPayload create() => AppEntityPayload._();
  @$core.override
  AppEntityPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEntityPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEntityPayload>(create);
  static AppEntityPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<AppEntityPayload_Item> get items => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get capacity => $_getIZ(2);
  @$pb.TagNumber(3)
  set capacity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCapacity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapacity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasProtection => $_getBF(3);
  @$pb.TagNumber(4)
  set hasProtection($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasProtection() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasProtection() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get protectionExpiry => $_getIZ(4);
  @$pb.TagNumber(5)
  set protectionExpiry($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProtectionExpiry() => $_has(4);
  @$pb.TagNumber(5)
  void clearProtectionExpiry() => $_clearField(5);
}

class AppTeamInfo_Member extends $pb.GeneratedMessage {
  factory AppTeamInfo_Member({
    $fixnum.Int64? steamId,
    $core.String? name,
    $core.double? x,
    $core.double? y,
    $core.bool? isOnline,
    $core.int? spawnTime,
    $core.bool? isAlive,
    $core.int? deathTime,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    if (name != null) result.name = name;
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (isOnline != null) result.isOnline = isOnline;
    if (spawnTime != null) result.spawnTime = spawnTime;
    if (isAlive != null) result.isAlive = isAlive;
    if (deathTime != null) result.deathTime = deathTime;
    return result;
  }

  AppTeamInfo_Member._();

  factory AppTeamInfo_Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamInfo_Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamInfo.Member',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.QF)
    ..aD(4, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.QF)
    ..a<$core.bool>(5, _omitFieldNames ? '' : 'isOnline', $pb.PbFieldType.QB,
        protoName: 'isOnline')
    ..aI(6, _omitFieldNames ? '' : 'spawnTime',
        protoName: 'spawnTime', fieldType: $pb.PbFieldType.QU3)
    ..a<$core.bool>(7, _omitFieldNames ? '' : 'isAlive', $pb.PbFieldType.QB,
        protoName: 'isAlive')
    ..aI(8, _omitFieldNames ? '' : 'deathTime',
        protoName: 'deathTime', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo_Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo_Member copyWith(void Function(AppTeamInfo_Member) updates) =>
      super.copyWith((message) => updates(message as AppTeamInfo_Member))
          as AppTeamInfo_Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamInfo_Member create() => AppTeamInfo_Member._();
  @$core.override
  AppTeamInfo_Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamInfo_Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamInfo_Member>(create);
  static AppTeamInfo_Member? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get x => $_getN(2);
  @$pb.TagNumber(3)
  set x($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasX() => $_has(2);
  @$pb.TagNumber(3)
  void clearX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get y => $_getN(3);
  @$pb.TagNumber(4)
  set y($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasY() => $_has(3);
  @$pb.TagNumber(4)
  void clearY() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isOnline => $_getBF(4);
  @$pb.TagNumber(5)
  set isOnline($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsOnline() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsOnline() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get spawnTime => $_getIZ(5);
  @$pb.TagNumber(6)
  set spawnTime($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSpawnTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpawnTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isAlive => $_getBF(6);
  @$pb.TagNumber(7)
  set isAlive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsAlive() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsAlive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get deathTime => $_getIZ(7);
  @$pb.TagNumber(8)
  set deathTime($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeathTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeathTime() => $_clearField(8);
}

class AppTeamInfo_Note extends $pb.GeneratedMessage {
  factory AppTeamInfo_Note({
    $core.int? type,
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  AppTeamInfo_Note._();

  factory AppTeamInfo_Note.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamInfo_Note.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamInfo.Note',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(2, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.Q3)
    ..aD(3, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.QF)
    ..aD(4, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.QF);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo_Note clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo_Note copyWith(void Function(AppTeamInfo_Note) updates) =>
      super.copyWith((message) => updates(message as AppTeamInfo_Note))
          as AppTeamInfo_Note;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamInfo_Note create() => AppTeamInfo_Note._();
  @$core.override
  AppTeamInfo_Note createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamInfo_Note getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamInfo_Note>(create);
  static AppTeamInfo_Note? _defaultInstance;

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(2)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get x => $_getN(1);
  @$pb.TagNumber(3)
  set x($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(3)
  $core.bool hasX() => $_has(1);
  @$pb.TagNumber(3)
  void clearX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get y => $_getN(2);
  @$pb.TagNumber(4)
  set y($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(4)
  $core.bool hasY() => $_has(2);
  @$pb.TagNumber(4)
  void clearY() => $_clearField(4);
}

class AppTeamInfo extends $pb.GeneratedMessage {
  factory AppTeamInfo({
    $fixnum.Int64? leaderSteamId,
    $core.Iterable<AppTeamInfo_Member>? members,
    $core.Iterable<AppTeamInfo_Note>? mapNotes,
    $core.Iterable<AppTeamInfo_Note>? leaderMapNotes,
  }) {
    final result = create();
    if (leaderSteamId != null) result.leaderSteamId = leaderSteamId;
    if (members != null) result.members.addAll(members);
    if (mapNotes != null) result.mapNotes.addAll(mapNotes);
    if (leaderMapNotes != null) result.leaderMapNotes.addAll(leaderMapNotes);
    return result;
  }

  AppTeamInfo._();

  factory AppTeamInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'leaderSteamId', $pb.PbFieldType.QU6,
        protoName: 'leaderSteamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<AppTeamInfo_Member>(2, _omitFieldNames ? '' : 'members',
        subBuilder: AppTeamInfo_Member.create)
    ..pPM<AppTeamInfo_Note>(3, _omitFieldNames ? '' : 'mapNotes',
        protoName: 'mapNotes', subBuilder: AppTeamInfo_Note.create)
    ..pPM<AppTeamInfo_Note>(4, _omitFieldNames ? '' : 'leaderMapNotes',
        protoName: 'leaderMapNotes', subBuilder: AppTeamInfo_Note.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamInfo copyWith(void Function(AppTeamInfo) updates) =>
      super.copyWith((message) => updates(message as AppTeamInfo))
          as AppTeamInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamInfo create() => AppTeamInfo._();
  @$core.override
  AppTeamInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamInfo>(create);
  static AppTeamInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get leaderSteamId => $_getI64(0);
  @$pb.TagNumber(1)
  set leaderSteamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLeaderSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeaderSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<AppTeamInfo_Member> get members => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<AppTeamInfo_Note> get mapNotes => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<AppTeamInfo_Note> get leaderMapNotes => $_getList(3);
}

class AppTeamMessage extends $pb.GeneratedMessage {
  factory AppTeamMessage({
    $fixnum.Int64? steamId,
    $core.String? name,
    $core.String? message,
    $core.String? color,
    $core.int? time,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    if (name != null) result.name = name;
    if (message != null) result.message = message;
    if (color != null) result.color = color;
    if (time != null) result.time = time;
    return result;
  }

  AppTeamMessage._();

  factory AppTeamMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'message')
    ..aQS(4, _omitFieldNames ? '' : 'color')
    ..aI(5, _omitFieldNames ? '' : 'time', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamMessage copyWith(void Function(AppTeamMessage) updates) =>
      super.copyWith((message) => updates(message as AppTeamMessage))
          as AppTeamMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamMessage create() => AppTeamMessage._();
  @$core.override
  AppTeamMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamMessage>(create);
  static AppTeamMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get time => $_getIZ(4);
  @$pb.TagNumber(5)
  set time($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearTime() => $_clearField(5);
}

class AppTeamChat extends $pb.GeneratedMessage {
  factory AppTeamChat({
    $core.Iterable<AppTeamMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  AppTeamChat._();

  factory AppTeamChat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamChat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..pPM<AppTeamMessage>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: AppTeamMessage.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamChat copyWith(void Function(AppTeamChat) updates) =>
      super.copyWith((message) => updates(message as AppTeamChat))
          as AppTeamChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamChat create() => AppTeamChat._();
  @$core.override
  AppTeamChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamChat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamChat>(create);
  static AppTeamChat? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AppTeamMessage> get messages => $_getList(0);
}

class AppMarker_SellOrder extends $pb.GeneratedMessage {
  factory AppMarker_SellOrder({
    $core.int? itemId,
    $core.int? quantity,
    $core.int? currencyId,
    $core.int? costPerItem,
    $core.int? amountInStock,
    $core.bool? itemIsBlueprint,
    $core.bool? currencyIsBlueprint,
    $core.double? itemCondition,
    $core.double? itemConditionMax,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (quantity != null) result.quantity = quantity;
    if (currencyId != null) result.currencyId = currencyId;
    if (costPerItem != null) result.costPerItem = costPerItem;
    if (amountInStock != null) result.amountInStock = amountInStock;
    if (itemIsBlueprint != null) result.itemIsBlueprint = itemIsBlueprint;
    if (currencyIsBlueprint != null)
      result.currencyIsBlueprint = currencyIsBlueprint;
    if (itemCondition != null) result.itemCondition = itemCondition;
    if (itemConditionMax != null) result.itemConditionMax = itemConditionMax;
    return result;
  }

  AppMarker_SellOrder._();

  factory AppMarker_SellOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMarker_SellOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMarker.SellOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'itemId',
        protoName: 'itemId', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'quantity', fieldType: $pb.PbFieldType.Q3)
    ..aI(3, _omitFieldNames ? '' : 'currencyId',
        protoName: 'currencyId', fieldType: $pb.PbFieldType.Q3)
    ..aI(4, _omitFieldNames ? '' : 'costPerItem',
        protoName: 'costPerItem', fieldType: $pb.PbFieldType.Q3)
    ..aI(5, _omitFieldNames ? '' : 'amountInStock',
        protoName: 'amountInStock', fieldType: $pb.PbFieldType.Q3)
    ..a<$core.bool>(
        6, _omitFieldNames ? '' : 'itemIsBlueprint', $pb.PbFieldType.QB,
        protoName: 'itemIsBlueprint')
    ..a<$core.bool>(
        7, _omitFieldNames ? '' : 'currencyIsBlueprint', $pb.PbFieldType.QB,
        protoName: 'currencyIsBlueprint')
    ..aD(8, _omitFieldNames ? '' : 'itemCondition',
        protoName: 'itemCondition', fieldType: $pb.PbFieldType.OF)
    ..aD(9, _omitFieldNames ? '' : 'itemConditionMax',
        protoName: 'itemConditionMax', fieldType: $pb.PbFieldType.OF);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMarker_SellOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMarker_SellOrder copyWith(void Function(AppMarker_SellOrder) updates) =>
      super.copyWith((message) => updates(message as AppMarker_SellOrder))
          as AppMarker_SellOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMarker_SellOrder create() => AppMarker_SellOrder._();
  @$core.override
  AppMarker_SellOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMarker_SellOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppMarker_SellOrder>(create);
  static AppMarker_SellOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itemId => $_getIZ(0);
  @$pb.TagNumber(1)
  set itemId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get currencyId => $_getIZ(2);
  @$pb.TagNumber(3)
  set currencyId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrencyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrencyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get costPerItem => $_getIZ(3);
  @$pb.TagNumber(4)
  set costPerItem($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCostPerItem() => $_has(3);
  @$pb.TagNumber(4)
  void clearCostPerItem() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get amountInStock => $_getIZ(4);
  @$pb.TagNumber(5)
  set amountInStock($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAmountInStock() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmountInStock() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get itemIsBlueprint => $_getBF(5);
  @$pb.TagNumber(6)
  set itemIsBlueprint($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasItemIsBlueprint() => $_has(5);
  @$pb.TagNumber(6)
  void clearItemIsBlueprint() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get currencyIsBlueprint => $_getBF(6);
  @$pb.TagNumber(7)
  set currencyIsBlueprint($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrencyIsBlueprint() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrencyIsBlueprint() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get itemCondition => $_getN(7);
  @$pb.TagNumber(8)
  set itemCondition($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasItemCondition() => $_has(7);
  @$pb.TagNumber(8)
  void clearItemCondition() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get itemConditionMax => $_getN(8);
  @$pb.TagNumber(9)
  set itemConditionMax($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasItemConditionMax() => $_has(8);
  @$pb.TagNumber(9)
  void clearItemConditionMax() => $_clearField(9);
}

class AppMarker extends $pb.GeneratedMessage {
  factory AppMarker({
    $core.int? id,
    AppMarkerType? type,
    $core.double? x,
    $core.double? y,
    $fixnum.Int64? steamId,
    $core.double? rotation,
    $core.double? radius,
    Vector4? color1,
    Vector4? color2,
    $core.double? alpha,
    $core.String? name,
    $core.bool? outOfStock,
    $core.Iterable<AppMarker_SellOrder>? sellOrders,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (steamId != null) result.steamId = steamId;
    if (rotation != null) result.rotation = rotation;
    if (radius != null) result.radius = radius;
    if (color1 != null) result.color1 = color1;
    if (color2 != null) result.color2 = color2;
    if (alpha != null) result.alpha = alpha;
    if (name != null) result.name = name;
    if (outOfStock != null) result.outOfStock = outOfStock;
    if (sellOrders != null) result.sellOrders.addAll(sellOrders);
    return result;
  }

  AppMarker._();

  factory AppMarker.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMarker.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMarker',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.QU3)
    ..aE<AppMarkerType>(2, _omitFieldNames ? '' : 'type',
        fieldType: $pb.PbFieldType.QE, enumValues: AppMarkerType.values)
    ..aD(3, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.QF)
    ..aD(4, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.QF)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.OU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(6, _omitFieldNames ? '' : 'rotation', fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'radius', fieldType: $pb.PbFieldType.OF)
    ..aOM<Vector4>(8, _omitFieldNames ? '' : 'color1',
        subBuilder: Vector4.create)
    ..aOM<Vector4>(9, _omitFieldNames ? '' : 'color2',
        subBuilder: Vector4.create)
    ..aD(10, _omitFieldNames ? '' : 'alpha', fieldType: $pb.PbFieldType.OF)
    ..aOS(11, _omitFieldNames ? '' : 'name')
    ..aOB(12, _omitFieldNames ? '' : 'outOfStock', protoName: 'outOfStock')
    ..pPM<AppMarker_SellOrder>(13, _omitFieldNames ? '' : 'sellOrders',
        protoName: 'sellOrders', subBuilder: AppMarker_SellOrder.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMarker clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMarker copyWith(void Function(AppMarker) updates) =>
      super.copyWith((message) => updates(message as AppMarker)) as AppMarker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMarker create() => AppMarker._();
  @$core.override
  AppMarker createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMarker getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppMarker>(create);
  static AppMarker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppMarkerType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(AppMarkerType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get x => $_getN(2);
  @$pb.TagNumber(3)
  set x($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasX() => $_has(2);
  @$pb.TagNumber(3)
  void clearX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get y => $_getN(3);
  @$pb.TagNumber(4)
  set y($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasY() => $_has(3);
  @$pb.TagNumber(4)
  void clearY() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get steamId => $_getI64(4);
  @$pb.TagNumber(5)
  set steamId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSteamId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSteamId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get rotation => $_getN(5);
  @$pb.TagNumber(6)
  set rotation($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRotation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRotation() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get radius => $_getN(6);
  @$pb.TagNumber(7)
  set radius($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRadius() => $_has(6);
  @$pb.TagNumber(7)
  void clearRadius() => $_clearField(7);

  @$pb.TagNumber(8)
  Vector4 get color1 => $_getN(7);
  @$pb.TagNumber(8)
  set color1(Vector4 value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasColor1() => $_has(7);
  @$pb.TagNumber(8)
  void clearColor1() => $_clearField(8);
  @$pb.TagNumber(8)
  Vector4 ensureColor1() => $_ensure(7);

  @$pb.TagNumber(9)
  Vector4 get color2 => $_getN(8);
  @$pb.TagNumber(9)
  set color2(Vector4 value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasColor2() => $_has(8);
  @$pb.TagNumber(9)
  void clearColor2() => $_clearField(9);
  @$pb.TagNumber(9)
  Vector4 ensureColor2() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.double get alpha => $_getN(9);
  @$pb.TagNumber(10)
  set alpha($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAlpha() => $_has(9);
  @$pb.TagNumber(10)
  void clearAlpha() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get name => $_getSZ(10);
  @$pb.TagNumber(11)
  set name($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasName() => $_has(10);
  @$pb.TagNumber(11)
  void clearName() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get outOfStock => $_getBF(11);
  @$pb.TagNumber(12)
  set outOfStock($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOutOfStock() => $_has(11);
  @$pb.TagNumber(12)
  void clearOutOfStock() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<AppMarker_SellOrder> get sellOrders => $_getList(12);
}

class AppMapMarkers extends $pb.GeneratedMessage {
  factory AppMapMarkers({
    $core.Iterable<AppMarker>? markers,
  }) {
    final result = create();
    if (markers != null) result.markers.addAll(markers);
    return result;
  }

  AppMapMarkers._();

  factory AppMapMarkers.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppMapMarkers.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppMapMarkers',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..pPM<AppMarker>(1, _omitFieldNames ? '' : 'markers',
        subBuilder: AppMarker.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMapMarkers clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppMapMarkers copyWith(void Function(AppMapMarkers) updates) =>
      super.copyWith((message) => updates(message as AppMapMarkers))
          as AppMapMarkers;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppMapMarkers create() => AppMapMarkers._();
  @$core.override
  AppMapMarkers createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppMapMarkers getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppMapMarkers>(create);
  static AppMapMarkers? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AppMarker> get markers => $_getList(0);
}

class AppClanInfo extends $pb.GeneratedMessage {
  factory AppClanInfo({
    ClanInfo? clanInfo,
  }) {
    final result = create();
    if (clanInfo != null) result.clanInfo = clanInfo;
    return result;
  }

  AppClanInfo._();

  factory AppClanInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppClanInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppClanInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOM<ClanInfo>(1, _omitFieldNames ? '' : 'clanInfo',
        protoName: 'clanInfo', subBuilder: ClanInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanInfo copyWith(void Function(AppClanInfo) updates) =>
      super.copyWith((message) => updates(message as AppClanInfo))
          as AppClanInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppClanInfo create() => AppClanInfo._();
  @$core.override
  AppClanInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppClanInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppClanInfo>(create);
  static AppClanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  ClanInfo get clanInfo => $_getN(0);
  @$pb.TagNumber(1)
  set clanInfo(ClanInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClanInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  ClanInfo ensureClanInfo() => $_ensure(0);
}

class AppClanMessage extends $pb.GeneratedMessage {
  factory AppClanMessage({
    $fixnum.Int64? steamId,
    $core.String? name,
    $core.String? message,
    $fixnum.Int64? time,
  }) {
    final result = create();
    if (steamId != null) result.steamId = steamId;
    if (name != null) result.name = name;
    if (message != null) result.message = message;
    if (time != null) result.time = time;
    return result;
  }

  AppClanMessage._();

  factory AppClanMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppClanMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppClanMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'steamId', $pb.PbFieldType.QU6,
        protoName: 'steamId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'message')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'time', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanMessage copyWith(void Function(AppClanMessage) updates) =>
      super.copyWith((message) => updates(message as AppClanMessage))
          as AppClanMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppClanMessage create() => AppClanMessage._();
  @$core.override
  AppClanMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppClanMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppClanMessage>(create);
  static AppClanMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get steamId => $_getI64(0);
  @$pb.TagNumber(1)
  set steamId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get time => $_getI64(3);
  @$pb.TagNumber(4)
  set time($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearTime() => $_clearField(4);
}

class AppClanChat extends $pb.GeneratedMessage {
  factory AppClanChat({
    $core.Iterable<AppClanMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  AppClanChat._();

  factory AppClanChat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppClanChat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppClanChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..pPM<AppClanMessage>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: AppClanMessage.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanChat copyWith(void Function(AppClanChat) updates) =>
      super.copyWith((message) => updates(message as AppClanChat))
          as AppClanChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppClanChat create() => AppClanChat._();
  @$core.override
  AppClanChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppClanChat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppClanChat>(create);
  static AppClanChat? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AppClanMessage> get messages => $_getList(0);
}

class AppNexusAuth extends $pb.GeneratedMessage {
  factory AppNexusAuth({
    $core.String? serverId,
    $core.int? playerToken,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (playerToken != null) result.playerToken = playerToken;
    return result;
  }

  AppNexusAuth._();

  factory AppNexusAuth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppNexusAuth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppNexusAuth',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'serverId', protoName: 'serverId')
    ..aI(2, _omitFieldNames ? '' : 'playerToken',
        protoName: 'playerToken', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNexusAuth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNexusAuth copyWith(void Function(AppNexusAuth) updates) =>
      super.copyWith((message) => updates(message as AppNexusAuth))
          as AppNexusAuth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppNexusAuth create() => AppNexusAuth._();
  @$core.override
  AppNexusAuth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppNexusAuth getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppNexusAuth>(create);
  static AppNexusAuth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get playerToken => $_getIZ(1);
  @$pb.TagNumber(2)
  set playerToken($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerToken() => $_clearField(2);
}

class AppTeamChanged extends $pb.GeneratedMessage {
  factory AppTeamChanged({
    $fixnum.Int64? playerId,
    AppTeamInfo? teamInfo,
  }) {
    final result = create();
    if (playerId != null) result.playerId = playerId;
    if (teamInfo != null) result.teamInfo = teamInfo;
    return result;
  }

  AppTeamChanged._();

  factory AppTeamChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppTeamChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppTeamChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'playerId', $pb.PbFieldType.QU6,
        protoName: 'playerId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQM<AppTeamInfo>(2, _omitFieldNames ? '' : 'teamInfo',
        protoName: 'teamInfo', subBuilder: AppTeamInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppTeamChanged copyWith(void Function(AppTeamChanged) updates) =>
      super.copyWith((message) => updates(message as AppTeamChanged))
          as AppTeamChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppTeamChanged create() => AppTeamChanged._();
  @$core.override
  AppTeamChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppTeamChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppTeamChanged>(create);
  static AppTeamChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get playerId => $_getI64(0);
  @$pb.TagNumber(1)
  set playerId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppTeamInfo get teamInfo => $_getN(1);
  @$pb.TagNumber(2)
  set teamInfo(AppTeamInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTeamInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTeamInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  AppTeamInfo ensureTeamInfo() => $_ensure(1);
}

class AppNewTeamMessage extends $pb.GeneratedMessage {
  factory AppNewTeamMessage({
    AppTeamMessage? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  AppNewTeamMessage._();

  factory AppNewTeamMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppNewTeamMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppNewTeamMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQM<AppTeamMessage>(1, _omitFieldNames ? '' : 'message',
        subBuilder: AppTeamMessage.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNewTeamMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNewTeamMessage copyWith(void Function(AppNewTeamMessage) updates) =>
      super.copyWith((message) => updates(message as AppNewTeamMessage))
          as AppNewTeamMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppNewTeamMessage create() => AppNewTeamMessage._();
  @$core.override
  AppNewTeamMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppNewTeamMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppNewTeamMessage>(create);
  static AppNewTeamMessage? _defaultInstance;

  @$pb.TagNumber(1)
  AppTeamMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(AppTeamMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  AppTeamMessage ensureMessage() => $_ensure(0);
}

class AppEntityChanged extends $pb.GeneratedMessage {
  factory AppEntityChanged({
    $core.int? entityId,
    AppEntityPayload? payload,
  }) {
    final result = create();
    if (entityId != null) result.entityId = entityId;
    if (payload != null) result.payload = payload;
    return result;
  }

  AppEntityChanged._();

  factory AppEntityChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEntityChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEntityChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'entityId',
        protoName: 'entityId', fieldType: $pb.PbFieldType.QU3)
    ..aQM<AppEntityPayload>(2, _omitFieldNames ? '' : 'payload',
        subBuilder: AppEntityPayload.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEntityChanged copyWith(void Function(AppEntityChanged) updates) =>
      super.copyWith((message) => updates(message as AppEntityChanged))
          as AppEntityChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEntityChanged create() => AppEntityChanged._();
  @$core.override
  AppEntityChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEntityChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEntityChanged>(create);
  static AppEntityChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get entityId => $_getIZ(0);
  @$pb.TagNumber(1)
  set entityId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppEntityPayload get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload(AppEntityPayload value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => $_clearField(2);
  @$pb.TagNumber(2)
  AppEntityPayload ensurePayload() => $_ensure(1);
}

class AppClanChanged extends $pb.GeneratedMessage {
  factory AppClanChanged({
    ClanInfo? clanInfo,
  }) {
    final result = create();
    if (clanInfo != null) result.clanInfo = clanInfo;
    return result;
  }

  AppClanChanged._();

  factory AppClanChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppClanChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppClanChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aOM<ClanInfo>(1, _omitFieldNames ? '' : 'clanInfo',
        protoName: 'clanInfo', subBuilder: ClanInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppClanChanged copyWith(void Function(AppClanChanged) updates) =>
      super.copyWith((message) => updates(message as AppClanChanged))
          as AppClanChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppClanChanged create() => AppClanChanged._();
  @$core.override
  AppClanChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppClanChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppClanChanged>(create);
  static AppClanChanged? _defaultInstance;

  @$pb.TagNumber(1)
  ClanInfo get clanInfo => $_getN(0);
  @$pb.TagNumber(1)
  set clanInfo(ClanInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClanInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  ClanInfo ensureClanInfo() => $_ensure(0);
}

class AppNewClanMessage extends $pb.GeneratedMessage {
  factory AppNewClanMessage({
    $fixnum.Int64? clanId,
    AppClanMessage? message,
  }) {
    final result = create();
    if (clanId != null) result.clanId = clanId;
    if (message != null) result.message = message;
    return result;
  }

  AppNewClanMessage._();

  factory AppNewClanMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppNewClanMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppNewClanMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'clanId', $pb.PbFieldType.Q6,
        protoName: 'clanId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQM<AppClanMessage>(2, _omitFieldNames ? '' : 'message',
        subBuilder: AppClanMessage.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNewClanMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppNewClanMessage copyWith(void Function(AppNewClanMessage) updates) =>
      super.copyWith((message) => updates(message as AppNewClanMessage))
          as AppNewClanMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppNewClanMessage create() => AppNewClanMessage._();
  @$core.override
  AppNewClanMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppNewClanMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppNewClanMessage>(create);
  static AppNewClanMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clanId => $_getI64(0);
  @$pb.TagNumber(1)
  set clanId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClanId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppClanMessage get message => $_getN(1);
  @$pb.TagNumber(2)
  set message(AppClanMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
  @$pb.TagNumber(2)
  AppClanMessage ensureMessage() => $_ensure(1);
}

class AppCameraSubscribe extends $pb.GeneratedMessage {
  factory AppCameraSubscribe({
    $core.String? cameraId,
  }) {
    final result = create();
    if (cameraId != null) result.cameraId = cameraId;
    return result;
  }

  AppCameraSubscribe._();

  factory AppCameraSubscribe.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppCameraSubscribe.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppCameraSubscribe',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'cameraId', protoName: 'cameraId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraSubscribe clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraSubscribe copyWith(void Function(AppCameraSubscribe) updates) =>
      super.copyWith((message) => updates(message as AppCameraSubscribe))
          as AppCameraSubscribe;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppCameraSubscribe create() => AppCameraSubscribe._();
  @$core.override
  AppCameraSubscribe createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppCameraSubscribe getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppCameraSubscribe>(create);
  static AppCameraSubscribe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cameraId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cameraId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCameraId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCameraId() => $_clearField(1);
}

class AppCameraInput extends $pb.GeneratedMessage {
  factory AppCameraInput({
    $core.int? buttons,
    Vector2? mouseDelta,
  }) {
    final result = create();
    if (buttons != null) result.buttons = buttons;
    if (mouseDelta != null) result.mouseDelta = mouseDelta;
    return result;
  }

  AppCameraInput._();

  factory AppCameraInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppCameraInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppCameraInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'buttons', fieldType: $pb.PbFieldType.Q3)
    ..aQM<Vector2>(2, _omitFieldNames ? '' : 'mouseDelta',
        protoName: 'mouseDelta', subBuilder: Vector2.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraInput copyWith(void Function(AppCameraInput) updates) =>
      super.copyWith((message) => updates(message as AppCameraInput))
          as AppCameraInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppCameraInput create() => AppCameraInput._();
  @$core.override
  AppCameraInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppCameraInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppCameraInput>(create);
  static AppCameraInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get buttons => $_getIZ(0);
  @$pb.TagNumber(1)
  set buttons($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasButtons() => $_has(0);
  @$pb.TagNumber(1)
  void clearButtons() => $_clearField(1);

  @$pb.TagNumber(2)
  Vector2 get mouseDelta => $_getN(1);
  @$pb.TagNumber(2)
  set mouseDelta(Vector2 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMouseDelta() => $_has(1);
  @$pb.TagNumber(2)
  void clearMouseDelta() => $_clearField(2);
  @$pb.TagNumber(2)
  Vector2 ensureMouseDelta() => $_ensure(1);
}

class AppCameraInfo extends $pb.GeneratedMessage {
  factory AppCameraInfo({
    $core.int? width,
    $core.int? height,
    $core.double? nearPlane,
    $core.double? farPlane,
    $core.int? controlFlags,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (nearPlane != null) result.nearPlane = nearPlane;
    if (farPlane != null) result.farPlane = farPlane;
    if (controlFlags != null) result.controlFlags = controlFlags;
    return result;
  }

  AppCameraInfo._();

  factory AppCameraInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppCameraInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppCameraInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.Q3)
    ..aD(3, _omitFieldNames ? '' : 'nearPlane',
        protoName: 'nearPlane', fieldType: $pb.PbFieldType.QF)
    ..aD(4, _omitFieldNames ? '' : 'farPlane',
        protoName: 'farPlane', fieldType: $pb.PbFieldType.QF)
    ..aI(5, _omitFieldNames ? '' : 'controlFlags',
        protoName: 'controlFlags', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraInfo copyWith(void Function(AppCameraInfo) updates) =>
      super.copyWith((message) => updates(message as AppCameraInfo))
          as AppCameraInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppCameraInfo create() => AppCameraInfo._();
  @$core.override
  AppCameraInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppCameraInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppCameraInfo>(create);
  static AppCameraInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get nearPlane => $_getN(2);
  @$pb.TagNumber(3)
  set nearPlane($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNearPlane() => $_has(2);
  @$pb.TagNumber(3)
  void clearNearPlane() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get farPlane => $_getN(3);
  @$pb.TagNumber(4)
  set farPlane($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFarPlane() => $_has(3);
  @$pb.TagNumber(4)
  void clearFarPlane() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get controlFlags => $_getIZ(4);
  @$pb.TagNumber(5)
  set controlFlags($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasControlFlags() => $_has(4);
  @$pb.TagNumber(5)
  void clearControlFlags() => $_clearField(5);
}

class AppCameraRays_Entity extends $pb.GeneratedMessage {
  factory AppCameraRays_Entity({
    $core.int? entityId,
    AppCameraRays_EntityType? type,
    Vector3? position,
    Vector3? rotation,
    Vector3? size,
    $core.String? name,
  }) {
    final result = create();
    if (entityId != null) result.entityId = entityId;
    if (type != null) result.type = type;
    if (position != null) result.position = position;
    if (rotation != null) result.rotation = rotation;
    if (size != null) result.size = size;
    if (name != null) result.name = name;
    return result;
  }

  AppCameraRays_Entity._();

  factory AppCameraRays_Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppCameraRays_Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppCameraRays.Entity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'entityId',
        protoName: 'entityId', fieldType: $pb.PbFieldType.QU3)
    ..aE<AppCameraRays_EntityType>(2, _omitFieldNames ? '' : 'type',
        fieldType: $pb.PbFieldType.QE,
        enumValues: AppCameraRays_EntityType.values)
    ..aQM<Vector3>(3, _omitFieldNames ? '' : 'position',
        subBuilder: Vector3.create)
    ..aQM<Vector3>(4, _omitFieldNames ? '' : 'rotation',
        subBuilder: Vector3.create)
    ..aQM<Vector3>(5, _omitFieldNames ? '' : 'size', subBuilder: Vector3.create)
    ..aOS(6, _omitFieldNames ? '' : 'name');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraRays_Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraRays_Entity copyWith(void Function(AppCameraRays_Entity) updates) =>
      super.copyWith((message) => updates(message as AppCameraRays_Entity))
          as AppCameraRays_Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppCameraRays_Entity create() => AppCameraRays_Entity._();
  @$core.override
  AppCameraRays_Entity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppCameraRays_Entity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppCameraRays_Entity>(create);
  static AppCameraRays_Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get entityId => $_getIZ(0);
  @$pb.TagNumber(1)
  set entityId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppCameraRays_EntityType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(AppCameraRays_EntityType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  Vector3 get position => $_getN(2);
  @$pb.TagNumber(3)
  set position(Vector3 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);
  @$pb.TagNumber(3)
  Vector3 ensurePosition() => $_ensure(2);

  @$pb.TagNumber(4)
  Vector3 get rotation => $_getN(3);
  @$pb.TagNumber(4)
  set rotation(Vector3 value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRotation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRotation() => $_clearField(4);
  @$pb.TagNumber(4)
  Vector3 ensureRotation() => $_ensure(3);

  @$pb.TagNumber(5)
  Vector3 get size => $_getN(4);
  @$pb.TagNumber(5)
  set size(Vector3 value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => $_clearField(5);
  @$pb.TagNumber(5)
  Vector3 ensureSize() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get name => $_getSZ(5);
  @$pb.TagNumber(6)
  set name($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasName() => $_has(5);
  @$pb.TagNumber(6)
  void clearName() => $_clearField(6);
}

class AppCameraRays extends $pb.GeneratedMessage {
  factory AppCameraRays({
    $core.double? verticalFov,
    $core.int? sampleOffset,
    $core.List<$core.int>? rayData,
    $core.double? distance,
    $core.Iterable<AppCameraRays_Entity>? entities,
  }) {
    final result = create();
    if (verticalFov != null) result.verticalFov = verticalFov;
    if (sampleOffset != null) result.sampleOffset = sampleOffset;
    if (rayData != null) result.rayData = rayData;
    if (distance != null) result.distance = distance;
    if (entities != null) result.entities.addAll(entities);
    return result;
  }

  AppCameraRays._();

  factory AppCameraRays.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppCameraRays.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppCameraRays',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rustplus'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'verticalFov',
        protoName: 'verticalFov', fieldType: $pb.PbFieldType.QF)
    ..aI(2, _omitFieldNames ? '' : 'sampleOffset',
        protoName: 'sampleOffset', fieldType: $pb.PbFieldType.Q3)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'rayData', $pb.PbFieldType.QY,
        protoName: 'rayData')
    ..aD(4, _omitFieldNames ? '' : 'distance', fieldType: $pb.PbFieldType.QF)
    ..pPM<AppCameraRays_Entity>(5, _omitFieldNames ? '' : 'entities',
        subBuilder: AppCameraRays_Entity.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraRays clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppCameraRays copyWith(void Function(AppCameraRays) updates) =>
      super.copyWith((message) => updates(message as AppCameraRays))
          as AppCameraRays;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppCameraRays create() => AppCameraRays._();
  @$core.override
  AppCameraRays createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppCameraRays getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppCameraRays>(create);
  static AppCameraRays? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get verticalFov => $_getN(0);
  @$pb.TagNumber(1)
  set verticalFov($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerticalFov() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerticalFov() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sampleOffset => $_getIZ(1);
  @$pb.TagNumber(2)
  set sampleOffset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get rayData => $_getN(2);
  @$pb.TagNumber(3)
  set rayData($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRayData() => $_has(2);
  @$pb.TagNumber(3)
  void clearRayData() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get distance => $_getN(3);
  @$pb.TagNumber(4)
  set distance($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDistance() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistance() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<AppCameraRays_Entity> get entities => $_getList(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
