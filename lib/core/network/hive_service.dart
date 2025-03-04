import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revive_reads/app/constants/hive_table_constant.dart';
import 'package:revive_reads/features/auth/data/model/user_hive_model.dart';
import 'package:revive_reads/features/dashboard/data/model/book_hive_model.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}revive_reads.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(BookHiveModelAdapter());
    
    // Open boxes
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    await Hive.openBox(HiveTableConstant.preferencesBox);
  }

  // User Queries
  Future<void> addUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var users = box.values.toList();
    return users;
  }

  Future<void> deleteUser(String userId) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
  }

  // Login using username and password
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return user;
  }
  
  // Book Queries
  Future<void> addBooks(List<BookHiveModel> books) async {
    var box = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    
    // Clear existing books if needed
    await box.clear();
    
    // Add all books with their IDs as keys
    for (var book in books) {
      await box.put(book.id, book);
    }
    
    // Update last cached timestamp
    var prefsBox = await Hive.openBox(HiveTableConstant.preferencesBox);
    await prefsBox.put('books_last_cached', DateTime.now().toIso8601String());
  }
  
  Future<List<BookHiveModel>> getAllBooks() async {
    var box = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    return box.values.toList();
  }
  
  Future<BookHiveModel?> getBookById(String bookId) async {
    var box = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    return box.get(bookId);
  }
  
  Future<List<BookHiveModel>> searchBooks(String query) async {
    var box = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    final queryLower = query.toLowerCase();
    
    return box.values.where((book) => 
      book.title.toLowerCase().contains(queryLower) || 
      book.description.toLowerCase().contains(queryLower) ||
      book.genre.toLowerCase().contains(queryLower)
    ).toList();
  }
  
  Future<DateTime?> getBooksLastCachedTime() async {
    var prefsBox = await Hive.openBox(HiveTableConstant.preferencesBox);
    final dateString = prefsBox.get('books_last_cached') as String?;
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }
  
  Future<bool> hasBooks() async {
    var box = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    return box.isNotEmpty;
  }
  
  // General methods
  Future<void> closeBoxes() async {
    await Hive.close();
  }
  
  Future<void> clearAllData() async {
    var userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var bookBox = await Hive.openBox<BookHiveModel>(HiveTableConstant.bookBox);
    var prefsBox = await Hive.openBox(HiveTableConstant.preferencesBox);
    
    await userBox.clear();
    await bookBox.clear();
    await prefsBox.clear();
  }
}