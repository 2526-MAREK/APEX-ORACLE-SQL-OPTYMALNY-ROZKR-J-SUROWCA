
  CREATE TABLE "KLIENCI" 
   (	"ID_KLIENTA" NUMBER, 
	"IMIE" VARCHAR2(100), 
	"NAZWISKO" VARCHAR2(100), 
	"NUMER_TELEFONU" NUMBER, 
	"DATA_PRZYBYCIA" DATE, 
	 PRIMARY KEY ("ID_KLIENTA")
  USING INDEX  ENABLE
   ) ;