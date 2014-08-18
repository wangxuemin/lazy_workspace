#!/bin/sh

shname=`basename $0`
pyname=${shname%%.sh}

touch bin/${pyname}.py
python bin/${pyname}.py >${pyname}.log 2>&1
