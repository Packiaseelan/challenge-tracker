String getTimeGreeting() {
  int hours = new DateTime.now().hour;

  if (hours >= 1 && hours <= 12) {
    return 'Good Morning';
  } else if (hours >= 12 && hours <= 16) {
    return 'Good Afternoon';
  } else if (hours >= 16 && hours <= 21) {
    return 'Good Evening';
  } else if (hours >= 21 && hours <= 24) {
    return 'Good Night';
  } else {
    return 'Good Day';
  }
}
