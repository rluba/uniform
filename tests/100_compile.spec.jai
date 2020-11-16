simplifies_a_parsed_regexp_without_error_params :: Stringify_Test_Args.[
	.{"", ""},
	.{"a", "a"},
	.{"abcd", "abcd"},
	.{"ab(cd)", "ab(cd)"},
	.{"a{2}", "aa"},
	.{"[ac]{2}", "[ac][ac]"},
	.{"[abc]{2}", "[a-c][a-c]"},
	.{"[ac]{2,}", "[ac][ac]+"},
	.{"[ac]{2,4}", "[ac][ac](?:[ac][ac]?)?"},
	.{"a[bc]{2}d", "a[b-c][b-c]d"},
	.{"ab?(cd)+", "ab?(cd)+"},
	.{"ab?(cd)+a*(:?foo)?", "ab?(cd)+a*(:?foo)?"},
	.{"a*", "a*"},
];

simplifies_a_parsed_regexp_without_error :: (args: Stringify_Test_Args) {
	parsed, status, pool := parse(args.pattern);
	defer uninit(*pool);

	result := simplify(parsed, *pool);

	assert_that(result, is_not(null));
	stringified := to_string(result);
	defer free(stringified);
	assert_that(stringified, is(args.expected_string));
} @Test

compiles_a_parsed_regexp_without_error_params :: string.[
	"",
	"a",
	"abcd",
	"ab(cd)",
	"a{2}",
	"[ab]{2}",
	"[ab]{2,}",
	"[ab]{2,4}",
	"a[bc]{2}d",
	"ab?(cd)+",
	"ab?(cd)+a*(:?foo)?",
	"a*",
	"[^a]", // This range contains both single-byte and multi-byte utf-8 characters
	".",
	".*",
];

compiles_a_parsed_regexp_without_error :: (re_string: string) {
	parsed, status, pool := parse(re_string);
	defer uninit(*pool);

	re := compile(parsed, *pool);

	assert_that(re, is_not(null));
} @Test

#scope_file

Stringify_Test_Args :: struct {
	pattern: string;
	expected_string: string;
}

