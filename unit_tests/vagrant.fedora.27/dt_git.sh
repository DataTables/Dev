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
error() {
    echo "FATAL ERROR: $*"
    exit 1
}

usage() {
	error "usage: $0 -p [pull] | -s [status (default)]"
}

#############################
command="status"
while getopts "ps" opt; do
    case $opt in
		p) command="pull" ;;
		s) command="status" ;;
		\?) usage ;; # Handle error: unknown option or missing required argument.
    esac
done


for directory in $DIRECTORIES ; do
	echo "Processing $directory"
	cd ~/$directory
	git $command
done

