import 'package:flutter_dotenv/flutter_dotenv.dart';

const baseUrl="https://newsdata.io/";
String newsUrl='/api/1/latest?country=in&apiKey=${dotenv.env['NEWS_API_KEY']}&language=en';

final List<int> homeTileColors = [
  ///economy background color
  0xFF9AE9D6,
  ///nature
  0xFF9DD296,
  ///food
  0xFFF7D596,
  ///science
  0xFF8DC8FD,
  ///sports
  0xFFEA9D9E,
  ///tech
  0xFFB1A1FC,
];

final labels = ["Business", "Nature", "Health", "Science", "Sports", "Tech"];
