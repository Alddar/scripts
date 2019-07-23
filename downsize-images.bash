
# Script takes a folder of images and downsizes them to specified size by lowering quality.

if [ $# -ne 3 ] ; then
	echo "Usage:"
	echo -e "\t$0 SIZE SOURCE DESTINATION"
	exit 1
fi

SIZE=$1
SOURCE=$2
DESTINATION=$3

if [ ! -d $SOURCE -o ! -d $DESTINATION ] ; then
	echo "SOURCE and DESTINATION must be directories."
	exit 1
fi

re='^[0-9]+$'

if [[ ! $SIZE =~ $re ]] ; then
	echo "SIZE must be integer"
fi

trap "exit" INT
for i in $SOURCE/{*.JPG,*.jpg} ; do 
	PERCENT=99
	convert $i -quality $PERCENT% $i-low.jpg
	echo "Converting $i"
	trap "exit" INT
	while [ $( du -k $i-low.jpg | cut -f1) -gt $SIZE ]; do
		PERCENT=$(($PERCENT-1))
		echo "Percent: $PERCENT Size:" $(du -k $i-low.jpg | cut -f1)
		convert $i -quality $PERCENT% $i-low.jpg
		if [ $PERCENT -eq 1 ] ; then
			echo "Cannot convert $i, size too low."
			break;
		fi
	done
	mv $i-low.jpg $DESTINATION
done
