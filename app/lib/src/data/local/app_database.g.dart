// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RawNotificationsTable extends RawNotifications
    with TableInfo<$RawNotificationsTable, RawNotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAppMeta = const VerificationMeta(
    'sourceApp',
  );
  @override
  late final GeneratedColumn<String> sourceApp = GeneratedColumn<String>(
    'source_app',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceHashMeta = const VerificationMeta(
    'sourceHash',
  );
  @override
  late final GeneratedColumn<String> sourceHash = GeneratedColumn<String>(
    'source_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    sourceApp,
    sender,
    title,
    body,
    receivedAt,
    sourceHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawNotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_app')) {
      context.handle(
        _sourceAppMeta,
        sourceApp.isAcceptableOrUnknown(data['source_app']!, _sourceAppMeta),
      );
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawNotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawNotificationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceApp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_app'],
      ),
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RawNotificationsTable createAlias(String alias) {
    return $RawNotificationsTable(attachedDatabase, alias);
  }
}

class RawNotificationRow extends DataClass
    implements Insertable<RawNotificationRow> {
  final String id;
  final String sourceType;
  final String? sourceApp;
  final String? sender;
  final String? title;
  final String body;
  final DateTime receivedAt;
  final String sourceHash;
  final DateTime createdAt;
  const RawNotificationRow({
    required this.id,
    required this.sourceType,
    this.sourceApp,
    this.sender,
    this.title,
    required this.body,
    required this.receivedAt,
    required this.sourceHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceApp != null) {
      map['source_app'] = Variable<String>(sourceApp);
    }
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['source_hash'] = Variable<String>(sourceHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawNotificationsCompanion toCompanion(bool nullToAbsent) {
    return RawNotificationsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      sourceApp: sourceApp == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceApp),
      sender: sender == null && nullToAbsent
          ? const Value.absent()
          : Value(sender),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: Value(body),
      receivedAt: Value(receivedAt),
      sourceHash: Value(sourceHash),
      createdAt: Value(createdAt),
    );
  }

  factory RawNotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawNotificationRow(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceApp: serializer.fromJson<String?>(json['sourceApp']),
      sender: serializer.fromJson<String?>(json['sender']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceApp': serializer.toJson<String?>(sourceApp),
      'sender': serializer.toJson<String?>(sender),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawNotificationRow copyWith({
    String? id,
    String? sourceType,
    Value<String?> sourceApp = const Value.absent(),
    Value<String?> sender = const Value.absent(),
    Value<String?> title = const Value.absent(),
    String? body,
    DateTime? receivedAt,
    String? sourceHash,
    DateTime? createdAt,
  }) => RawNotificationRow(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    sourceApp: sourceApp.present ? sourceApp.value : this.sourceApp,
    sender: sender.present ? sender.value : this.sender,
    title: title.present ? title.value : this.title,
    body: body ?? this.body,
    receivedAt: receivedAt ?? this.receivedAt,
    sourceHash: sourceHash ?? this.sourceHash,
    createdAt: createdAt ?? this.createdAt,
  );
  RawNotificationRow copyWithCompanion(RawNotificationsCompanion data) {
    return RawNotificationRow(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceApp: data.sourceApp.present ? data.sourceApp.value : this.sourceApp,
      sender: data.sender.present ? data.sender.value : this.sender,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawNotificationRow(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('sender: $sender, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    sourceApp,
    sender,
    title,
    body,
    receivedAt,
    sourceHash,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawNotificationRow &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.sourceApp == this.sourceApp &&
          other.sender == this.sender &&
          other.title == this.title &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.sourceHash == this.sourceHash &&
          other.createdAt == this.createdAt);
}

class RawNotificationsCompanion extends UpdateCompanion<RawNotificationRow> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<String?> sourceApp;
  final Value<String?> sender;
  final Value<String?> title;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<String> sourceHash;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RawNotificationsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceApp = const Value.absent(),
    this.sender = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawNotificationsCompanion.insert({
    required String id,
    required String sourceType,
    this.sourceApp = const Value.absent(),
    this.sender = const Value.absent(),
    this.title = const Value.absent(),
    required String body,
    required DateTime receivedAt,
    required String sourceHash,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       body = Value(body),
       receivedAt = Value(receivedAt),
       sourceHash = Value(sourceHash),
       createdAt = Value(createdAt);
  static Insertable<RawNotificationRow> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<String>? sourceApp,
    Expression<String>? sender,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<String>? sourceHash,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceApp != null) 'source_app': sourceApp,
      if (sender != null) 'sender': sender,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<String?>? sourceApp,
    Value<String?>? sender,
    Value<String?>? title,
    Value<String>? body,
    Value<DateTime>? receivedAt,
    Value<String>? sourceHash,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RawNotificationsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      sourceApp: sourceApp ?? this.sourceApp,
      sender: sender ?? this.sender,
      title: title ?? this.title,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      sourceHash: sourceHash ?? this.sourceHash,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceApp.present) {
      map['source_app'] = Variable<String>(sourceApp.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceApp: $sourceApp, ')
          ..write('sender: $sender, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTransactionsTable extends ExpenseTransactions
    with TableInfo<$ExpenseTransactionsTable, ExpenseTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantNameMeta = const VerificationMeta(
    'merchantName',
  );
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
    'merchant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmationStatusMeta =
      const VerificationMeta('confirmationStatus');
  @override
  late final GeneratedColumn<String> confirmationStatus =
      GeneratedColumn<String>(
        'confirmation_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _confirmedByMeta = const VerificationMeta(
    'confirmedBy',
  );
  @override
  late final GeneratedColumn<String> confirmedBy = GeneratedColumn<String>(
    'confirmed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _candidateIdsJsonMeta = const VerificationMeta(
    'candidateIdsJson',
  );
  @override
  late final GeneratedColumn<String> candidateIdsJson = GeneratedColumn<String>(
    'candidate_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    merchantName,
    categoryId,
    spentAt,
    confirmationStatus,
    confirmedBy,
    candidateIdsJson,
    createdAt,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
        _merchantNameMeta,
        merchantName.isAcceptableOrUnknown(
          data['merchant_name']!,
          _merchantNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('confirmation_status')) {
      context.handle(
        _confirmationStatusMeta,
        confirmationStatus.isAcceptableOrUnknown(
          data['confirmation_status']!,
          _confirmationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmationStatusMeta);
    }
    if (data.containsKey('confirmed_by')) {
      context.handle(
        _confirmedByMeta,
        confirmedBy.isAcceptableOrUnknown(
          data['confirmed_by']!,
          _confirmedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedByMeta);
    }
    if (data.containsKey('candidate_ids_json')) {
      context.handle(
        _candidateIdsJsonMeta,
        candidateIdsJson.isAcceptableOrUnknown(
          data['candidate_ids_json']!,
          _candidateIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateIdsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      merchantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      spentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spent_at'],
      )!,
      confirmationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmation_status'],
      )!,
      confirmedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_by'],
      )!,
      candidateIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_ids_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ExpenseTransactionsTable createAlias(String alias) {
    return $ExpenseTransactionsTable(attachedDatabase, alias);
  }
}

class ExpenseTransactionRow extends DataClass
    implements Insertable<ExpenseTransactionRow> {
  final String id;
  final int amount;
  final String merchantName;
  final String? categoryId;
  final DateTime spentAt;
  final String confirmationStatus;
  final String confirmedBy;
  final String candidateIdsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const ExpenseTransactionRow({
    required this.id,
    required this.amount,
    required this.merchantName,
    this.categoryId,
    required this.spentAt,
    required this.confirmationStatus,
    required this.confirmedBy,
    required this.candidateIdsJson,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<int>(amount);
    map['merchant_name'] = Variable<String>(merchantName);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['spent_at'] = Variable<DateTime>(spentAt);
    map['confirmation_status'] = Variable<String>(confirmationStatus);
    map['confirmed_by'] = Variable<String>(confirmedBy);
    map['candidate_ids_json'] = Variable<String>(candidateIdsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ExpenseTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      merchantName: Value(merchantName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      spentAt: Value(spentAt),
      confirmationStatus: Value(confirmationStatus),
      confirmedBy: Value(confirmedBy),
      candidateIdsJson: Value(candidateIdsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory ExpenseTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      merchantName: serializer.fromJson<String>(json['merchantName']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      confirmationStatus: serializer.fromJson<String>(
        json['confirmationStatus'],
      ),
      confirmedBy: serializer.fromJson<String>(json['confirmedBy']),
      candidateIdsJson: serializer.fromJson<String>(json['candidateIdsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<int>(amount),
      'merchantName': serializer.toJson<String>(merchantName),
      'categoryId': serializer.toJson<String?>(categoryId),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'confirmationStatus': serializer.toJson<String>(confirmationStatus),
      'confirmedBy': serializer.toJson<String>(confirmedBy),
      'candidateIdsJson': serializer.toJson<String>(candidateIdsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  ExpenseTransactionRow copyWith({
    String? id,
    int? amount,
    String? merchantName,
    Value<String?> categoryId = const Value.absent(),
    DateTime? spentAt,
    String? confirmationStatus,
    String? confirmedBy,
    String? candidateIdsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) => ExpenseTransactionRow(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    merchantName: merchantName ?? this.merchantName,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    spentAt: spentAt ?? this.spentAt,
    confirmationStatus: confirmationStatus ?? this.confirmationStatus,
    confirmedBy: confirmedBy ?? this.confirmedBy,
    candidateIdsJson: candidateIdsJson ?? this.candidateIdsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ExpenseTransactionRow copyWithCompanion(ExpenseTransactionsCompanion data) {
    return ExpenseTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      confirmationStatus: data.confirmationStatus.present
          ? data.confirmationStatus.value
          : this.confirmationStatus,
      confirmedBy: data.confirmedBy.present
          ? data.confirmedBy.value
          : this.confirmedBy,
      candidateIdsJson: data.candidateIdsJson.present
          ? data.candidateIdsJson.value
          : this.candidateIdsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTransactionRow(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('merchantName: $merchantName, ')
          ..write('categoryId: $categoryId, ')
          ..write('spentAt: $spentAt, ')
          ..write('confirmationStatus: $confirmationStatus, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('candidateIdsJson: $candidateIdsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    merchantName,
    categoryId,
    spentAt,
    confirmationStatus,
    confirmedBy,
    candidateIdsJson,
    createdAt,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseTransactionRow &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.merchantName == this.merchantName &&
          other.categoryId == this.categoryId &&
          other.spentAt == this.spentAt &&
          other.confirmationStatus == this.confirmationStatus &&
          other.confirmedBy == this.confirmedBy &&
          other.candidateIdsJson == this.candidateIdsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class ExpenseTransactionsCompanion
    extends UpdateCompanion<ExpenseTransactionRow> {
  final Value<String> id;
  final Value<int> amount;
  final Value<String> merchantName;
  final Value<String?> categoryId;
  final Value<DateTime> spentAt;
  final Value<String> confirmationStatus;
  final Value<String> confirmedBy;
  final Value<String> candidateIdsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ExpenseTransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.confirmationStatus = const Value.absent(),
    this.confirmedBy = const Value.absent(),
    this.candidateIdsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseTransactionsCompanion.insert({
    required String id,
    required int amount,
    required String merchantName,
    this.categoryId = const Value.absent(),
    required DateTime spentAt,
    required String confirmationStatus,
    required String confirmedBy,
    required String candidateIdsJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       merchantName = Value(merchantName),
       spentAt = Value(spentAt),
       confirmationStatus = Value(confirmationStatus),
       confirmedBy = Value(confirmedBy),
       candidateIdsJson = Value(candidateIdsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus);
  static Insertable<ExpenseTransactionRow> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<String>? merchantName,
    Expression<String>? categoryId,
    Expression<DateTime>? spentAt,
    Expression<String>? confirmationStatus,
    Expression<String>? confirmedBy,
    Expression<String>? candidateIdsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (merchantName != null) 'merchant_name': merchantName,
      if (categoryId != null) 'category_id': categoryId,
      if (spentAt != null) 'spent_at': spentAt,
      if (confirmationStatus != null) 'confirmation_status': confirmationStatus,
      if (confirmedBy != null) 'confirmed_by': confirmedBy,
      if (candidateIdsJson != null) 'candidate_ids_json': candidateIdsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseTransactionsCompanion copyWith({
    Value<String>? id,
    Value<int>? amount,
    Value<String>? merchantName,
    Value<String?>? categoryId,
    Value<DateTime>? spentAt,
    Value<String>? confirmationStatus,
    Value<String>? confirmedBy,
    Value<String>? candidateIdsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return ExpenseTransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      merchantName: merchantName ?? this.merchantName,
      categoryId: categoryId ?? this.categoryId,
      spentAt: spentAt ?? this.spentAt,
      confirmationStatus: confirmationStatus ?? this.confirmationStatus,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      candidateIdsJson: candidateIdsJson ?? this.candidateIdsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (confirmationStatus.present) {
      map['confirmation_status'] = Variable<String>(confirmationStatus.value);
    }
    if (confirmedBy.present) {
      map['confirmed_by'] = Variable<String>(confirmedBy.value);
    }
    if (candidateIdsJson.present) {
      map['candidate_ids_json'] = Variable<String>(candidateIdsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('merchantName: $merchantName, ')
          ..write('categoryId: $categoryId, ')
          ..write('spentAt: $spentAt, ')
          ..write('confirmationStatus: $confirmationStatus, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('candidateIdsJson: $candidateIdsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionCandidatesTable extends TransactionCandidates
    with TableInfo<$TransactionCandidatesTable, TransactionCandidateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionCandidatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawNotificationIdMeta = const VerificationMeta(
    'rawNotificationId',
  );
  @override
  late final GeneratedColumn<String> rawNotificationId =
      GeneratedColumn<String>(
        'raw_notification_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantNameMeta = const VerificationMeta(
    'merchantName',
  );
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
    'merchant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodHintMeta = const VerificationMeta(
    'paymentMethodHint',
  );
  @override
  late final GeneratedColumn<String> paymentMethodHint =
      GeneratedColumn<String>(
        'payment_method_hint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parseConfidenceMeta = const VerificationMeta(
    'parseConfidence',
  );
  @override
  late final GeneratedColumn<double> parseConfidence = GeneratedColumn<double>(
    'parse_confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parseStatusMeta = const VerificationMeta(
    'parseStatus',
  );
  @override
  late final GeneratedColumn<String> parseStatus = GeneratedColumn<String>(
    'parse_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rawNotificationId,
    amount,
    merchantName,
    paymentMethodHint,
    occurredAt,
    sourceType,
    parseConfidence,
    parseStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionCandidateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_notification_id')) {
      context.handle(
        _rawNotificationIdMeta,
        rawNotificationId.isAcceptableOrUnknown(
          data['raw_notification_id']!,
          _rawNotificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawNotificationIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
        _merchantNameMeta,
        merchantName.isAcceptableOrUnknown(
          data['merchant_name']!,
          _merchantNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantNameMeta);
    }
    if (data.containsKey('payment_method_hint')) {
      context.handle(
        _paymentMethodHintMeta,
        paymentMethodHint.isAcceptableOrUnknown(
          data['payment_method_hint']!,
          _paymentMethodHintMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('parse_confidence')) {
      context.handle(
        _parseConfidenceMeta,
        parseConfidence.isAcceptableOrUnknown(
          data['parse_confidence']!,
          _parseConfidenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parseConfidenceMeta);
    }
    if (data.containsKey('parse_status')) {
      context.handle(
        _parseStatusMeta,
        parseStatus.isAcceptableOrUnknown(
          data['parse_status']!,
          _parseStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parseStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionCandidateRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionCandidateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawNotificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_notification_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      merchantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_name'],
      )!,
      paymentMethodHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method_hint'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      parseConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}parse_confidence'],
      )!,
      parseStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parse_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionCandidatesTable createAlias(String alias) {
    return $TransactionCandidatesTable(attachedDatabase, alias);
  }
}

class TransactionCandidateRow extends DataClass
    implements Insertable<TransactionCandidateRow> {
  final String id;
  final String rawNotificationId;
  final int amount;
  final String merchantName;
  final String? paymentMethodHint;
  final DateTime occurredAt;
  final String sourceType;
  final double parseConfidence;
  final String parseStatus;
  final DateTime createdAt;
  const TransactionCandidateRow({
    required this.id,
    required this.rawNotificationId,
    required this.amount,
    required this.merchantName,
    this.paymentMethodHint,
    required this.occurredAt,
    required this.sourceType,
    required this.parseConfidence,
    required this.parseStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_notification_id'] = Variable<String>(rawNotificationId);
    map['amount'] = Variable<int>(amount);
    map['merchant_name'] = Variable<String>(merchantName);
    if (!nullToAbsent || paymentMethodHint != null) {
      map['payment_method_hint'] = Variable<String>(paymentMethodHint);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['source_type'] = Variable<String>(sourceType);
    map['parse_confidence'] = Variable<double>(parseConfidence);
    map['parse_status'] = Variable<String>(parseStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionCandidatesCompanion toCompanion(bool nullToAbsent) {
    return TransactionCandidatesCompanion(
      id: Value(id),
      rawNotificationId: Value(rawNotificationId),
      amount: Value(amount),
      merchantName: Value(merchantName),
      paymentMethodHint: paymentMethodHint == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodHint),
      occurredAt: Value(occurredAt),
      sourceType: Value(sourceType),
      parseConfidence: Value(parseConfidence),
      parseStatus: Value(parseStatus),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionCandidateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionCandidateRow(
      id: serializer.fromJson<String>(json['id']),
      rawNotificationId: serializer.fromJson<String>(json['rawNotificationId']),
      amount: serializer.fromJson<int>(json['amount']),
      merchantName: serializer.fromJson<String>(json['merchantName']),
      paymentMethodHint: serializer.fromJson<String?>(
        json['paymentMethodHint'],
      ),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      parseConfidence: serializer.fromJson<double>(json['parseConfidence']),
      parseStatus: serializer.fromJson<String>(json['parseStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawNotificationId': serializer.toJson<String>(rawNotificationId),
      'amount': serializer.toJson<int>(amount),
      'merchantName': serializer.toJson<String>(merchantName),
      'paymentMethodHint': serializer.toJson<String?>(paymentMethodHint),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'sourceType': serializer.toJson<String>(sourceType),
      'parseConfidence': serializer.toJson<double>(parseConfidence),
      'parseStatus': serializer.toJson<String>(parseStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionCandidateRow copyWith({
    String? id,
    String? rawNotificationId,
    int? amount,
    String? merchantName,
    Value<String?> paymentMethodHint = const Value.absent(),
    DateTime? occurredAt,
    String? sourceType,
    double? parseConfidence,
    String? parseStatus,
    DateTime? createdAt,
  }) => TransactionCandidateRow(
    id: id ?? this.id,
    rawNotificationId: rawNotificationId ?? this.rawNotificationId,
    amount: amount ?? this.amount,
    merchantName: merchantName ?? this.merchantName,
    paymentMethodHint: paymentMethodHint.present
        ? paymentMethodHint.value
        : this.paymentMethodHint,
    occurredAt: occurredAt ?? this.occurredAt,
    sourceType: sourceType ?? this.sourceType,
    parseConfidence: parseConfidence ?? this.parseConfidence,
    parseStatus: parseStatus ?? this.parseStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionCandidateRow copyWithCompanion(
    TransactionCandidatesCompanion data,
  ) {
    return TransactionCandidateRow(
      id: data.id.present ? data.id.value : this.id,
      rawNotificationId: data.rawNotificationId.present
          ? data.rawNotificationId.value
          : this.rawNotificationId,
      amount: data.amount.present ? data.amount.value : this.amount,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      paymentMethodHint: data.paymentMethodHint.present
          ? data.paymentMethodHint.value
          : this.paymentMethodHint,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      parseConfidence: data.parseConfidence.present
          ? data.parseConfidence.value
          : this.parseConfidence,
      parseStatus: data.parseStatus.present
          ? data.parseStatus.value
          : this.parseStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionCandidateRow(')
          ..write('id: $id, ')
          ..write('rawNotificationId: $rawNotificationId, ')
          ..write('amount: $amount, ')
          ..write('merchantName: $merchantName, ')
          ..write('paymentMethodHint: $paymentMethodHint, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sourceType: $sourceType, ')
          ..write('parseConfidence: $parseConfidence, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rawNotificationId,
    amount,
    merchantName,
    paymentMethodHint,
    occurredAt,
    sourceType,
    parseConfidence,
    parseStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionCandidateRow &&
          other.id == this.id &&
          other.rawNotificationId == this.rawNotificationId &&
          other.amount == this.amount &&
          other.merchantName == this.merchantName &&
          other.paymentMethodHint == this.paymentMethodHint &&
          other.occurredAt == this.occurredAt &&
          other.sourceType == this.sourceType &&
          other.parseConfidence == this.parseConfidence &&
          other.parseStatus == this.parseStatus &&
          other.createdAt == this.createdAt);
}

class TransactionCandidatesCompanion
    extends UpdateCompanion<TransactionCandidateRow> {
  final Value<String> id;
  final Value<String> rawNotificationId;
  final Value<int> amount;
  final Value<String> merchantName;
  final Value<String?> paymentMethodHint;
  final Value<DateTime> occurredAt;
  final Value<String> sourceType;
  final Value<double> parseConfidence;
  final Value<String> parseStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionCandidatesCompanion({
    this.id = const Value.absent(),
    this.rawNotificationId = const Value.absent(),
    this.amount = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.paymentMethodHint = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.parseConfidence = const Value.absent(),
    this.parseStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionCandidatesCompanion.insert({
    required String id,
    required String rawNotificationId,
    required int amount,
    required String merchantName,
    this.paymentMethodHint = const Value.absent(),
    required DateTime occurredAt,
    required String sourceType,
    required double parseConfidence,
    required String parseStatus,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawNotificationId = Value(rawNotificationId),
       amount = Value(amount),
       merchantName = Value(merchantName),
       occurredAt = Value(occurredAt),
       sourceType = Value(sourceType),
       parseConfidence = Value(parseConfidence),
       parseStatus = Value(parseStatus),
       createdAt = Value(createdAt);
  static Insertable<TransactionCandidateRow> custom({
    Expression<String>? id,
    Expression<String>? rawNotificationId,
    Expression<int>? amount,
    Expression<String>? merchantName,
    Expression<String>? paymentMethodHint,
    Expression<DateTime>? occurredAt,
    Expression<String>? sourceType,
    Expression<double>? parseConfidence,
    Expression<String>? parseStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawNotificationId != null) 'raw_notification_id': rawNotificationId,
      if (amount != null) 'amount': amount,
      if (merchantName != null) 'merchant_name': merchantName,
      if (paymentMethodHint != null) 'payment_method_hint': paymentMethodHint,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (sourceType != null) 'source_type': sourceType,
      if (parseConfidence != null) 'parse_confidence': parseConfidence,
      if (parseStatus != null) 'parse_status': parseStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionCandidatesCompanion copyWith({
    Value<String>? id,
    Value<String>? rawNotificationId,
    Value<int>? amount,
    Value<String>? merchantName,
    Value<String?>? paymentMethodHint,
    Value<DateTime>? occurredAt,
    Value<String>? sourceType,
    Value<double>? parseConfidence,
    Value<String>? parseStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionCandidatesCompanion(
      id: id ?? this.id,
      rawNotificationId: rawNotificationId ?? this.rawNotificationId,
      amount: amount ?? this.amount,
      merchantName: merchantName ?? this.merchantName,
      paymentMethodHint: paymentMethodHint ?? this.paymentMethodHint,
      occurredAt: occurredAt ?? this.occurredAt,
      sourceType: sourceType ?? this.sourceType,
      parseConfidence: parseConfidence ?? this.parseConfidence,
      parseStatus: parseStatus ?? this.parseStatus,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rawNotificationId.present) {
      map['raw_notification_id'] = Variable<String>(rawNotificationId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (paymentMethodHint.present) {
      map['payment_method_hint'] = Variable<String>(paymentMethodHint.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (parseConfidence.present) {
      map['parse_confidence'] = Variable<double>(parseConfidence.value);
    }
    if (parseStatus.present) {
      map['parse_status'] = Variable<String>(parseStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionCandidatesCompanion(')
          ..write('id: $id, ')
          ..write('rawNotificationId: $rawNotificationId, ')
          ..write('amount: $amount, ')
          ..write('merchantName: $merchantName, ')
          ..write('paymentMethodHint: $paymentMethodHint, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sourceType: $sourceType, ')
          ..write('parseConfidence: $parseConfidence, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassificationResultsTable extends ClassificationResults
    with TableInfo<$ClassificationResultsTable, ClassificationResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassificationResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _candidateIdsJsonMeta = const VerificationMeta(
    'candidateIdsJson',
  );
  @override
  late final GeneratedColumn<String> candidateIdsJson = GeneratedColumn<String>(
    'candidate_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDuplicateMeta = const VerificationMeta(
    'isDuplicate',
  );
  @override
  late final GeneratedColumn<bool> isDuplicate = GeneratedColumn<bool>(
    'is_duplicate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_duplicate" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isTransferLikeMeta = const VerificationMeta(
    'isTransferLike',
  );
  @override
  late final GeneratedColumn<bool> isTransferLike = GeneratedColumn<bool>(
    'is_transfer_like',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_transfer_like" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isExpenseMeta = const VerificationMeta(
    'isExpense',
  );
  @override
  late final GeneratedColumn<bool> isExpense = GeneratedColumn<bool>(
    'is_expense',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_expense" IN (0, 1))',
    ),
  );
  static const VerificationMeta _requiresReviewMeta = const VerificationMeta(
    'requiresReview',
  );
  @override
  late final GeneratedColumn<bool> requiresReview = GeneratedColumn<bool>(
    'requires_review',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_review" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reasonCodesJsonMeta = const VerificationMeta(
    'reasonCodesJson',
  );
  @override
  late final GeneratedColumn<String> reasonCodesJson = GeneratedColumn<String>(
    'reason_codes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userFeedbackMeta = const VerificationMeta(
    'userFeedback',
  );
  @override
  late final GeneratedColumn<bool> userFeedback = GeneratedColumn<bool>(
    'user_feedback',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_feedback" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    candidateIdsJson,
    isDuplicate,
    isTransferLike,
    isExpense,
    requiresReview,
    reasonCodesJson,
    confidence,
    createdAt,
    userFeedback,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classification_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassificationResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('candidate_ids_json')) {
      context.handle(
        _candidateIdsJsonMeta,
        candidateIdsJson.isAcceptableOrUnknown(
          data['candidate_ids_json']!,
          _candidateIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateIdsJsonMeta);
    }
    if (data.containsKey('is_duplicate')) {
      context.handle(
        _isDuplicateMeta,
        isDuplicate.isAcceptableOrUnknown(
          data['is_duplicate']!,
          _isDuplicateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isDuplicateMeta);
    }
    if (data.containsKey('is_transfer_like')) {
      context.handle(
        _isTransferLikeMeta,
        isTransferLike.isAcceptableOrUnknown(
          data['is_transfer_like']!,
          _isTransferLikeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isTransferLikeMeta);
    }
    if (data.containsKey('is_expense')) {
      context.handle(
        _isExpenseMeta,
        isExpense.isAcceptableOrUnknown(data['is_expense']!, _isExpenseMeta),
      );
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('requires_review')) {
      context.handle(
        _requiresReviewMeta,
        requiresReview.isAcceptableOrUnknown(
          data['requires_review']!,
          _requiresReviewMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requiresReviewMeta);
    }
    if (data.containsKey('reason_codes_json')) {
      context.handle(
        _reasonCodesJsonMeta,
        reasonCodesJson.isAcceptableOrUnknown(
          data['reason_codes_json']!,
          _reasonCodesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reasonCodesJsonMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('user_feedback')) {
      context.handle(
        _userFeedbackMeta,
        userFeedback.isAcceptableOrUnknown(
          data['user_feedback']!,
          _userFeedbackMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassificationResultRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassificationResultRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      candidateIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_ids_json'],
      )!,
      isDuplicate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_duplicate'],
      )!,
      isTransferLike: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_transfer_like'],
      )!,
      isExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_expense'],
      )!,
      requiresReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_review'],
      )!,
      reasonCodesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_codes_json'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      userFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_feedback'],
      ),
    );
  }

  @override
  $ClassificationResultsTable createAlias(String alias) {
    return $ClassificationResultsTable(attachedDatabase, alias);
  }
}

class ClassificationResultRow extends DataClass
    implements Insertable<ClassificationResultRow> {
  final String id;
  final String candidateIdsJson;
  final bool isDuplicate;
  final bool isTransferLike;
  final bool isExpense;
  final bool requiresReview;
  final String reasonCodesJson;
  final double confidence;
  final DateTime createdAt;
  final bool? userFeedback;
  const ClassificationResultRow({
    required this.id,
    required this.candidateIdsJson,
    required this.isDuplicate,
    required this.isTransferLike,
    required this.isExpense,
    required this.requiresReview,
    required this.reasonCodesJson,
    required this.confidence,
    required this.createdAt,
    this.userFeedback,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['candidate_ids_json'] = Variable<String>(candidateIdsJson);
    map['is_duplicate'] = Variable<bool>(isDuplicate);
    map['is_transfer_like'] = Variable<bool>(isTransferLike);
    map['is_expense'] = Variable<bool>(isExpense);
    map['requires_review'] = Variable<bool>(requiresReview);
    map['reason_codes_json'] = Variable<String>(reasonCodesJson);
    map['confidence'] = Variable<double>(confidence);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || userFeedback != null) {
      map['user_feedback'] = Variable<bool>(userFeedback);
    }
    return map;
  }

  ClassificationResultsCompanion toCompanion(bool nullToAbsent) {
    return ClassificationResultsCompanion(
      id: Value(id),
      candidateIdsJson: Value(candidateIdsJson),
      isDuplicate: Value(isDuplicate),
      isTransferLike: Value(isTransferLike),
      isExpense: Value(isExpense),
      requiresReview: Value(requiresReview),
      reasonCodesJson: Value(reasonCodesJson),
      confidence: Value(confidence),
      createdAt: Value(createdAt),
      userFeedback: userFeedback == null && nullToAbsent
          ? const Value.absent()
          : Value(userFeedback),
    );
  }

  factory ClassificationResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassificationResultRow(
      id: serializer.fromJson<String>(json['id']),
      candidateIdsJson: serializer.fromJson<String>(json['candidateIdsJson']),
      isDuplicate: serializer.fromJson<bool>(json['isDuplicate']),
      isTransferLike: serializer.fromJson<bool>(json['isTransferLike']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      requiresReview: serializer.fromJson<bool>(json['requiresReview']),
      reasonCodesJson: serializer.fromJson<String>(json['reasonCodesJson']),
      confidence: serializer.fromJson<double>(json['confidence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      userFeedback: serializer.fromJson<bool?>(json['userFeedback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'candidateIdsJson': serializer.toJson<String>(candidateIdsJson),
      'isDuplicate': serializer.toJson<bool>(isDuplicate),
      'isTransferLike': serializer.toJson<bool>(isTransferLike),
      'isExpense': serializer.toJson<bool>(isExpense),
      'requiresReview': serializer.toJson<bool>(requiresReview),
      'reasonCodesJson': serializer.toJson<String>(reasonCodesJson),
      'confidence': serializer.toJson<double>(confidence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'userFeedback': serializer.toJson<bool?>(userFeedback),
    };
  }

  ClassificationResultRow copyWith({
    String? id,
    String? candidateIdsJson,
    bool? isDuplicate,
    bool? isTransferLike,
    bool? isExpense,
    bool? requiresReview,
    String? reasonCodesJson,
    double? confidence,
    DateTime? createdAt,
    Value<bool?> userFeedback = const Value.absent(),
  }) => ClassificationResultRow(
    id: id ?? this.id,
    candidateIdsJson: candidateIdsJson ?? this.candidateIdsJson,
    isDuplicate: isDuplicate ?? this.isDuplicate,
    isTransferLike: isTransferLike ?? this.isTransferLike,
    isExpense: isExpense ?? this.isExpense,
    requiresReview: requiresReview ?? this.requiresReview,
    reasonCodesJson: reasonCodesJson ?? this.reasonCodesJson,
    confidence: confidence ?? this.confidence,
    createdAt: createdAt ?? this.createdAt,
    userFeedback: userFeedback.present ? userFeedback.value : this.userFeedback,
  );
  ClassificationResultRow copyWithCompanion(
    ClassificationResultsCompanion data,
  ) {
    return ClassificationResultRow(
      id: data.id.present ? data.id.value : this.id,
      candidateIdsJson: data.candidateIdsJson.present
          ? data.candidateIdsJson.value
          : this.candidateIdsJson,
      isDuplicate: data.isDuplicate.present
          ? data.isDuplicate.value
          : this.isDuplicate,
      isTransferLike: data.isTransferLike.present
          ? data.isTransferLike.value
          : this.isTransferLike,
      isExpense: data.isExpense.present ? data.isExpense.value : this.isExpense,
      requiresReview: data.requiresReview.present
          ? data.requiresReview.value
          : this.requiresReview,
      reasonCodesJson: data.reasonCodesJson.present
          ? data.reasonCodesJson.value
          : this.reasonCodesJson,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      userFeedback: data.userFeedback.present
          ? data.userFeedback.value
          : this.userFeedback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationResultRow(')
          ..write('id: $id, ')
          ..write('candidateIdsJson: $candidateIdsJson, ')
          ..write('isDuplicate: $isDuplicate, ')
          ..write('isTransferLike: $isTransferLike, ')
          ..write('isExpense: $isExpense, ')
          ..write('requiresReview: $requiresReview, ')
          ..write('reasonCodesJson: $reasonCodesJson, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('userFeedback: $userFeedback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    candidateIdsJson,
    isDuplicate,
    isTransferLike,
    isExpense,
    requiresReview,
    reasonCodesJson,
    confidence,
    createdAt,
    userFeedback,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassificationResultRow &&
          other.id == this.id &&
          other.candidateIdsJson == this.candidateIdsJson &&
          other.isDuplicate == this.isDuplicate &&
          other.isTransferLike == this.isTransferLike &&
          other.isExpense == this.isExpense &&
          other.requiresReview == this.requiresReview &&
          other.reasonCodesJson == this.reasonCodesJson &&
          other.confidence == this.confidence &&
          other.createdAt == this.createdAt &&
          other.userFeedback == this.userFeedback);
}

class ClassificationResultsCompanion
    extends UpdateCompanion<ClassificationResultRow> {
  final Value<String> id;
  final Value<String> candidateIdsJson;
  final Value<bool> isDuplicate;
  final Value<bool> isTransferLike;
  final Value<bool> isExpense;
  final Value<bool> requiresReview;
  final Value<String> reasonCodesJson;
  final Value<double> confidence;
  final Value<DateTime> createdAt;
  final Value<bool?> userFeedback;
  final Value<int> rowid;
  const ClassificationResultsCompanion({
    this.id = const Value.absent(),
    this.candidateIdsJson = const Value.absent(),
    this.isDuplicate = const Value.absent(),
    this.isTransferLike = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.requiresReview = const Value.absent(),
    this.reasonCodesJson = const Value.absent(),
    this.confidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.userFeedback = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassificationResultsCompanion.insert({
    required String id,
    required String candidateIdsJson,
    required bool isDuplicate,
    required bool isTransferLike,
    required bool isExpense,
    required bool requiresReview,
    required String reasonCodesJson,
    required double confidence,
    required DateTime createdAt,
    this.userFeedback = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       candidateIdsJson = Value(candidateIdsJson),
       isDuplicate = Value(isDuplicate),
       isTransferLike = Value(isTransferLike),
       isExpense = Value(isExpense),
       requiresReview = Value(requiresReview),
       reasonCodesJson = Value(reasonCodesJson),
       confidence = Value(confidence),
       createdAt = Value(createdAt);
  static Insertable<ClassificationResultRow> custom({
    Expression<String>? id,
    Expression<String>? candidateIdsJson,
    Expression<bool>? isDuplicate,
    Expression<bool>? isTransferLike,
    Expression<bool>? isExpense,
    Expression<bool>? requiresReview,
    Expression<String>? reasonCodesJson,
    Expression<double>? confidence,
    Expression<DateTime>? createdAt,
    Expression<bool>? userFeedback,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (candidateIdsJson != null) 'candidate_ids_json': candidateIdsJson,
      if (isDuplicate != null) 'is_duplicate': isDuplicate,
      if (isTransferLike != null) 'is_transfer_like': isTransferLike,
      if (isExpense != null) 'is_expense': isExpense,
      if (requiresReview != null) 'requires_review': requiresReview,
      if (reasonCodesJson != null) 'reason_codes_json': reasonCodesJson,
      if (confidence != null) 'confidence': confidence,
      if (createdAt != null) 'created_at': createdAt,
      if (userFeedback != null) 'user_feedback': userFeedback,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassificationResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? candidateIdsJson,
    Value<bool>? isDuplicate,
    Value<bool>? isTransferLike,
    Value<bool>? isExpense,
    Value<bool>? requiresReview,
    Value<String>? reasonCodesJson,
    Value<double>? confidence,
    Value<DateTime>? createdAt,
    Value<bool?>? userFeedback,
    Value<int>? rowid,
  }) {
    return ClassificationResultsCompanion(
      id: id ?? this.id,
      candidateIdsJson: candidateIdsJson ?? this.candidateIdsJson,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      isTransferLike: isTransferLike ?? this.isTransferLike,
      isExpense: isExpense ?? this.isExpense,
      requiresReview: requiresReview ?? this.requiresReview,
      reasonCodesJson: reasonCodesJson ?? this.reasonCodesJson,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      userFeedback: userFeedback ?? this.userFeedback,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (candidateIdsJson.present) {
      map['candidate_ids_json'] = Variable<String>(candidateIdsJson.value);
    }
    if (isDuplicate.present) {
      map['is_duplicate'] = Variable<bool>(isDuplicate.value);
    }
    if (isTransferLike.present) {
      map['is_transfer_like'] = Variable<bool>(isTransferLike.value);
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (requiresReview.present) {
      map['requires_review'] = Variable<bool>(requiresReview.value);
    }
    if (reasonCodesJson.present) {
      map['reason_codes_json'] = Variable<String>(reasonCodesJson.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (userFeedback.present) {
      map['user_feedback'] = Variable<bool>(userFeedback.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationResultsCompanion(')
          ..write('id: $id, ')
          ..write('candidateIdsJson: $candidateIdsJson, ')
          ..write('isDuplicate: $isDuplicate, ')
          ..write('isTransferLike: $isTransferLike, ')
          ..write('isExpense: $isExpense, ')
          ..write('requiresReview: $requiresReview, ')
          ..write('reasonCodesJson: $reasonCodesJson, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('userFeedback: $userFeedback, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RawNotificationsTable rawNotifications = $RawNotificationsTable(
    this,
  );
  late final $ExpenseTransactionsTable expenseTransactions =
      $ExpenseTransactionsTable(this);
  late final $TransactionCandidatesTable transactionCandidates =
      $TransactionCandidatesTable(this);
  late final $ClassificationResultsTable classificationResults =
      $ClassificationResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rawNotifications,
    expenseTransactions,
    transactionCandidates,
    classificationResults,
  ];
}

typedef $$RawNotificationsTableCreateCompanionBuilder =
    RawNotificationsCompanion Function({
      required String id,
      required String sourceType,
      Value<String?> sourceApp,
      Value<String?> sender,
      Value<String?> title,
      required String body,
      required DateTime receivedAt,
      required String sourceHash,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RawNotificationsTableUpdateCompanionBuilder =
    RawNotificationsCompanion Function({
      Value<String> id,
      Value<String> sourceType,
      Value<String?> sourceApp,
      Value<String?> sender,
      Value<String?> title,
      Value<String> body,
      Value<DateTime> receivedAt,
      Value<String> sourceHash,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RawNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $RawNotificationsTable> {
  $$RawNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RawNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RawNotificationsTable> {
  $$RawNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceApp => $composableBuilder(
    column: $table.sourceApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawNotificationsTable> {
  $$RawNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceApp =>
      $composableBuilder(column: $table.sourceApp, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RawNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RawNotificationsTable,
          RawNotificationRow,
          $$RawNotificationsTableFilterComposer,
          $$RawNotificationsTableOrderingComposer,
          $$RawNotificationsTableAnnotationComposer,
          $$RawNotificationsTableCreateCompanionBuilder,
          $$RawNotificationsTableUpdateCompanionBuilder,
          (
            RawNotificationRow,
            BaseReferences<
              _$AppDatabase,
              $RawNotificationsTable,
              RawNotificationRow
            >,
          ),
          RawNotificationRow,
          PrefetchHooks Function()
        > {
  $$RawNotificationsTableTableManager(
    _$AppDatabase db,
    $RawNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawNotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceApp = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RawNotificationsCompanion(
                id: id,
                sourceType: sourceType,
                sourceApp: sourceApp,
                sender: sender,
                title: title,
                body: body,
                receivedAt: receivedAt,
                sourceHash: sourceHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                Value<String?> sourceApp = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String body,
                required DateTime receivedAt,
                required String sourceHash,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RawNotificationsCompanion.insert(
                id: id,
                sourceType: sourceType,
                sourceApp: sourceApp,
                sender: sender,
                title: title,
                body: body,
                receivedAt: receivedAt,
                sourceHash: sourceHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RawNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RawNotificationsTable,
      RawNotificationRow,
      $$RawNotificationsTableFilterComposer,
      $$RawNotificationsTableOrderingComposer,
      $$RawNotificationsTableAnnotationComposer,
      $$RawNotificationsTableCreateCompanionBuilder,
      $$RawNotificationsTableUpdateCompanionBuilder,
      (
        RawNotificationRow,
        BaseReferences<
          _$AppDatabase,
          $RawNotificationsTable,
          RawNotificationRow
        >,
      ),
      RawNotificationRow,
      PrefetchHooks Function()
    >;
typedef $$ExpenseTransactionsTableCreateCompanionBuilder =
    ExpenseTransactionsCompanion Function({
      required String id,
      required int amount,
      required String merchantName,
      Value<String?> categoryId,
      required DateTime spentAt,
      required String confirmationStatus,
      required String confirmedBy,
      required String candidateIdsJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$ExpenseTransactionsTableUpdateCompanionBuilder =
    ExpenseTransactionsCompanion Function({
      Value<String> id,
      Value<int> amount,
      Value<String> merchantName,
      Value<String?> categoryId,
      Value<DateTime> spentAt,
      Value<String> confirmationStatus,
      Value<String> confirmedBy,
      Value<String> candidateIdsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$ExpenseTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmationStatus => $composableBuilder(
    column: $table.confirmationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmationStatus => $composableBuilder(
    column: $table.confirmationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<String> get confirmationStatus => $composableBuilder(
    column: $table.confirmationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ExpenseTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseTransactionsTable,
          ExpenseTransactionRow,
          $$ExpenseTransactionsTableFilterComposer,
          $$ExpenseTransactionsTableOrderingComposer,
          $$ExpenseTransactionsTableAnnotationComposer,
          $$ExpenseTransactionsTableCreateCompanionBuilder,
          $$ExpenseTransactionsTableUpdateCompanionBuilder,
          (
            ExpenseTransactionRow,
            BaseReferences<
              _$AppDatabase,
              $ExpenseTransactionsTable,
              ExpenseTransactionRow
            >,
          ),
          ExpenseTransactionRow,
          PrefetchHooks Function()
        > {
  $$ExpenseTransactionsTableTableManager(
    _$AppDatabase db,
    $ExpenseTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExpenseTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> merchantName = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime> spentAt = const Value.absent(),
                Value<String> confirmationStatus = const Value.absent(),
                Value<String> confirmedBy = const Value.absent(),
                Value<String> candidateIdsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseTransactionsCompanion(
                id: id,
                amount: amount,
                merchantName: merchantName,
                categoryId: categoryId,
                spentAt: spentAt,
                confirmationStatus: confirmationStatus,
                confirmedBy: confirmedBy,
                candidateIdsJson: candidateIdsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amount,
                required String merchantName,
                Value<String?> categoryId = const Value.absent(),
                required DateTime spentAt,
                required String confirmationStatus,
                required String confirmedBy,
                required String candidateIdsJson,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => ExpenseTransactionsCompanion.insert(
                id: id,
                amount: amount,
                merchantName: merchantName,
                categoryId: categoryId,
                spentAt: spentAt,
                confirmationStatus: confirmationStatus,
                confirmedBy: confirmedBy,
                candidateIdsJson: candidateIdsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseTransactionsTable,
      ExpenseTransactionRow,
      $$ExpenseTransactionsTableFilterComposer,
      $$ExpenseTransactionsTableOrderingComposer,
      $$ExpenseTransactionsTableAnnotationComposer,
      $$ExpenseTransactionsTableCreateCompanionBuilder,
      $$ExpenseTransactionsTableUpdateCompanionBuilder,
      (
        ExpenseTransactionRow,
        BaseReferences<
          _$AppDatabase,
          $ExpenseTransactionsTable,
          ExpenseTransactionRow
        >,
      ),
      ExpenseTransactionRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionCandidatesTableCreateCompanionBuilder =
    TransactionCandidatesCompanion Function({
      required String id,
      required String rawNotificationId,
      required int amount,
      required String merchantName,
      Value<String?> paymentMethodHint,
      required DateTime occurredAt,
      required String sourceType,
      required double parseConfidence,
      required String parseStatus,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TransactionCandidatesTableUpdateCompanionBuilder =
    TransactionCandidatesCompanion Function({
      Value<String> id,
      Value<String> rawNotificationId,
      Value<int> amount,
      Value<String> merchantName,
      Value<String?> paymentMethodHint,
      Value<DateTime> occurredAt,
      Value<String> sourceType,
      Value<double> parseConfidence,
      Value<String> parseStatus,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TransactionCandidatesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionCandidatesTable> {
  $$TransactionCandidatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawNotificationId => $composableBuilder(
    column: $table.rawNotificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethodHint => $composableBuilder(
    column: $table.paymentMethodHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get parseConfidence => $composableBuilder(
    column: $table.parseConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionCandidatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionCandidatesTable> {
  $$TransactionCandidatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawNotificationId => $composableBuilder(
    column: $table.rawNotificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethodHint => $composableBuilder(
    column: $table.paymentMethodHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get parseConfidence => $composableBuilder(
    column: $table.parseConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionCandidatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionCandidatesTable> {
  $$TransactionCandidatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawNotificationId => $composableBuilder(
    column: $table.rawNotificationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethodHint => $composableBuilder(
    column: $table.paymentMethodHint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get parseConfidence => $composableBuilder(
    column: $table.parseConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionCandidatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionCandidatesTable,
          TransactionCandidateRow,
          $$TransactionCandidatesTableFilterComposer,
          $$TransactionCandidatesTableOrderingComposer,
          $$TransactionCandidatesTableAnnotationComposer,
          $$TransactionCandidatesTableCreateCompanionBuilder,
          $$TransactionCandidatesTableUpdateCompanionBuilder,
          (
            TransactionCandidateRow,
            BaseReferences<
              _$AppDatabase,
              $TransactionCandidatesTable,
              TransactionCandidateRow
            >,
          ),
          TransactionCandidateRow,
          PrefetchHooks Function()
        > {
  $$TransactionCandidatesTableTableManager(
    _$AppDatabase db,
    $TransactionCandidatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionCandidatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionCandidatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionCandidatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawNotificationId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> merchantName = const Value.absent(),
                Value<String?> paymentMethodHint = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<double> parseConfidence = const Value.absent(),
                Value<String> parseStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionCandidatesCompanion(
                id: id,
                rawNotificationId: rawNotificationId,
                amount: amount,
                merchantName: merchantName,
                paymentMethodHint: paymentMethodHint,
                occurredAt: occurredAt,
                sourceType: sourceType,
                parseConfidence: parseConfidence,
                parseStatus: parseStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawNotificationId,
                required int amount,
                required String merchantName,
                Value<String?> paymentMethodHint = const Value.absent(),
                required DateTime occurredAt,
                required String sourceType,
                required double parseConfidence,
                required String parseStatus,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionCandidatesCompanion.insert(
                id: id,
                rawNotificationId: rawNotificationId,
                amount: amount,
                merchantName: merchantName,
                paymentMethodHint: paymentMethodHint,
                occurredAt: occurredAt,
                sourceType: sourceType,
                parseConfidence: parseConfidence,
                parseStatus: parseStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionCandidatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionCandidatesTable,
      TransactionCandidateRow,
      $$TransactionCandidatesTableFilterComposer,
      $$TransactionCandidatesTableOrderingComposer,
      $$TransactionCandidatesTableAnnotationComposer,
      $$TransactionCandidatesTableCreateCompanionBuilder,
      $$TransactionCandidatesTableUpdateCompanionBuilder,
      (
        TransactionCandidateRow,
        BaseReferences<
          _$AppDatabase,
          $TransactionCandidatesTable,
          TransactionCandidateRow
        >,
      ),
      TransactionCandidateRow,
      PrefetchHooks Function()
    >;
typedef $$ClassificationResultsTableCreateCompanionBuilder =
    ClassificationResultsCompanion Function({
      required String id,
      required String candidateIdsJson,
      required bool isDuplicate,
      required bool isTransferLike,
      required bool isExpense,
      required bool requiresReview,
      required String reasonCodesJson,
      required double confidence,
      required DateTime createdAt,
      Value<bool?> userFeedback,
      Value<int> rowid,
    });
typedef $$ClassificationResultsTableUpdateCompanionBuilder =
    ClassificationResultsCompanion Function({
      Value<String> id,
      Value<String> candidateIdsJson,
      Value<bool> isDuplicate,
      Value<bool> isTransferLike,
      Value<bool> isExpense,
      Value<bool> requiresReview,
      Value<String> reasonCodesJson,
      Value<double> confidence,
      Value<DateTime> createdAt,
      Value<bool?> userFeedback,
      Value<int> rowid,
    });

class $$ClassificationResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassificationResultsTable> {
  $$ClassificationResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDuplicate => $composableBuilder(
    column: $table.isDuplicate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTransferLike => $composableBuilder(
    column: $table.isTransferLike,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExpense => $composableBuilder(
    column: $table.isExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresReview => $composableBuilder(
    column: $table.requiresReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userFeedback => $composableBuilder(
    column: $table.userFeedback,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClassificationResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassificationResultsTable> {
  $$ClassificationResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDuplicate => $composableBuilder(
    column: $table.isDuplicate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTransferLike => $composableBuilder(
    column: $table.isTransferLike,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExpense => $composableBuilder(
    column: $table.isExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresReview => $composableBuilder(
    column: $table.requiresReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userFeedback => $composableBuilder(
    column: $table.userFeedback,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClassificationResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassificationResultsTable> {
  $$ClassificationResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get candidateIdsJson => $composableBuilder(
    column: $table.candidateIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDuplicate => $composableBuilder(
    column: $table.isDuplicate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTransferLike => $composableBuilder(
    column: $table.isTransferLike,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isExpense =>
      $composableBuilder(column: $table.isExpense, builder: (column) => column);

  GeneratedColumn<bool> get requiresReview => $composableBuilder(
    column: $table.requiresReview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonCodesJson => $composableBuilder(
    column: $table.reasonCodesJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get userFeedback => $composableBuilder(
    column: $table.userFeedback,
    builder: (column) => column,
  );
}

class $$ClassificationResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassificationResultsTable,
          ClassificationResultRow,
          $$ClassificationResultsTableFilterComposer,
          $$ClassificationResultsTableOrderingComposer,
          $$ClassificationResultsTableAnnotationComposer,
          $$ClassificationResultsTableCreateCompanionBuilder,
          $$ClassificationResultsTableUpdateCompanionBuilder,
          (
            ClassificationResultRow,
            BaseReferences<
              _$AppDatabase,
              $ClassificationResultsTable,
              ClassificationResultRow
            >,
          ),
          ClassificationResultRow,
          PrefetchHooks Function()
        > {
  $$ClassificationResultsTableTableManager(
    _$AppDatabase db,
    $ClassificationResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassificationResultsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ClassificationResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClassificationResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> candidateIdsJson = const Value.absent(),
                Value<bool> isDuplicate = const Value.absent(),
                Value<bool> isTransferLike = const Value.absent(),
                Value<bool> isExpense = const Value.absent(),
                Value<bool> requiresReview = const Value.absent(),
                Value<String> reasonCodesJson = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool?> userFeedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassificationResultsCompanion(
                id: id,
                candidateIdsJson: candidateIdsJson,
                isDuplicate: isDuplicate,
                isTransferLike: isTransferLike,
                isExpense: isExpense,
                requiresReview: requiresReview,
                reasonCodesJson: reasonCodesJson,
                confidence: confidence,
                createdAt: createdAt,
                userFeedback: userFeedback,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String candidateIdsJson,
                required bool isDuplicate,
                required bool isTransferLike,
                required bool isExpense,
                required bool requiresReview,
                required String reasonCodesJson,
                required double confidence,
                required DateTime createdAt,
                Value<bool?> userFeedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassificationResultsCompanion.insert(
                id: id,
                candidateIdsJson: candidateIdsJson,
                isDuplicate: isDuplicate,
                isTransferLike: isTransferLike,
                isExpense: isExpense,
                requiresReview: requiresReview,
                reasonCodesJson: reasonCodesJson,
                confidence: confidence,
                createdAt: createdAt,
                userFeedback: userFeedback,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClassificationResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassificationResultsTable,
      ClassificationResultRow,
      $$ClassificationResultsTableFilterComposer,
      $$ClassificationResultsTableOrderingComposer,
      $$ClassificationResultsTableAnnotationComposer,
      $$ClassificationResultsTableCreateCompanionBuilder,
      $$ClassificationResultsTableUpdateCompanionBuilder,
      (
        ClassificationResultRow,
        BaseReferences<
          _$AppDatabase,
          $ClassificationResultsTable,
          ClassificationResultRow
        >,
      ),
      ClassificationResultRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RawNotificationsTableTableManager get rawNotifications =>
      $$RawNotificationsTableTableManager(_db, _db.rawNotifications);
  $$ExpenseTransactionsTableTableManager get expenseTransactions =>
      $$ExpenseTransactionsTableTableManager(_db, _db.expenseTransactions);
  $$TransactionCandidatesTableTableManager get transactionCandidates =>
      $$TransactionCandidatesTableTableManager(_db, _db.transactionCandidates);
  $$ClassificationResultsTableTableManager get classificationResults =>
      $$ClassificationResultsTableTableManager(_db, _db.classificationResults);
}
