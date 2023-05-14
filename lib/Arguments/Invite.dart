import 'package:mysql1/mysql1.dart';

class Invite {
   final int sender_id;
   final String r_email;
   final String sender_log_name;
   final int sender_logid;
   late MySqlConnection connection;

   Invite(this.sender_id, this.r_email, this.sender_log_name,this.sender_logid);

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
         final result=await connection.query(
            "SELECT user_fname,user_lname FROM USERS WHERE user_id=?",[sender_id]
         );
         result.toList();
         final rows = result.toList();
         final row = rows.first;
         final name = row['user_fname'] as String;
         final surname = row['user_lname'] as String;
         final result2 = await connection.query(
             'INSERT IGNORE INTO INVITATIONS (SENDER_NAME, RECIPIENT_EMAIL, S_GARDEN_NAME,S_GARDEN_ID) VALUES (?, ?, ?,?)',
             ["${name} ${surname}", r_email, sender_log_name,sender_logid]);

      } catch (e) {
         print(e);
         print("failed at invite");
         // Handle any exceptions that occur during the query execution
      } finally {
         await connection.close();
      }
   }
}
