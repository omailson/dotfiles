#!/bin/bash

function __makej() {
    make -j"$JOBS"
}
export -f __makej
export MAKE="__makej"

"$QTSRC"/configure -developer-build -no-gtkstyle -opensource --confirm-license -no-pch -nomake examples -nomake tests -nomake translations -nomake docs

if [ $? -ne 0 ]
then
	echo
	echo "FAIL: Qt5 configure has failed"
	echo "Did you installed all dependencies on your machine?"
	exit 1
fi

echo
echo "Configurarion finished!"
echo "Now run 'make' to build qtbase and then run build-qt5.sh to finish building Qt5"
