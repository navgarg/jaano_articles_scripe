import 'package:flutter_dotenv/flutter_dotenv.dart';

const baseUrl="https://newsdata.io/";
String newsUrl='/api/1/latest?country=in&apiKey=${dotenv.env['NEWS_API_KEY']}&language=en';