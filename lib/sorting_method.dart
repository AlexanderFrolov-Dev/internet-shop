enum SortingMethod {
  byPriceIncrease('По цене↑'),
  byPriceDecrease('По цене↓'),
  byAlphabet('По названию↑'),
  byReverseAlphabet('По названию↓');

  const SortingMethod(this.label);
  final String label;
}