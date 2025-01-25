#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

char *log_name="/usr/tmp/traf";
char *my_net="80.255.136";

// Cena za 1 mb

double cmb=3.0;

// Koefficient ot 0 do 1 (%) na kotoriy domnojaetsya trafik

double coef=1;


time_t time0,time1,time2;
unsigned long traf1,traf2,traf;
char ip[1024],user[256],*s1,*s2,*s3,*s4,*s5;
char line[4097];
char *InputNames[100];
char *InputValues[100];
int InputCount=0;

unsigned long sum_traf=0;

typedef struct date_time
{
    unsigned int year;
    unsigned int month;
    unsigned int day;
    unsigned long traf[24];
} s_date_time, *ps_date_time;

typedef struct entry
{
    char *ip;
    char *user;
    unsigned long traf;
    unsigned long cost;
    ps_date_time dates;
    unsigned long dates_count;
    
} s_entry, *ps_entry;

ps_entry entries = NULL;
unsigned long count;

void *smalloc(size_t size)
{
    void *ptr = malloc(size);
    if (ptr == NULL)
    {
	fprintf(stderr, "\n\nOut of memory\n\n");
	exit(2);
    }
    
    return ptr;
}

void *srealloc(void *ptr, size_t size)
{
    void *newptr = realloc(ptr, size);
    if (newptr == NULL)
    {
	fprintf(stderr, "\n\nOut of memory\n\n");
	exit(2);
    }
    
    return newptr;
}

int read_cfg()
{
    FILE *log;
    int i,j,k,n;
    struct tm *ct;
    char *addr1,*fp,*addr2,*tp,*proto,*size,*packets,*gmt;    
    
    count=0;
    
    if ((log = fopen(log_name,"rb")) == NULL)
    {
	printf("Cannot open file: \"%s\"\n\n",log_name);
	exit(2);
    }    
    
    while (fgets(line,4097,log))
    {
	if (line == NULL) continue;
	j = strlen (line) - 1;
	while(j && (line[j] == '\r' || line[j] == '\n')) {line[j]='\0'; j--;}

	addr1=strtok(line," \r\n\t");  // from addr
	if (addr1==NULL) continue;	

	fp=strtok(NULL," \r\n\t");  // from port
	if (fp==NULL) continue;	

	addr2=strtok(NULL," \r\n\t");  // to addr
	if (addr2==NULL) continue;	

	tp=strtok(NULL," \r\n\t");  // to port
	if (tp==NULL) continue;	

	proto=strtok(NULL," \r\n\t");  // protocol
	if (proto==NULL) continue;	

	size=strtok(NULL," \r\n\t");  // traf
	if (size==NULL) continue;	

	packets=strtok(NULL," \r\n\t");  // pkts
	if (packets==NULL) continue;	

	gmt=strtok(NULL," \r\n\t");  // time
	if (gmt==NULL) continue;	

	
//	printf("%s<br>\n",gmt);
	
	time0 = atol(gmt); // calculate local time from GMT

	ct = localtime(&time0);
	
//	printf("y=%d m=%d d=%d h=%d mm=%d<br>\n",ct->tm_year,ct->tm_mon,ct->tm_mday,ct->tm_hour,ct->tm_min);
//	printf("time1=%d time2=%d time0=%d\n",time1,time2,time0);

//	time0=0;

	if (!strstr(addr2,my_net)) continue;
	
	if (time0 >= time1 && time0 <= time2)
	{
	    
	    strcpy(ip,addr2);
	    strcpy(user,"all");
	    traf=atoi(size); //+traf2;
	    
	    traf+=traf*coef;
	    
	    
	    /* debug */

/*
	    
	    printf("time=%d\n",time0);
	    printf("traf=%d\n",traf);
	    printf("ip=%s\n",ip);
	    printf("user=%s\n",user);
	    printf("<br><br>",user);

*/
	    n = 0;

	    for (i=0; i<count; i++)
	    {
		if (!strcmp(entries[i].ip,ip))
		    if (!strcmp(entries[i].user,user))
		    {
			n = 1;
			entries[i].traf+=traf;

			if (entries[i].dates[entries[i].dates_count-1].year != ct->tm_year ||
			    entries[i].dates[entries[i].dates_count-1].month != ct->tm_mon ||
			    entries[i].dates[entries[i].dates_count-1].day != ct->tm_mday)
			{
			    entries[i].dates_count++;
			    entries[i].dates = srealloc (entries[i].dates, entries[i].dates_count * sizeof(s_date_time));
			    entries[i].dates[entries[i].dates_count-1].year=ct->tm_year;
			    entries[i].dates[entries[i].dates_count-1].month=ct->tm_mon;
			    entries[i].dates[entries[i].dates_count-1].day=ct->tm_mday;
			    for (k=0; k<=23; k++) if (k==ct->tm_hour)
			    entries[i].dates[entries[i].dates_count-1].traf[k]=traf; else
			    entries[i].dates[entries[i].dates_count-1].traf[k]=0;
			} else
			{
			    for (k=0; k<=23; k++) if (k==ct->tm_hour)
			    {
				entries[i].dates[entries[i].dates_count-1].traf[k]+=traf;
				break;
			    }
			}

		    }
	    }

	    if (!n)
	    {
	    
		count++;
		entries = srealloc (entries, count * sizeof(s_entry));
		entries[count-1].ip = smalloc(strlen(ip)+1);
		strcpy (entries[count-1].ip,ip);
		entries[count-1].user = smalloc(strlen(user)+1);
		strcpy (entries[count-1].user,user);
		entries[count-1].traf = traf;
		entries[count-1].cost = 0;
		entries[count-1].dates_count=1;
		entries[count-1].dates = smalloc (sizeof(s_date_time));
		entries[count-1].dates[entries[count-1].dates_count-1].year=ct->tm_year;
		entries[count-1].dates[entries[count-1].dates_count-1].month=ct->tm_mon;
		entries[count-1].dates[entries[count-1].dates_count-1].day=ct->tm_mday;
		
		for (j=0; j<=23; j++) if (j==ct->tm_hour) 
		entries[count-1].dates[entries[count-1].dates_count-1].traf[j]=traf; 
		else
		entries[count-1].dates[entries[count-1].dates_count-1].traf[j]=0;

//		printf("%s %s\n",entries[count-1].user,entries[count-1].ip);
		
	    }

	}	    		      
    }
    
    fclose(log);        
    return 0;
}

int print_results(const int type_of_sort)
{
    unsigned long i;
    double f,ff,tot_traf=0;
    char save[256]="\0";
    
    sum_traf=0;

    puts("<table border=1 width=600>");
    puts("<tr>");
    puts("<td align=center bgcolor=000099><font color=ffffff><b>IP Address</b></td><td align=center bgcolor=000099><font color=ffffff><b>Traffic (MB)</b></td><td align=center bgcolor=000099><font color=ffffff><b>Cost (RU)bles</b></td>");

    for (i=0; i<count; i++)
    {
	if (strchr(entries[i].user,'+')==NULL && strchr(entries[i].user,'%')==NULL)
	{

	/*  
	    if (type_of_sort==1) strcpy(save,entries[i].user);
    	    if (type_of_sort==2) strcpy(save,entries[i].user);
	    if (type_of_sort==3) strcpy(save,entries[i].ip);
	*/    
	    break;
	}	    
    }

    for (i=0; i<count; i++)
    {
	if (strchr(entries[i].user,'+')==NULL && strchr(entries[i].user,'%')==NULL)
	{
	    f=entries[i].traf*0.00000095367431640625;
	    
	    sum_traf+=entries[i].traf;
	    
	    if (type_of_sort==1) tot_traf+=f;
	    if (type_of_sort==2)
	    {
		if (!strcmp(entries[i].user,save)) tot_traf+=f; else
		{
		    puts("<tr>");
		    printf("<td bgcolor=ccffcc><font color=0000ff><b>%s -zzzz</font></td><td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",save,tot_traf,tot_traf*cmb);
		    tot_traf=f;
		}
	    }
	    if (type_of_sort==3)
	    {
		if (!strcmp(entries[i].ip,save)) tot_traf+=f; else
		{
		    puts("<tr>");
		    printf("<td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td bgcolor=ccffcc><font color=0000ff><b>%s</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",save,tot_traf,tot_traf*cmb);
		    tot_traf=f;
		}
	    }

	    puts("<tr>");
	    printf("<td>%s</td><td align=right>%.4lf</td><td align=right>%-.4lf</td>\n",entries[i].ip,f,f*cmb);
    	    
	    if (type_of_sort==2) strcpy(save,entries[i].user);
	    if (type_of_sort==3) strcpy(save,entries[i].ip);
	}
    }

    if(count && strcmp(save,"\0"))
    {

	    if (type_of_sort==1)
	    {
		puts("<tr>");
		printf("<td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",tot_traf,tot_traf*cmb);
	    }
	    if (type_of_sort==2)
	    {
		puts("<tr>");
		printf("<td bgcolor=ccffcc><font color=0000ff><b>%s</font></td><td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",save,tot_traf,tot_traf*cmb);
	    }
	    if (type_of_sort==3)
	    {
		puts("<tr>");
		printf("<td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td bgcolor=ccffcc><font color=0000ff><b>%s</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",save,tot_traf,tot_traf*cmb);
	    }
    }
    
    ff=sum_traf*0.00000095367431640625;
    
    puts("<tr>");
    printf("<td bgcolor=ccffcc align=center><font color=0000ff><b>(total)</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%.4lf</font></td><td align=right bgcolor=ccffcc><font color=0000ff><b>%-.4lf</font></td>\n",ff,ff*cmb);

    puts("</table><br>");
    		        
    return 0;
}

void print_hdr()
{
    puts("Content-type: text/html\n");
    puts("<html>");
    puts("<head></head>");
    puts("<body bgcolor=white>");
    puts("<font face=\"verdana\" size=1>");
}

void print_end()
{
    puts("<hr>");
    puts("Statistics generated by SQLOG for ipacctd v1.00<br>Copyright &copy; 2003 by <A href=\"mailto:dm@kraslan.ru\">Dmitry Rusov</A>.<br> All rights reserved.");
    puts("</body>");
    puts("</html>");
}

int name_comparer(const void *str1, const void *str2) 
{
  return strcmp(((ps_entry)str1)->user,((ps_entry)str2)->user);
}

int ip_comparer(const void *str1, const void *str2) 
{
  return strcmp(((ps_entry)str1)->ip,((ps_entry)str2)->ip);
}

int traf_comparer(const void *traf1, const void *traf2) 
{
    if(((ps_entry) traf1) -> traf > ((ps_entry) traf2) -> traf) return -1;
    if (((ps_entry) traf1) -> traf == ((ps_entry) traf2) -> traf) return 0;
    return 1;
}

void print_err()
{
    print_hdr();
    puts("<h1>ERROR IN DATA</h1>");
    print_end();
    exit(2);
}

void ConvChars(char *str)
{
    int x,y;
    char buff2[10000];
    char hexstr[5];
    for (x = 0, y = 0; x < strlen(str); x++, y++)
    {
	switch (str[x])
	{
	    case '+':
		buff2[y] = ' ';
	    break;
	    case '%':
		strncpy(hexstr, &str[x + 1], 2);
		x = x + 2;
		if( ((strcmp(hexstr,"26")==0)) || ((strcmp(hexstr,"3D")==0)) )
		{
		    buff2[y]='%';
		    y++;
		    strcpy(buff2,hexstr);
		    y=y+2;
		    break;
		}
		buff2[y] = (char)strtol(hexstr, NULL, 16);
		break;
	    default:
		buff2[y] = str[x];
		break;
	}
    }
    strcpy(str,buff2);
}

void ParseInput(char *Input)
{
    int i=0,k=0;
    ConvChars(Input); 
    while(Input[i++]!=0)
    {
	if(Input[i]=='=')
	{
	    InputNames[InputCount]=smalloc(i-k+1);
	    strncpy(InputNames[InputCount],&Input[k],i-k);
	    k=i+1;
	}
	if((Input[i]=='&')||(Input[i]==0))
	{
	    InputValues[InputCount]=smalloc(i-k+1);
	    strncpy(InputValues[InputCount],&Input[k],i-k);
	    k=i+1;
	    InputCount++;
	}
    }
}

int print_stat_by_date_time()
{
    int i,j,n;
    double f,tot_traf,ttot_traf;
    unsigned long tmp[24];

    puts("<table border=1>");
    puts("<tr><td><font size=1><b>IP address</td><td><font size=1><b>Traffic by date and time</td></tr>");

    for (i=0;i<count;i++)
    {
	if (strchr(entries[i].user,'+')==NULL && strchr(entries[i].user,'%')==NULL)
	{
	    printf("<tr><td bgcolor=ffccff><font size=1>%s</td><td>\n",entries[i].ip);
	
    	    puts("<table border=0>");
	    puts("<tr><td bgcolor=ccffcc><font size=1><b>Date/Time</td>");
	    for (n=0;n<=23;n++)
	    {
		tmp[n]=0;
		printf("<td align=center bgcolor=ccffff><font size=1>%02d</td>\n",n);
	    }
	    
	    puts("<td align=center bgcolor=ccffcc><font size=1><b>Total</b></td>");
		
	    ttot_traf=0;

	    for (j=0; j<entries[i].dates_count; j++)
	    {
		tot_traf=0;
		printf("<tr><td bgcolor=ffcccc><font size=1>%02d:%02d:%04d</td>\n",entries[i].dates[j].day,entries[i].dates[j].month+1,entries[i].dates[j].year+1900);
		for (n=0; n<=23; n++)
		{
		    tmp[n]+=entries[i].dates[j].traf[n];
		    if (entries[i].dates[j].traf[n])
		    {
			f=entries[i].dates[j].traf[n]*0.00000095367431640625;
			tot_traf+=f;
			printf("<td><font size=1 color=005500><b>%-.4lf</b></td>\n",f);
		    } else
		    {
			f=0;
			printf("<td><font size=1>%-.4lf</td>\n",f);
		    }
			
		}
		printf("<td><font size=1 color=cc0000><b>%-.4lf</b></td></tr>\n",tot_traf);
		ttot_traf+=tot_traf;
	    
	    }	

	    puts("<tr><td bgcolor=ccffcc><font size=1><b>Total:</b></td>");
	    for (n=0; n<=23; n++)
	    {
		f=tmp[n]*0.00000095367431640625;
	        printf("<td bgcolor=ccffcc><font size=1>%-.04lf</td>\n",f);
	    }
	    printf("<td bgcolor=ccffcc><font size=1><b>%-.4lf</b></td>\n",ttot_traf);
	    
	    puts("</table>");
	}    
    }

    puts("</table><br>");
    
    return 0;
}

int main()
{

    struct tm t1;
    struct tm t2;
//    struct tm *ct1,*ct2;
    char *s=getenv("REQUEST_METHOD");
    char *endptr;
    int i;
    unsigned int contentlength;
    char buff[10000];
    char a,b;
    const char *len1 = getenv("CONTENT_LENGTH");

/*
    printf("Content-Type: text/html\n\n");
    printf( "<HTML><HEAD><TITLE>Environment</TITLE></HEAD>\n");
    printf( "<BODY>\n");
    printf( "Your request is: %s<BR><br>\n",getenv("REQUEST_STRING"));
    printf( "Variables:<BR>\n");
    printf( "<I><B>REQUEST_METHOD</B></I>=%s<br>\n",getenv("REQUEST_METHOD"));
    printf( "<I><B>QUERY_STRING</B></I>=%s<br>\n",getenv("QUERY_STRING"));
    printf( "<I><B>CONTENT_LENGTH</B></I>=%s<br>\n",getenv("CONTENT_LENGTH"));
    printf( "<I><B>CONTENT_TYPE</B></I>=%s<br>\n",getenv("CONTENT_TYPE"));
    printf( "<I><B>GATEWAY_INTERFACE</B></I>=%s<br>\n",getenv("GATEWAY_INTERFACE"));
    printf( "<I><B>REMOTE_ADDR</B></I>=%s<br>\n",getenv("REMOTE_ADDR"));
    printf( "<I><B>REMOTE_HOST</B></I>=%s<br>\n",getenv("REMOTE_HOST"));
    printf( "<I><B>SCRIPT_NAME</B></I>=%s<br>\n",getenv("SCRIPT_NAME"));
    printf( "<I><B>SCRIPT_FILENAME</B></I>=%s<br>\n",getenv("SCRIPT_FILENAME"));
    printf( "<I><B>SERVER_NAME</B></I>=%s<br>\n",getenv("SERVER_NAME"));
    printf( "<I><B>SERVER_PORT</B></I>=%s<br>\n",getenv("SERVER_PORT"));
    printf( "<I><B>SERVER_PROTOCOL</B></I>=%s<br>\n",getenv("SERVER_PROTOCOL"));
    printf( "<I><B>SERVER_SOFTWARE</B></I>=%s<br>\n",getenv("SERVER_SOFTWARE"));
    printf( "<I><B>HTTP_ACCEPT</B></I>=%s<br>\n",getenv("HTTP_ACCEPT"));
    printf( "<I><B>HTTP_USER_AGENT</B></I>=%s<br>\n",getenv("HTTP_USER_AGENT"));
    printf( "</BODY></HTML>\n");
				    			    		    
    exit(2);
*/
    
    if(s!=NULL)
    {
	if(strcmp(s,"GET")==0)
	{
	    strcpy(buff,getenv("QUERY_STRING"));
	}else
	if(strcmp(s,"POST")==0)
	{
	    contentlength=strtol(len1, &endptr, 10);
	    fread(buff, contentlength, 1, stdin); 
	}
	ParseInput(buff);
    }

    if (InputCount!=10) print_err();

    print_hdr();

    t1.tm_mday=atoi(InputValues[0]);
    t1.tm_mon=atoi(InputValues[1])-1;
    t1.tm_year=atoi(InputValues[2])-1900;
    t1.tm_hour=atoi(InputValues[3]);
    t1.tm_min=atoi(InputValues[4]);
    t1.tm_sec=0;
    t2.tm_mday=atoi(InputValues[5]);
    t2.tm_mon=atoi(InputValues[6])-1;
    t2.tm_year=atoi(InputValues[7])-1900;
    t2.tm_hour=atoi(InputValues[8]);
    t2.tm_min=atoi(InputValues[9]);
    t2.tm_sec=59;

    time1=mktime(&t1);
    time2=mktime(&t2);


/*
	ct1 = gmtime(&time1);
	
	printf("ct1 y=%d m=%d d=%d h=%d mm=%d <br>\n",ct1->tm_year,ct1->tm_mon,ct1->tm_mday,ct1->tm_hour,ct1->tm_min);


	ct2 = gmtime(&time2);
	
	printf("ct2 y=%d m=%d d=%d h=%d mm=%d<br>\n",ct2->tm_year,ct2->tm_mon,ct2->tm_mday,ct2->tm_hour,ct2->tm_min);
*/

    printf("<h3>Statistics for %02d:%02d:%02d %02d:%02d - %02d:%02d:%02d %02d:%02d</h2><hr>\n",
    t1.tm_mday,t1.tm_mon+1,t1.tm_year+1900,t1.tm_hour,t1.tm_min,
    t2.tm_mday,t2.tm_mon+1,t2.tm_year+1900,t2.tm_hour,t2.tm_min);

//    printf("<h2>Statistics for %s - %s</h2><hr>\n",asctime(&t1),asctime(&t2));

//    printf("%d<br>",time1);
//    printf("%d",time2);

    read_cfg();

    qsort(entries,count,sizeof(s_entry),traf_comparer);
    puts("<h3>Sorted by traffic</h2>");
    print_results(1);

/* 


    qsort(entries,count,sizeof(s_entry),name_comparer);
    puts("<h3>Sorted by user name</h2>");
    print_results(2);

*/

    qsort(entries,count,sizeof(s_entry),ip_comparer);
    puts("<h3>Sorted by ip address</h2>");
    print_results(1);

    qsort(entries,count,sizeof(s_entry),name_comparer);
    puts("<h3>Statistics by date and time</h2>");
    print_stat_by_date_time();
    print_end();
        
    return 0;
}
