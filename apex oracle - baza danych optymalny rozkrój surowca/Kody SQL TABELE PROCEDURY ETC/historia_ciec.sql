
  CREATE TABLE "HISTORIA_CIEC" 
   (	"ID_HISTORII" NUMBER, 
	"ID_CIECIA" NUMBER, 
	"ID_POZYCJI" NUMBER, 
	 PRIMARY KEY ("ID_HISTORII")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "HISTORIA_CIEC" ADD CONSTRAINT "HISTORIA_CIEC_CIECIA_FK" FOREIGN KEY ("ID_CIECIA")
	  REFERENCES "CIECIA" ("ID_CIECIA") ENABLE;
  ALTER TABLE "HISTORIA_CIEC" ADD CONSTRAINT "HISTORIA_CIEC_POZYCJE_FK" FOREIGN KEY ("ID_POZYCJI")
	  REFERENCES "POZYCJE" ("ID_POZYCJI") ENABLE;