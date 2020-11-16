Parse_Regexp_Args :: struct {
	p: string;
	flags := ParseFlags.NoParseFlags;
	status := Status.{.Success, ""};
}

parses_simple_patterns_correctly_params :: Parse_Regexp_Args.[
	.{p=""},
	.{p="a"},
	.{p="abcd"},
	.{p="ab(cd", status = .{.MissingParen, "ab(cd"}},
	.{p="ab(cd)"},
	.{p="ab[cx", status = .{.MissingBracket, "[cx"}},
	.{p="ab[cx]"},
	.{p="a{2}"},
	.{p="a{2,}"},
	.{p="a{2,4}"},
	.{p="[ac]{2}"},
	.{p="[ac]{2,}"},
	.{p="[ac]{2,4}"},
	.{p="[ac]{2}x"},
	.{p="([ac]{2})?"},
	.{p="a*b?(cd)+"},
	.{p="(?:foo)?bar", status = .{.RepeatArgument, "?"}},
	.{p="(?:foo)?bar", flags = .LikePerl},
	.{p="\\bbar\\B", status = .{.BadEscape, "\\b"}},
	.{p="\\bbar\\B", flags = .LikePerl},
	.{p="foo\\sbar", status = .{.BadEscape, "\\s"}},
	.{p="^fo"},
	.{p="fo$"},
	.{p="^fo$"},
];

parses_simple_patterns_correctly :: (args: Parse_Regexp_Args) {
	result, status, pool := parse(args.p, args.flags);
	defer uninit(*pool);

	if args.status.code == .Success {
		assert_that(status, is(Status.{.Success, ""}, equal_status));
		assert_that(result, is_not(null));
		stringified := to_string(result);
		defer free(stringified);
		assert_that(stringified, is(args.p));
	} else {
		assert_that(result, is(null));
		assert_that(status, is(args.status, equal_status));
	}
} @Test

simplifies_char_classes_if_possible_params :: Stringify_Test_Args.[
	.{p="[a]", e="a"},
	.{p="[ac]", e="[ac]"},
	.{p="[ab]", e="[a-b]"},
	.{p="[abcdefg]", e="[a-g]"},
	.{p="[aefbcdg]", e="[a-g]"},
	.{p="\\s", e="[\\t-\\n\\f-\\r ]", flags = .LikePerl},
];

simplifies_char_classes_if_possible :: (args: Stringify_Test_Args) {
	result, status, pool := parse(args.p, args.flags);
	defer uninit(*pool);

	assert_that(result, is_not(null));
	stringified := to_string(result);
	defer free(stringified);
	assert_that(stringified, is(args.e));
} @Test

#scope_file

equal_status :: (a: Status, b: Status) -> bool {
	return a.code == b.code && a.error_arg == b.error_arg;
}

Stringify_Test_Args :: struct {
	p: string;
	flags := ParseFlags.NoParseFlags;
	e: string;
}

