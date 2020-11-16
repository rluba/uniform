RANGES :: RuneRange.[
	.{10, 10},
	.{12, 15},
	.{20, 25},
];

Range_Test_Args :: struct {
	range: RuneRange;
	found: bool;
	index: int;
}

returns_an_overlapping_range_or_the_insertion_index_params :: Range_Test_Args.[
	.{.{0, 0}, false, 0},
	.{.{0, 10}, true, 0},
	.{.{10, 10}, true, 0},
	.{.{10, 12}, true, 1},
	.{.{11, 11}, false, 1},
	.{.{12, 12}, true, 1},
	.{.{13, 14}, true, 1},
	.{.{15, 15}, true, 1},
	.{.{15, 19}, true, 1},
	.{.{16, 16}, false, 2},
	.{.{15, 25}, true, 1},
	.{.{20, 20}, true, 2},
	.{.{20, 25}, true, 2},
	.{.{26, 27}, false, 3},
];

returns_an_overlapping_range_or_the_insertion_index :: (args: Range_Test_Args) {
	ranges := RANGES;
	range, result, found := find_range(ranges, args.range);

	assert_that(found, is(args.found));
	assert_that(result, is(args.index));
} @Test
