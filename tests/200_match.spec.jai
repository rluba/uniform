Match_Args :: struct {
	pattern: string;
	text: string;
	anchor: Anchor;
	expected_matches: [] string;
}

returns_all_matches_if_the_expression_matches_params :: Match_Args.[
	.{"", "", .Unanchored, .[""]},
	.{"", "", .Anchor_Start, .[""]},
	.{"", "", .Anchor_Both, .[""]},
	.{"a", "", .Unanchored, .[]},
	.{"a", "b", .Unanchored, .[]},
	.{"a", "a", .Unanchored, .["a"]},
	.{"a", "a", .Anchor_Start, .["a"]},
	.{"a", "a", .Anchor_Both, .["a"]},
	.{"a", "ba", .Unanchored, .["a"]},
	.{"a", "ba", .Anchor_Start, .[]},
	.{"a", "ba", .Anchor_Both, .[]},
	.{"a", "ab", .Unanchored, .["a"]},
	.{"a", "ab", .Anchor_Start, .["a"]},
	.{"a", "ab", .Anchor_Both, .[]},
	.{"a*", "b", .Unanchored, .[""]},
	.{"a*", "baa", .Unanchored, .[""]},
	.{"a*", "baa", .Anchor_Start, .[""]},
	.{"a*", "baa", .Anchor_Both, .[]},
	.{"a+", "b", .Unanchored, .[]},
	.{"a+", "baa", .Unanchored, .["aa"]},
	.{"a+", "baa", .Anchor_Start, .[]},
	.{"(a)+", "baa", .Unanchored, .["aa", "a"]},
	.{"(a+)", "baa", .Unanchored, .["aa", "aa"]},
	.{"((b)(a+))", "baa", .Unanchored, .["baa", "baa", "b", "aa"]},
	.{"^a+", "baa", .Unanchored, .[]},
	.{"^a+", "axaaa", .Unanchored, .["a"]},
	.{"a+$", "ab", .Unanchored, .[]},
	.{"a+$", "axaaa", .Unanchored, .["aaa"]},
	.{"a[bc]?d", "abcd", .Unanchored, .[]},
	.{"a[bc]?d", "ab", .Unanchored, .[]},
	.{"a[bc]?d", "xadx", .Unanchored, .["ad"]},
	.{"a[bc]?d", "xabdx", .Unanchored, .["abd"]},
	.{"a[bc]?d", "xacdx", .Unanchored, .["acd"]},
	.{"a[bc]{2}d", "xacdx", .Unanchored, .[]},
	.{"a[bc]{2}d", "xacbdx", .Unanchored, .["acbd"]},
	.{"a[bc]{2}d", "xacbcdx", .Unanchored, .[]},
	.{"a[bc]{1,}d", "xacdx", .Unanchored, .["acd"]},
	.{"a[bc]{1,}d", "xacbcdx", .Unanchored, .["acbcd"]},
	.{"a[bc]{1,}d", "xacbcbdx", .Unanchored, .["acbcbd"]},
	.{"a[bc]{1,3}d", "xacdx", .Unanchored, .["acd"]},
	.{"a[bc]{1,3}d", "xacbcdx", .Unanchored, .["acbcd"]},
	.{"a[bc]{1,3}d", "xacbcbdx", .Unanchored, .[]},
	.{"a(?:bc)", "xabcx", .Unanchored, .["abc"]},
	.{"a(:?bc)", "xabcx", .Unanchored, .["abc", "bc"]},
	.{"^fo", "ofo", .Unanchored, .[]},
	.{"^fo", "fo", .Unanchored, .["fo"]},
	.{"^fo", "foooo", .Unanchored, .["fo"]},
	.{"^fo(o+)", "foooo", .Unanchored, .["foooo", "ooo"]},
	.{"^fo$", "foo", .Unanchored, .[]},
	.{"^fo$", "ofo", .Unanchored, .[]},
	.{"^fo$", "fo", .Unanchored, .["fo"]},
	.{"^f(o+)$", "fo", .Unanchored, .["fo", "o"]},
	.{"^f(o+)$", "foo", .Unanchored, .["foo", "oo"]},
	.{"^f(o+)$", "foosball", .Unanchored, .[]},
	.{"[^a]+", "some", .Unanchored, .["some"]},
	.{"[^a]+", "ahem", .Unanchored, .["hem"]},
	.{"[^a]+", "ahem", .Anchor_Start, .[]},
	.{".*", "something", .Unanchored, .["something"]},
	.{"some(.*)thing", "something", .Unanchored, .["something", ""]},
	.{"some(.*)thing", "some other thing", .Unanchored, .["some other thing", " other "]},
];

returns_all_matches_if_the_expression_matches :: (args: Match_Args) {
	matched, matches := match(args.text, args.pattern, args.anchor);

	assert_that(matched, is(args.expected_matches.count > 0));
	if matched {
		assert_that(matches, contains_items(..args.expected_matches));
	}
} @Test
