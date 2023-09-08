abstract class ISearchListener {
  void startSearch();

  void stopSearch();

  void updateSearchQuery(String newQuery);

  void clearSearchQuery();
}
