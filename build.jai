#load "modules/stubborn/run.jai";

#run {
	args := compiler_get_command_line_arguments();

	entrypoint := ifx args.count then args[0] else "";
	if entrypoint == "test" {
		test_args := args;
		test_args.data += 1;
		test_args.count -= 1;

		// @ToDo @CompilerBug Running the tests at compile time trips up the compiler (as of beta 036). Set run = false to avoid that.
		build_tests("tests", #string END
			#load "module.jai";
			// #load "char_class.jai";
			// #load "rune.jai";
		END, "modules", args = test_args, run = true);
	} else {
		build("module.jai", .NO_OUTPUT);
	}
}

DOCKER_JAI_PATH :: "/home/jai/jai";
HOST_JAI_PATH :: "/Users/raphael/Projekte/jai/jai";

build :: (filename: string, output_type := Build_Output_Type.EXECUTABLE, executable := "") {
    build_options := get_build_options();
    build_options.output_type = .NO_OUTPUT;
    set_build_options(build_options);

    w := compiler_create_workspace();
    build_options.output_type = output_type;
	build_options.output_executable_name = ifx executable then executable else basename(filename);
	build_options.backend = .X64;
    // build_options.optimization_level = Optimization_Level.RELEASE;

	// llvm_args: [..] string;
	// array_add(*llvm_args, "-fasdgasgsanitize=address");
	// build_options.llvm_options.debug_options = llvm_args;
	array_add(*build_options.modules_search_path_array, "modules");
    set_build_options(build_options, w);

	compiler_begin_intercept(w);

    add_build_file(filename, w);

	ctags: CTags;
	ctags.base_path = get_working_directory();
	ctags.transform_path = (ctags: *CTags, path: string) -> string {
		// Transform in-docker paths to host paths
		if begins_with(path, DOCKER_JAI_PATH) {
			result := sprint("%1%2", HOST_JAI_PATH, slice(path, DOCKER_JAI_PATH.count, path.count - DOCKER_JAI_PATH.count));
			array_add(*ctags.strings, result);
			return result;
		}
		return path;
	};
	defer reset(*ctags);

	while true {
		message := compiler_wait_for_message();
		if !message continue;

		if message.workspace == w {
			process_message(*ctags, message);
		}

		if message.kind == .COMPLETE break;
	}

	compiler_end_intercept(w);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "ctags";
#import "String";

