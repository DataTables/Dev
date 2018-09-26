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
	"

#############################
# General functions
#############################

error() {
    echo "FATAL ERROR: $*"
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
		*)
			error "usage: $0 git [ pull | status ]"
			;;
	esac

	for directory in $DIRECTORIES ; do
		echo "Processing $directory"
		cd ~/$directory
		git $command
	done
}

#############################
# Test functions
#############################

test_commands() {
	shift
	case $1 in
		editor)
			sh /vagrant/run_editor_tests.sh
			;;
		unittest)
			cd ~/DataTablesSrc
			npm run test
			;;
		website)
			cd ~/datatables-system-tests/selenium
			npm run website
			;;
		*)
			error "usage: $0 test [ editor | unittest | website ]"
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
	*)
		error "usage: $0 [ build | git | test ]"
		;;
esac
