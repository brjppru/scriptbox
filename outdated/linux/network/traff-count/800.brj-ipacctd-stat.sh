#!/bin/sh

# brj@ipacctd shell counter
# (c) 2004, Roman Y. Bogdanov, http://brj.pp.ru/

# full dump of ipacctd statistic file
# ip_from         port    ip_to           port    proto   bytes   packet   time
# 213.148.21.9    80      192.168.201.9   4049    tcp     14733   15      10864239

# mynetwork is 192.168.201/24

echo "internet trafic daily stat"
echo " "

cat /var/log/traf/traf.log | awk 'BEGIN {OFMT="%10.0f"; }
{
if ($1 ~ "192\\.168\\.201") 
{ ip[$1]=$1; out_b[$3] += $6; all_out_b += $6 };

if ($3 ~ "192\\.168\\.201") 
{ ip[$3]=$3; in_b[$3] += $6; all_in_b += $6 };
} 

END {
for (name in ip)
{
out_kb = out_b[name]/1024;
in_kb = in_b[name]/1024;

all_out_kb = all_out_b/1024
all_in_kb = all_in_b/1024

printf "%-15s\t%5d Kb.In\t%7d Kb.Out\t%8d Kb.Sum\n",
name, in_kb, out_kb,in_kb+out_kb;
}
printf "%-15s\t%5d Kb.In\t%7d Kb.Out\t%8d Kb.Sum\n",
"all", all_in_kb, all_out_kb,all_in_kb+all_out_kb;

}' $1 | sort -rnk 6
