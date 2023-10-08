import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/memo/data/memo_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

final memoProvider = StreamProvider<List<Memo>>(
  (ref) => ref
      .watch(memoRepositoryProvider)
      .readMemo(roomCode: 'JXfnbvqjtURZgDCQHxcOf9OriIo1'),
);
