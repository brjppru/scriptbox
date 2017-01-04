BEGIN {
    FS = ";"

    KEYS["Фамилия"] = "N.1";
    KEYS["Имя"] = "N.2"; 	
    KEYS["Отество"] = "N.3"; 	
    KEYS["Обращение"] = "N.4";
    KEYS["Суффикс"] = "N.5";
    
    KEYS["Организация"] = "ORG.1";
    KEYS["Отдел"] = "ORG.2";
    KEYS["Должность"] = "TITLE";
    
    KEYS["Улицарабадрес"] = "ADR;TYPE=work.2";
    KEYS["Улица2рабадрес"] = "ADR;TYPE=work.2";
    KEYS["Улица3рабадрес"] = "ADR;TYPE=work.2";
    KEYS["Городрабадрес"] = "ADR;TYPE=work.3";
    KEYS["Областьрабадрес"] = "ADR;TYPE=work.4";
    KEYS["Индексрабадрес"] = "ADR;TYPE=work.5";
    KEYS["Странарабадрес"] = "ADR;TYPE=work.6";

    KEYS["Потовыйкоддом"] = "ADR;TYPE=home.1";
    KEYS["Улицадомадрес"] = "ADR;TYPE=home.2";
    KEYS["Улица2домадрес"] = "ADR;TYPE=home.2";
    KEYS["Улица3домадрес"] = "ADR;TYPE=home.2";
    KEYS["Городдомадрес"] = "ADR;TYPE=home.3";
    KEYS["Областьдомадрес"] = "ADR;TYPE=home.4";
    KEYS["Индексдомадрес"] = "ADR;TYPE=home.5";
    KEYS["Странадомадрес"] = "ADR;TYPE=home.6";

    KEYS["Улицадругойадрес"] = "ADR;TYPE=postal.2";
    KEYS["Улица2другойадрес"] = "ADR;TYPE=postal.2";
    KEYS["Улица3другойадрес"] = "ADR;TYPE=postal.2";
    KEYS["Городдругойадрес"] = "ADR;TYPE=postal.3";
    KEYS["Областьдругойадрес"] = "ADR;TYPE=postal.4";
    KEYS["Индексдругойадрес"] = "ADR;TYPE=postal.5";
    KEYS["Странадругойадрес"] = "ADR;TYPE=postal.6";
    
    KEYS["Телефонпомощника"] = "TEL;TYPE=pager";
    KEYS["Рабоийфакс"] = "TEL;TYPE=work;TYPE=fax";
    KEYS["Рабоийтелефон"] = "TEL;TYPE=work";
    KEYS["Телефонраб2"] = "TEL;TYPE=work";
    KEYS["Обратныйвызов"] = "TEL;TYPE=X-EVOLUTION-CALLBACK";
    KEYS["Телефонвмашине"] = "TEL;TYPE=car";
    KEYS["Основнойтелефонорганизации"] = "TEL;TYPE=work";
    KEYS["Домашнийфакс"] = "TEL;TYPE=home;TYPE=fax";
    KEYS["Домашнийтелефон"] = "TEL;TYPE=home";
    KEYS["Телефондом2"] = "TEL;TYPE=home";
    KEYS["ISDN"] = "TEL;TYPE=isdn";
    KEYS["Телефонпереносной"] = "TEL;TYPE=cell";
    KEYS["Другойфакс"] = "TEL;TYPE=fax";
    KEYS["Другойтелефон"] = "TEL";
    KEYS["Пейджер"] = "TEL;TYPE=pager";
    KEYS["Основнойтелефон"] = "TEL";
    KEYS["Радиотелефон"] = "TEL;TYPE=pcs";
    KEYS["Телетайптелефонститрами"] = "TEL;TYPE=msg";
    KEYS["Телекс"] = "TEL;TYPE=msg";
    
    KEYS["Важность"] = "";
    KEYS["Вебстраница"] = "URL";
    KEYS["Годовщина"] = "X-ANNIVERSARY";
    KEYS["Деньрождения"] = "BDAY";
    KEYS["Дети"] = "";
    KEYS["Имяпомощника"] = "X-ASSISTANT";
    KEYS["Инициалы"] = "";
    KEYS["Категории"] = "CATEGORIES";
    KEYS["Клюевыеслова"] = "NOTE";
    KEYS["Кодорганизации"] = "";
    KEYS["Линыйкод"] = "";
    KEYS["Отложено"] = "";
    KEYS["Пол"] = "";

    KEYS["Пользователь1"] = "";
    KEYS["Пользователь2"] = "";
    KEYS["Пользователь3"] = "";
    KEYS["Пользователь4"] = "";
    KEYS["Пометка"] = "";
    KEYS["Потовыйящикдомадрес"] = "";
    KEYS["Потовыйящикдругойадрес"] = "";
    KEYS["Потовыйящикрабадрес"] = "";
    KEYS["Профессия"] = "";
    KEYS["Расположение"] = "";
    KEYS["Расположениекомнаты"] = "";
    KEYS["Расстояние"] = "";
    KEYS["Руководитель"] = "";
    KEYS["СведенияодоступностивИнтернете"] = "";
    KEYS["Серверкаталогов"] = "";
    KEYS["Супруга"] = "X-SPOUSE";
    KEYS["Сет"] = "";
    KEYS["Сета"] = "";
    KEYS["Хобби"] = "";
    KEYS["_астное"] = "";
    KEYS["Адресэлпоты"] = "EMAIL;TYPE=internet";
    KEYS["Типэлпоты"] = "";
    KEYS["Краткоеимяэлпоты"] = "";
    KEYS["Адрес2элпоты"] = "EMAIL;TYPE=internet";
    KEYS["Тип2элпоты"] = "";
    KEYS["Краткое2имяэлпоты"] = "";
    KEYS["Адрес3элпоты"] = "EMAIL;TYPE=internet";
    KEYS["Тип3элпоты"] = "";
    KEYS["Краткое3имяэлпоты"] = "";
    KEYS["Язык"] = "";
}

FNR == 1 {
    for (i = 1; i <= NF; i++) {
        k = KEYS[$i];
        if ("" != k) {
            MAPS[i] = k;
        }
    }
}

FNR != 1 {
    delete PROPS;
    for (i = 1; i <= NF; i++) {
        k = MAPS[i];
        if (("" != $i) && ("" != k)) {
            PROPS[k] = $i;
        }
    }
    
    n = asorti(PROPS, SKEYS);
    if (n > 0) {
        l = "";
        print("BEGIN:VCARD");
        printf("VERSION:3.0");
        for (i = 1; i <= n; i++) {
            k = SKEYS[i];
            v = PROPS[k];
            if (2 == split(k, a, ".")) {
                k = a[1];
                x = 0 + a[2];
            }
            else {
                x = 1;
            }
            if (l != k) {
                l = k;
                m = 1;
                printf("\r\n%s:", l);
            }
            while (m < x) {
                m++;
                printf(";");
            }
            printf("%s", v);
        }
        print("\r\nEND:VCARD");
    }
}

function die(str) {
    print "Error at " FILENAME ":" FNR " " str
    exit
}

function warn(str) {
    print "Warning at " FILENAME ":" FNR " " str
}

