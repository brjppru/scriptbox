10 CLS
20 LOCATE 13, 1
PRINT "����� � �� ��᪮���  200 �㡫�� � ���ଠ���� �� 1.44 �� "
PRINT "������ ���� �������"
1 a$ = INKEY$: IF a$ = "" THEN 1
PRINT "�஢������ ࠧ��� �����"
SLEEP 3
PRINT "�� 200 �㡫�� ����㧨� 800.com"

q = CSRLIN + 1
FOR i = 1 TO 100
LOCATE q - 1: PRINT "200 �㡫�� �ଠ������ �� 1.44 �� "; i; "% ���ଠ�ࠢ����"
FOR j = 1 TO 100: NEXT

NEXT
LOCATE q - 1: PRINT STRING$(80, " ")
LOCATE q - 1: PRINT "��ଠ�஢����� �����饭�� ����ࠩ� ᢮� 1 �㡫� � 44 �������"

