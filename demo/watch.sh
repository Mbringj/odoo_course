while true; do
	echo "watch is running..."
	inotify-hookable -f file.txt -c 'asciidoctor -q file.txt'
	echo "== $(date) : excuted, continuing to monitor..."
done
