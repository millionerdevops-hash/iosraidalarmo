// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lib/core/proto/**

part of 'automation_rule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAutomationRuleCollection on Isar {
  IsarCollection<AutomationRule> get automationRules => this.collection();
}

const AutomationRuleSchema = CollectionSchema(
  name: r'AutomationRule',
  id: -2923571291435955635,
  properties: {
    r'actions': PropertySchema(
      id: 0,
      name: r'actions',
      type: IsarType.objectList,
      target: r'AutomationAction',
    ),
    r'autoOff': PropertySchema(
      id: 1,
      name: r'autoOff',
      type: IsarType.bool,
    ),
    r'currentTriggerCount': PropertySchema(
      id: 2,
      name: r'currentTriggerCount',
      type: IsarType.long,
    ),
    r'endTimeMinutes': PropertySchema(
      id: 3,
      name: r'endTimeMinutes',
      type: IsarType.long,
    ),
    r'isEnabled': PropertySchema(
      id: 4,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'playAppAlarm': PropertySchema(
      id: 6,
      name: r'playAppAlarm',
      type: IsarType.bool,
    ),
    r'serverId': PropertySchema(
      id: 7,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'startTimeMinutes': PropertySchema(
      id: 8,
      name: r'startTimeMinutes',
      type: IsarType.long,
    ),
    r'triggerCondition': PropertySchema(
      id: 9,
      name: r'triggerCondition',
      type: IsarType.long,
    ),
    r'triggerCountThreshold': PropertySchema(
      id: 10,
      name: r'triggerCountThreshold',
      type: IsarType.long,
    ),
    r'triggerEntityId': PropertySchema(
      id: 11,
      name: r'triggerEntityId',
      type: IsarType.long,
    ),
    r'triggerThreshold': PropertySchema(
      id: 12,
      name: r'triggerThreshold',
      type: IsarType.double,
    )
  },
  estimateSize: _automationRuleEstimateSize,
  serialize: _automationRuleSerialize,
  deserialize: _automationRuleDeserialize,
  deserializeProp: _automationRuleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'AutomationAction': AutomationActionSchema},
  getId: _automationRuleGetId,
  getLinks: _automationRuleGetLinks,
  attach: _automationRuleAttach,
  version: '3.1.0+1',
);

int _automationRuleEstimateSize(
  AutomationRule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actions.length * 3;
  {
    final offsets = allOffsets[AutomationAction]!;
    for (var i = 0; i < object.actions.length; i++) {
      final value = object.actions[i];
      bytesCount +=
          AutomationActionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _automationRuleSerialize(
  AutomationRule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<AutomationAction>(
    offsets[0],
    allOffsets,
    AutomationActionSchema.serialize,
    object.actions,
  );
  writer.writeBool(offsets[1], object.autoOff);
  writer.writeLong(offsets[2], object.currentTriggerCount);
  writer.writeLong(offsets[3], object.endTimeMinutes);
  writer.writeBool(offsets[4], object.isEnabled);
  writer.writeString(offsets[5], object.name);
  writer.writeBool(offsets[6], object.playAppAlarm);
  writer.writeLong(offsets[7], object.serverId);
  writer.writeLong(offsets[8], object.startTimeMinutes);
  writer.writeLong(offsets[9], object.triggerCondition);
  writer.writeLong(offsets[10], object.triggerCountThreshold);
  writer.writeLong(offsets[11], object.triggerEntityId);
  writer.writeDouble(offsets[12], object.triggerThreshold);
}

AutomationRule _automationRuleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutomationRule();
  object.actions = reader.readObjectList<AutomationAction>(
        offsets[0],
        AutomationActionSchema.deserialize,
        allOffsets,
        AutomationAction(),
      ) ??
      [];
  object.autoOff = reader.readBool(offsets[1]);
  object.currentTriggerCount = reader.readLong(offsets[2]);
  object.endTimeMinutes = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.isEnabled = reader.readBool(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.playAppAlarm = reader.readBool(offsets[6]);
  object.serverId = reader.readLong(offsets[7]);
  object.startTimeMinutes = reader.readLongOrNull(offsets[8]);
  object.triggerCondition = reader.readLong(offsets[9]);
  object.triggerCountThreshold = reader.readLong(offsets[10]);
  object.triggerEntityId = reader.readLong(offsets[11]);
  object.triggerThreshold = reader.readDoubleOrNull(offsets[12]);
  return object;
}

P _automationRuleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<AutomationAction>(
            offset,
            AutomationActionSchema.deserialize,
            allOffsets,
            AutomationAction(),
          ) ??
          []) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _automationRuleGetId(AutomationRule object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _automationRuleGetLinks(AutomationRule object) {
  return [];
}

void _automationRuleAttach(
    IsarCollection<dynamic> col, Id id, AutomationRule object) {
  object.id = id;
}

extension AutomationRuleQueryWhereSort
    on QueryBuilder<AutomationRule, AutomationRule, QWhere> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AutomationRuleQueryWhere
    on QueryBuilder<AutomationRule, AutomationRule, QWhereClause> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterWhereClause> idBetween(
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

extension AutomationRuleQueryFilter
    on QueryBuilder<AutomationRule, AutomationRule, QFilterCondition> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'actions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      autoOffEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoOff',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      currentTriggerCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTriggerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      currentTriggerCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTriggerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      currentTriggerCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTriggerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      currentTriggerCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTriggerCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTimeMinutes',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTimeMinutes',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      endTimeMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTimeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      isEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameEqualTo(
    String value, {
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameLessThan(
    String value, {
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      playAppAlarmEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playAppAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      serverIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      serverIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      serverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTimeMinutes',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTimeMinutes',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      startTimeMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTimeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerConditionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerCondition',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerConditionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerCondition',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerConditionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerCondition',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerConditionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerCondition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerCountThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerCountThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerCountThresholdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerCountThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerCountThresholdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerCountThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerCountThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerCountThreshold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerEntityIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerEntityIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerEntityIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerEntityIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerEntityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggerThreshold',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggerThreshold',
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      triggerThresholdBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerThreshold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AutomationRuleQueryObject
    on QueryBuilder<AutomationRule, AutomationRule, QFilterCondition> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterFilterCondition>
      actionsElement(FilterQuery<AutomationAction> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'actions');
    });
  }
}

extension AutomationRuleQueryLinks
    on QueryBuilder<AutomationRule, AutomationRule, QFilterCondition> {}

extension AutomationRuleQuerySortBy
    on QueryBuilder<AutomationRule, AutomationRule, QSortBy> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> sortByAutoOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoOff', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByAutoOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoOff', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByCurrentTriggerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTriggerCount', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByCurrentTriggerCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTriggerCount', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByEndTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByEndTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByPlayAppAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playAppAlarm', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByPlayAppAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playAppAlarm', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByStartTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCondition', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCondition', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerCountThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCountThreshold', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerCountThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCountThreshold', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerEntityId', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerEntityId', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerThreshold', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      sortByTriggerThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerThreshold', Sort.desc);
    });
  }
}

extension AutomationRuleQuerySortThenBy
    on QueryBuilder<AutomationRule, AutomationRule, QSortThenBy> {
  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByAutoOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoOff', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByAutoOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoOff', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByCurrentTriggerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTriggerCount', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByCurrentTriggerCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTriggerCount', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByEndTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByEndTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByPlayAppAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playAppAlarm', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByPlayAppAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playAppAlarm', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByStartTimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCondition', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCondition', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerCountThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCountThreshold', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerCountThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerCountThreshold', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerEntityId', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerEntityId', Sort.desc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerThreshold', Sort.asc);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QAfterSortBy>
      thenByTriggerThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerThreshold', Sort.desc);
    });
  }
}

extension AutomationRuleQueryWhereDistinct
    on QueryBuilder<AutomationRule, AutomationRule, QDistinct> {
  QueryBuilder<AutomationRule, AutomationRule, QDistinct> distinctByAutoOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoOff');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByCurrentTriggerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTriggerCount');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByEndTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTimeMinutes');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByPlayAppAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playAppAlarm');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByStartTimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTimeMinutes');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByTriggerCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerCondition');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByTriggerCountThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerCountThreshold');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByTriggerEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerEntityId');
    });
  }

  QueryBuilder<AutomationRule, AutomationRule, QDistinct>
      distinctByTriggerThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerThreshold');
    });
  }
}

extension AutomationRuleQueryProperty
    on QueryBuilder<AutomationRule, AutomationRule, QQueryProperty> {
  QueryBuilder<AutomationRule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AutomationRule, List<AutomationAction>, QQueryOperations>
      actionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actions');
    });
  }

  QueryBuilder<AutomationRule, bool, QQueryOperations> autoOffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoOff');
    });
  }

  QueryBuilder<AutomationRule, int, QQueryOperations>
      currentTriggerCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTriggerCount');
    });
  }

  QueryBuilder<AutomationRule, int?, QQueryOperations>
      endTimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTimeMinutes');
    });
  }

  QueryBuilder<AutomationRule, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<AutomationRule, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AutomationRule, bool, QQueryOperations> playAppAlarmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playAppAlarm');
    });
  }

  QueryBuilder<AutomationRule, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<AutomationRule, int?, QQueryOperations>
      startTimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTimeMinutes');
    });
  }

  QueryBuilder<AutomationRule, int, QQueryOperations>
      triggerConditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerCondition');
    });
  }

  QueryBuilder<AutomationRule, int, QQueryOperations>
      triggerCountThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerCountThreshold');
    });
  }

  QueryBuilder<AutomationRule, int, QQueryOperations>
      triggerEntityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerEntityId');
    });
  }

  QueryBuilder<AutomationRule, double?, QQueryOperations>
      triggerThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerThreshold');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AutomationActionSchema = Schema(
  name: r'AutomationAction',
  id: 6897842173651759503,
  properties: {
    r'actionEntityId': PropertySchema(
      id: 0,
      name: r'actionEntityId',
      type: IsarType.long,
    ),
    r'actionValue': PropertySchema(
      id: 1,
      name: r'actionValue',
      type: IsarType.long,
    ),
    r'delaySeconds': PropertySchema(
      id: 2,
      name: r'delaySeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _automationActionEstimateSize,
  serialize: _automationActionSerialize,
  deserialize: _automationActionDeserialize,
  deserializeProp: _automationActionDeserializeProp,
);

int _automationActionEstimateSize(
  AutomationAction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _automationActionSerialize(
  AutomationAction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actionEntityId);
  writer.writeLong(offsets[1], object.actionValue);
  writer.writeLong(offsets[2], object.delaySeconds);
}

AutomationAction _automationActionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutomationAction();
  object.actionEntityId = reader.readLongOrNull(offsets[0]);
  object.actionValue = reader.readLongOrNull(offsets[1]);
  object.delaySeconds = reader.readLong(offsets[2]);
  return object;
}

P _automationActionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AutomationActionQueryFilter
    on QueryBuilder<AutomationAction, AutomationAction, QFilterCondition> {
  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionEntityId',
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionEntityId',
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionEntityId',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionEntityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionEntityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionValue',
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionValue',
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      actionValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      delaySecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      delaySecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      delaySecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationAction, AutomationAction, QAfterFilterCondition>
      delaySecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delaySeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AutomationActionQueryObject
    on QueryBuilder<AutomationAction, AutomationAction, QFilterCondition> {}
