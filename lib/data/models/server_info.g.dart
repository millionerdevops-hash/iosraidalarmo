// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lib/core/proto/**

part of 'server_info.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerInfoCollection on Isar {
  IsarCollection<ServerInfo> get serverInfos => this.collection();
}

const ServerInfoSchema = CollectionSchema(
  name: r'ServerInfo',
  id: 2884500712778782988,
  properties: {
    r'ip': PropertySchema(
      id: 0,
      name: r'ip',
      type: IsarType.string,
    ),
    r'isSelected': PropertySchema(
      id: 1,
      name: r'isSelected',
      type: IsarType.bool,
    ),
    r'logoUrl': PropertySchema(
      id: 2,
      name: r'logoUrl',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'playerId': PropertySchema(
      id: 4,
      name: r'playerId',
      type: IsarType.string,
    ),
    r'playerToken': PropertySchema(
      id: 5,
      name: r'playerToken',
      type: IsarType.string,
    ),
    r'port': PropertySchema(
      id: 6,
      name: r'port',
      type: IsarType.string,
    ),
    r'useProxy': PropertySchema(
      id: 7,
      name: r'useProxy',
      type: IsarType.bool,
    )
  },
  estimateSize: _serverInfoEstimateSize,
  serialize: _serverInfoSerialize,
  deserialize: _serverInfoDeserialize,
  deserializeProp: _serverInfoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _serverInfoGetId,
  getLinks: _serverInfoGetLinks,
  attach: _serverInfoAttach,
  version: '3.1.0+1',
);

int _serverInfoEstimateSize(
  ServerInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ip.length * 3;
  {
    final value = object.logoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.playerId.length * 3;
  bytesCount += 3 + object.playerToken.length * 3;
  bytesCount += 3 + object.port.length * 3;
  return bytesCount;
}

void _serverInfoSerialize(
  ServerInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.ip);
  writer.writeBool(offsets[1], object.isSelected);
  writer.writeString(offsets[2], object.logoUrl);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.playerId);
  writer.writeString(offsets[5], object.playerToken);
  writer.writeString(offsets[6], object.port);
  writer.writeBool(offsets[7], object.useProxy);
}

ServerInfo _serverInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ServerInfo();
  object.id = id;
  object.ip = reader.readString(offsets[0]);
  object.isSelected = reader.readBool(offsets[1]);
  object.logoUrl = reader.readStringOrNull(offsets[2]);
  object.name = reader.readStringOrNull(offsets[3]);
  object.playerId = reader.readString(offsets[4]);
  object.playerToken = reader.readString(offsets[5]);
  object.port = reader.readString(offsets[6]);
  object.useProxy = reader.readBool(offsets[7]);
  return object;
}

P _serverInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverInfoGetId(ServerInfo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverInfoGetLinks(ServerInfo object) {
  return [];
}

void _serverInfoAttach(IsarCollection<dynamic> col, Id id, ServerInfo object) {
  object.id = id;
}

extension ServerInfoQueryWhereSort
    on QueryBuilder<ServerInfo, ServerInfo, QWhere> {
  QueryBuilder<ServerInfo, ServerInfo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServerInfoQueryWhere
    on QueryBuilder<ServerInfo, ServerInfo, QWhereClause> {
  QueryBuilder<ServerInfo, ServerInfo, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerInfo, ServerInfo, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterWhereClause> idBetween(
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

extension ServerInfoQueryFilter
    on QueryBuilder<ServerInfo, ServerInfo, QFilterCondition> {
  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ip',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ip',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ip',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ip',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> ipIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ip',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> isSelectedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSelected',
        value: value,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoUrl',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      logoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoUrl',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      logoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> logoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      logoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> playerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerToken',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition>
      playerTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerToken',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'port',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'port',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'port',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'port',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> portIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'port',
        value: '',
      ));
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterFilterCondition> useProxyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useProxy',
        value: value,
      ));
    });
  }
}

extension ServerInfoQueryObject
    on QueryBuilder<ServerInfo, ServerInfo, QFilterCondition> {}

extension ServerInfoQueryLinks
    on QueryBuilder<ServerInfo, ServerInfo, QFilterCondition> {}

extension ServerInfoQuerySortBy
    on QueryBuilder<ServerInfo, ServerInfo, QSortBy> {
  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByIp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ip', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByIpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ip', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPlayerToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerToken', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPlayerTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerToken', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'port', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'port', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByUseProxy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProxy', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> sortByUseProxyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProxy', Sort.desc);
    });
  }
}

extension ServerInfoQuerySortThenBy
    on QueryBuilder<ServerInfo, ServerInfo, QSortThenBy> {
  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByIp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ip', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByIpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ip', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPlayerToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerToken', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPlayerTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerToken', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'port', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'port', Sort.desc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByUseProxy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProxy', Sort.asc);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QAfterSortBy> thenByUseProxyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProxy', Sort.desc);
    });
  }
}

extension ServerInfoQueryWhereDistinct
    on QueryBuilder<ServerInfo, ServerInfo, QDistinct> {
  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByIp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ip', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSelected');
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByLogoUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByPlayerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByPlayerToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByPort(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'port', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerInfo, ServerInfo, QDistinct> distinctByUseProxy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useProxy');
    });
  }
}

extension ServerInfoQueryProperty
    on QueryBuilder<ServerInfo, ServerInfo, QQueryProperty> {
  QueryBuilder<ServerInfo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerInfo, String, QQueryOperations> ipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ip');
    });
  }

  QueryBuilder<ServerInfo, bool, QQueryOperations> isSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSelected');
    });
  }

  QueryBuilder<ServerInfo, String?, QQueryOperations> logoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoUrl');
    });
  }

  QueryBuilder<ServerInfo, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ServerInfo, String, QQueryOperations> playerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerId');
    });
  }

  QueryBuilder<ServerInfo, String, QQueryOperations> playerTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerToken');
    });
  }

  QueryBuilder<ServerInfo, String, QQueryOperations> portProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'port');
    });
  }

  QueryBuilder<ServerInfo, bool, QQueryOperations> useProxyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useProxy');
    });
  }
}
