Match_Args :: struct {
	pattern: string;
	text: string;
	anchor: Anchor;
	expected: bool;
	expected_matches: [] string;
}

returns_all_matches_if_the_expression_matches_params :: Match_Args.[
	.{"", "", .Unanchored, true, .[""]},
	.{"", "", .Anchor_Start, true, .[""]},
	.{"", "", .Anchor_Both, true, .[""]},
	.{"a", "", .Unanchored, false, .[]},
	.{"a", "b", .Unanchored, false, .[]},
	.{"a", "a", .Unanchored, true, .["a"]},
	.{"a", "a", .Anchor_Start, true, .["a"]},
	.{"a", "a", .Anchor_Both, true, .["a"]},
	.{"a", "ba", .Unanchored, true, .["a"]},
	.{"a", "ba", .Anchor_Start, false, .[]},
	.{"a", "ba", .Anchor_Both, false, .[]},
	.{"a", "ab", .Unanchored, true, .["a"]},
	.{"a", "ab", .Anchor_Start, true, .["a"]},
	.{"a", "ab", .Anchor_Both, false, .[]},
	.{"a*", "b", .Unanchored, true, .[""]},
	.{"a*", "baa", .Unanchored, true, .[""]},
	.{"a*", "baa", .Anchor_Start, true, .[""]},
	.{"a*", "baa", .Anchor_Both, false, .[]},
	.{"a+", "b", .Unanchored, false, .[]},
	.{"a+", "baa", .Unanchored, true, .["aa"]},
	.{"a+", "baa", .Anchor_Start, false, .[]},
	.{"(a)+", "baa", .Unanchored, true, .["aa", "a"]},
	.{"(a+)", "baa", .Unanchored, true, .["aa", "aa"]},
	.{"((b)(a+))", "baa", .Unanchored, true, .["baa", "baa", "b", "aa"]},
	.{"^a+", "baa", .Unanchored, false, .[]},
	.{"^a+", "axaaa", .Unanchored, true, .["a"]},
	.{"a+$", "ab", .Unanchored, false, .[]},
	.{"a+$", "axaaa", .Unanchored, true, .["aaa"]},
	.{"a[bc]?d", "abcd", .Unanchored, false, .[]},
	.{"a[bc]?d", "ab", .Unanchored, false, .[]},
	.{"a[bc]?d", "xadx", .Unanchored, true, .["ad"]},
	.{"a[bc]?d", "xabdx", .Unanchored, true, .["abd"]},
	.{"a[bc]?d", "xacdx", .Unanchored, true, .["acd"]},
	.{"a[bc]{2}d", "xacdx", .Unanchored, false, .[]},
	.{"a[bc]{2}d", "xacbdx", .Unanchored, true, .["acbd"]},
	.{"a[bc]{2}d", "xacbcdx", .Unanchored, false, .[]},
	.{"a[bc]{1,}d", "xacdx", .Unanchored, true, .["acd"]},
	.{"a[bc]{1,}d", "xacbcdx", .Unanchored, true, .["acbcd"]},
	.{"a[bc]{1,}d", "xacbcbdx", .Unanchored, true, .["acbcbd"]},
	.{"a[bc]{1,3}d", "xacdx", .Unanchored, true, .["acd"]},
	.{"a[bc]{1,3}d", "xacbcdx", .Unanchored, true, .["acbcd"]},
	.{"a[bc]{1,3}d", "xacbcbdx", .Unanchored, false, .[]},
	.{"a(?:bc)", "xabcx", .Unanchored, true, .["abc"]},
	.{"a(:?bc)", "xabcx", .Unanchored, true, .["abc", "bc"]},
	.{"^fo", "ofo", .Unanchored, false, .[]},
	.{"^fo", "fo", .Unanchored, true, .["fo"]},
	.{"^fo", "foooo", .Unanchored, true, .["fo"]},
	.{"^fo(o+)", "foooo", .Unanchored, true, .["foooo", "ooo"]},
	.{"^fo$", "foo", .Unanchored, false, .[]},
	.{"^fo$", "ofo", .Unanchored, false, .[]},
	.{"^fo$", "fo", .Unanchored, true, .["fo"]},
	.{"^f(o+)$", "fo", .Unanchored, true, .["fo", "o"]},
	.{"^f(o+)$", "foo", .Unanchored, true, .["foo", "oo"]},
	.{"^f(o+)$", "foosball", .Unanchored, false, .[]},
	.{"[^a]+", "some", .Unanchored, true, .["some"]},
	.{"[^a]+", "ahem", .Unanchored, true, .["hem"]},
	.{"[^a]+", "ahem", .Anchor_Start, false, .[]},
	.{".*", "something", .Unanchored, true, .["something"]},
	.{"some(.*)thing", "something", .Unanchored, true, .["something", ""]},
	.{"some(.*)thing", "some other thing", .Unanchored, true, .["some other thing", " other "]},
];

returns_all_matches_if_the_expression_matches :: (args: Match_Args) {
	matched, matches := match(args.text, args.pattern, args.anchor);

	assert_that(matched, is(args.expected));
	if matched {
		assert_that(matches, contains_items(..args.expected_matches));
	}
} @Test
