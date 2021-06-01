import './sign_up_cubit/sign_up_cubit_test.dart' as sign_up;
import './login_cubit/login_cubit_test.dart' as login;
import './poids_mesures_cubit/poids_mesures_cubit_test.dart' as poids_mesures;
import './plan_alimentaire_cubit/plan_alimentaire_cubit_test.dart' as plan_alimentaire;
import './photos_cubit/photos_cubit_test.dart' as photos;
import './photo_detail_cubit/photo_detail_cubit_test.dart' as photo_detail;
import './add_mesures_cubit/add_mesures_cubit_test.dart' as add_mesure;
import './detail_day_comments_cubit/detail_day_comments_test.dart' as detail_day_comment;
import './detail_meal_cubit/detail_meal_cubit_test.dart' as detail_meal;
import './detail_wellbeing_cubit/detail_wellbeing_cubit_test.dart' as detail_wellbeing;
main(){
  sign_up.main();
  login.main();
  poids_mesures.main();
  plan_alimentaire.main();
  photos.main();
  photo_detail.main();
  add_mesure.main();
  detail_day_comment.main();
  detail_meal.main();
  detail_wellbeing.main();
}