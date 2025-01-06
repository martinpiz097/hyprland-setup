#!/bin/bash
echo "Copying JDK $1..."

TMP_JDK_FOLDER=/tmp/jdk

mkdir $TMP_JDK_FOLDER|| true

rm -rf $TMP_JDK_FOLDER/$1 || true
cp -r /usr/lib/jvm/$1 $TMP_JDK_FOLDER/

echo "---------------------------------------------------------"
ls -lh $TMP_JDK_FOLDER
echo "---------------------------------------------------------"
ls -lh $TMP_JDK_FOLDER/$1
echo "---------------------------------------------------------"
