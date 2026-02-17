// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lib/core/proto/**

part of 'fcm_credential.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFcmCredentialCollection on Isar {
  IsarCollection<FcmCredential> get fcmCredentials => this.collection();
}

const FcmCredentialSchema = CollectionSchema(
  name: r'FcmCredential',
  id: 4284765266677665235,
  properties: {
    r'androidId': PropertySchema(
      id: 0,
      name: r'androidId',
      type: IsarType.long,
    ),
    r'expoPushToken': PropertySchema(
      id: 1,
      name: r'expoPushToken',
      type: IsarType.string,
    ),
    r'fcmToken': PropertySchema(
      id: 2,
      name: r'fcmToken',
      type: IsarType.string,
    ),
    r'securityToken': PropertySchema(
      id: 3,
      name: r'securityToken',
      type: IsarType.long,
    ),
    r'steamId': PropertySchema(
      id: 4,
      name: r'steamId',
      type: IsarType.string,
    ),
    r'steamToken': PropertySchema(
      id: 5,
      name: r'steamToken',
      type: IsarType.string,
    )
  },
  estimateSize: _fcmCredentialEstimateSize,
  serialize: _fcmCredentialSerialize,
  deserialize: _fcmCredentialDeserialize,
  deserializeProp: _fcmCredentialDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _fcmCredentialGetId,
  getLinks: _fcmCredentialGetLinks,
  attach: _fcmCredentialAttach,
  version: '3.1.0+1',
);

int _fcmCredentialEstimateSize(
  FcmCredential object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.expoPushToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fcmToken.length * 3;
  {
    final value = object.steamId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.steamToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fcmCredentialSerialize(
  FcmCredential object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.androidId);
  writer.writeString(offsets[1], object.expoPushToken);
  writer.writeString(offsets[2], object.fcmToken);
  writer.writeLong(offsets[3], object.securityToken);
  writer.writeString(offsets[4], object.steamId);
  writer.writeString(offsets[5], object.steamToken);
}

FcmCredential _fcmCredentialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FcmCredential();
  object.androidId = reader.readLongOrNull(offsets[0]);
  object.expoPushToken = reader.readStringOrNull(offsets[1]);
  object.fcmToken = reader.readString(offsets[2]);
  object.id = id;
  object.securityToken = reader.readLongOrNull(offsets[3]);
  object.steamId = reader.readStringOrNull(offsets[4]);
  object.steamToken = reader.readStringOrNull(offsets[5]);
  return object;
}

P _fcmCredentialDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fcmCredentialGetId(FcmCredential object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fcmCredentialGetLinks(FcmCredential object) {
  return [];
}

void _fcmCredentialAttach(
    IsarCollection<dynamic> col, Id id, FcmCredential object) {
  object.id = id;
}

extension FcmCredentialQueryWhereSort
    on QueryBuilder<FcmCredential, FcmCredential, QWhere> {
  QueryBuilder<FcmCredential, FcmCredential, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FcmCredentialQueryWhere
    on QueryBuilder<FcmCredential, FcmCredential, QWhereClause> {
  QueryBuilder<FcmCredential, FcmCredential, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FcmCredentialQueryFilter
    on QueryBuilder<FcmCredential, FcmCredential, QFilterCondition> {
  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'androidId',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'androidId',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'androidId',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'androidId',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'androidId',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      androidIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'androidId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expoPushToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expoPushToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expoPushToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expoPushToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expoPushToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expoPushToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      expoPushTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expoPushToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fcmToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fcmToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fcmToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fcmToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      fcmTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fcmToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'securityToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'securityToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'securityToken',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'securityToken',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'securityToken',
        value: value,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      securityTokenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'securityToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'steamId',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'steamId',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'steamId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'steamId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamId',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'steamId',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'steamToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'steamToken',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'steamToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'steamToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamToken',
        value: '',
      ));
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterFilterCondition>
      steamTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'steamToken',
        value: '',
      ));
    });
  }
}

extension FcmCredentialQueryObject
    on QueryBuilder<FcmCredential, FcmCredential, QFilterCondition> {}

extension FcmCredentialQueryLinks
    on QueryBuilder<FcmCredential, FcmCredential, QFilterCondition> {}

extension FcmCredentialQuerySortBy
    on QueryBuilder<FcmCredential, FcmCredential, QSortBy> {
  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> sortByAndroidId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidId', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortByAndroidIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidId', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortByExpoPushToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expoPushToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortByExpoPushTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expoPushToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> sortByFcmToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fcmToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortByFcmTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fcmToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortBySecurityToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'securityToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortBySecurityTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'securityToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> sortBySteamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> sortBySteamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> sortBySteamToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      sortBySteamTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.desc);
    });
  }
}

extension FcmCredentialQuerySortThenBy
    on QueryBuilder<FcmCredential, FcmCredential, QSortThenBy> {
  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenByAndroidId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidId', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenByAndroidIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidId', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenByExpoPushToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expoPushToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenByExpoPushTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expoPushToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenByFcmToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fcmToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenByFcmTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fcmToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenBySecurityToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'securityToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenBySecurityTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'securityToken', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenBySteamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenBySteamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.desc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy> thenBySteamToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.asc);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QAfterSortBy>
      thenBySteamTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.desc);
    });
  }
}

extension FcmCredentialQueryWhereDistinct
    on QueryBuilder<FcmCredential, FcmCredential, QDistinct> {
  QueryBuilder<FcmCredential, FcmCredential, QDistinct> distinctByAndroidId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'androidId');
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QDistinct> distinctByExpoPushToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expoPushToken',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QDistinct> distinctByFcmToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fcmToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QDistinct>
      distinctBySecurityToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'securityToken');
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QDistinct> distinctBySteamId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'steamId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FcmCredential, FcmCredential, QDistinct> distinctBySteamToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'steamToken', caseSensitive: caseSensitive);
    });
  }
}

extension FcmCredentialQueryProperty
    on QueryBuilder<FcmCredential, FcmCredential, QQueryProperty> {
  QueryBuilder<FcmCredential, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FcmCredential, int?, QQueryOperations> androidIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'androidId');
    });
  }

  QueryBuilder<FcmCredential, String?, QQueryOperations>
      expoPushTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expoPushToken');
    });
  }

  QueryBuilder<FcmCredential, String, QQueryOperations> fcmTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fcmToken');
    });
  }

  QueryBuilder<FcmCredential, int?, QQueryOperations> securityTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'securityToken');
    });
  }

  QueryBuilder<FcmCredential, String?, QQueryOperations> steamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'steamId');
    });
  }

  QueryBuilder<FcmCredential, String?, QQueryOperations> steamTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'steamToken');
    });
  }
}
