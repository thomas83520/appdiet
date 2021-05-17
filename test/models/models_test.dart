import './signin_login/password_test.dart' as password;
import './signin_login/name_test.dart' as name;
import './signin_login/first_name_test.dart' as first_name;
import './signin_login/email_test.dart' as email;
import './signin_login/confirm_password_test.dart' as confirm_password;
import './signin_login/code_diet_test.dart' as code_diet;
import './signin_login/birth_date_date.dart' as birth_date;
import './chat/chat_message_test.dart' as chat_message;
import './poids_mesures/poids_mesures_test.dart' as poids_mesures;
import './photos/photos_detail_test.dart' as photo_detail;
import './journal/repas_test.dart' as repas;
import './journal/journal_test.dart' as journal;
import './journal/welbeing_test.dart' as wellBeing;
import './journal/day_comments_test.dart' as day_comments;
import './goal/goals_test.dart' as goal;

void main() {
  //signin_login
  password.main();
  name.main();
  first_name.main();
  email.main();
  confirm_password.main();
  code_diet.main();
  birth_date.main();

  //chat
  chat_message.main();

  //Poids mesures
  poids_mesures.main();

  //goal
  goal.main();

  //journal
  repas.main();
  wellBeing.main();
  day_comments.main();
  journal.main();

  //photos
  photo_detail.main();

}