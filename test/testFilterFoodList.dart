test_FilterFoodList() {
  // Arrange
  List food = [{category: "Herb", name: "Basil"}, {category: "Fruit", name: "Strawberry"}, {category: "Fruit", name: "Banana"}];
  String category = "category";
  String filter = "Fruit";
  List expectedOutput = [{category: "Fruit", name: "Strawberry"}, {category: "Fruit", name: "Banana"}];

  // Act
  List result = FilterFoodList(food, category, filter);

  // Assert
  assert(result == expectedOutput, "Expected output did not match actual output");
}
