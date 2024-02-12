create or replace PROCEDURE przenies_pozycje(ilosc_w_tabeli_pozycje IN NUMBER, v_ilosc_zamowien_w_sekwencji IN NUMBER) AS
BEGIN 
        FOR pozycja IN (SELECT * FROM pozycje WHERE wykonano = 0 ORDER BY termin_realizacji ASC) LOOP
            IF pozycja.ilosc > (ilosc_w_tabeli_pozycje - v_ilosc_zamowien_w_sekwencji) THEN
                INSERT INTO pozycje_oczekujace 
                VALUES (pozycja.id_pozycji, pozycja.id_klienta, (ilosc_w_tabeli_pozycje - v_ilosc_zamowien_w_sekwencji), 
                        pozycja.dlugosc, pozycja.szerokosc, pozycja.termin_realizacji, 0);
                UPDATE pozycje SET ilosc = (pozycja.ilosc - (ilosc_w_tabeli_pozycje - v_ilosc_zamowien_w_sekwencji)) WHERE id_pozycji = pozycja.id_pozycji;
            END IF;     
        END LOOP;
    
END;
/