arqUsers="users.txt"
echo $$ > pidSshKill.txt
if [ ! -f "$arqUsers" ]
then
	echo "$arqUsers inexistente!"
	exit 0
fi

while true
do
	while read userLine
	do
		user="$(echo $userLine | cut -d' ' -f1)"
		maxSessions="$(echo $userLine | cut -d' ' -f2)"

		ps x | grep $user | grep -v grep | grep -v pts > tmp.tmp

		qtdSessions="$(cat tmp.tmp | wc -l)"

		echo "User: $user - $qtdSessions/$maxSessions"

		if ((qtdSessions > maxSessions))
		then
			echo 'Killing...'
      
			while read line
			do
				tmp="$(echo $line | cut -d' ' -f1)"
				echo "killing $tmp"
				kill $tmp
			done < tmp.tmp
			rm tmp.tmp
		fi
	done < "$arqUsers"

	echo "Sleeping $sleepTime..."
	sleep 4
done
