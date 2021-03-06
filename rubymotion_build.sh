#!/bin/sh

CMD=$1
ENV=$2

if [ "$CMD" = "" ]; then
	CMD="rake build"
fi
if [ "$ENV" != "" ]; then
	eval . $ENV
fi

$CMD 2>&1 | ruby -e "\
	build_dir = Dir.pwd;\
	until FileTest.exist?(build_dir + '/Rakefile');\
		build_dir = File.dirname(build_dir);\
		break if build_dir == '/';\
	end;\
	ARGF.each do |line|;\
		STDERR.puts line.gsub(/^\.\//, build_dir + '/').gsub(/\\x1b.../, '');\
	end"
