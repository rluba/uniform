Anchor :: enum {
	Unanchored;         // No anchoring
	Anchor_Start;       // Anchor at start only
	Anchor_Both;        // Anchor at start and end
}

// See comile.jai and match.jai for details

#scope_module

REGEXP_DEBUG :: false;

report_error :: (format: string, args: .. Any) {
    log(format, .. args);
}

// @ToDo: Move to a common utility module
array_view :: inline (array: [] $T, index: int, count: int) -> [] T {
    assert(index >= 0, "index = %", index);
    assert(count >= 0, "count = %", count);
    assert(index <= array.count, "index too large: % of %", index, array.count);
    assert(index + count <= array.count, "index too large: % of %", index, array.count);
	c: [] T = ---;
    if index >= array.count {
		c.data = null;
		c.count = 0;
		return c;
	}

    c.data = array.data + index;
    c.count = count;
    return c;
}

#scope_file

#load "char_class.jai";
#load "compile.jai";
#load "match.jai";
#load "nfa.jai";
#load "parse.jai";
#load "program.jai";
#load "rune.jai";
#load "simplify.jai";
#load "sparse.jai";
#load "unicode_casefold.jai";
#load "unicode_group.jai";
#load "walk.jai";
