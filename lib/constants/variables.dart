class MomentCalendarFormatting {
  final String lastDay;
  final String sameDay;
  final String nextDay;
  final String lastWeek;
  final String nextWeek;
  final String sameElse;

  MomentCalendarFormatting({
    this.lastDay,
    this.sameDay,
    this.nextDay,
    this.lastWeek,
    this.nextWeek,
    this.sameElse,
  });
}

MomentCalendarFormatting calendarStrings = MomentCalendarFormatting(
  lastDay: '[Yesterday at] LT',
  sameDay: '[Today at] LT',
  nextDay: '[Tomorrow at] LT',
  lastWeek: '[last] dddd [at] LT',
  nextWeek: 'dddd [at] LT',
  sameElse: 'L',
);
