#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<time.h>

struct tm *t;
time_t tt;

int make_html()
{
    int i;


    puts("Content-type: text/html\n");
    puts("<html>");
    puts("<head></head>");
    puts("<body bgcolor=white>");
    puts("<form action='sqlog.cgi' method=GET>");
    
    puts("<center>");
    puts("<h2>Select date and time period</h2>");

    printf("<b>Current time is: %02d:%02d:%04d %02d:%02d</b><br><br>\n",t->tm_mday,t->tm_mon+1,t->tm_year+1900,t->tm_hour,t->tm_min);

    puts("<b>First date:</b><br><br>");

    puts("Day");
    
    puts("<input type=hidden value='1'>");
    puts("<select name=d1>");
    for (i=1; i<=31; i++)
    {
	if (i==t->tm_mday)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Month");

    puts("<input type=hidden value='1'>");
    puts("<select name=mm1>");
    for (i=1; i<=12; i++)
    {
	if (i==t->tm_mon+1)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Year");

    puts("<input type=hidden value='1'>");
    puts("<select name=y1>");
    for (i=2001; i<=2010; i++)
    {
	if (i==t->tm_year+1900)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Hour");

    puts("<input type=hidden value='1'>");
    puts("<select name=h1>");
    for (i=0; i<=23; i++)
    {
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Min");

    puts("<input type=hidden value='1'>");
    puts("<select name=m1>");
    for (i=0; i<=59; i++)
    {
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("<br><br><br><b>Last date:</b><br><br>");

    puts("Day");

    puts("<input type=hidden value='1'>");
    puts("<select name=d2>");
    for (i=1; i<=31; i++)
    {
	if (i==t->tm_mday)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Month");

    puts("<input type=hidden value='1'>");
    puts("<select name=mm2>");
    for (i=1; i<=12; i++)
    {
	if (i==t->tm_mon+1)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Year");

    puts("<input type=hidden value='1'>");
    puts("<select name=y2>");
    for (i=2001; i<=2010; i++)
    {
	if (i==t->tm_year+1900)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Hour");

    puts("<input type=hidden value='1'>");
    puts("<select name=h2>");
    for (i=0; i<=23; i++)
    {
	if (i==t->tm_hour)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    puts("Min");

    puts("<input type=hidden value='1'>");
    puts("<select name=m2>");
    for (i=0; i<=59; i++)
    {
	if (i==t->tm_min)
	printf("<option selected value='%02d'>%02d\n",i,i); else
	printf("<option value='%02d'>%02d\n",i,i);
    }
    puts("</select>");

    printf("<br><br><br>\n");
    printf("<font size=-1>\n");
    printf("<input type=submit value='Calculate'>\n");
    printf("</font>\n");
    printf("</form>\n");

    
    puts("</center>");
    puts("</body>");
    puts("</html>");

    return(0);
			
}

main(argc, argv)
{

    tt=time(NULL);
    t=localtime(&tt);
    
    make_html();
    
}
