#!/bin/bash

DIRECTORIES="\
	DataTablesSrc \
	datatables-system-tests \
	dt-test-tools \
	DataTablesSrc/extensions/AutoFill \
	DataTablesSrc/extensions/Buttons \
	DataTablesSrc/extensions/ColReorder \
	DataTablesSrc/extensions/Editor \
	DataTablesSrc/extensions/Editor-NET \
	DataTablesSrc/extensions/Editor-NETCore-Demo \
	DataTablesSrc/extensions/Editor-NETFramework-Demo \
	DataTablesSrc/extensions/Editor-Node \
	DataTablesSrc/extensions/Editor-Node-Demo
	DataTablesSrc/extensions/Editor-PHP \
	DataTablesSrc/extensions/Editor-PHP-Demo \
	DataTablesSrc/extensions/FixedColumns \
	DataTablesSrc/extensions/FixedHeader \
	DataTablesSrc/extensions/KeyTable \
	DataTablesSrc/extensions/Responsive \
	DataTablesSrc/extensions/RowGroup \
	DataTablesSrc/extensions/RowReorder \
	DataTablesSrc/extensions/Scroller \
	DataTablesSrc/extensions/Select \
	DataTablesSrc/extensions/Plugins \
	DataTables-Site \
	"

#############################
# General functions
#############################

error() {
    echo "FATAL ERROR: $*"
    exit 1
}

usage() {
    echo "Usage: $0 $*"
    exit 1
}

log() {
    echo "$*"
}



#############################
# Git functions
#############################

git_commands() {
	shift
	case $1 in
		pull)
			command="pull"
			;;
		status)
			command="status"
			;;
		help|*)
			usage "git [ help | pull | status ]"
			;;
	esac

	for directory in $DIRECTORIES ; do
		echo "Processing $directory"
		cd ~/$directory
		git $command
	done
}

#############################
# Test Editor Platform Database functions
#############################

test_editor_platform_database_commands() {
	browser=$3
	if [ -z $3 ] ; then
		browser="help"
	fi
	case $browser in
		all)
			sh /vagrant/run_editor_tests.sh -p $1 -d $2
			;;
		help)
			usage "test editor $1 $2 [ all | browser (chrome|firefox) | help ]"
			;;
		*)
			sh /vagrant/run_editor_tests.sh -p $1 -d $2 -b $3
			;;
	esac
}

#############################
# Test Editor Platform functions
#############################

test_editor_platform_commands() {
	database=$2
	if [ -z $2 ] ; then
		database="help"
	fi
	case $database in
		all)
			sh /vagrant/run_editor_tests.sh -p $1
			;;
		help)
			usage "test editor $1 [ all | database (mysql|postgres|sqlserver) | help ]"
			;;
		*)
			test_editor_platform_database_commands $*
			;;
	esac
}

#############################
# Test Editor functions
#############################

test_editor_commands() {
	shift
	command=$1
	if [ -z $1 ] ; then
		command="help"
	fi

	case $command in
		all)
			sh /vagrant/run_editor_tests.sh
			;;
		help)
			usage "test editor [ all | help | platform (PHP|NETCore|Node) ]"
			;;
		*)
			test_editor_platform_commands $*
	esac
}

#############################
# Test functions
#############################

test_commands() {
	shift
	case $1 in
		editor)
			test_editor_commands $*
			;;
		unittest)
			cd ~/DataTablesSrc
			npm run test
			;;
		website)
			cd ~/datatables-system-tests/selenium
			npm run website
			;;
		help|*)
			usage "test [ editor | help | unittest | website ]"
			;;
	esac
}

#############################
# Build functions
#############################

build_commands() {
	# we'll just pass this onto the build scriptshift
	shift
	cd ~/DataTablesSrc/build
	./make.sh $*
}

#############################
# Script start
#############################

case $1 in
	build)
		build_commands $*
		;;
	git)
		git_commands $*
		;;
	test)
		test_commands $*
		;;
	help|*)
		usage "[ build | git | help | test ]"
		;;
esac
