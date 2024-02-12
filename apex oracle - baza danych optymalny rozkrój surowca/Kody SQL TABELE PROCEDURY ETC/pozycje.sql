
  CREATE TABLE "POZYCJE" 
   (	"ID_POZYCJI" NUMBER, 
	"ID_KLIENTA" NUMBER, 
	"ILOSC" NUMBER, 
	"DLUGOSC" NUMBER(5,0), 
	"SZEROKOSC" NUMBER(5,0), 
	"TERMIN_REALIZACJI" DATE, 
	"WYKONANO" NUMBER, 
	 PRIMARY KEY ("ID_POZYCJI")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "POZYCJE" ADD CONSTRAINT "POZYCJE_KLIENCI_FK" FOREIGN KEY ("ID_KLIENTA")
	  REFERENCES "KLIENCI" ("ID_KLIENTA") ENABLE;