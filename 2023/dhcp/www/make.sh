#!/bin/sh

awk 'BEGIN { format = "%-20s %-15s %s\n"
	     printf format, " ", " ", " " }
{printf format, "<tr><td>"$2"</td>", "<td>"$3"</td>", "<td>"$4"</td></tr>" }' /dhcp/www/dnsmasq-leases.log > /dhcp/www/table.txt

