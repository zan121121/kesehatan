import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ================= INIT DB =================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // ================= CREATE TABLE =================
  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  email TEXT UNIQUE,
  password TEXT
  
)
''');



    await db.execute('''
CREATE TABLE checkin (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  date TEXT,
  mood TEXT,
  level REAL,
  reason TEXT
)
''');

    await db.execute('''
CREATE TABLE mood (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  date TEXT,
  score INTEGER,
  UNIQUE(email, date)
)
''');

    await db.execute('''
CREATE TABLE reflection (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  date TEXT,
  journal TEXT,
  answers TEXT,
  mood TEXT,
  insight TEXT
)
''');

    await db.execute('''
CREATE TABLE points (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  type TEXT,
  date TEXT
)
''');
  }

  // ================= UPGRADE =================
Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
CREATE TABLE IF NOT EXISTS reflection (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  date TEXT,
  journal TEXT,
  mood TEXT,
  insight TEXT
)
''');
  }

  if (oldVersion < 3) {
    await db.execute('''
CREATE TABLE IF NOT EXISTS points (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  type TEXT,
  date TEXT
)
''');
  }

  if (oldVersion < 4) {
    await db.execute('''
CREATE TABLE IF NOT EXISTS checkin (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  date TEXT,
  mood TEXT,
  level REAL,
  reason TEXT
)
''');
  }

  /// 🔥 TAMBAHKAN INI
  if (oldVersion < 5) {
    await db.execute('ALTER TABLE mood ADD COLUMN note TEXT');
  }
}

  // =====================================================
  // ================= USER ===============================
  // =====================================================

  Future<int> register(String username, String email, String password) async {
    final db = await database;

    return await db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<bool> login(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  Future<bool> checkEmail(String email) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    final db = await database;

    return await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // =====================================================
  // ================= MOOD ===============================
  // =====================================================

 Future<bool> insertMood(
  String email,
  String date,
  int score,
  String note,
) async {
  final db = await database;

  try {
    await db.insert(
      'mood',
      {
        'email': email,
        'date': date,
        'score': score,
        'note': note, // tambahan penting
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  } catch (e) {
    print("Insert Mood Error: $e"); // biar kelihatan kalau error
    return false;
  }
}
  Future<bool> checkTodayMood(String email, String date) async {
    final db = await database;

    final result = await db.query(
      'mood',
      where: 'email = ? AND date = ?',
      whereArgs: [email, date],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getMoodHistory(String email) async {
    final db = await database;

    return await db.query(
      'mood',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getLast7Mood(String email) async {
    final db = await database;

    return await db.query(
      'mood',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
      limit: 7,
    );
  }

  Future<List<int>> getAllMoodScore(String email) async {
  final db = await database;

  final result = await db.query(
    'mood',
    where: 'email = ?',
    whereArgs: [email],
  );

  return result.map((e) => e['score'] as int).toList();
}

  Future<List<int>> getLast7MoodScore(String email) async {
    final data = await getLast7Mood(email);
    return data.map((e) => e['score'] as int).toList();
  }

Future<List<Map<String, dynamic>>> getAllMood(String email) async {
  final db = await database;

  final result = await db.query(
    'mood',
    where: 'email = ?',
    whereArgs: [email],
    orderBy: 'date DESC',
  );

  return result;
}
  Future<List<int>> getLast2Mood(String email) async {
    final db = await database;

    final result = await db.query(
      'mood',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
      limit: 2,
    );

    return result.map((e) => e['score'] as int).toList();
  }

  Future<bool> isMoodDeclining3Days(String email) async {
    final db = await database;

    final result = await db.query(
      'mood',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
      limit: 3,
    );

    if (result.length < 3) return false;

    final moods = result.map((e) => e['score'] as int).toList();

    return moods[0] < moods[1] && moods[1] < moods[2];
  }

  Future<bool> isMoodCritical(String email) async {
    final db = await database;

    final result = await db.query(
      'mood',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (result.isEmpty) return false;

    return (result.first['score'] as int) < 40;
  }

  // =====================================================
  // ================= CHECKIN (NEW SYSTEM) ==============
  // =====================================================

  Future<bool> insertCheckIn(
    String email,
    String date,
    String mood,
    double level,
    String reason,
  ) async {
    final db = await database;

    try {
      await db.insert(
        'checkin',
        {
          'email': email,
          'date': date,
          'mood': mood,
          'level': level,
          'reason': reason,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkTodayCheckIn(String email, String date) async {
    final db = await database;

    final result = await db.query(
      'checkin',
      where: 'email = ? AND date = ?',
      whereArgs: [email, date],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getCheckInHistory(String email) async {
    final db = await database;

    return await db.query(
      'checkin',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
  }

  // =====================================================
  // ================= REFLECTION =========================
  // =====================================================

Future<void> insertReflection({
  required String email,
  required String date,
  required String journal,
  required String answers,
  required String mood,
  required String insight,
}) async {
  final db = await database;

  await db.insert('reflection', {
    'email': email,
    'date': date,
    'journal': journal,
    'answers': answers,
    'mood': mood,
    'insight': insight,
  });
}


  Future<List<Map<String, dynamic>>> getReflectionHistory(String email) async {
    final db = await database;

    return await db.query(
      'reflection',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getReflectionsByEmail(String email) async {
    final db = await database;

    return await db.query(
      'reflection',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
  }

  // =====================================================
  // ================= POINT SYSTEM =======================
  // =====================================================

  Future<void> addPoint(String email, String type, String date) async {
     final db = await database;

  final exists = await db.query(
    'points',
    where: 'email = ? AND type = ? AND date = ?',
    whereArgs: [email, type, date],
    limit: 1,
  );

  if (exists.isEmpty) {
    await db.insert('points', {
      'email': email,
      'type': type,
      'date': date,
    });
  }
}

/// ================= CEK COIN SUDAH DIAMBIL HARI INI =================
Future<bool> hasTodayPoint(String email, String date) async {
  final db = await database;

  final result = await db.query(
    'points',
    where: 'email = ? AND type = ? AND date = ?',
    whereArgs: [email, 'reflect', date],
    limit: 1,
  );

  return result.isNotEmpty;
}
  Future<void> useCoin(String email, int amount) async {
  final db = await database;

  for (int i = 0; i < amount; i += 10) {
    await db.insert('points', {
      'email': email,
      'type': 'redeem', // 🔥 type baru
      'date': DateTime.now().toString(),
    });
  }
}


  Future<int> getTotalPoint(String email) async {
    final db = await database;

    final result = await db.query(
      'points',
      where: 'email = ?',
      whereArgs: [email],
    );

    int total = 0;

    for (var item in result) {
      switch (item['type']) {
        case 'mood':
          total += 20;
          break;
        case 'reflect':
          total += 10;
          break;
        case 'test':
          total += 50;
          break;
          case 'checkin':
          total += 20;
          break;
          case 'redeem':
          total -= 10; // 🔥 INI YANG KAMU TAMBAHIN
          break;
      }
    }

    return total;
  }

  Future<bool> hasClaimedToday(String email, String type, String date) async {
    final db = await database;

    final result = await db.query(
      'points',
      where: 'email = ? AND type = ? AND date = ?',
      whereArgs: [email, type, date],
    );

    return result.isNotEmpty;
  }

  

  Future<bool> canTakeTest(String email) async {
    final db = await database;

    final result = await db.query(
      'points',
      where: 'email = ? AND type = ?',
      whereArgs: [email, 'test'],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (result.isEmpty) return true;

    final lastDate = DateTime.parse(result.first['date'] as String);
    final diff = DateTime.now().difference(lastDate).inDays;

    return diff >= 3;
  }
  Future<List<int>> getLastTestAnswers(String email) async {
  final db = await database;

  final result = await db.query(
    'points',
    where: 'email = ? AND type = ?',
    whereArgs: [email, 'test'],
    orderBy: 'date DESC',
    limit: 45,
  );

  

  return List.generate(result.length, (index) => 50);
}
}



