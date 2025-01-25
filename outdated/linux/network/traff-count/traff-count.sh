#!/bin/sh

# brj@ipacctd shell counter
# (c) 2004, Roman Y. Bogdanov, http://brj.pp.ru/

# mynetwork is 172.21.223

echo "internet trafic daily stat"
echo " "

cat traf.log | awk 'BEGIN {OFMT="%10.0f"; }
{
if ($4 ~ "172\\.21\\.223")
{ ip[$4]=$4; out_b[$12] += $12; all_out_b += $12 };

if ($7 ~ "172\\.21\\.223")
{ ip[$7]=$7; in_b[$7] += $12; all_in_b += $12 };
}

END {
for (name in ip)
{
out_kb = out_b[name];
in_kb = in_b[name];

all_out_kb = all_out_b
all_in_kb = all_in_b

printf "%-15s\t%5d Kb.In\t%7d Kb.Out\t%8d Kb.Sum\n",
name, in_kb, out_kb,in_kb+out_kb;
}
printf "%-15s\t%5d Kb.In\t%7d Kb.Out\t%8d Kb.Sum\n",
"all", all_in_kb, all_out_kb,all_in_kb+all_out_kb;

}' $1 | sort -rnk 6

