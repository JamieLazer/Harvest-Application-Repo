import 'package:mysql1/mysql1.dart';

class OpenDataBase {
  MySqlConnection? connection;

  Future<MySqlConnection> openDatabase() async {
    if (connection != null) {
      return connection!;
    }

    var settings = ConnectionSettings(
      host: 'db4free.net',
      port: 3306,
      user: 'hardcoded',
      password: '5Scrummies@SD',
      db: 'harvestapp',
    );
    connection = await MySqlConnection.connect(settings);
    return connection!;
  }
}
