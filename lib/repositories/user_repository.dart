import 'package:growana/models/user.dart';
import 'package:growana/db/database_helper.dart';

class UserRepository {
  final db = DatabaseHelper.instance;

  Future<int> createUser(User user) async {
    final database = await db.database;
    return await database.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final database = await db.database;
    final res = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final database = await db.database;
    final res = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<int> updateUser(User user) async {
    final database = await db.database;
    return await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final database = await db.database;
    return await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
