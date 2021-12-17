# Uniform – a fully-featured regular expression library for Jai

This library is a partial port of [RE2](https://github.com/google/re2).
As such, it offers "fast" expression matching of the full PRCE syntax (except backreferences)
but is _not exponential in the length of the input text_.

This library is still in _very_ rough condition and only minimally tested.
Proceed with caution. There may be dragons.

For now, it only supports RE2’s general NFA execution engine and
none of RE2’s conditional fast-paths (DFA, single-pass NFA, …).
So "fast" isn’t as fast as it could be for some subsets of regular expressions.

See [Russ Cox’s excellent article series](https://swtch.com/~rsc/regexp/) for more information about fast regular expression implementations and details about the different execution engines.

## Usage 

The simplest form is:

```Jai
// Match anywhere in the text:
matched, captures := match("text_to_search", "some\\sexpression\\b");
defer array_free(captures);

// … or anchor it to require the expression to match the whole text:
matched, captures := match("text_to_search", "some\\sexpression\\b", .Anchored_Both);
defer array_free(captures);
```

… after which:

* `matched` indicates whether the expression matched the text,
* `captures[0]` contains the whole match and
* `captures[1]` through `[n]` the content of each capture group (`(…)`) in the expression.

The captures reference segments of the original text, so they’re only valid as long as
the text exists. You need to copy them if you want them to persist.
This also means that you need to free only the capture array, but not its contents.

### Recommended: compiling the expression
Compiling the regular expression is the slowest part.
If you use an expression multiple times (or want more control about available regular expression features),
you should definitely compile it beforehand:

```Jai
regexp, success := compile("some\\sexpression\\b");
defer uninit(*regexp);

// Use regexp as often as you want…
for text: texts {
	matched, captures := match(text, regexp);
	defer array_free(captures);
}
```

See [compile.jai](./compile.jai) and [match.jai](./match.jai) for additional options.

## Running the tests

Running the tests requires the [`stubborn` module](https://github.com/rluba/stubborn).
It’s already included as a submodule, but don’t forget the usual git submodule shenanigans to fetch it.

Compile with `<compiler> first.jai -- test`, then run the `test` binary.
(The tests should run at compile-time but this is currently broken in the compiler.)

## Compiling the library

If you want to compile the library (even though it doesn’t produce any binary),
you need the [`ctags` module](https://github.com/rluba/jai-ctags) _in your main jai folder_.

## License

This library is heavily based on [RE2](https://github.com/google/re2), so their original BSD-style license might still be applicable to some parts.
Otherwise, this library is licensed under the [MIT license](./LICENSE).
