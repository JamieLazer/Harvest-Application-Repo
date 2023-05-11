import 'package:mysql1/mysql1.dart';

class Invite {
   final int sender_id;
   final String r_email;
   final int sender_log;
   late MySqlConnection connection;

   Invite(this.sender_id, this.r_email, this.sender_log);

   Future<void> openDatabase() async {
      var settings = ConnectionSettings(
         host: 'db4free.net',
         port: 3306,
         user: 'hardcoded',
         password: '5Scrummies@SD',
         db: 'harvestapp',
      );
      connection = await MySqlConnection.connect(settings);
   }

   Future<void> sendInvite() async {
      await openDatabase();

      try {
         final result = await connection.query(
             'INSERT INTO INVITATIONS (SENDER_ID, RECIPIENT_EMAIL, SENDER_LOG) VALUES (?, ?, ?)',
             [sender_id, r_email, sender_log]);

      } catch (e) {
         print(e);
         // Handle any exceptions that occur during the query execution
      } finally {
         await connection.close();
      }
   }
}
