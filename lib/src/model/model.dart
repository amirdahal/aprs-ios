import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableChatStore = SqfEntityTable(
  tableName: 'chatStore',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('callsign', DbType.text, isUnique: true),
    SqfEntityField('lastMessage', DbType.text),
    SqfEntityField('seen', DbType.bool, defaultValue: false),
    SqfEntityField('time', DbType.datetime, defaultValue: DateTime.timestamp),
  ],
);

const tableBeaconStore = SqfEntityTable(
  tableName: 'beaconStore',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('source', DbType.text),
    SqfEntityField('destination', DbType.text),
    SqfEntityField('path', DbType.text),
    SqfEntityField('latitude', DbType.real),
    SqfEntityField('longitude', DbType.real),
    SqfEntityField('symbolTable', DbType.text),
    SqfEntityField('symbol', DbType.text),
    SqfEntityField('comment', DbType.text),
    SqfEntityField('raw', DbType.text),
    SqfEntityField('timestamp', DbType.datetime),
  ],
);

const tableMessageStore = SqfEntityTable(
  tableName: 'messageStore',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('sender', DbType.text, isNotNull: true),
    SqfEntityField('recipient', DbType.text, isNotNull: true),
    SqfEntityField('messageText', DbType.text, isNotNull: true),
    SqfEntityField('messageId', DbType.integer),
    SqfEntityField('sent', DbType.bool),
    SqfEntityField('raw', DbType.text),
    SqfEntityField('timestamp', DbType.datetime, isNotNull: true),
  ],
);

const tablePassword = SqfEntityTable(
  tableName: 'passwordStore',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [SqfEntityField('password', DbType.text)],
);

const tableDrr = SqfEntityTable(
  tableName: 'drrStore',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('sendAllPositions', DbType.bool, defaultValue: false),
    SqfEntityField('sendMyPosition', DbType.bool),
    SqfEntityField('uuid', DbType.text),
    SqfEntityField('interval', DbType.integer),
    SqfEntityField('comment', DbType.text),
  ],
);

const seqIdentity = SqfEntitySequence(sequenceName: 'identity');

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'RadioStore',
  databaseName: 'radio_store.db',
  databaseTables: [
    tableBeaconStore,
    tableMessageStore,
    tableChatStore,
    tablePassword,
    tableDrr,
  ],
  sequences: [seqIdentity],
);
