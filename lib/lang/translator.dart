import 'package:bulls_n_cows_reloaded/lang/pt_br.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'en_us.dart';
import 'es_es.dart';

class Translator extends Translations {

  //Fallback locale
  static const fallbackLocale = Locale('en');

  @override
  Map<String, Map<String, String>> get keys => {
    'en' : enUS,
    'es' : esES,
    'pt' : ptBR,
  };

}