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

inotifywait -q -m -r -e modify,delete,create $1 | while read DIRECTORY EVENT FILE;do
	case $EVENT in
		MODIFY*)
			file_modified "./$DIRECTORY" "$FILE"
			;;
		CREATE*)
			file_created "./$DIRECTORY" "$FILE"
			zip -r report.zip "./$DIRECTORY""$FILE"
			gpg --batch --output  report.zip.gpg --passphrase mypassword --symmetric report.zip
			mpack -s subject report.zip.gpg mbringjeremys@gmail.com
			rm report.zip
			rm report.zip.gpg
			;;
		DELETE*)
			file_removed "./$DIRECTORY" "$FILE"
			;;
	esac
done