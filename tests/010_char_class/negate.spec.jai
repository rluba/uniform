converts_a_full_range_into_an_empty_one :: () {
	char_class: CharClass;
	add_range(*char_class, 0, Runemax);

	negate(*char_class);

	assert_that(char_class.ranges.count, is(0));
} @Test

converts_an_empty_range_into_a_full_one :: () {
	char_class: CharClass;

	negate(*char_class);

	assert_that(char_class.ranges, contains_items(
		make_range(0, Runemax),
	is_equal = equal_range));
} @Test

// ToDo: report error if this still crashes with beta >=031
// Simple_Range_Test_Args :: struct {
// 	input: [] RuneRange;
// 	expected: [] RuneRange;
// };

// converts_a_partial_range_into_the_rest_params :: Simple_Range_Test_Args.[
// 	.{
// 		RuneRange.[],
// 		RuneRange.[.{0, Runemax}]
// 	},
// 	.{
// 		RuneRange.[.{0, Runemax}],
// 		RuneRange.[]
// 	},
// 	.{
// 		RuneRange.[.{0, 100}],
// 		RuneRange.[.{101, Runemax}]
// 	},
// ];

Simple_Range_Test_Args :: struct {
	input: RuneRange;
	expected: RuneRange;
};

converts_a_partial_range_into_the_rest_params :: Simple_Range_Test_Args.[
	.{
		.{0, 100},
		.{101, Runemax}
	},
	.{
		.{100, Runemax},
		.{0, 99},
	},
];

converts_a_partial_range_into_the_rest :: (args: Simple_Range_Test_Args) {
	char_class: CharClass;
	add_range(*char_class, args.input.lo, args.input.hi);

	negate(*char_class);

	assert_that(char_class.ranges, contains_items(
		args.expected,
	is_equal = equal_range));
} @Test

converts_all_ranges_correctly :: () {
	char_class: CharClass;
	add_range(*char_class, 100, 150);
	add_range(*char_class, 160, 170);

	negate(*char_class);

	assert_that(char_class.ranges, contains_items(
		make_range(0, 99),
		make_range(151, 159),
		make_range(171, Runemax),
	is_equal = equal_range));
} @Test

converts_all_ranges_correctly_2 :: () {
	char_class: CharClass;
	add_range(*char_class, 0, 100);
	add_range(*char_class, 200, Runemax);

	negate(*char_class);

	assert_that(char_class.ranges, contains_items(
		make_range(101, 199),
	is_equal = equal_range));
} @Test

#scope_file

equal_range :: (a: RuneRange, b: RuneRange) -> bool {
	return a.lo == b.lo && a.hi == b.hi;
}
