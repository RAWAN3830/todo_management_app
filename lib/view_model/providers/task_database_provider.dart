import 'package:riverpod/riverpod.dart';

import '../../services/database_connection.dart';

final taskDatabaseProvider = Provider<DatabaseRepo>((ref) {
  return DatabaseRepo();
},);