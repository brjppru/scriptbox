#!/bin/sh

HOME=/home/acc

IPFW_FILE=$HOME/IPFW_ACCT
IPFW_ZERO=$HOME/IPFW_ZERO
ACC_FILE=$HOME/LAST.ACC
TMP_FILE=$HOME/TMP

RULE_BEG=10000
RULE_END=30000

ipfw -a list > $IPFW_FILE

awk -v beg=$RULE_BEG -v end=$RULE_END -v zero=$IPFW_ZERO \
'BEGIN 	{ s=""; n=-1; nn=0; printf ("") > zero; } \
	{	if ( $1 >= beg && $1 <= end ) { \
			if ( $3 > 0 ) { \
				if ( $4=="allow"||$4=="count"||$4=="pipe" ) { \
					p = ( $4=="pipe" ) ? 1 : 0; \
					f = $(7 +p); \
					t = $(9 +p); \
					io= $(10+p); \
					if ( f=="any" )	f = "0.0.0.0/0"; \
					if ( t=="any" )	t = "0.0.0.0/0"; \
					if ( index(f,"/") == 0 ) f = f "/32"; \
					if ( index(t,"/") == 0 ) t = t "/32"; \
					if ( io == "in" )
						print "o\t"f"\t"t"\t"$2"\t"$3; \
					else
						print "i\t"t"\t"f"\t"$2"\t"$3; \
				} \
			} \
			if ( $1 != n ) { \
				n = $1; s = s " " $1; \
				nn += 1; \
				if ( nn > 9 ) { \
					print "zero" s >> zero ; \
					s="" ; \
					nn = 0; \
				} \
			} \
		} \
	} \
END	{ if (nn > 0 ) print "zero" s >> zero ; }' $IPFW_FILE > $TMP_FILE

ipfw -q $IPFW_ZERO

#ACC=$HOME/`date +%Y%m%d%H`.ACC
sort +1 -2 +0 -1 +2 -3 < $TMP_FILE > $ACC_FILE
#rm -f $IPFW_FILE $IPFW_ZERO $TMP_FILE
#ln -fs $ACC $ACC_FILE
 
