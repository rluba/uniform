inserts_the_new_range_at_the_right_position_1 :: () {
	char_class: CharClass;
	add_range(*char_class, 0, 1);
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);
	assert_that(char_class.ranges, contains_items(
		make_range(0, 1),
		make_range(3, 4),
		make_range(6, 10),
	is_equal = equal_range));
} @Test

merges_ranges_correctly :: () {
	char_class: CharClass;
	add_range(*char_class, 0, 1);
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);

	add_range(*char_class, 2, 2);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 4),
		make_range(6, 10),
	is_equal = equal_range));
} @Test

merges_ranges_correctly_2 :: () {
	char_class: CharClass;
	add_range(*char_class, 0, 1);
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);

	add_range(*char_class, 2, 4);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 4),
		make_range(6, 10),
	is_equal = equal_range));
} @Test

merges_ranges_correctly_3 :: () {
	char_class: CharClass;
	add_range(*char_class, 0, 1);
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);

	add_range(*char_class, 2, 5);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 10),
	is_equal = equal_range));
} @Test

merges_ranges_correctly_4 :: () {
	char_class: CharClass;
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);
	add_range(*char_class, 0, 1);

	add_range(*char_class, 2, 20);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 20),
	is_equal = equal_range));
} @Test

merges_ranges_correctly_5 :: () {
	char_class: CharClass;
	add_range(*char_class, 6, 10);
	add_range(*char_class, 3, 4);
	add_range(*char_class, 0, 1);

	add_range(*char_class, 3, 20);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 1),
		make_range(3, 20),
	is_equal = equal_range));
} @Test

#scope_file

equal_range :: (a: RuneRange, b: RuneRange) -> bool {
	return a.lo == b.lo && a.hi == b.hi;
}
