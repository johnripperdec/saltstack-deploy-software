#!/bin/bash
mysql -e "select version();" &>/dev/null
	if [ "$?" = "0" ]; then
	mysql_secure_installation << EOF

	y
	{{DB_PASSWORD}}
	{{DB_PASSWORD}}
	y
	y
	y
	y
EOF
fi
