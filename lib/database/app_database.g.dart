// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DrinkTypesTable extends DrinkTypes
    with TableInfo<$DrinkTypesTable, DrinkTypesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrinkTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hydrationCoefficientMeta =
      const VerificationMeta('hydrationCoefficient');
  @override
  late final GeneratedColumn<double> hydrationCoefficient =
      GeneratedColumn<double>(
        'hydration_coefficient',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hydrationCoefficient,
    iconName,
    colorHex,
    isCustom,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drink_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrinkTypesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hydration_coefficient')) {
      context.handle(
        _hydrationCoefficientMeta,
        hydrationCoefficient.isAcceptableOrUnknown(
          data['hydration_coefficient']!,
          _hydrationCoefficientMeta,
        ),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrinkTypesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrinkTypesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hydrationCoefficient: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hydration_coefficient'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DrinkTypesTable createAlias(String alias) {
    return $DrinkTypesTable(attachedDatabase, alias);
  }
}

class DrinkTypesData extends DataClass implements Insertable<DrinkTypesData> {
  final int id;
  final String name;
  final double hydrationCoefficient;
  final String iconName;
  final String colorHex;
  final bool isCustom;
  final int sortOrder;
  const DrinkTypesData({
    required this.id,
    required this.name,
    required this.hydrationCoefficient,
    required this.iconName,
    required this.colorHex,
    required this.isCustom,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['hydration_coefficient'] = Variable<double>(hydrationCoefficient);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_custom'] = Variable<bool>(isCustom);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DrinkTypesCompanion toCompanion(bool nullToAbsent) {
    return DrinkTypesCompanion(
      id: Value(id),
      name: Value(name),
      hydrationCoefficient: Value(hydrationCoefficient),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      isCustom: Value(isCustom),
      sortOrder: Value(sortOrder),
    );
  }

  factory DrinkTypesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrinkTypesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hydrationCoefficient: serializer.fromJson<double>(
        json['hydrationCoefficient'],
      ),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hydrationCoefficient': serializer.toJson<double>(hydrationCoefficient),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'isCustom': serializer.toJson<bool>(isCustom),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DrinkTypesData copyWith({
    int? id,
    String? name,
    double? hydrationCoefficient,
    String? iconName,
    String? colorHex,
    bool? isCustom,
    int? sortOrder,
  }) => DrinkTypesData(
    id: id ?? this.id,
    name: name ?? this.name,
    hydrationCoefficient: hydrationCoefficient ?? this.hydrationCoefficient,
    iconName: iconName ?? this.iconName,
    colorHex: colorHex ?? this.colorHex,
    isCustom: isCustom ?? this.isCustom,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DrinkTypesData copyWithCompanion(DrinkTypesCompanion data) {
    return DrinkTypesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hydrationCoefficient: data.hydrationCoefficient.present
          ? data.hydrationCoefficient.value
          : this.hydrationCoefficient,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrinkTypesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hydrationCoefficient: $hydrationCoefficient, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    hydrationCoefficient,
    iconName,
    colorHex,
    isCustom,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrinkTypesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.hydrationCoefficient == this.hydrationCoefficient &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.isCustom == this.isCustom &&
          other.sortOrder == this.sortOrder);
}

class DrinkTypesCompanion extends UpdateCompanion<DrinkTypesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> hydrationCoefficient;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<bool> isCustom;
  final Value<int> sortOrder;
  const DrinkTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hydrationCoefficient = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  DrinkTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.hydrationCoefficient = const Value.absent(),
    required String iconName,
    required String colorHex,
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       iconName = Value(iconName),
       colorHex = Value(colorHex);
  static Insertable<DrinkTypesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? hydrationCoefficient,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<bool>? isCustom,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hydrationCoefficient != null)
        'hydration_coefficient': hydrationCoefficient,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (isCustom != null) 'is_custom': isCustom,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  DrinkTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? hydrationCoefficient,
    Value<String>? iconName,
    Value<String>? colorHex,
    Value<bool>? isCustom,
    Value<int>? sortOrder,
  }) {
    return DrinkTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hydrationCoefficient: hydrationCoefficient ?? this.hydrationCoefficient,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isCustom: isCustom ?? this.isCustom,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hydrationCoefficient.present) {
      map['hydration_coefficient'] = Variable<double>(
        hydrationCoefficient.value,
      );
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrinkTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hydrationCoefficient: $hydrationCoefficient, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<double> amountMl = GeneratedColumn<double>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drinkTypeIdMeta = const VerificationMeta(
    'drinkTypeId',
  );
  @override
  late final GeneratedColumn<int> drinkTypeId = GeneratedColumn<int>(
    'drink_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES drink_types (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loggedAt,
    amountMl,
    drinkTypeId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLogsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('drink_type_id')) {
      context.handle(
        _drinkTypeIdMeta,
        drinkTypeId.isAcceptableOrUnknown(
          data['drink_type_id']!,
          _drinkTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_drinkTypeIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLogsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_ml'],
      )!,
      drinkTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drink_type_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLogsData extends DataClass implements Insertable<WaterLogsData> {
  final int id;
  final DateTime loggedAt;
  final double amountMl;
  final int drinkTypeId;
  final String? note;
  const WaterLogsData({
    required this.id,
    required this.loggedAt,
    required this.amountMl,
    required this.drinkTypeId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['amount_ml'] = Variable<double>(amountMl);
    map['drink_type_id'] = Variable<int>(drinkTypeId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      amountMl: Value(amountMl),
      drinkTypeId: Value(drinkTypeId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WaterLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLogsData(
      id: serializer.fromJson<int>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      amountMl: serializer.fromJson<double>(json['amountMl']),
      drinkTypeId: serializer.fromJson<int>(json['drinkTypeId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'amountMl': serializer.toJson<double>(amountMl),
      'drinkTypeId': serializer.toJson<int>(drinkTypeId),
      'note': serializer.toJson<String?>(note),
    };
  }

  WaterLogsData copyWith({
    int? id,
    DateTime? loggedAt,
    double? amountMl,
    int? drinkTypeId,
    Value<String?> note = const Value.absent(),
  }) => WaterLogsData(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    amountMl: amountMl ?? this.amountMl,
    drinkTypeId: drinkTypeId ?? this.drinkTypeId,
    note: note.present ? note.value : this.note,
  );
  WaterLogsData copyWithCompanion(WaterLogsCompanion data) {
    return WaterLogsData(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      drinkTypeId: data.drinkTypeId.present
          ? data.drinkTypeId.value
          : this.drinkTypeId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsData(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('amountMl: $amountMl, ')
          ..write('drinkTypeId: $drinkTypeId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loggedAt, amountMl, drinkTypeId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLogsData &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.amountMl == this.amountMl &&
          other.drinkTypeId == this.drinkTypeId &&
          other.note == this.note);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLogsData> {
  final Value<int> id;
  final Value<DateTime> loggedAt;
  final Value<double> amountMl;
  final Value<int> drinkTypeId;
  final Value<String?> note;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.drinkTypeId = const Value.absent(),
    this.note = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime loggedAt,
    required double amountMl,
    required int drinkTypeId,
    this.note = const Value.absent(),
  }) : loggedAt = Value(loggedAt),
       amountMl = Value(amountMl),
       drinkTypeId = Value(drinkTypeId);
  static Insertable<WaterLogsData> custom({
    Expression<int>? id,
    Expression<DateTime>? loggedAt,
    Expression<double>? amountMl,
    Expression<int>? drinkTypeId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (amountMl != null) 'amount_ml': amountMl,
      if (drinkTypeId != null) 'drink_type_id': drinkTypeId,
      if (note != null) 'note': note,
    });
  }

  WaterLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? loggedAt,
    Value<double>? amountMl,
    Value<int>? drinkTypeId,
    Value<String?>? note,
  }) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      amountMl: amountMl ?? this.amountMl,
      drinkTypeId: drinkTypeId ?? this.drinkTypeId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<double>(amountMl.value);
    }
    if (drinkTypeId.present) {
      map['drink_type_id'] = Variable<int>(drinkTypeId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('amountMl: $amountMl, ')
          ..write('drinkTypeId: $drinkTypeId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<int> activityLevel = GeneratedColumn<int>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyGoalMlMeta = const VerificationMeta(
    'dailyGoalMl',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMl = GeneratedColumn<int>(
    'daily_goal_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ml'),
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('male'),
  );
  static const VerificationMeta _isPregnantMeta = const VerificationMeta(
    'isPregnant',
  );
  @override
  late final GeneratedColumn<bool> isPregnant = GeneratedColumn<bool>(
    'is_pregnant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pregnant" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _climateTypeMeta = const VerificationMeta(
    'climateType',
  );
  @override
  late final GeneratedColumn<String> climateType = GeneratedColumn<String>(
    'climate_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('moderate'),
  );
  static const VerificationMeta _wakeHourMeta = const VerificationMeta(
    'wakeHour',
  );
  @override
  late final GeneratedColumn<int> wakeHour = GeneratedColumn<int>(
    'wake_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _sleepHourMeta = const VerificationMeta(
    'sleepHour',
  );
  @override
  late final GeneratedColumn<int> sleepHour = GeneratedColumn<int>(
    'sleep_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(23),
  );
  static const VerificationMeta _wakeMinuteMeta = const VerificationMeta(
    'wakeMinute',
  );
  @override
  late final GeneratedColumn<int> wakeMinute = GeneratedColumn<int>(
    'wake_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sleepMinuteMeta = const VerificationMeta(
    'sleepMinute',
  );
  @override
  late final GeneratedColumn<int> sleepMinute = GeneratedColumn<int>(
    'sleep_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reminderIntervalMinutesMeta =
      const VerificationMeta('reminderIntervalMinutes');
  @override
  late final GeneratedColumn<int> reminderIntervalMinutes =
      GeneratedColumn<int>(
        'reminder_interval_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(90),
      );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    weightKg,
    activityLevel,
    dailyGoalMl,
    unit,
    weightUnit,
    gender,
    isPregnant,
    climateType,
    wakeHour,
    sleepHour,
    wakeMinute,
    sleepMinute,
    reminderIntervalMinutes,
    notificationsEnabled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('daily_goal_ml')) {
      context.handle(
        _dailyGoalMlMeta,
        dailyGoalMl.isAcceptableOrUnknown(
          data['daily_goal_ml']!,
          _dailyGoalMlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyGoalMlMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('is_pregnant')) {
      context.handle(
        _isPregnantMeta,
        isPregnant.isAcceptableOrUnknown(data['is_pregnant']!, _isPregnantMeta),
      );
    }
    if (data.containsKey('climate_type')) {
      context.handle(
        _climateTypeMeta,
        climateType.isAcceptableOrUnknown(
          data['climate_type']!,
          _climateTypeMeta,
        ),
      );
    }
    if (data.containsKey('wake_hour')) {
      context.handle(
        _wakeHourMeta,
        wakeHour.isAcceptableOrUnknown(data['wake_hour']!, _wakeHourMeta),
      );
    }
    if (data.containsKey('sleep_hour')) {
      context.handle(
        _sleepHourMeta,
        sleepHour.isAcceptableOrUnknown(data['sleep_hour']!, _sleepHourMeta),
      );
    }
    if (data.containsKey('wake_minute')) {
      context.handle(
        _wakeMinuteMeta,
        wakeMinute.isAcceptableOrUnknown(data['wake_minute']!, _wakeMinuteMeta),
      );
    }
    if (data.containsKey('sleep_minute')) {
      context.handle(
        _sleepMinuteMeta,
        sleepMinute.isAcceptableOrUnknown(
          data['sleep_minute']!,
          _sleepMinuteMeta,
        ),
      );
    }
    if (data.containsKey('reminder_interval_minutes')) {
      context.handle(
        _reminderIntervalMinutesMeta,
        reminderIntervalMinutes.isAcceptableOrUnknown(
          data['reminder_interval_minutes']!,
          _reminderIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_level'],
      )!,
      dailyGoalMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_ml'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      isPregnant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pregnant'],
      )!,
      climateType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}climate_type'],
      )!,
      wakeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_hour'],
      )!,
      sleepHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_hour'],
      )!,
      wakeMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_minute'],
      )!,
      sleepMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_minute'],
      )!,
      reminderIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_interval_minutes'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final String name;
  final double weightKg;
  final int activityLevel;
  final int dailyGoalMl;
  final String unit;
  final String weightUnit;
  final String gender;
  final bool isPregnant;
  final String climateType;
  final int wakeHour;
  final int sleepHour;
  final int wakeMinute;
  final int sleepMinute;
  final int reminderIntervalMinutes;
  final bool notificationsEnabled;
  final DateTime createdAt;
  const UserProfileData({
    required this.id,
    required this.name,
    required this.weightKg,
    required this.activityLevel,
    required this.dailyGoalMl,
    required this.unit,
    required this.weightUnit,
    required this.gender,
    required this.isPregnant,
    required this.climateType,
    required this.wakeHour,
    required this.sleepHour,
    required this.wakeMinute,
    required this.sleepMinute,
    required this.reminderIntervalMinutes,
    required this.notificationsEnabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['weight_kg'] = Variable<double>(weightKg);
    map['activity_level'] = Variable<int>(activityLevel);
    map['daily_goal_ml'] = Variable<int>(dailyGoalMl);
    map['unit'] = Variable<String>(unit);
    map['weight_unit'] = Variable<String>(weightUnit);
    map['gender'] = Variable<String>(gender);
    map['is_pregnant'] = Variable<bool>(isPregnant);
    map['climate_type'] = Variable<String>(climateType);
    map['wake_hour'] = Variable<int>(wakeHour);
    map['sleep_hour'] = Variable<int>(sleepHour);
    map['wake_minute'] = Variable<int>(wakeMinute);
    map['sleep_minute'] = Variable<int>(sleepMinute);
    map['reminder_interval_minutes'] = Variable<int>(reminderIntervalMinutes);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      name: Value(name),
      weightKg: Value(weightKg),
      activityLevel: Value(activityLevel),
      dailyGoalMl: Value(dailyGoalMl),
      unit: Value(unit),
      weightUnit: Value(weightUnit),
      gender: Value(gender),
      isPregnant: Value(isPregnant),
      climateType: Value(climateType),
      wakeHour: Value(wakeHour),
      sleepHour: Value(sleepHour),
      wakeMinute: Value(wakeMinute),
      sleepMinute: Value(sleepMinute),
      reminderIntervalMinutes: Value(reminderIntervalMinutes),
      notificationsEnabled: Value(notificationsEnabled),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      activityLevel: serializer.fromJson<int>(json['activityLevel']),
      dailyGoalMl: serializer.fromJson<int>(json['dailyGoalMl']),
      unit: serializer.fromJson<String>(json['unit']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
      gender: serializer.fromJson<String>(json['gender']),
      isPregnant: serializer.fromJson<bool>(json['isPregnant']),
      climateType: serializer.fromJson<String>(json['climateType']),
      wakeHour: serializer.fromJson<int>(json['wakeHour']),
      sleepHour: serializer.fromJson<int>(json['sleepHour']),
      wakeMinute: serializer.fromJson<int>(json['wakeMinute']),
      sleepMinute: serializer.fromJson<int>(json['sleepMinute']),
      reminderIntervalMinutes: serializer.fromJson<int>(
        json['reminderIntervalMinutes'],
      ),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'weightKg': serializer.toJson<double>(weightKg),
      'activityLevel': serializer.toJson<int>(activityLevel),
      'dailyGoalMl': serializer.toJson<int>(dailyGoalMl),
      'unit': serializer.toJson<String>(unit),
      'weightUnit': serializer.toJson<String>(weightUnit),
      'gender': serializer.toJson<String>(gender),
      'isPregnant': serializer.toJson<bool>(isPregnant),
      'climateType': serializer.toJson<String>(climateType),
      'wakeHour': serializer.toJson<int>(wakeHour),
      'sleepHour': serializer.toJson<int>(sleepHour),
      'wakeMinute': serializer.toJson<int>(wakeMinute),
      'sleepMinute': serializer.toJson<int>(sleepMinute),
      'reminderIntervalMinutes': serializer.toJson<int>(
        reminderIntervalMinutes,
      ),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfileData copyWith({
    int? id,
    String? name,
    double? weightKg,
    int? activityLevel,
    int? dailyGoalMl,
    String? unit,
    String? weightUnit,
    String? gender,
    bool? isPregnant,
    String? climateType,
    int? wakeHour,
    int? sleepHour,
    int? wakeMinute,
    int? sleepMinute,
    int? reminderIntervalMinutes,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) => UserProfileData(
    id: id ?? this.id,
    name: name ?? this.name,
    weightKg: weightKg ?? this.weightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
    unit: unit ?? this.unit,
    weightUnit: weightUnit ?? this.weightUnit,
    gender: gender ?? this.gender,
    isPregnant: isPregnant ?? this.isPregnant,
    climateType: climateType ?? this.climateType,
    wakeHour: wakeHour ?? this.wakeHour,
    sleepHour: sleepHour ?? this.sleepHour,
    wakeMinute: wakeMinute ?? this.wakeMinute,
    sleepMinute: sleepMinute ?? this.sleepMinute,
    reminderIntervalMinutes:
        reminderIntervalMinutes ?? this.reminderIntervalMinutes,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      dailyGoalMl: data.dailyGoalMl.present
          ? data.dailyGoalMl.value
          : this.dailyGoalMl,
      unit: data.unit.present ? data.unit.value : this.unit,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      gender: data.gender.present ? data.gender.value : this.gender,
      isPregnant: data.isPregnant.present
          ? data.isPregnant.value
          : this.isPregnant,
      climateType: data.climateType.present
          ? data.climateType.value
          : this.climateType,
      wakeHour: data.wakeHour.present ? data.wakeHour.value : this.wakeHour,
      sleepHour: data.sleepHour.present ? data.sleepHour.value : this.sleepHour,
      wakeMinute: data.wakeMinute.present
          ? data.wakeMinute.value
          : this.wakeMinute,
      sleepMinute: data.sleepMinute.present
          ? data.sleepMinute.value
          : this.sleepMinute,
      reminderIntervalMinutes: data.reminderIntervalMinutes.present
          ? data.reminderIntervalMinutes.value
          : this.reminderIntervalMinutes,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dailyGoalMl: $dailyGoalMl, ')
          ..write('unit: $unit, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('gender: $gender, ')
          ..write('isPregnant: $isPregnant, ')
          ..write('climateType: $climateType, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('sleepMinute: $sleepMinute, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    weightKg,
    activityLevel,
    dailyGoalMl,
    unit,
    weightUnit,
    gender,
    isPregnant,
    climateType,
    wakeHour,
    sleepHour,
    wakeMinute,
    sleepMinute,
    reminderIntervalMinutes,
    notificationsEnabled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.name == this.name &&
          other.weightKg == this.weightKg &&
          other.activityLevel == this.activityLevel &&
          other.dailyGoalMl == this.dailyGoalMl &&
          other.unit == this.unit &&
          other.weightUnit == this.weightUnit &&
          other.gender == this.gender &&
          other.isPregnant == this.isPregnant &&
          other.climateType == this.climateType &&
          other.wakeHour == this.wakeHour &&
          other.sleepHour == this.sleepHour &&
          other.wakeMinute == this.wakeMinute &&
          other.sleepMinute == this.sleepMinute &&
          other.reminderIntervalMinutes == this.reminderIntervalMinutes &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.createdAt == this.createdAt);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> weightKg;
  final Value<int> activityLevel;
  final Value<int> dailyGoalMl;
  final Value<String> unit;
  final Value<String> weightUnit;
  final Value<String> gender;
  final Value<bool> isPregnant;
  final Value<String> climateType;
  final Value<int> wakeHour;
  final Value<int> sleepHour;
  final Value<int> wakeMinute;
  final Value<int> sleepMinute;
  final Value<int> reminderIntervalMinutes;
  final Value<bool> notificationsEnabled;
  final Value<DateTime> createdAt;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.dailyGoalMl = const Value.absent(),
    this.unit = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.gender = const Value.absent(),
    this.isPregnant = const Value.absent(),
    this.climateType = const Value.absent(),
    this.wakeHour = const Value.absent(),
    this.sleepHour = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.sleepMinute = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double weightKg,
    required int activityLevel,
    required int dailyGoalMl,
    this.unit = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.gender = const Value.absent(),
    this.isPregnant = const Value.absent(),
    this.climateType = const Value.absent(),
    this.wakeHour = const Value.absent(),
    this.sleepHour = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.sleepMinute = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       weightKg = Value(weightKg),
       activityLevel = Value(activityLevel),
       dailyGoalMl = Value(dailyGoalMl);
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? weightKg,
    Expression<int>? activityLevel,
    Expression<int>? dailyGoalMl,
    Expression<String>? unit,
    Expression<String>? weightUnit,
    Expression<String>? gender,
    Expression<bool>? isPregnant,
    Expression<String>? climateType,
    Expression<int>? wakeHour,
    Expression<int>? sleepHour,
    Expression<int>? wakeMinute,
    Expression<int>? sleepMinute,
    Expression<int>? reminderIntervalMinutes,
    Expression<bool>? notificationsEnabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (weightKg != null) 'weight_kg': weightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (dailyGoalMl != null) 'daily_goal_ml': dailyGoalMl,
      if (unit != null) 'unit': unit,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (gender != null) 'gender': gender,
      if (isPregnant != null) 'is_pregnant': isPregnant,
      if (climateType != null) 'climate_type': climateType,
      if (wakeHour != null) 'wake_hour': wakeHour,
      if (sleepHour != null) 'sleep_hour': sleepHour,
      if (wakeMinute != null) 'wake_minute': wakeMinute,
      if (sleepMinute != null) 'sleep_minute': sleepMinute,
      if (reminderIntervalMinutes != null)
        'reminder_interval_minutes': reminderIntervalMinutes,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? weightKg,
    Value<int>? activityLevel,
    Value<int>? dailyGoalMl,
    Value<String>? unit,
    Value<String>? weightUnit,
    Value<String>? gender,
    Value<bool>? isPregnant,
    Value<String>? climateType,
    Value<int>? wakeHour,
    Value<int>? sleepHour,
    Value<int>? wakeMinute,
    Value<int>? sleepMinute,
    Value<int>? reminderIntervalMinutes,
    Value<bool>? notificationsEnabled,
    Value<DateTime>? createdAt,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      unit: unit ?? this.unit,
      weightUnit: weightUnit ?? this.weightUnit,
      gender: gender ?? this.gender,
      isPregnant: isPregnant ?? this.isPregnant,
      climateType: climateType ?? this.climateType,
      wakeHour: wakeHour ?? this.wakeHour,
      sleepHour: sleepHour ?? this.sleepHour,
      wakeMinute: wakeMinute ?? this.wakeMinute,
      sleepMinute: sleepMinute ?? this.sleepMinute,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<int>(activityLevel.value);
    }
    if (dailyGoalMl.present) {
      map['daily_goal_ml'] = Variable<int>(dailyGoalMl.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (isPregnant.present) {
      map['is_pregnant'] = Variable<bool>(isPregnant.value);
    }
    if (climateType.present) {
      map['climate_type'] = Variable<String>(climateType.value);
    }
    if (wakeHour.present) {
      map['wake_hour'] = Variable<int>(wakeHour.value);
    }
    if (sleepHour.present) {
      map['sleep_hour'] = Variable<int>(sleepHour.value);
    }
    if (wakeMinute.present) {
      map['wake_minute'] = Variable<int>(wakeMinute.value);
    }
    if (sleepMinute.present) {
      map['sleep_minute'] = Variable<int>(sleepMinute.value);
    }
    if (reminderIntervalMinutes.present) {
      map['reminder_interval_minutes'] = Variable<int>(
        reminderIntervalMinutes.value,
      );
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dailyGoalMl: $dailyGoalMl, ')
          ..write('unit: $unit, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('gender: $gender, ')
          ..write('isPregnant: $isPregnant, ')
          ..write('climateType: $climateType, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('sleepMinute: $sleepMinute, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DrinkTypesTable drinkTypes = $DrinkTypesTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final UserProfileDao userProfileDao = UserProfileDao(
    this as AppDatabase,
  );
  late final DrinkTypesDao drinkTypesDao = DrinkTypesDao(this as AppDatabase);
  late final WaterLogsDao waterLogsDao = WaterLogsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    drinkTypes,
    waterLogs,
    userProfile,
  ];
}

typedef $$DrinkTypesTableCreateCompanionBuilder =
    DrinkTypesCompanion Function({
      Value<int> id,
      required String name,
      Value<double> hydrationCoefficient,
      required String iconName,
      required String colorHex,
      Value<bool> isCustom,
      Value<int> sortOrder,
    });
typedef $$DrinkTypesTableUpdateCompanionBuilder =
    DrinkTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> hydrationCoefficient,
      Value<String> iconName,
      Value<String> colorHex,
      Value<bool> isCustom,
      Value<int> sortOrder,
    });

final class $$DrinkTypesTableReferences
    extends BaseReferences<_$AppDatabase, $DrinkTypesTable, DrinkTypesData> {
  $$DrinkTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WaterLogsTable, List<WaterLogsData>>
  _waterLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.waterLogs,
    aliasName: $_aliasNameGenerator(db.drinkTypes.id, db.waterLogs.drinkTypeId),
  );

  $$WaterLogsTableProcessedTableManager get waterLogsRefs {
    final manager = $$WaterLogsTableTableManager(
      $_db,
      $_db.waterLogs,
    ).filter((f) => f.drinkTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_waterLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DrinkTypesTableFilterComposer
    extends Composer<_$AppDatabase, $DrinkTypesTable> {
  $$DrinkTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hydrationCoefficient => $composableBuilder(
    column: $table.hydrationCoefficient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> waterLogsRefs(
    Expression<bool> Function($$WaterLogsTableFilterComposer f) f,
  ) {
    final $$WaterLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterLogs,
      getReferencedColumn: (t) => t.drinkTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterLogsTableFilterComposer(
            $db: $db,
            $table: $db.waterLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DrinkTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $DrinkTypesTable> {
  $$DrinkTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hydrationCoefficient => $composableBuilder(
    column: $table.hydrationCoefficient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrinkTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrinkTypesTable> {
  $$DrinkTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get hydrationCoefficient => $composableBuilder(
    column: $table.hydrationCoefficient,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> waterLogsRefs<T extends Object>(
    Expression<T> Function($$WaterLogsTableAnnotationComposer a) f,
  ) {
    final $$WaterLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterLogs,
      getReferencedColumn: (t) => t.drinkTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.waterLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DrinkTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrinkTypesTable,
          DrinkTypesData,
          $$DrinkTypesTableFilterComposer,
          $$DrinkTypesTableOrderingComposer,
          $$DrinkTypesTableAnnotationComposer,
          $$DrinkTypesTableCreateCompanionBuilder,
          $$DrinkTypesTableUpdateCompanionBuilder,
          (DrinkTypesData, $$DrinkTypesTableReferences),
          DrinkTypesData,
          PrefetchHooks Function({bool waterLogsRefs})
        > {
  $$DrinkTypesTableTableManager(_$AppDatabase db, $DrinkTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrinkTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrinkTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrinkTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> hydrationCoefficient = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => DrinkTypesCompanion(
                id: id,
                name: name,
                hydrationCoefficient: hydrationCoefficient,
                iconName: iconName,
                colorHex: colorHex,
                isCustom: isCustom,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<double> hydrationCoefficient = const Value.absent(),
                required String iconName,
                required String colorHex,
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => DrinkTypesCompanion.insert(
                id: id,
                name: name,
                hydrationCoefficient: hydrationCoefficient,
                iconName: iconName,
                colorHex: colorHex,
                isCustom: isCustom,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DrinkTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({waterLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (waterLogsRefs) db.waterLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (waterLogsRefs)
                    await $_getPrefetchedData<
                      DrinkTypesData,
                      $DrinkTypesTable,
                      WaterLogsData
                    >(
                      currentTable: table,
                      referencedTable: $$DrinkTypesTableReferences
                          ._waterLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DrinkTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).waterLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.drinkTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DrinkTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrinkTypesTable,
      DrinkTypesData,
      $$DrinkTypesTableFilterComposer,
      $$DrinkTypesTableOrderingComposer,
      $$DrinkTypesTableAnnotationComposer,
      $$DrinkTypesTableCreateCompanionBuilder,
      $$DrinkTypesTableUpdateCompanionBuilder,
      (DrinkTypesData, $$DrinkTypesTableReferences),
      DrinkTypesData,
      PrefetchHooks Function({bool waterLogsRefs})
    >;
typedef $$WaterLogsTableCreateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      required DateTime loggedAt,
      required double amountMl,
      required int drinkTypeId,
      Value<String?> note,
    });
typedef $$WaterLogsTableUpdateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      Value<DateTime> loggedAt,
      Value<double> amountMl,
      Value<int> drinkTypeId,
      Value<String?> note,
    });

final class $$WaterLogsTableReferences
    extends BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLogsData> {
  $$WaterLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DrinkTypesTable _drinkTypeIdTable(_$AppDatabase db) =>
      db.drinkTypes.createAlias(
        $_aliasNameGenerator(db.waterLogs.drinkTypeId, db.drinkTypes.id),
      );

  $$DrinkTypesTableProcessedTableManager get drinkTypeId {
    final $_column = $_itemColumn<int>('drink_type_id')!;

    final manager = $$DrinkTypesTableTableManager(
      $_db,
      $_db.drinkTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_drinkTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$DrinkTypesTableFilterComposer get drinkTypeId {
    final $$DrinkTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drinkTypeId,
      referencedTable: $db.drinkTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrinkTypesTableFilterComposer(
            $db: $db,
            $table: $db.drinkTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$DrinkTypesTableOrderingComposer get drinkTypeId {
    final $$DrinkTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drinkTypeId,
      referencedTable: $db.drinkTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrinkTypesTableOrderingComposer(
            $db: $db,
            $table: $db.drinkTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<double> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$DrinkTypesTableAnnotationComposer get drinkTypeId {
    final $$DrinkTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drinkTypeId,
      referencedTable: $db.drinkTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrinkTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.drinkTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTable,
          WaterLogsData,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (WaterLogsData, $$WaterLogsTableReferences),
          WaterLogsData,
          PrefetchHooks Function({bool drinkTypeId})
        > {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<double> amountMl = const Value.absent(),
                Value<int> drinkTypeId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WaterLogsCompanion(
                id: id,
                loggedAt: loggedAt,
                amountMl: amountMl,
                drinkTypeId: drinkTypeId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime loggedAt,
                required double amountMl,
                required int drinkTypeId,
                Value<String?> note = const Value.absent(),
              }) => WaterLogsCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                amountMl: amountMl,
                drinkTypeId: drinkTypeId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WaterLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({drinkTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (drinkTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.drinkTypeId,
                                referencedTable: $$WaterLogsTableReferences
                                    ._drinkTypeIdTable(db),
                                referencedColumn: $$WaterLogsTableReferences
                                    ._drinkTypeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTable,
      WaterLogsData,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (WaterLogsData, $$WaterLogsTableReferences),
      WaterLogsData,
      PrefetchHooks Function({bool drinkTypeId})
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      required String name,
      required double weightKg,
      required int activityLevel,
      required int dailyGoalMl,
      Value<String> unit,
      Value<String> weightUnit,
      Value<String> gender,
      Value<bool> isPregnant,
      Value<String> climateType,
      Value<int> wakeHour,
      Value<int> sleepHour,
      Value<int> wakeMinute,
      Value<int> sleepMinute,
      Value<int> reminderIntervalMinutes,
      Value<bool> notificationsEnabled,
      Value<DateTime> createdAt,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> weightKg,
      Value<int> activityLevel,
      Value<int> dailyGoalMl,
      Value<String> unit,
      Value<String> weightUnit,
      Value<String> gender,
      Value<bool> isPregnant,
      Value<String> climateType,
      Value<int> wakeHour,
      Value<int> sleepHour,
      Value<int> wakeMinute,
      Value<int> sleepMinute,
      Value<int> reminderIntervalMinutes,
      Value<bool> notificationsEnabled,
      Value<DateTime> createdAt,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get climateType => $composableBuilder(
    column: $table.climateType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepHour => $composableBuilder(
    column: $table.sleepHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get climateType => $composableBuilder(
    column: $table.climateType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepHour => $composableBuilder(
    column: $table.sleepHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get climateType => $composableBuilder(
    column: $table.climateType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeHour =>
      $composableBuilder(column: $table.wakeHour, builder: (column) => column);

  GeneratedColumn<int> get sleepHour =>
      $composableBuilder(column: $table.sleepHour, builder: (column) => column);

  GeneratedColumn<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileData,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
          ),
          UserProfileData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> activityLevel = const Value.absent(),
                Value<int> dailyGoalMl = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<bool> isPregnant = const Value.absent(),
                Value<String> climateType = const Value.absent(),
                Value<int> wakeHour = const Value.absent(),
                Value<int> sleepHour = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<int> sleepMinute = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                name: name,
                weightKg: weightKg,
                activityLevel: activityLevel,
                dailyGoalMl: dailyGoalMl,
                unit: unit,
                weightUnit: weightUnit,
                gender: gender,
                isPregnant: isPregnant,
                climateType: climateType,
                wakeHour: wakeHour,
                sleepHour: sleepHour,
                wakeMinute: wakeMinute,
                sleepMinute: sleepMinute,
                reminderIntervalMinutes: reminderIntervalMinutes,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double weightKg,
                required int activityLevel,
                required int dailyGoalMl,
                Value<String> unit = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<bool> isPregnant = const Value.absent(),
                Value<String> climateType = const Value.absent(),
                Value<int> wakeHour = const Value.absent(),
                Value<int> sleepHour = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<int> sleepMinute = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                name: name,
                weightKg: weightKg,
                activityLevel: activityLevel,
                dailyGoalMl: dailyGoalMl,
                unit: unit,
                weightUnit: weightUnit,
                gender: gender,
                isPregnant: isPregnant,
                climateType: climateType,
                wakeHour: wakeHour,
                sleepHour: sleepHour,
                wakeMinute: wakeMinute,
                sleepMinute: sleepMinute,
                reminderIntervalMinutes: reminderIntervalMinutes,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileData,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
      ),
      UserProfileData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DrinkTypesTableTableManager get drinkTypes =>
      $$DrinkTypesTableTableManager(_db, _db.drinkTypes);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
}
