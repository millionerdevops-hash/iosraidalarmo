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

import 'package:protobuf/protobuf.dart' as $pb;

class AppEntityType extends $pb.ProtobufEnum {
  static const AppEntityType Switch =
      AppEntityType._(1, _omitEnumNames ? '' : 'Switch');
  static const AppEntityType Alarm =
      AppEntityType._(2, _omitEnumNames ? '' : 'Alarm');
  static const AppEntityType StorageMonitor =
      AppEntityType._(3, _omitEnumNames ? '' : 'StorageMonitor');

  static const $core.List<AppEntityType> values = <AppEntityType>[
    Switch,
    Alarm,
    StorageMonitor,
  ];

  static final $core.List<AppEntityType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AppEntityType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AppEntityType._(super.value, super.name);
}

class AppMarkerType extends $pb.ProtobufEnum {
  static const AppMarkerType Undefined =
      AppMarkerType._(0, _omitEnumNames ? '' : 'Undefined');
  static const AppMarkerType Player =
      AppMarkerType._(1, _omitEnumNames ? '' : 'Player');
  static const AppMarkerType Explosion =
      AppMarkerType._(2, _omitEnumNames ? '' : 'Explosion');
  static const AppMarkerType VendingMachine =
      AppMarkerType._(3, _omitEnumNames ? '' : 'VendingMachine');
  static const AppMarkerType CH47 =
      AppMarkerType._(4, _omitEnumNames ? '' : 'CH47');
  static const AppMarkerType CargoShip =
      AppMarkerType._(5, _omitEnumNames ? '' : 'CargoShip');
  static const AppMarkerType Crate =
      AppMarkerType._(6, _omitEnumNames ? '' : 'Crate');
  static const AppMarkerType GenericRadius =
      AppMarkerType._(7, _omitEnumNames ? '' : 'GenericRadius');
  static const AppMarkerType PatrolHelicopter =
      AppMarkerType._(8, _omitEnumNames ? '' : 'PatrolHelicopter');

  static const $core.List<AppMarkerType> values = <AppMarkerType>[
    Undefined,
    Player,
    Explosion,
    VendingMachine,
    CH47,
    CargoShip,
    Crate,
    GenericRadius,
    PatrolHelicopter,
  ];

  static final $core.List<AppMarkerType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static AppMarkerType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AppMarkerType._(super.value, super.name);
}

class AppCameraRays_EntityType extends $pb.ProtobufEnum {
  static const AppCameraRays_EntityType Tree =
      AppCameraRays_EntityType._(1, _omitEnumNames ? '' : 'Tree');
  static const AppCameraRays_EntityType Player =
      AppCameraRays_EntityType._(2, _omitEnumNames ? '' : 'Player');

  static const $core.List<AppCameraRays_EntityType> values =
      <AppCameraRays_EntityType>[
    Tree,
    Player,
  ];

  static final $core.Map<$core.int, AppCameraRays_EntityType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AppCameraRays_EntityType? valueOf($core.int value) => _byValue[value];

  const AppCameraRays_EntityType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
