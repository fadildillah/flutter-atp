import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  final String tableTrips = 'trips';
  final String columnId = 'id';
  final String columnDestinationId = 'destination_id';
  final String columnStartTime = 'start_time';
  final String columnStatus = 'status';

  final String tableUserLocations = 'user_locations';
  final String columnULId = 'id';
  final String columnULTripId = 'trip_id';
  final String columnULLatitude = 'latitude';
  final String columnULLongitude = 'longitude';
  final String columnULTimestamp = 'timestamp';

  final String tableTripStations = 'trip_stations';
  final String columnTSId = 'id';
  final String columnTSStationId = 'station_id';
  final String columnTSStartTime = 'start_time';
  final String columnTSStatus = 'status';

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'atp_main.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableTrips (
            $columnId TEXT PRIMARY KEY,
            $columnDestinationId TEXT,
            $columnStartTime TEXT,
            $columnStatus TEXT
          CHECK ($columnStatus IN ('ongoing', 'success'))
          )
          ''');
        await db.execute('''
          CREATE TABLE $tableUserLocations (
            $columnULId TEXT PRIMARY KEY,
            $columnULTripId TEXT,
            $columnULLatitude REAL,
            $columnULLongitude REAL,
            $columnULTimestamp TEXT,
            FOREIGN KEY ($columnULTripId) REFERENCES $tableTrips($columnId)
          )
          ''');
        await db.execute('''
          CREATE TABLE $tableTripStations (
            $columnTSId TEXT PRIMARY KEY,
            $columnTSStationId INTEGER,
            $columnTSStartTime TEXT,
            $columnTSStatus TEXT
            CHECK ($columnTSStatus IN ('ongoing', 'success'))
          )
        ''');
      },
    );
  }
}
