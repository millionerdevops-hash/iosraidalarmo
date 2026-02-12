// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lib/core/proto/**

part of 'steam_credential.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSteamCredentialCollection on Isar {
  IsarCollection<SteamCredential> get steamCredentials => this.collection();
}

const SteamCredentialSchema = CollectionSchema(
  name: r'SteamCredential',
  id: -7852550586329301488,
  properties: {
    r'steamId': PropertySchema(
      id: 0,
      name: r'steamId',
      type: IsarType.string,
    ),
    r'steamToken': PropertySchema(
      id: 1,
      name: r'steamToken',
      type: IsarType.string,
    )
  },
  estimateSize: _steamCredentialEstimateSize,
  serialize: _steamCredentialSerialize,
  deserialize: _steamCredentialDeserialize,
  deserializeProp: _steamCredentialDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _steamCredentialGetId,
  getLinks: _steamCredentialGetLinks,
  attach: _steamCredentialAttach,
  version: '3.1.0+1',
);

int _steamCredentialEstimateSize(
  SteamCredential object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
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

void _steamCredentialSerialize(
  SteamCredential object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.steamId);
  writer.writeString(offsets[1], object.steamToken);
}

SteamCredential _steamCredentialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SteamCredential();
  object.id = id;
  object.steamId = reader.readStringOrNull(offsets[0]);
  object.steamToken = reader.readStringOrNull(offsets[1]);
  return object;
}

P _steamCredentialDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _steamCredentialGetId(SteamCredential object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _steamCredentialGetLinks(SteamCredential object) {
  return [];
}

void _steamCredentialAttach(
    IsarCollection<dynamic> col, Id id, SteamCredential object) {
  object.id = id;
}

extension SteamCredentialQueryWhereSort
    on QueryBuilder<SteamCredential, SteamCredential, QWhere> {
  QueryBuilder<SteamCredential, SteamCredential, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SteamCredentialQueryWhere
    on QueryBuilder<SteamCredential, SteamCredential, QWhereClause> {
  QueryBuilder<SteamCredential, SteamCredential, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterWhereClause> idBetween(
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

extension SteamCredentialQueryFilter
    on QueryBuilder<SteamCredential, SteamCredential, QFilterCondition> {
  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'steamId',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'steamId',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'steamId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'steamId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamId',
        value: '',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'steamId',
        value: '',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'steamToken',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'steamToken',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
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

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'steamToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'steamToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'steamToken',
        value: '',
      ));
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterFilterCondition>
      steamTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'steamToken',
        value: '',
      ));
    });
  }
}

extension SteamCredentialQueryObject
    on QueryBuilder<SteamCredential, SteamCredential, QFilterCondition> {}

extension SteamCredentialQueryLinks
    on QueryBuilder<SteamCredential, SteamCredential, QFilterCondition> {}

extension SteamCredentialQuerySortBy
    on QueryBuilder<SteamCredential, SteamCredential, QSortBy> {
  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy> sortBySteamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.asc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      sortBySteamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.desc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      sortBySteamToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.asc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      sortBySteamTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.desc);
    });
  }
}

extension SteamCredentialQuerySortThenBy
    on QueryBuilder<SteamCredential, SteamCredential, QSortThenBy> {
  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy> thenBySteamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.asc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      thenBySteamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamId', Sort.desc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      thenBySteamToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.asc);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QAfterSortBy>
      thenBySteamTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'steamToken', Sort.desc);
    });
  }
}

extension SteamCredentialQueryWhereDistinct
    on QueryBuilder<SteamCredential, SteamCredential, QDistinct> {
  QueryBuilder<SteamCredential, SteamCredential, QDistinct> distinctBySteamId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'steamId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SteamCredential, SteamCredential, QDistinct>
      distinctBySteamToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'steamToken', caseSensitive: caseSensitive);
    });
  }
}

extension SteamCredentialQueryProperty
    on QueryBuilder<SteamCredential, SteamCredential, QQueryProperty> {
  QueryBuilder<SteamCredential, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SteamCredential, String?, QQueryOperations> steamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'steamId');
    });
  }

  QueryBuilder<SteamCredential, String?, QQueryOperations>
      steamTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'steamToken');
    });
  }
}
