Match_Args :: struct {
	pattern: string;
	text: string;
	anchor: Anchor;
	expected_matches: [] string;
}

returns_all_matches_if_the_expression_matches_params :: Match_Args.[
	.{"", "", .UNANCHORED, .[""]},
	.{"", "", .ANCHOR_START, .[""]},
	.{"", "", .ANCHOR_BOTH, .[""]},
	.{"a", "", .UNANCHORED, .[]},
	.{"a", "b", .UNANCHORED, .[]},
	.{"a", "a", .UNANCHORED, .["a"]},
	.{"a", "a", .ANCHOR_START, .["a"]},
	.{"a", "a", .ANCHOR_BOTH, .["a"]},
	.{"a", "ba", .UNANCHORED, .["a"]},
	.{"a", "ba", .ANCHOR_START, .[]},
	.{"a", "ba", .ANCHOR_BOTH, .[]},
	.{"a", "ab", .UNANCHORED, .["a"]},
	.{"a", "ab", .ANCHOR_START, .["a"]},
	.{"a", "ab", .ANCHOR_BOTH, .[]},
	.{"a*", "b", .UNANCHORED, .[""]},
	.{"a*", "baa", .UNANCHORED, .[""]},
	.{"a*", "baa", .ANCHOR_START, .[""]},
	.{"a*", "baa", .ANCHOR_BOTH, .[]},
	.{"a+", "b", .UNANCHORED, .[]},
	.{"a+", "baa", .UNANCHORED, .["aa"]},
	.{"a+", "baa", .ANCHOR_START, .[]},
	.{"(a)+", "baa", .UNANCHORED, .["aa", "a"]},
	.{"(a+)", "baa", .UNANCHORED, .["aa", "aa"]},
	.{"((b)(a+))", "baa", .UNANCHORED, .["baa", "baa", "b", "aa"]},
	.{"^a+", "baa", .UNANCHORED, .[]},
	.{"^a+", "axaaa", .UNANCHORED, .["a"]},
	.{"a+$", "ab", .UNANCHORED, .[]},
	.{"a+$", "axaaa", .UNANCHORED, .["aaa"]},
	.{"a[bc]?d", "abcd", .UNANCHORED, .[]},
	.{"a[bc]?d", "ab", .UNANCHORED, .[]},
	.{"a[bc]?d", "xadx", .UNANCHORED, .["ad"]},
	.{"a[bc]?d", "xabdx", .UNANCHORED, .["abd"]},
	.{"a[bc]?d", "xacdx", .UNANCHORED, .["acd"]},
	.{"a[bc]{2}d", "xacdx", .UNANCHORED, .[]},
	.{"a[bc]{2}d", "xacbdx", .UNANCHORED, .["acbd"]},
	.{"a[bc]{2}d", "xacbcdx", .UNANCHORED, .[]},
	.{"a[bc]{1,}d", "xacdx", .UNANCHORED, .["acd"]},
	.{"a[bc]{1,}d", "xacbcdx", .UNANCHORED, .["acbcd"]},
	.{"a[bc]{1,}d", "xacbcbdx", .UNANCHORED, .["acbcbd"]},
	.{"a[bc]{1,3}d", "xacdx", .UNANCHORED, .["acd"]},
	.{"a[bc]{1,3}d", "xacbcdx", .UNANCHORED, .["acbcd"]},
	.{"a[bc]{1,3}d", "xacbcbdx", .UNANCHORED, .[]},
	.{"a(?:bc)", "xabcx", .UNANCHORED, .["abc"]},
	.{"a(:?bc)", "xabcx", .UNANCHORED, .["abc", "bc"]},
	.{"^fo", "ofo", .UNANCHORED, .[]},
	.{"^fo", "fo", .UNANCHORED, .["fo"]},
	.{"^fo", "foooo", .UNANCHORED, .["fo"]},
	.{"^fo(o+)", "foooo", .UNANCHORED, .["foooo", "ooo"]},
	.{"^fo$", "foo", .UNANCHORED, .[]},
	.{"^fo$", "ofo", .UNANCHORED, .[]},
	.{"^fo$", "fo", .UNANCHORED, .["fo"]},
	.{"^f(o+)$", "fo", .UNANCHORED, .["fo", "o"]},
	.{"^f(o+)$", "foo", .UNANCHORED, .["foo", "oo"]},
	.{"^f(o+)$", "foosball", .UNANCHORED, .[]},
	.{"[^a]+", "some", .UNANCHORED, .["some"]},
	.{"[^a]+", "ahem", .UNANCHORED, .["hem"]},
	.{"[^a]+", "ahem", .ANCHOR_START, .[]},
	.{".*", "something", .UNANCHORED, .["something"]},
	.{"some(.*)thing", "something", .UNANCHORED, .["something", ""]},
	.{"some(.*)thing", "some other thing", .UNANCHORED, .["some other thing", " other "]},
	.{"beta", "xbxx", .UNANCHORED, .[]},
	.{"beta", "bxxx", .UNANCHORED, .[]},
];

returns_all_matches_if_the_expression_matches :: (args: Match_Args) {
	matched, matches := match(args.text, args.pattern, args.anchor);

	assert_that(matched, is(args.expected_matches.count > 0));
	if matched {
		assert_that(matches, contains_items(..args.expected_matches));
	}
} @Test
