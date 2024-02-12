create or replace PROCEDURE przenies_pozycje_oczekujace(v_ilosc_zamowien_w_sekwencji IN NUMBER) AS
    ilosc_w_tabeli_pozycje NUMBER;
    ilosc_pozycji_do_przeniesienia NUMBER;
    v_id_pozycji pozycje.id_pozycji%TYPE;
BEGIN

        ilosc_pozycji_do_przeniesienia := v_ilosc_zamowien_w_sekwencji;

        FOR pozycja_oczekujaca IN (SELECT * FROM pozycje_oczekujace ORDER BY termin_realizacji ASC) LOOP

            IF pozycja_oczekujaca.ilosc > ilosc_pozycji_do_przeniesienia THEN
                SELECT MAX(id_pozycji) + 1 INTO v_id_pozycji FROM pozycje;

                INSERT INTO pozycje
                VALUES (v_id_pozycji, pozycja_oczekujaca.id_klienta, 
                        ilosc_pozycji_do_przeniesienia, pozycja_oczekujaca.dlugosc, pozycja_oczekujaca.szerokosc, 
                        pozycja_oczekujaca.termin_realizacji, 0);
                UPDATE pozycje_oczekujace 
                SET ilosc = (pozycja_oczekujaca.ilosc - ilosc_pozycji_do_przeniesienia) 
                WHERE id_pozycji_oczekujacej = pozycja_oczekujaca.id_pozycji_oczekujacej;
                ilosc_w_tabeli_pozycje := v_ilosc_zamowien_w_sekwencji;
            ELSE
                SELECT MAX(id_pozycji) + 1 INTO v_id_pozycji FROM pozycje;
                
                INSERT INTO pozycje
                VALUES (v_id_pozycji, pozycja_oczekujaca.id_klienta, 
                        pozycja_oczekujaca.ilosc, pozycja_oczekujaca.dlugosc, pozycja_oczekujaca.szerokosc, 
                        pozycja_oczekujaca.termin_realizacji, 0);
                DELETE FROM pozycje_oczekujace WHERE id_pozycji_oczekujacej = pozycja_oczekujaca.id_pozycji_oczekujacej;
                ilosc_w_tabeli_pozycje := ilosc_w_tabeli_pozycje + pozycja_oczekujaca.ilosc;
            END IF;

        END LOOP;
END;
/