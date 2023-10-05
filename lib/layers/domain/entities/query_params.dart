abstract class QueryParams {
  String orderDirection = "DESC";
  // size
  int pageLength = 30;
  // offset
  int pageNumber = 1;

  String paramValue(String name, Object? value) {
    return value != null ? '&$name=$value' : '';
  }

  @override
  String toString() {
    return "skip=$pageNumber&limit=$pageLength&orderDirection=$orderDirection";
  }
}
