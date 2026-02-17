// This is a generated file - do not edit.
//
// Generated from rustplus.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;
import 'package:protobuf/protobuf.dart' as $pb;

@$core.Deprecated('Use appEntityTypeDescriptor instead')
const AppEntityType$json = {
  '1': 'AppEntityType',
  '2': [
    {'1': 'Switch', '2': 1},
    {'1': 'Alarm', '2': 2},
    {'1': 'StorageMonitor', '2': 3},
  ],
};

/// Descriptor for `AppEntityType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appEntityTypeDescriptor = $convert.base64Decode(
    'Cg1BcHBFbnRpdHlUeXBlEgoKBlN3aXRjaBABEgkKBUFsYXJtEAISEgoOU3RvcmFnZU1vbml0b3'
    'IQAw==');

@$core.Deprecated('Use appMarkerTypeDescriptor instead')
const AppMarkerType$json = {
  '1': 'AppMarkerType',
  '2': [
    {'1': 'Undefined', '2': 0},
    {'1': 'Player', '2': 1},
    {'1': 'Explosion', '2': 2},
    {'1': 'VendingMachine', '2': 3},
    {'1': 'CH47', '2': 4},
    {'1': 'CargoShip', '2': 5},
    {'1': 'Crate', '2': 6},
    {'1': 'GenericRadius', '2': 7},
    {'1': 'PatrolHelicopter', '2': 8},
  ],
};

/// Descriptor for `AppMarkerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appMarkerTypeDescriptor = $convert.base64Decode(
    'Cg1BcHBNYXJrZXJUeXBlEg0KCVVuZGVmaW5lZBAAEgoKBlBsYXllchABEg0KCUV4cGxvc2lvbh'
    'ACEhIKDlZlbmRpbmdNYWNoaW5lEAMSCAoEQ0g0NxAEEg0KCUNhcmdvU2hpcBAFEgkKBUNyYXRl'
    'EAYSEQoNR2VuZXJpY1JhZGl1cxAHEhQKEFBhdHJvbEhlbGljb3B0ZXIQCA==');

@$core.Deprecated('Use vector2Descriptor instead')
const Vector2$json = {
  '1': 'Vector2',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `Vector2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vector2Descriptor = $convert
    .base64Decode('CgdWZWN0b3IyEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeQ==');

@$core.Deprecated('Use vector3Descriptor instead')
const Vector3$json = {
  '1': 'Vector3',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `Vector3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vector3Descriptor = $convert.base64Decode(
    'CgdWZWN0b3IzEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeRIMCgF6GAMgASgCUgF6');

@$core.Deprecated('Use vector4Descriptor instead')
const Vector4$json = {
  '1': 'Vector4',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
    {'1': 'w', '3': 4, '4': 1, '5': 2, '10': 'w'},
  ],
};

/// Descriptor for `Vector4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vector4Descriptor = $convert.base64Decode(
    'CgdWZWN0b3I0EgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeRIMCgF6GAMgASgCUgF6EgwKAX'
    'cYBCABKAJSAXc=');

@$core.Deprecated('Use half3Descriptor instead')
const Half3$json = {
  '1': 'Half3',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `Half3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List half3Descriptor = $convert.base64Decode(
    'CgVIYWxmMxIMCgF4GAEgASgCUgF4EgwKAXkYAiABKAJSAXkSDAoBehgDIAEoAlIBeg==');

@$core.Deprecated('Use colorDescriptor instead')
const Color$json = {
  '1': 'Color',
  '2': [
    {'1': 'r', '3': 1, '4': 1, '5': 2, '10': 'r'},
    {'1': 'g', '3': 2, '4': 1, '5': 2, '10': 'g'},
    {'1': 'b', '3': 3, '4': 1, '5': 2, '10': 'b'},
    {'1': 'a', '3': 4, '4': 1, '5': 2, '10': 'a'},
  ],
};

/// Descriptor for `Color`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorDescriptor = $convert.base64Decode(
    'CgVDb2xvchIMCgFyGAEgASgCUgFyEgwKAWcYAiABKAJSAWcSDAoBYhgDIAEoAlIBYhIMCgFhGA'
    'QgASgCUgFh');

@$core.Deprecated('Use rayDescriptor instead')
const Ray$json = {
  '1': 'Ray',
  '2': [
    {
      '1': 'origin',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rustplus.Vector3',
      '10': 'origin'
    },
    {
      '1': 'direction',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.rustplus.Vector3',
      '10': 'direction'
    },
  ],
};

/// Descriptor for `Ray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rayDescriptor = $convert.base64Decode(
    'CgNSYXkSKQoGb3JpZ2luGAEgASgLMhEucnVzdHBsdXMuVmVjdG9yM1IGb3JpZ2luEi8KCWRpcm'
    'VjdGlvbhgCIAEoCzIRLnJ1c3RwbHVzLlZlY3RvcjNSCWRpcmVjdGlvbg==');

@$core.Deprecated('Use clanActionResultDescriptor instead')
const ClanActionResult$json = {
  '1': 'ClanActionResult',
  '2': [
    {'1': 'requestId', '3': 1, '4': 2, '5': 5, '10': 'requestId'},
    {'1': 'result', '3': 2, '4': 2, '5': 5, '10': 'result'},
    {'1': 'hasClanInfo', '3': 3, '4': 2, '5': 8, '10': 'hasClanInfo'},
    {
      '1': 'clanInfo',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.rustplus.ClanInfo',
      '10': 'clanInfo'
    },
  ],
};

/// Descriptor for `ClanActionResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clanActionResultDescriptor = $convert.base64Decode(
    'ChBDbGFuQWN0aW9uUmVzdWx0EhwKCXJlcXVlc3RJZBgBIAIoBVIJcmVxdWVzdElkEhYKBnJlc3'
    'VsdBgCIAIoBVIGcmVzdWx0EiAKC2hhc0NsYW5JbmZvGAMgAigIUgtoYXNDbGFuSW5mbxIuCghj'
    'bGFuSW5mbxgEIAEoCzISLnJ1c3RwbHVzLkNsYW5JbmZvUghjbGFuSW5mbw==');

@$core.Deprecated('Use clanInfoDescriptor instead')
const ClanInfo$json = {
  '1': 'ClanInfo',
  '2': [
    {'1': 'clanId', '3': 1, '4': 2, '5': 3, '10': 'clanId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'created', '3': 3, '4': 2, '5': 3, '10': 'created'},
    {'1': 'creator', '3': 4, '4': 2, '5': 4, '10': 'creator'},
    {'1': 'motd', '3': 5, '4': 1, '5': 9, '10': 'motd'},
    {'1': 'motdTimestamp', '3': 6, '4': 1, '5': 3, '10': 'motdTimestamp'},
    {'1': 'motdAuthor', '3': 7, '4': 1, '5': 4, '10': 'motdAuthor'},
    {'1': 'logo', '3': 8, '4': 1, '5': 12, '10': 'logo'},
    {'1': 'color', '3': 9, '4': 1, '5': 17, '10': 'color'},
    {
      '1': 'roles',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.rustplus.ClanInfo.Role',
      '10': 'roles'
    },
    {
      '1': 'members',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.rustplus.ClanInfo.Member',
      '10': 'members'
    },
    {
      '1': 'invites',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.rustplus.ClanInfo.Invite',
      '10': 'invites'
    },
    {'1': 'maxMemberCount', '3': 13, '4': 1, '5': 5, '10': 'maxMemberCount'},
  ],
  '3': [ClanInfo_Role$json, ClanInfo_Member$json, ClanInfo_Invite$json],
};

@$core.Deprecated('Use clanInfoDescriptor instead')
const ClanInfo_Role$json = {
  '1': 'Role',
  '2': [
    {'1': 'roleId', '3': 1, '4': 2, '5': 5, '10': 'roleId'},
    {'1': 'rank', '3': 2, '4': 2, '5': 5, '10': 'rank'},
    {'1': 'name', '3': 3, '4': 2, '5': 9, '10': 'name'},
    {'1': 'canSetMotd', '3': 4, '4': 2, '5': 8, '10': 'canSetMotd'},
    {'1': 'canSetLogo', '3': 5, '4': 2, '5': 8, '10': 'canSetLogo'},
    {'1': 'canInvite', '3': 6, '4': 2, '5': 8, '10': 'canInvite'},
    {'1': 'canKick', '3': 7, '4': 2, '5': 8, '10': 'canKick'},
    {'1': 'canPromote', '3': 8, '4': 2, '5': 8, '10': 'canPromote'},
    {'1': 'canDemote', '3': 9, '4': 2, '5': 8, '10': 'canDemote'},
    {
      '1': 'canSetPlayerNotes',
      '3': 10,
      '4': 2,
      '5': 8,
      '10': 'canSetPlayerNotes'
    },
    {'1': 'canAccessLogs', '3': 11, '4': 2, '5': 8, '10': 'canAccessLogs'},
  ],
};

@$core.Deprecated('Use clanInfoDescriptor instead')
const ClanInfo_Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
    {'1': 'roleId', '3': 2, '4': 2, '5': 5, '10': 'roleId'},
    {'1': 'joined', '3': 3, '4': 2, '5': 3, '10': 'joined'},
    {'1': 'lastSeen', '3': 4, '4': 2, '5': 3, '10': 'lastSeen'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'online', '3': 6, '4': 1, '5': 8, '10': 'online'},
  ],
};

@$core.Deprecated('Use clanInfoDescriptor instead')
const ClanInfo_Invite$json = {
  '1': 'Invite',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
    {'1': 'recruiter', '3': 2, '4': 2, '5': 4, '10': 'recruiter'},
    {'1': 'timestamp', '3': 3, '4': 2, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ClanInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clanInfoDescriptor = $convert.base64Decode(
    'CghDbGFuSW5mbxIWCgZjbGFuSWQYASACKANSBmNsYW5JZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'gKB2NyZWF0ZWQYAyACKANSB2NyZWF0ZWQSGAoHY3JlYXRvchgEIAIoBFIHY3JlYXRvchISCgRt'
    'b3RkGAUgASgJUgRtb3RkEiQKDW1vdGRUaW1lc3RhbXAYBiABKANSDW1vdGRUaW1lc3RhbXASHg'
    'oKbW90ZEF1dGhvchgHIAEoBFIKbW90ZEF1dGhvchISCgRsb2dvGAggASgMUgRsb2dvEhQKBWNv'
    'bG9yGAkgASgRUgVjb2xvchItCgVyb2xlcxgKIAMoCzIXLnJ1c3RwbHVzLkNsYW5JbmZvLlJvbG'
    'VSBXJvbGVzEjMKB21lbWJlcnMYCyADKAsyGS5ydXN0cGx1cy5DbGFuSW5mby5NZW1iZXJSB21l'
    'bWJlcnMSMwoHaW52aXRlcxgMIAMoCzIZLnJ1c3RwbHVzLkNsYW5JbmZvLkludml0ZVIHaW52aX'
    'RlcxImCg5tYXhNZW1iZXJDb3VudBgNIAEoBVIObWF4TWVtYmVyQ291bnQa0AIKBFJvbGUSFgoG'
    'cm9sZUlkGAEgAigFUgZyb2xlSWQSEgoEcmFuaxgCIAIoBVIEcmFuaxISCgRuYW1lGAMgAigJUg'
    'RuYW1lEh4KCmNhblNldE1vdGQYBCACKAhSCmNhblNldE1vdGQSHgoKY2FuU2V0TG9nbxgFIAIo'
    'CFIKY2FuU2V0TG9nbxIcCgljYW5JbnZpdGUYBiACKAhSCWNhbkludml0ZRIYCgdjYW5LaWNrGA'
    'cgAigIUgdjYW5LaWNrEh4KCmNhblByb21vdGUYCCACKAhSCmNhblByb21vdGUSHAoJY2FuRGVt'
    'b3RlGAkgAigIUgljYW5EZW1vdGUSLAoRY2FuU2V0UGxheWVyTm90ZXMYCiACKAhSEWNhblNldF'
    'BsYXllck5vdGVzEiQKDWNhbkFjY2Vzc0xvZ3MYCyACKAhSDWNhbkFjY2Vzc0xvZ3ManAEKBk1l'
    'bWJlchIYCgdzdGVhbUlkGAEgAigEUgdzdGVhbUlkEhYKBnJvbGVJZBgCIAIoBVIGcm9sZUlkEh'
    'YKBmpvaW5lZBgDIAIoA1IGam9pbmVkEhoKCGxhc3RTZWVuGAQgAigDUghsYXN0U2VlbhIUCgVu'
    'b3RlcxgFIAEoCVIFbm90ZXMSFgoGb25saW5lGAYgASgIUgZvbmxpbmUaXgoGSW52aXRlEhgKB3'
    'N0ZWFtSWQYASACKARSB3N0ZWFtSWQSHAoJcmVjcnVpdGVyGAIgAigEUglyZWNydWl0ZXISHAoJ'
    'dGltZXN0YW1wGAMgAigDUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use clanLogDescriptor instead')
const ClanLog$json = {
  '1': 'ClanLog',
  '2': [
    {'1': 'clanId', '3': 1, '4': 2, '5': 3, '10': 'clanId'},
    {
      '1': 'logEntries',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.rustplus.ClanLog.Entry',
      '10': 'logEntries'
    },
  ],
  '3': [ClanLog_Entry$json],
};

@$core.Deprecated('Use clanLogDescriptor instead')
const ClanLog_Entry$json = {
  '1': 'Entry',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 2, '5': 3, '10': 'timestamp'},
    {'1': 'eventKey', '3': 2, '4': 2, '5': 9, '10': 'eventKey'},
    {'1': 'arg1', '3': 3, '4': 1, '5': 9, '10': 'arg1'},
    {'1': 'arg2', '3': 4, '4': 1, '5': 9, '10': 'arg2'},
    {'1': 'arg3', '3': 5, '4': 1, '5': 9, '10': 'arg3'},
    {'1': 'arg4', '3': 6, '4': 1, '5': 9, '10': 'arg4'},
  ],
};

/// Descriptor for `ClanLog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clanLogDescriptor = $convert.base64Decode(
    'CgdDbGFuTG9nEhYKBmNsYW5JZBgBIAIoA1IGY2xhbklkEjcKCmxvZ0VudHJpZXMYAiADKAsyFy'
    '5ydXN0cGx1cy5DbGFuTG9nLkVudHJ5Ugpsb2dFbnRyaWVzGpEBCgVFbnRyeRIcCgl0aW1lc3Rh'
    'bXAYASACKANSCXRpbWVzdGFtcBIaCghldmVudEtleRgCIAIoCVIIZXZlbnRLZXkSEgoEYXJnMR'
    'gDIAEoCVIEYXJnMRISCgRhcmcyGAQgASgJUgRhcmcyEhIKBGFyZzMYBSABKAlSBGFyZzMSEgoE'
    'YXJnNBgGIAEoCVIEYXJnNA==');

@$core.Deprecated('Use clanInvitationsDescriptor instead')
const ClanInvitations$json = {
  '1': 'ClanInvitations',
  '2': [
    {
      '1': 'invitations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.rustplus.ClanInvitations.Invitation',
      '10': 'invitations'
    },
  ],
  '3': [ClanInvitations_Invitation$json],
};

@$core.Deprecated('Use clanInvitationsDescriptor instead')
const ClanInvitations_Invitation$json = {
  '1': 'Invitation',
  '2': [
    {'1': 'clanId', '3': 1, '4': 2, '5': 3, '10': 'clanId'},
    {'1': 'recruiter', '3': 2, '4': 2, '5': 4, '10': 'recruiter'},
    {'1': 'timestamp', '3': 3, '4': 2, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ClanInvitations`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clanInvitationsDescriptor = $convert.base64Decode(
    'Cg9DbGFuSW52aXRhdGlvbnMSRgoLaW52aXRhdGlvbnMYASADKAsyJC5ydXN0cGx1cy5DbGFuSW'
    '52aXRhdGlvbnMuSW52aXRhdGlvblILaW52aXRhdGlvbnMaYAoKSW52aXRhdGlvbhIWCgZjbGFu'
    'SWQYASACKANSBmNsYW5JZBIcCglyZWNydWl0ZXIYAiACKARSCXJlY3J1aXRlchIcCgl0aW1lc3'
    'RhbXAYAyACKANSCXRpbWVzdGFtcA==');

@$core.Deprecated('Use appRequestDescriptor instead')
const AppRequest$json = {
  '1': 'AppRequest',
  '2': [
    {'1': 'seq', '3': 1, '4': 2, '5': 13, '10': 'seq'},
    {'1': 'playerId', '3': 2, '4': 2, '5': 4, '10': 'playerId'},
    {'1': 'playerToken', '3': 3, '4': 2, '5': 5, '10': 'playerToken'},
    {'1': 'entityId', '3': 4, '4': 1, '5': 13, '10': 'entityId'},
    {
      '1': 'getInfo',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getInfo'
    },
    {
      '1': 'getTime',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getTime'
    },
    {
      '1': 'getMap',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getMap'
    },
    {
      '1': 'getTeamInfo',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getTeamInfo'
    },
    {
      '1': 'getTeamChat',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getTeamChat'
    },
    {
      '1': 'sendTeamMessage',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppSendMessage',
      '10': 'sendTeamMessage'
    },
    {
      '1': 'getEntityInfo',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getEntityInfo'
    },
    {
      '1': 'setEntityValue',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppSetEntityValue',
      '10': 'setEntityValue'
    },
    {
      '1': 'checkSubscription',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'checkSubscription'
    },
    {
      '1': 'setSubscription',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppFlag',
      '10': 'setSubscription'
    },
    {
      '1': 'getMapMarkers',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getMapMarkers'
    },
    {
      '1': 'promoteToLeader',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppPromoteToLeader',
      '10': 'promoteToLeader'
    },
    {
      '1': 'getClanInfo',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getClanInfo'
    },
    {
      '1': 'setClanMotd',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppSendMessage',
      '10': 'setClanMotd'
    },
    {
      '1': 'getClanChat',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'getClanChat'
    },
    {
      '1': 'sendClanMessage',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppSendMessage',
      '10': 'sendClanMessage'
    },
    {
      '1': 'getNexusAuth',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppGetNexusAuth',
      '10': 'getNexusAuth'
    },
    {
      '1': 'cameraSubscribe',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppCameraSubscribe',
      '10': 'cameraSubscribe'
    },
    {
      '1': 'cameraUnsubscribe',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEmpty',
      '10': 'cameraUnsubscribe'
    },
    {
      '1': 'cameraInput',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppCameraInput',
      '10': 'cameraInput'
    },
  ],
};

/// Descriptor for `AppRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appRequestDescriptor = $convert.base64Decode(
    'CgpBcHBSZXF1ZXN0EhAKA3NlcRgBIAIoDVIDc2VxEhoKCHBsYXllcklkGAIgAigEUghwbGF5ZX'
    'JJZBIgCgtwbGF5ZXJUb2tlbhgDIAIoBVILcGxheWVyVG9rZW4SGgoIZW50aXR5SWQYBCABKA1S'
    'CGVudGl0eUlkEiwKB2dldEluZm8YCCABKAsyEi5ydXN0cGx1cy5BcHBFbXB0eVIHZ2V0SW5mbx'
    'IsCgdnZXRUaW1lGAkgASgLMhIucnVzdHBsdXMuQXBwRW1wdHlSB2dldFRpbWUSKgoGZ2V0TWFw'
    'GAogASgLMhIucnVzdHBsdXMuQXBwRW1wdHlSBmdldE1hcBI0CgtnZXRUZWFtSW5mbxgLIAEoCz'
    'ISLnJ1c3RwbHVzLkFwcEVtcHR5UgtnZXRUZWFtSW5mbxI0CgtnZXRUZWFtQ2hhdBgMIAEoCzIS'
    'LnJ1c3RwbHVzLkFwcEVtcHR5UgtnZXRUZWFtQ2hhdBJCCg9zZW5kVGVhbU1lc3NhZ2UYDSABKA'
    'syGC5ydXN0cGx1cy5BcHBTZW5kTWVzc2FnZVIPc2VuZFRlYW1NZXNzYWdlEjgKDWdldEVudGl0'
    'eUluZm8YDiABKAsyEi5ydXN0cGx1cy5BcHBFbXB0eVINZ2V0RW50aXR5SW5mbxJDCg5zZXRFbn'
    'RpdHlWYWx1ZRgPIAEoCzIbLnJ1c3RwbHVzLkFwcFNldEVudGl0eVZhbHVlUg5zZXRFbnRpdHlW'
    'YWx1ZRJAChFjaGVja1N1YnNjcmlwdGlvbhgQIAEoCzISLnJ1c3RwbHVzLkFwcEVtcHR5UhFjaG'
    'Vja1N1YnNjcmlwdGlvbhI7Cg9zZXRTdWJzY3JpcHRpb24YESABKAsyES5ydXN0cGx1cy5BcHBG'
    'bGFnUg9zZXRTdWJzY3JpcHRpb24SOAoNZ2V0TWFwTWFya2VycxgSIAEoCzISLnJ1c3RwbHVzLk'
    'FwcEVtcHR5Ug1nZXRNYXBNYXJrZXJzEkYKD3Byb21vdGVUb0xlYWRlchgUIAEoCzIcLnJ1c3Rw'
    'bHVzLkFwcFByb21vdGVUb0xlYWRlclIPcHJvbW90ZVRvTGVhZGVyEjQKC2dldENsYW5JbmZvGB'
    'UgASgLMhIucnVzdHBsdXMuQXBwRW1wdHlSC2dldENsYW5JbmZvEjoKC3NldENsYW5Nb3RkGBYg'
    'ASgLMhgucnVzdHBsdXMuQXBwU2VuZE1lc3NhZ2VSC3NldENsYW5Nb3RkEjQKC2dldENsYW5DaG'
    'F0GBcgASgLMhIucnVzdHBsdXMuQXBwRW1wdHlSC2dldENsYW5DaGF0EkIKD3NlbmRDbGFuTWVz'
    'c2FnZRgYIAEoCzIYLnJ1c3RwbHVzLkFwcFNlbmRNZXNzYWdlUg9zZW5kQ2xhbk1lc3NhZ2USPQ'
    'oMZ2V0TmV4dXNBdXRoGBkgASgLMhkucnVzdHBsdXMuQXBwR2V0TmV4dXNBdXRoUgxnZXROZXh1'
    'c0F1dGgSRgoPY2FtZXJhU3Vic2NyaWJlGB4gASgLMhwucnVzdHBsdXMuQXBwQ2FtZXJhU3Vic2'
    'NyaWJlUg9jYW1lcmFTdWJzY3JpYmUSQAoRY2FtZXJhVW5zdWJzY3JpYmUYHyABKAsyEi5ydXN0'
    'cGx1cy5BcHBFbXB0eVIRY2FtZXJhVW5zdWJzY3JpYmUSOgoLY2FtZXJhSW5wdXQYICABKAsyGC'
    '5ydXN0cGx1cy5BcHBDYW1lcmFJbnB1dFILY2FtZXJhSW5wdXQ=');

@$core.Deprecated('Use appMessageDescriptor instead')
const AppMessage$json = {
  '1': 'AppMessage',
  '2': [
    {
      '1': 'response',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppResponse',
      '10': 'response'
    },
    {
      '1': 'broadcast',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppBroadcast',
      '10': 'broadcast'
    },
  ],
};

/// Descriptor for `AppMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appMessageDescriptor = $convert.base64Decode(
    'CgpBcHBNZXNzYWdlEjEKCHJlc3BvbnNlGAEgASgLMhUucnVzdHBsdXMuQXBwUmVzcG9uc2VSCH'
    'Jlc3BvbnNlEjQKCWJyb2FkY2FzdBgCIAEoCzIWLnJ1c3RwbHVzLkFwcEJyb2FkY2FzdFIJYnJv'
    'YWRjYXN0');

@$core.Deprecated('Use appResponseDescriptor instead')
const AppResponse$json = {
  '1': 'AppResponse',
  '2': [
    {'1': 'seq', '3': 1, '4': 2, '5': 13, '10': 'seq'},
    {
      '1': 'success',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppSuccess',
      '10': 'success'
    },
    {
      '1': 'error',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppError',
      '10': 'error'
    },
    {
      '1': 'info',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppInfo',
      '10': 'info'
    },
    {
      '1': 'time',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppTime',
      '10': 'time'
    },
    {'1': 'map', '3': 8, '4': 1, '5': 11, '6': '.rustplus.AppMap', '10': 'map'},
    {
      '1': 'teamInfo',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppTeamInfo',
      '10': 'teamInfo'
    },
    {
      '1': 'teamChat',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppTeamChat',
      '10': 'teamChat'
    },
    {
      '1': 'entityInfo',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEntityInfo',
      '10': 'entityInfo'
    },
    {
      '1': 'flag',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppFlag',
      '10': 'flag'
    },
    {
      '1': 'mapMarkers',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppMapMarkers',
      '10': 'mapMarkers'
    },
    {
      '1': 'clanInfo',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppClanInfo',
      '10': 'clanInfo'
    },
    {
      '1': 'clanChat',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppClanChat',
      '10': 'clanChat'
    },
    {
      '1': 'nexusAuth',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppNexusAuth',
      '10': 'nexusAuth'
    },
    {
      '1': 'cameraSubscribeInfo',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppCameraInfo',
      '10': 'cameraSubscribeInfo'
    },
  ],
};

/// Descriptor for `AppResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appResponseDescriptor = $convert.base64Decode(
    'CgtBcHBSZXNwb25zZRIQCgNzZXEYASACKA1SA3NlcRIuCgdzdWNjZXNzGAQgASgLMhQucnVzdH'
    'BsdXMuQXBwU3VjY2Vzc1IHc3VjY2VzcxIoCgVlcnJvchgFIAEoCzISLnJ1c3RwbHVzLkFwcEVy'
    'cm9yUgVlcnJvchIlCgRpbmZvGAYgASgLMhEucnVzdHBsdXMuQXBwSW5mb1IEaW5mbxIlCgR0aW'
    '1lGAcgASgLMhEucnVzdHBsdXMuQXBwVGltZVIEdGltZRIiCgNtYXAYCCABKAsyEC5ydXN0cGx1'
    'cy5BcHBNYXBSA21hcBIxCgh0ZWFtSW5mbxgJIAEoCzIVLnJ1c3RwbHVzLkFwcFRlYW1JbmZvUg'
    'h0ZWFtSW5mbxIxCgh0ZWFtQ2hhdBgKIAEoCzIVLnJ1c3RwbHVzLkFwcFRlYW1DaGF0Ugh0ZWFt'
    'Q2hhdBI3CgplbnRpdHlJbmZvGAsgASgLMhcucnVzdHBsdXMuQXBwRW50aXR5SW5mb1IKZW50aX'
    'R5SW5mbxIlCgRmbGFnGAwgASgLMhEucnVzdHBsdXMuQXBwRmxhZ1IEZmxhZxI3CgptYXBNYXJr'
    'ZXJzGA0gASgLMhcucnVzdHBsdXMuQXBwTWFwTWFya2Vyc1IKbWFwTWFya2VycxIxCghjbGFuSW'
    '5mbxgPIAEoCzIVLnJ1c3RwbHVzLkFwcENsYW5JbmZvUghjbGFuSW5mbxIxCghjbGFuQ2hhdBgQ'
    'IAEoCzIVLnJ1c3RwbHVzLkFwcENsYW5DaGF0UghjbGFuQ2hhdBI0CgluZXh1c0F1dGgYESABKA'
    'syFi5ydXN0cGx1cy5BcHBOZXh1c0F1dGhSCW5leHVzQXV0aBJJChNjYW1lcmFTdWJzY3JpYmVJ'
    'bmZvGBQgASgLMhcucnVzdHBsdXMuQXBwQ2FtZXJhSW5mb1ITY2FtZXJhU3Vic2NyaWJlSW5mbw'
    '==');

@$core.Deprecated('Use appBroadcastDescriptor instead')
const AppBroadcast$json = {
  '1': 'AppBroadcast',
  '2': [
    {
      '1': 'teamChanged',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppTeamChanged',
      '10': 'teamChanged'
    },
    {
      '1': 'teamMessage',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppNewTeamMessage',
      '10': 'teamMessage'
    },
    {
      '1': 'entityChanged',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppEntityChanged',
      '10': 'entityChanged'
    },
    {
      '1': 'clanChanged',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppClanChanged',
      '10': 'clanChanged'
    },
    {
      '1': 'clanMessage',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppNewClanMessage',
      '10': 'clanMessage'
    },
    {
      '1': 'cameraRays',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.rustplus.AppCameraRays',
      '10': 'cameraRays'
    },
  ],
};

/// Descriptor for `AppBroadcast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appBroadcastDescriptor = $convert.base64Decode(
    'CgxBcHBCcm9hZGNhc3QSOgoLdGVhbUNoYW5nZWQYBCABKAsyGC5ydXN0cGx1cy5BcHBUZWFtQ2'
    'hhbmdlZFILdGVhbUNoYW5nZWQSPQoLdGVhbU1lc3NhZ2UYBSABKAsyGy5ydXN0cGx1cy5BcHBO'
    'ZXdUZWFtTWVzc2FnZVILdGVhbU1lc3NhZ2USQAoNZW50aXR5Q2hhbmdlZBgGIAEoCzIaLnJ1c3'
    'RwbHVzLkFwcEVudGl0eUNoYW5nZWRSDWVudGl0eUNoYW5nZWQSOgoLY2xhbkNoYW5nZWQYByAB'
    'KAsyGC5ydXN0cGx1cy5BcHBDbGFuQ2hhbmdlZFILY2xhbkNoYW5nZWQSPQoLY2xhbk1lc3NhZ2'
    'UYCCABKAsyGy5ydXN0cGx1cy5BcHBOZXdDbGFuTWVzc2FnZVILY2xhbk1lc3NhZ2USNwoKY2Ft'
    'ZXJhUmF5cxgKIAEoCzIXLnJ1c3RwbHVzLkFwcENhbWVyYVJheXNSCmNhbWVyYVJheXM=');

@$core.Deprecated('Use appEmptyDescriptor instead')
const AppEmpty$json = {
  '1': 'AppEmpty',
};

/// Descriptor for `AppEmpty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEmptyDescriptor =
    $convert.base64Decode('CghBcHBFbXB0eQ==');

@$core.Deprecated('Use appSendMessageDescriptor instead')
const AppSendMessage$json = {
  '1': 'AppSendMessage',
  '2': [
    {'1': 'message', '3': 1, '4': 2, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AppSendMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appSendMessageDescriptor = $convert
    .base64Decode('Cg5BcHBTZW5kTWVzc2FnZRIYCgdtZXNzYWdlGAEgAigJUgdtZXNzYWdl');

@$core.Deprecated('Use appSetEntityValueDescriptor instead')
const AppSetEntityValue$json = {
  '1': 'AppSetEntityValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 8, '10': 'value'},
  ],
};

/// Descriptor for `AppSetEntityValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appSetEntityValueDescriptor = $convert
    .base64Decode('ChFBcHBTZXRFbnRpdHlWYWx1ZRIUCgV2YWx1ZRgBIAIoCFIFdmFsdWU=');

@$core.Deprecated('Use appPromoteToLeaderDescriptor instead')
const AppPromoteToLeader$json = {
  '1': 'AppPromoteToLeader',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
  ],
};

/// Descriptor for `AppPromoteToLeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appPromoteToLeaderDescriptor =
    $convert.base64Decode(
        'ChJBcHBQcm9tb3RlVG9MZWFkZXISGAoHc3RlYW1JZBgBIAIoBFIHc3RlYW1JZA==');

@$core.Deprecated('Use appGetNexusAuthDescriptor instead')
const AppGetNexusAuth$json = {
  '1': 'AppGetNexusAuth',
  '2': [
    {'1': 'appKey', '3': 1, '4': 2, '5': 9, '10': 'appKey'},
  ],
};

/// Descriptor for `AppGetNexusAuth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appGetNexusAuthDescriptor = $convert
    .base64Decode('Cg9BcHBHZXROZXh1c0F1dGgSFgoGYXBwS2V5GAEgAigJUgZhcHBLZXk=');

@$core.Deprecated('Use appSuccessDescriptor instead')
const AppSuccess$json = {
  '1': 'AppSuccess',
};

/// Descriptor for `AppSuccess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appSuccessDescriptor =
    $convert.base64Decode('CgpBcHBTdWNjZXNz');

@$core.Deprecated('Use appErrorDescriptor instead')
const AppError$json = {
  '1': 'AppError',
  '2': [
    {'1': 'error', '3': 1, '4': 2, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `AppError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appErrorDescriptor =
    $convert.base64Decode('CghBcHBFcnJvchIUCgVlcnJvchgBIAIoCVIFZXJyb3I=');

@$core.Deprecated('Use appFlagDescriptor instead')
const AppFlag$json = {
  '1': 'AppFlag',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 8, '10': 'value'},
  ],
};

/// Descriptor for `AppFlag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appFlagDescriptor =
    $convert.base64Decode('CgdBcHBGbGFnEhQKBXZhbHVlGAEgAigIUgV2YWx1ZQ==');

@$core.Deprecated('Use appInfoDescriptor instead')
const AppInfo$json = {
  '1': 'AppInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'headerImage', '3': 2, '4': 2, '5': 9, '10': 'headerImage'},
    {'1': 'url', '3': 3, '4': 2, '5': 9, '10': 'url'},
    {'1': 'map', '3': 4, '4': 2, '5': 9, '10': 'map'},
    {'1': 'mapSize', '3': 5, '4': 2, '5': 13, '10': 'mapSize'},
    {'1': 'wipeTime', '3': 6, '4': 2, '5': 13, '10': 'wipeTime'},
    {'1': 'players', '3': 7, '4': 2, '5': 13, '10': 'players'},
    {'1': 'maxPlayers', '3': 8, '4': 2, '5': 13, '10': 'maxPlayers'},
    {'1': 'queuedPlayers', '3': 9, '4': 2, '5': 13, '10': 'queuedPlayers'},
    {'1': 'seed', '3': 10, '4': 1, '5': 13, '10': 'seed'},
    {'1': 'salt', '3': 11, '4': 1, '5': 13, '10': 'salt'},
    {'1': 'logoImage', '3': 12, '4': 1, '5': 9, '10': 'logoImage'},
    {'1': 'nexus', '3': 13, '4': 1, '5': 9, '10': 'nexus'},
    {'1': 'nexusId', '3': 14, '4': 1, '5': 5, '10': 'nexusId'},
    {'1': 'nexusZone', '3': 15, '4': 1, '5': 9, '10': 'nexusZone'},
  ],
};

/// Descriptor for `AppInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appInfoDescriptor = $convert.base64Decode(
    'CgdBcHBJbmZvEhIKBG5hbWUYASACKAlSBG5hbWUSIAoLaGVhZGVySW1hZ2UYAiACKAlSC2hlYW'
    'RlckltYWdlEhAKA3VybBgDIAIoCVIDdXJsEhAKA21hcBgEIAIoCVIDbWFwEhgKB21hcFNpemUY'
    'BSACKA1SB21hcFNpemUSGgoId2lwZVRpbWUYBiACKA1SCHdpcGVUaW1lEhgKB3BsYXllcnMYBy'
    'ACKA1SB3BsYXllcnMSHgoKbWF4UGxheWVycxgIIAIoDVIKbWF4UGxheWVycxIkCg1xdWV1ZWRQ'
    'bGF5ZXJzGAkgAigNUg1xdWV1ZWRQbGF5ZXJzEhIKBHNlZWQYCiABKA1SBHNlZWQSEgoEc2FsdB'
    'gLIAEoDVIEc2FsdBIcCglsb2dvSW1hZ2UYDCABKAlSCWxvZ29JbWFnZRIUCgVuZXh1cxgNIAEo'
    'CVIFbmV4dXMSGAoHbmV4dXNJZBgOIAEoBVIHbmV4dXNJZBIcCgluZXh1c1pvbmUYDyABKAlSCW'
    '5leHVzWm9uZQ==');

@$core.Deprecated('Use appTimeDescriptor instead')
const AppTime$json = {
  '1': 'AppTime',
  '2': [
    {'1': 'dayLengthMinutes', '3': 1, '4': 2, '5': 2, '10': 'dayLengthMinutes'},
    {'1': 'timeScale', '3': 2, '4': 2, '5': 2, '10': 'timeScale'},
    {'1': 'sunrise', '3': 3, '4': 2, '5': 2, '10': 'sunrise'},
    {'1': 'sunset', '3': 4, '4': 2, '5': 2, '10': 'sunset'},
    {'1': 'time', '3': 5, '4': 2, '5': 2, '10': 'time'},
  ],
};

/// Descriptor for `AppTime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appTimeDescriptor = $convert.base64Decode(
    'CgdBcHBUaW1lEioKEGRheUxlbmd0aE1pbnV0ZXMYASACKAJSEGRheUxlbmd0aE1pbnV0ZXMSHA'
    'oJdGltZVNjYWxlGAIgAigCUgl0aW1lU2NhbGUSGAoHc3VucmlzZRgDIAIoAlIHc3VucmlzZRIW'
    'CgZzdW5zZXQYBCACKAJSBnN1bnNldBISCgR0aW1lGAUgAigCUgR0aW1l');

@$core.Deprecated('Use appMapDescriptor instead')
const AppMap$json = {
  '1': 'AppMap',
  '2': [
    {'1': 'width', '3': 1, '4': 2, '5': 13, '10': 'width'},
    {'1': 'height', '3': 2, '4': 2, '5': 13, '10': 'height'},
    {'1': 'jpgImage', '3': 3, '4': 2, '5': 12, '10': 'jpgImage'},
    {'1': 'oceanMargin', '3': 4, '4': 2, '5': 5, '10': 'oceanMargin'},
    {
      '1': 'monuments',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppMap.Monument',
      '10': 'monuments'
    },
    {'1': 'background', '3': 6, '4': 1, '5': 9, '10': 'background'},
  ],
  '3': [AppMap_Monument$json],
};

@$core.Deprecated('Use appMapDescriptor instead')
const AppMap_Monument$json = {
  '1': 'Monument',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    {'1': 'x', '3': 2, '4': 2, '5': 2, '10': 'x'},
    {'1': 'y', '3': 3, '4': 2, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `AppMap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appMapDescriptor = $convert.base64Decode(
    'CgZBcHBNYXASFAoFd2lkdGgYASACKA1SBXdpZHRoEhYKBmhlaWdodBgCIAIoDVIGaGVpZ2h0Eh'
    'oKCGpwZ0ltYWdlGAMgAigMUghqcGdJbWFnZRIgCgtvY2Vhbk1hcmdpbhgEIAIoBVILb2NlYW5N'
    'YXJnaW4SNwoJbW9udW1lbnRzGAUgAygLMhkucnVzdHBsdXMuQXBwTWFwLk1vbnVtZW50Ugltb2'
    '51bWVudHMSHgoKYmFja2dyb3VuZBgGIAEoCVIKYmFja2dyb3VuZBo8CghNb251bWVudBIUCgV0'
    'b2tlbhgBIAIoCVIFdG9rZW4SDAoBeBgCIAIoAlIBeBIMCgF5GAMgAigCUgF5');

@$core.Deprecated('Use appEntityInfoDescriptor instead')
const AppEntityInfo$json = {
  '1': 'AppEntityInfo',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 2,
      '5': 14,
      '6': '.rustplus.AppEntityType',
      '10': 'type'
    },
    {
      '1': 'payload',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.rustplus.AppEntityPayload',
      '10': 'payload'
    },
  ],
};

/// Descriptor for `AppEntityInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEntityInfoDescriptor = $convert.base64Decode(
    'Cg1BcHBFbnRpdHlJbmZvEisKBHR5cGUYASACKA4yFy5ydXN0cGx1cy5BcHBFbnRpdHlUeXBlUg'
    'R0eXBlEjQKB3BheWxvYWQYAyACKAsyGi5ydXN0cGx1cy5BcHBFbnRpdHlQYXlsb2FkUgdwYXls'
    'b2Fk');

@$core.Deprecated('Use appEntityPayloadDescriptor instead')
const AppEntityPayload$json = {
  '1': 'AppEntityPayload',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppEntityPayload.Item',
      '10': 'items'
    },
    {'1': 'capacity', '3': 3, '4': 1, '5': 5, '10': 'capacity'},
    {'1': 'hasProtection', '3': 4, '4': 1, '5': 8, '10': 'hasProtection'},
    {
      '1': 'protectionExpiry',
      '3': 5,
      '4': 1,
      '5': 13,
      '10': 'protectionExpiry'
    },
  ],
  '3': [AppEntityPayload_Item$json],
};

@$core.Deprecated('Use appEntityPayloadDescriptor instead')
const AppEntityPayload_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'itemId', '3': 1, '4': 2, '5': 5, '10': 'itemId'},
    {'1': 'quantity', '3': 2, '4': 2, '5': 5, '10': 'quantity'},
    {'1': 'itemIsBlueprint', '3': 3, '4': 2, '5': 8, '10': 'itemIsBlueprint'},
  ],
};

/// Descriptor for `AppEntityPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEntityPayloadDescriptor = $convert.base64Decode(
    'ChBBcHBFbnRpdHlQYXlsb2FkEhQKBXZhbHVlGAEgASgIUgV2YWx1ZRI1CgVpdGVtcxgCIAMoCz'
    'IfLnJ1c3RwbHVzLkFwcEVudGl0eVBheWxvYWQuSXRlbVIFaXRlbXMSGgoIY2FwYWNpdHkYAyAB'
    'KAVSCGNhcGFjaXR5EiQKDWhhc1Byb3RlY3Rpb24YBCABKAhSDWhhc1Byb3RlY3Rpb24SKgoQcH'
    'JvdGVjdGlvbkV4cGlyeRgFIAEoDVIQcHJvdGVjdGlvbkV4cGlyeRpkCgRJdGVtEhYKBml0ZW1J'
    'ZBgBIAIoBVIGaXRlbUlkEhoKCHF1YW50aXR5GAIgAigFUghxdWFudGl0eRIoCg9pdGVtSXNCbH'
    'VlcHJpbnQYAyACKAhSD2l0ZW1Jc0JsdWVwcmludA==');

@$core.Deprecated('Use appTeamInfoDescriptor instead')
const AppTeamInfo$json = {
  '1': 'AppTeamInfo',
  '2': [
    {'1': 'leaderSteamId', '3': 1, '4': 2, '5': 4, '10': 'leaderSteamId'},
    {
      '1': 'members',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppTeamInfo.Member',
      '10': 'members'
    },
    {
      '1': 'mapNotes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppTeamInfo.Note',
      '10': 'mapNotes'
    },
    {
      '1': 'leaderMapNotes',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppTeamInfo.Note',
      '10': 'leaderMapNotes'
    },
  ],
  '3': [AppTeamInfo_Member$json, AppTeamInfo_Note$json],
};

@$core.Deprecated('Use appTeamInfoDescriptor instead')
const AppTeamInfo_Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'x', '3': 3, '4': 2, '5': 2, '10': 'x'},
    {'1': 'y', '3': 4, '4': 2, '5': 2, '10': 'y'},
    {'1': 'isOnline', '3': 5, '4': 2, '5': 8, '10': 'isOnline'},
    {'1': 'spawnTime', '3': 6, '4': 2, '5': 13, '10': 'spawnTime'},
    {'1': 'isAlive', '3': 7, '4': 2, '5': 8, '10': 'isAlive'},
    {'1': 'deathTime', '3': 8, '4': 2, '5': 13, '10': 'deathTime'},
  ],
};

@$core.Deprecated('Use appTeamInfoDescriptor instead')
const AppTeamInfo_Note$json = {
  '1': 'Note',
  '2': [
    {'1': 'type', '3': 2, '4': 2, '5': 5, '10': 'type'},
    {'1': 'x', '3': 3, '4': 2, '5': 2, '10': 'x'},
    {'1': 'y', '3': 4, '4': 2, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `AppTeamInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appTeamInfoDescriptor = $convert.base64Decode(
    'CgtBcHBUZWFtSW5mbxIkCg1sZWFkZXJTdGVhbUlkGAEgAigEUg1sZWFkZXJTdGVhbUlkEjYKB2'
    '1lbWJlcnMYAiADKAsyHC5ydXN0cGx1cy5BcHBUZWFtSW5mby5NZW1iZXJSB21lbWJlcnMSNgoI'
    'bWFwTm90ZXMYAyADKAsyGi5ydXN0cGx1cy5BcHBUZWFtSW5mby5Ob3RlUghtYXBOb3RlcxJCCg'
    '5sZWFkZXJNYXBOb3RlcxgEIAMoCzIaLnJ1c3RwbHVzLkFwcFRlYW1JbmZvLk5vdGVSDmxlYWRl'
    'ck1hcE5vdGVzGsQBCgZNZW1iZXISGAoHc3RlYW1JZBgBIAIoBFIHc3RlYW1JZBISCgRuYW1lGA'
    'IgAigJUgRuYW1lEgwKAXgYAyACKAJSAXgSDAoBeRgEIAIoAlIBeRIaCghpc09ubGluZRgFIAIo'
    'CFIIaXNPbmxpbmUSHAoJc3Bhd25UaW1lGAYgAigNUglzcGF3blRpbWUSGAoHaXNBbGl2ZRgHIA'
    'IoCFIHaXNBbGl2ZRIcCglkZWF0aFRpbWUYCCACKA1SCWRlYXRoVGltZRo2CgROb3RlEhIKBHR5'
    'cGUYAiACKAVSBHR5cGUSDAoBeBgDIAIoAlIBeBIMCgF5GAQgAigCUgF5');

@$core.Deprecated('Use appTeamMessageDescriptor instead')
const AppTeamMessage$json = {
  '1': 'AppTeamMessage',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'message', '3': 3, '4': 2, '5': 9, '10': 'message'},
    {'1': 'color', '3': 4, '4': 2, '5': 9, '10': 'color'},
    {'1': 'time', '3': 5, '4': 2, '5': 13, '10': 'time'},
  ],
};

/// Descriptor for `AppTeamMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appTeamMessageDescriptor = $convert.base64Decode(
    'Cg5BcHBUZWFtTWVzc2FnZRIYCgdzdGVhbUlkGAEgAigEUgdzdGVhbUlkEhIKBG5hbWUYAiACKA'
    'lSBG5hbWUSGAoHbWVzc2FnZRgDIAIoCVIHbWVzc2FnZRIUCgVjb2xvchgEIAIoCVIFY29sb3IS'
    'EgoEdGltZRgFIAIoDVIEdGltZQ==');

@$core.Deprecated('Use appTeamChatDescriptor instead')
const AppTeamChat$json = {
  '1': 'AppTeamChat',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppTeamMessage',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `AppTeamChat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appTeamChatDescriptor = $convert.base64Decode(
    'CgtBcHBUZWFtQ2hhdBI0CghtZXNzYWdlcxgBIAMoCzIYLnJ1c3RwbHVzLkFwcFRlYW1NZXNzYW'
    'dlUghtZXNzYWdlcw==');

@$core.Deprecated('Use appMarkerDescriptor instead')
const AppMarker$json = {
  '1': 'AppMarker',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 13, '10': 'id'},
    {
      '1': 'type',
      '3': 2,
      '4': 2,
      '5': 14,
      '6': '.rustplus.AppMarkerType',
      '10': 'type'
    },
    {'1': 'x', '3': 3, '4': 2, '5': 2, '10': 'x'},
    {'1': 'y', '3': 4, '4': 2, '5': 2, '10': 'y'},
    {'1': 'steamId', '3': 5, '4': 1, '5': 4, '10': 'steamId'},
    {'1': 'rotation', '3': 6, '4': 1, '5': 2, '10': 'rotation'},
    {'1': 'radius', '3': 7, '4': 1, '5': 2, '10': 'radius'},
    {
      '1': 'color1',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.rustplus.Vector4',
      '10': 'color1'
    },
    {
      '1': 'color2',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.rustplus.Vector4',
      '10': 'color2'
    },
    {'1': 'alpha', '3': 10, '4': 1, '5': 2, '10': 'alpha'},
    {'1': 'name', '3': 11, '4': 1, '5': 9, '10': 'name'},
    {'1': 'outOfStock', '3': 12, '4': 1, '5': 8, '10': 'outOfStock'},
    {
      '1': 'sellOrders',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppMarker.SellOrder',
      '10': 'sellOrders'
    },
  ],
  '3': [AppMarker_SellOrder$json],
};

@$core.Deprecated('Use appMarkerDescriptor instead')
const AppMarker_SellOrder$json = {
  '1': 'SellOrder',
  '2': [
    {'1': 'itemId', '3': 1, '4': 2, '5': 5, '10': 'itemId'},
    {'1': 'quantity', '3': 2, '4': 2, '5': 5, '10': 'quantity'},
    {'1': 'currencyId', '3': 3, '4': 2, '5': 5, '10': 'currencyId'},
    {'1': 'costPerItem', '3': 4, '4': 2, '5': 5, '10': 'costPerItem'},
    {'1': 'amountInStock', '3': 5, '4': 2, '5': 5, '10': 'amountInStock'},
    {'1': 'itemIsBlueprint', '3': 6, '4': 2, '5': 8, '10': 'itemIsBlueprint'},
    {
      '1': 'currencyIsBlueprint',
      '3': 7,
      '4': 2,
      '5': 8,
      '10': 'currencyIsBlueprint'
    },
    {'1': 'itemCondition', '3': 8, '4': 1, '5': 2, '10': 'itemCondition'},
    {'1': 'itemConditionMax', '3': 9, '4': 1, '5': 2, '10': 'itemConditionMax'},
  ],
};

/// Descriptor for `AppMarker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appMarkerDescriptor = $convert.base64Decode(
    'CglBcHBNYXJrZXISDgoCaWQYASACKA1SAmlkEisKBHR5cGUYAiACKA4yFy5ydXN0cGx1cy5BcH'
    'BNYXJrZXJUeXBlUgR0eXBlEgwKAXgYAyACKAJSAXgSDAoBeRgEIAIoAlIBeRIYCgdzdGVhbUlk'
    'GAUgASgEUgdzdGVhbUlkEhoKCHJvdGF0aW9uGAYgASgCUghyb3RhdGlvbhIWCgZyYWRpdXMYBy'
    'ABKAJSBnJhZGl1cxIpCgZjb2xvcjEYCCABKAsyES5ydXN0cGx1cy5WZWN0b3I0UgZjb2xvcjES'
    'KQoGY29sb3IyGAkgASgLMhEucnVzdHBsdXMuVmVjdG9yNFIGY29sb3IyEhQKBWFscGhhGAogAS'
    'gCUgVhbHBoYRISCgRuYW1lGAsgASgJUgRuYW1lEh4KCm91dE9mU3RvY2sYDCABKAhSCm91dE9m'
    'U3RvY2sSPQoKc2VsbE9yZGVycxgNIAMoCzIdLnJ1c3RwbHVzLkFwcE1hcmtlci5TZWxsT3JkZX'
    'JSCnNlbGxPcmRlcnMa1QIKCVNlbGxPcmRlchIWCgZpdGVtSWQYASACKAVSBml0ZW1JZBIaCghx'
    'dWFudGl0eRgCIAIoBVIIcXVhbnRpdHkSHgoKY3VycmVuY3lJZBgDIAIoBVIKY3VycmVuY3lJZB'
    'IgCgtjb3N0UGVySXRlbRgEIAIoBVILY29zdFBlckl0ZW0SJAoNYW1vdW50SW5TdG9jaxgFIAIo'
    'BVINYW1vdW50SW5TdG9jaxIoCg9pdGVtSXNCbHVlcHJpbnQYBiACKAhSD2l0ZW1Jc0JsdWVwcm'
    'ludBIwChNjdXJyZW5jeUlzQmx1ZXByaW50GAcgAigIUhNjdXJyZW5jeUlzQmx1ZXByaW50EiQK'
    'DWl0ZW1Db25kaXRpb24YCCABKAJSDWl0ZW1Db25kaXRpb24SKgoQaXRlbUNvbmRpdGlvbk1heB'
    'gJIAEoAlIQaXRlbUNvbmRpdGlvbk1heA==');

@$core.Deprecated('Use appMapMarkersDescriptor instead')
const AppMapMarkers$json = {
  '1': 'AppMapMarkers',
  '2': [
    {
      '1': 'markers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppMarker',
      '10': 'markers'
    },
  ],
};

/// Descriptor for `AppMapMarkers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appMapMarkersDescriptor = $convert.base64Decode(
    'Cg1BcHBNYXBNYXJrZXJzEi0KB21hcmtlcnMYASADKAsyEy5ydXN0cGx1cy5BcHBNYXJrZXJSB2'
    '1hcmtlcnM=');

@$core.Deprecated('Use appClanInfoDescriptor instead')
const AppClanInfo$json = {
  '1': 'AppClanInfo',
  '2': [
    {
      '1': 'clanInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rustplus.ClanInfo',
      '10': 'clanInfo'
    },
  ],
};

/// Descriptor for `AppClanInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appClanInfoDescriptor = $convert.base64Decode(
    'CgtBcHBDbGFuSW5mbxIuCghjbGFuSW5mbxgBIAEoCzISLnJ1c3RwbHVzLkNsYW5JbmZvUghjbG'
    'FuSW5mbw==');

@$core.Deprecated('Use appClanMessageDescriptor instead')
const AppClanMessage$json = {
  '1': 'AppClanMessage',
  '2': [
    {'1': 'steamId', '3': 1, '4': 2, '5': 4, '10': 'steamId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'message', '3': 3, '4': 2, '5': 9, '10': 'message'},
    {'1': 'time', '3': 4, '4': 2, '5': 3, '10': 'time'},
  ],
};

/// Descriptor for `AppClanMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appClanMessageDescriptor = $convert.base64Decode(
    'Cg5BcHBDbGFuTWVzc2FnZRIYCgdzdGVhbUlkGAEgAigEUgdzdGVhbUlkEhIKBG5hbWUYAiACKA'
    'lSBG5hbWUSGAoHbWVzc2FnZRgDIAIoCVIHbWVzc2FnZRISCgR0aW1lGAQgAigDUgR0aW1l');

@$core.Deprecated('Use appClanChatDescriptor instead')
const AppClanChat$json = {
  '1': 'AppClanChat',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppClanMessage',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `AppClanChat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appClanChatDescriptor = $convert.base64Decode(
    'CgtBcHBDbGFuQ2hhdBI0CghtZXNzYWdlcxgBIAMoCzIYLnJ1c3RwbHVzLkFwcENsYW5NZXNzYW'
    'dlUghtZXNzYWdlcw==');

@$core.Deprecated('Use appNexusAuthDescriptor instead')
const AppNexusAuth$json = {
  '1': 'AppNexusAuth',
  '2': [
    {'1': 'serverId', '3': 1, '4': 2, '5': 9, '10': 'serverId'},
    {'1': 'playerToken', '3': 2, '4': 2, '5': 5, '10': 'playerToken'},
  ],
};

/// Descriptor for `AppNexusAuth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appNexusAuthDescriptor = $convert.base64Decode(
    'CgxBcHBOZXh1c0F1dGgSGgoIc2VydmVySWQYASACKAlSCHNlcnZlcklkEiAKC3BsYXllclRva2'
    'VuGAIgAigFUgtwbGF5ZXJUb2tlbg==');

@$core.Deprecated('Use appTeamChangedDescriptor instead')
const AppTeamChanged$json = {
  '1': 'AppTeamChanged',
  '2': [
    {'1': 'playerId', '3': 1, '4': 2, '5': 4, '10': 'playerId'},
    {
      '1': 'teamInfo',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.rustplus.AppTeamInfo',
      '10': 'teamInfo'
    },
  ],
};

/// Descriptor for `AppTeamChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appTeamChangedDescriptor = $convert.base64Decode(
    'Cg5BcHBUZWFtQ2hhbmdlZBIaCghwbGF5ZXJJZBgBIAIoBFIIcGxheWVySWQSMQoIdGVhbUluZm'
    '8YAiACKAsyFS5ydXN0cGx1cy5BcHBUZWFtSW5mb1IIdGVhbUluZm8=');

@$core.Deprecated('Use appNewTeamMessageDescriptor instead')
const AppNewTeamMessage$json = {
  '1': 'AppNewTeamMessage',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 2,
      '5': 11,
      '6': '.rustplus.AppTeamMessage',
      '10': 'message'
    },
  ],
};

/// Descriptor for `AppNewTeamMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appNewTeamMessageDescriptor = $convert.base64Decode(
    'ChFBcHBOZXdUZWFtTWVzc2FnZRIyCgdtZXNzYWdlGAEgAigLMhgucnVzdHBsdXMuQXBwVGVhbU'
    '1lc3NhZ2VSB21lc3NhZ2U=');

@$core.Deprecated('Use appEntityChangedDescriptor instead')
const AppEntityChanged$json = {
  '1': 'AppEntityChanged',
  '2': [
    {'1': 'entityId', '3': 1, '4': 2, '5': 13, '10': 'entityId'},
    {
      '1': 'payload',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.rustplus.AppEntityPayload',
      '10': 'payload'
    },
  ],
};

/// Descriptor for `AppEntityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEntityChangedDescriptor = $convert.base64Decode(
    'ChBBcHBFbnRpdHlDaGFuZ2VkEhoKCGVudGl0eUlkGAEgAigNUghlbnRpdHlJZBI0CgdwYXlsb2'
    'FkGAIgAigLMhoucnVzdHBsdXMuQXBwRW50aXR5UGF5bG9hZFIHcGF5bG9hZA==');

@$core.Deprecated('Use appClanChangedDescriptor instead')
const AppClanChanged$json = {
  '1': 'AppClanChanged',
  '2': [
    {
      '1': 'clanInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rustplus.ClanInfo',
      '10': 'clanInfo'
    },
  ],
};

/// Descriptor for `AppClanChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appClanChangedDescriptor = $convert.base64Decode(
    'Cg5BcHBDbGFuQ2hhbmdlZBIuCghjbGFuSW5mbxgBIAEoCzISLnJ1c3RwbHVzLkNsYW5JbmZvUg'
    'hjbGFuSW5mbw==');

@$core.Deprecated('Use appNewClanMessageDescriptor instead')
const AppNewClanMessage$json = {
  '1': 'AppNewClanMessage',
  '2': [
    {'1': 'clanId', '3': 1, '4': 2, '5': 3, '10': 'clanId'},
    {
      '1': 'message',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.rustplus.AppClanMessage',
      '10': 'message'
    },
  ],
};

/// Descriptor for `AppNewClanMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appNewClanMessageDescriptor = $convert.base64Decode(
    'ChFBcHBOZXdDbGFuTWVzc2FnZRIWCgZjbGFuSWQYASACKANSBmNsYW5JZBIyCgdtZXNzYWdlGA'
    'IgAigLMhgucnVzdHBsdXMuQXBwQ2xhbk1lc3NhZ2VSB21lc3NhZ2U=');

@$core.Deprecated('Use appCameraSubscribeDescriptor instead')
const AppCameraSubscribe$json = {
  '1': 'AppCameraSubscribe',
  '2': [
    {'1': 'cameraId', '3': 1, '4': 2, '5': 9, '10': 'cameraId'},
  ],
};

/// Descriptor for `AppCameraSubscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appCameraSubscribeDescriptor =
    $convert.base64Decode(
        'ChJBcHBDYW1lcmFTdWJzY3JpYmUSGgoIY2FtZXJhSWQYASACKAlSCGNhbWVyYUlk');

@$core.Deprecated('Use appCameraInputDescriptor instead')
const AppCameraInput$json = {
  '1': 'AppCameraInput',
  '2': [
    {'1': 'buttons', '3': 1, '4': 2, '5': 5, '10': 'buttons'},
    {
      '1': 'mouseDelta',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.rustplus.Vector2',
      '10': 'mouseDelta'
    },
  ],
};

/// Descriptor for `AppCameraInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appCameraInputDescriptor = $convert.base64Decode(
    'Cg5BcHBDYW1lcmFJbnB1dBIYCgdidXR0b25zGAEgAigFUgdidXR0b25zEjEKCm1vdXNlRGVsdG'
    'EYAiACKAsyES5ydXN0cGx1cy5WZWN0b3IyUgptb3VzZURlbHRh');

@$core.Deprecated('Use appCameraInfoDescriptor instead')
const AppCameraInfo$json = {
  '1': 'AppCameraInfo',
  '2': [
    {'1': 'width', '3': 1, '4': 2, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 2, '5': 5, '10': 'height'},
    {'1': 'nearPlane', '3': 3, '4': 2, '5': 2, '10': 'nearPlane'},
    {'1': 'farPlane', '3': 4, '4': 2, '5': 2, '10': 'farPlane'},
    {'1': 'controlFlags', '3': 5, '4': 2, '5': 5, '10': 'controlFlags'},
  ],
};

/// Descriptor for `AppCameraInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appCameraInfoDescriptor = $convert.base64Decode(
    'Cg1BcHBDYW1lcmFJbmZvEhQKBXdpZHRoGAEgAigFUgV3aWR0aBIWCgZoZWlnaHQYAiACKAVSBm'
    'hlaWdodBIcCgluZWFyUGxhbmUYAyACKAJSCW5lYXJQbGFuZRIaCghmYXJQbGFuZRgEIAIoAlII'
    'ZmFyUGxhbmUSIgoMY29udHJvbEZsYWdzGAUgAigFUgxjb250cm9sRmxhZ3M=');

@$core.Deprecated('Use appCameraRaysDescriptor instead')
const AppCameraRays$json = {
  '1': 'AppCameraRays',
  '2': [
    {'1': 'verticalFov', '3': 1, '4': 2, '5': 2, '10': 'verticalFov'},
    {'1': 'sampleOffset', '3': 2, '4': 2, '5': 5, '10': 'sampleOffset'},
    {'1': 'rayData', '3': 3, '4': 2, '5': 12, '10': 'rayData'},
    {'1': 'distance', '3': 4, '4': 2, '5': 2, '10': 'distance'},
    {
      '1': 'entities',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.rustplus.AppCameraRays.Entity',
      '10': 'entities'
    },
  ],
  '3': [AppCameraRays_Entity$json],
  '4': [AppCameraRays_EntityType$json],
};

@$core.Deprecated('Use appCameraRaysDescriptor instead')
const AppCameraRays_Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'entityId', '3': 1, '4': 2, '5': 13, '10': 'entityId'},
    {
      '1': 'type',
      '3': 2,
      '4': 2,
      '5': 14,
      '6': '.rustplus.AppCameraRays.EntityType',
      '10': 'type'
    },
    {
      '1': 'position',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.rustplus.Vector3',
      '10': 'position'
    },
    {
      '1': 'rotation',
      '3': 4,
      '4': 2,
      '5': 11,
      '6': '.rustplus.Vector3',
      '10': 'rotation'
    },
    {
      '1': 'size',
      '3': 5,
      '4': 2,
      '5': 11,
      '6': '.rustplus.Vector3',
      '10': 'size'
    },
    {'1': 'name', '3': 6, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appCameraRaysDescriptor instead')
const AppCameraRays_EntityType$json = {
  '1': 'EntityType',
  '2': [
    {'1': 'Tree', '2': 1},
    {'1': 'Player', '2': 2},
  ],
};

/// Descriptor for `AppCameraRays`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appCameraRaysDescriptor = $convert.base64Decode(
    'Cg1BcHBDYW1lcmFSYXlzEiAKC3ZlcnRpY2FsRm92GAEgAigCUgt2ZXJ0aWNhbEZvdhIiCgxzYW'
    '1wbGVPZmZzZXQYAiACKAVSDHNhbXBsZU9mZnNldBIYCgdyYXlEYXRhGAMgAigMUgdyYXlEYXRh'
    'EhoKCGRpc3RhbmNlGAQgAigCUghkaXN0YW5jZRI6CghlbnRpdGllcxgFIAMoCzIeLnJ1c3RwbH'
    'VzLkFwcENhbWVyYVJheXMuRW50aXR5UghlbnRpdGllcxr1AQoGRW50aXR5EhoKCGVudGl0eUlk'
    'GAEgAigNUghlbnRpdHlJZBI2CgR0eXBlGAIgAigOMiIucnVzdHBsdXMuQXBwQ2FtZXJhUmF5cy'
    '5FbnRpdHlUeXBlUgR0eXBlEi0KCHBvc2l0aW9uGAMgAigLMhEucnVzdHBsdXMuVmVjdG9yM1II'
    'cG9zaXRpb24SLQoIcm90YXRpb24YBCACKAsyES5ydXN0cGx1cy5WZWN0b3IzUghyb3RhdGlvbh'
    'IlCgRzaXplGAUgAigLMhEucnVzdHBsdXMuVmVjdG9yM1IEc2l6ZRISCgRuYW1lGAYgASgJUgRu'
    'YW1lIiIKCkVudGl0eVR5cGUSCAoEVHJlZRABEgoKBlBsYXllchAC');
