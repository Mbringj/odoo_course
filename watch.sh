file_removed() {
	echo "$2 was removed from $1"
}

file_modified() {
	TIMESTAMP=`date`
	echo "[$TIMESTAMP]: the file $1$2 was modified">>monitor_log
}

file_created() {
	TIMESTAMP=`date`
	echo "[$TIMESTAMP]: the file $1$2 was created $1">>monitor_log
}

do_some_action() {
	file_created "./$1" "$2"
	zip -r report.zip "./$1""$2"
	gpg --batch --output  report.zip.gpg --passphrase mypassword --symmetric report.zip
	mpack -s subject report.zip.gpg mbringjeremys@gmail.com
	rm report.zip
	rm report.zip.gpg
}

inotifywait -q -m -r -e modify,delete,create $1 | while read DIRECTORY EVENT FILE;do
	case $EVENT in
		MODIFY*)
			file_modified "./$DIRECTORY" "$FILE"
			do_some_action $DIRECTORY $FILE
			;;
		CREATE*)
			file_created "./$DIRECTORY" "$FILE"
			do_some_action $DIRECTORY $FILE
			;;
		DELETE*)
			file_removed "./$DIRECTORY" "$FILE"
			do_some_action $DIRECTORY $FILE
			;;
	esac
done