String extractYoutubeId(String url) {
  // Handle youtu.be URLs (shortened)
  if (url.contains('youtu.be')) {
    return url.split('/').last.split('?').first;
  }

  // Handle full URLs with v= parameter
  final regExp = RegExp(
    r'.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
  );
  final match = regExp.firstMatch(url);
  return (match != null && match.group(7)!.length == 11) ? match.group(7)! : '';
}
