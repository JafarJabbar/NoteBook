class DateHelper{

  String dateFormat(DateTime tm){

    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Yanvar";
        break;
      case 2:
        month = "Fevral";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Aprel";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "İyun";
        break;
      case 7:
        month = "İyul";
        break;
      case 8:
        month = "Avqust";
        break;
      case 9:
        month = "Sentyabr";
        break;
      case 10:
        month = "Oktyabr";
        break;
      case 11:
        month = "Noyabr";
        break;
      case 12:
        month = "Dekabr";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dünən";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Bazar ertəsi";
        case 2:
          return "Çərşənbə axşamı";
        case 3:
          return "Çərşənbə";
        case 4:
          return "Cümə axşamı";
        case 5:
          return "Cümə";
        case 6:
          return "Şənbə";
        case 7:
          return "Bazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";


  }


}