set NetPrinter=\\%COMPUTERNAME%\HP
net use /persistent:no
if defined NetPrinter net use LPT1 %NetPrinter%
copy /b hpini.pjl prn
copy /b normal.pjl prn
