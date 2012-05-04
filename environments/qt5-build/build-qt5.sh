#!/bin/bash
THREADS=-j"$JOBS"
QT5_MODULES="qtjsbackend qtscript qtxmlpatterns qtdeclarative"

for module in $QT5_MODULES
do
  cd $module && make $THREADS && make install && cd ..
  if [ $? -ne 0 ] ; then
    echo FAIL: building $module.
    exit 1
  fi
done

echo
echo Build Completed.
