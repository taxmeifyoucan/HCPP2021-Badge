#!/bin/bash

if [ $# -lt 4 ]
then
echo "Arguments needed: <user id>, <read key>, <number of walelts>, <lnbits web address>"
exit
fi
C=0

while [ $C -lt $3 ]
do

WALL=`diceware -n 3`
USER=`diceware -n 3`

ID=`curl -s -X POST https://$4/usermanager/api/v1/users \
-d '{"admin_id": "'"$1"'", "wallet_name": "'"$WALL"'", "user_name": "'"$USER"'", "email": "", "password": ""}' \
-H "X-Api-Key: $2" -H "Content-type: application/json" | tee -a wallets | jq -r '.id'`

AKEY=`grep $ID wallets -m 1 -A  6 | grep "adminkey" | awk -F'"' '{ print $4 }'`
INKEY=`grep $ID wallets -m 1 -A 8 | grep '"inkey"' | awk -F'"' '{ print $4 }'`

curl -s -X POST https://$4/api/v1/extensions \
 -d '{"userid": "'"$ID"'", "extension": "withdraw", "active": true}' \
 -H "X-Api-Key: $INKEY" -H "Content-type: application/json" >> /dev/null

curl -s -X POST https://$4/withdraw/api/v1/links \
 -d '{"title": "'"$INKEY"'", "min_withdrawable": 1, "max_withdrawable": 100000, "uses": 100, "wait_time": 10, "is_unique": false}' \
 -H "X-Api-Key: $AKEY" -H "Content-type: application/json" | jq -r '.lnurl' | tee -a badges

curl -s -X POST https://$4/usermanager/api/v1/extensions \
 -d '{"userid": "'"$ID"'", "extension": "lnurlp", "active": true}' \
 -H "X-Api-Key: $INKEY" -H "Content-type: application/json" >> /dev/null

curl -s -X POST https://$4/lnurlp/api/v1/links \
 -d '{"description": "LNURL Badge", "amount": 1, "max": 4000000, "min": 1, "comment_chars": 10}' \
 -H "X-Api-Key: $INKEY" -H "Content-type: application/json" | jq -r '.lnurl' | tee -a badges

echo https://$4/wallet?usr=$ID | tee -a badges

((C++))
done

echo "$3 wallets created"

