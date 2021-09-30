# HCPP2021 Badge

For Hackers Congress Paralelní Polis 2021, we created payments system which enables Bitcoin Lightning payments using NFC badge. 

## Previous design, motivation

Card payments in traditional finance became standard over past years. They offer easy and conveniently fast payments with certain security trade offs. Bitcoin competing with this easy kind of payments while requiring phone with wallet app makes onboarding and daily transactions much harder for many people. Paralelní Polis - Bitcoin Coffee aimed to solve this for ordinary customers and brought user experience of payment cards to Bitcoin payments years ago. 

Design was build basically on paper wallets. Either NFC with or QR code with private key is given to customer who can use it with ATMs and PoS terminals. For receiving/checking balance device derives pub key from priv key and for payments it takes private key and signs a transaction. Obviously, this comes with strong security and privacy disadvanteges. 

Trust is involved in private key generation and devices which read your private key. Constant address reuse also makes this very painful from privacy perspective. These payments were done only on-chain, recently majorly with Litcoin because of fees and compatibility with Bitcoin formants. 

## Lightning badge
# HCPP2021 Badge

For Hackers Congress Paralelní Polis 2021, we created payments system which enables Bitcoin Lightning payments using NFC badge. 

## Previous design, motivation

Card payments in traditional finance became standard over past years. They offer easy and conveniently fast payments with certain security trade offs. Bitcoin competing with this easy kind of payments while requiring phone with wallet app makes onboarding and daily transactions much harder for many people. Paralelní Polis - Bitcoin Coffee aimed to solve this for ordinary customers and brought user experience of payment cards to Bitcoin payments years ago. 

Design was build basically on paper wallets. Either NFC with or QR code with private key is given to customer who can use it with ATMs and PoS terminals. For receiving/checking balance device derives pub key from priv key and for payments it takes private key and signs a transaction. Obviously, this comes with strong security and privacy disadvantages. 

Trust is involved in private key generation and devices which read your private key. Constant address reuse also makes this very painful from privacy perspective. These payments were done only on-chain, recently majorly with Litcoin because of fees and compatibility with Bitcoin formants. 

## Lightning badge

Lightning Network solves many of above problems. Privacy, lower fees, instant settlement and better security can be easily achieved using Bitcoin's native payment network. 

Daily small payments are perfect use case for LN but it is hard to implement it as card payments. Lightning is interactive protocol and payments cannot be done by simple priv key signing on base layer. Thankfully, we have LNURL which aims to improve this UX. With LNURL subprotocols, we are able to create NFC badge/QR card for 'offline' lightning payments. 

### How does it work

NFC badge contents 2 fields - LNURL-withdraw for paying and LNURL-pay for receiving sats. These are static codes which are created and uploaded only once. To receive funds, user approaches badge/reads QR code with LNURL-pay for example to Bitcoin ATM. Received funds can be immediately spend by reading LNURL-withdraw for example by point of sale terminal. 

LNURL pairs are created using [LNbits](https://github.com/lnbits/lnbits). Each pair represents user in LNBits instance. With web address and user ID, user can easily access web interface of the wallet and manage badge funds there.

Yes, this solution is custodial and involves trust to LNURL server provider. However, compared to previous model it offers same level of trust. User can easily withdraw all funds to own non-custodial wallet which is easy, fast and with minimum fees thanks to Lightning Network and LNBits feature for Draining funds.

It also offers security benefit because LNURL-withdraw can be limited to maximum withdraw amount, number of uses and time between them. Privacy benefit - avoiding address reuse and not puting all data onchain is obvious.    

Check more general info and recommended practices at paralelnipolis.cz/wallet.

### HCPP badge

Every attendee of HCPP21 conference received badge with pre-prepared LNURL codes ready to be used. Badge contains two EEPROM memory modules and two buttons which connect them to antenna. Data cannot be read unless button is pushed. Badge design is created by Michael, check details at Monero Devices. 

![](/badge.jpeg)

This double memory system is used for separating withdraw and pay link. Therefore more security is achieved because while reading pay, no money can be withdrawn. 

LNURL decoding and payment/withdraw needs to be implemented on the side of ATM/PoS. Kudos to General Bytes for pioneering and quickly implementing this concept.

Thanks to this, attendees can simply tap ATM with badge, receive money and immediately pay by tapping PoS terminal. 

With the badge, attendee also gets a paper card which includes LNURL links in form of QR codes. This can be used with Lightning wallets supporting LNURL but not NFC. 

![](cards.jpeg)

On the other side of card is QR code with link including user ID for LNBits instance. User can open wallet in browser, use it as Lightning wallet via web app and utilize many features offered by LNBits. 

Feature for checking balance at ATM/PoS is also implemented. Description of LNURL-pay includes read key of user's wallet and device gets balance by calling LNbits API. This alters same feature in old concept where ATM derives pub key from priv key and checks onchain balance.  

## Create your own 

Concept of these badges is built on free and open source tool. Feel free to create own badges for your own business, event, café...

Different users in LNbits with LNURL pairs can be generated by API. For creating larger number of wallets for this purpose, use simple bash script in this repo. 

First you need to create a wallet in LNbits instance. This will be main wallet used to create and manage all other. 

Head e.g. to lnbits.com and create new wallet. Enable extension User Manager in Manage extensions. 

Get your user id which can be found in URL:

```
https://lnbits.com/wallet?usr=<ThisIsUserID>
```

And Invoice/read key which is found in API info on home page (wallet). 

Install dependencies for running the script.

```
apt install curl jq diceware
```

And run script with arguments:

```
./gen_pairs.sh <userID> <read key> <number of wallets to create> <address of LNbits instance>
```

For example:

```
./gen_pairs.sh <string> <string> 10 lnbits.com
```

Creats 10 wallet pairs. Printed output is in format:

```
LNURL-withdraw
LNURL-pay
Link to wallet
```

This output can be also in created file `badges` and all information about created wallets are in file `wallets`. 

Script calls User manager extension in wallet you manually created, creates new wallet, enables extensions and creates payment links. In LNURL-withdraw it allows withdraw up to 100k sats with maximum 100 uses once per 10 seconds. For LNURL-pay it allows to receive up to 4m sats and puts read key of wallet to LNURL description for checking balance feature. 
It is pretty simple, edit it to match your needs. 

You can use open source design of badge by Monero devices (above) or just turn create QR codes and make payments by scanning them. 

Come to visit Paralelní Polis in Prague to try it in wild! 
