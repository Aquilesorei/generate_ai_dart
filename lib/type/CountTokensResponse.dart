/// Represents a response measuring model input.


class CountTokensResponse {
  /// A count of the number of tokens in the input
  final int _totalTokens;

  CountTokensResponse(this._totalTokens);

  int get totalTokens => _totalTokens;
}
