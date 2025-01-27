import '../sources/sources.dart';
import '../../domain/repositories/repositories.dart';

class RecordRepositoryImp implements RecordRepository {
  final RecordRemoteDataSource remoteDataSource;
  RecordRepositoryImp({required this.remoteDataSource});

  // ... example ...
  //
  // Future<User> getUser(String userId) async {
  //     return remoteDataSource.getUser(userId);
  //   }
  // ...
}
