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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RawNotificationsTable rawNotifications = $RawNotificationsTable(
    this,
  );
  late final $ExpenseTransactionsTable expenseTransactions =
      $ExpenseTransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rawNotifications,
    expenseTransactions,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RawNotificationsTableTableManager get rawNotifications =>
      $$RawNotificationsTableTableManager(_db, _db.rawNotifications);
  $$ExpenseTransactionsTableTableManager get expenseTransactions =>
      $$ExpenseTransactionsTableTableManager(_db, _db.expenseTransactions);
}
