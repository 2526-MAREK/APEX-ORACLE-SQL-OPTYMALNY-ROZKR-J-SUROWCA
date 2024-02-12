create or replace PROCEDURE optymalizuj_rozkroj(v_id_pozycji IN NUMBER, v_surowiec_id IN NUMBER, v_obrocono IN BOOLEAN)
AS
  s surowce%ROWTYPE;
  r pozycje%ROWTYPE;
  v_id_ciecia NUMBER;
  v_wykonano BOOLEAN := FALSE;
BEGIN
  SELECT * INTO r FROM pozycje WHERE id_pozycji = v_id_pozycji;
    DBMS_OUTPUT.PUT_LINE('Pozycje: id_pozycji=' || r.id_pozycji || ', dlugosc=' || r.dlugosc || ', szerokosc=' || r.szerokosc);  
    BEGIN
      SELECT * INTO s FROM surowce WHERE id_blatu = v_surowiec_id;
      
      DBMS_OUTPUT.PUT_LINE('Dopasowany surowiec: id_blatu=' || s.id_blatu || ', dlugosc=' || s.dlugosc || ', szerokosc=' || s.szerokosc);

      
      
      -- Zaktualizuj tabelę surowce, zmniejszając ilość danego surowca
      UPDATE surowce
      SET ilosc = ilosc - 1,
          magazynowany = CASE WHEN ilosc - 1 = 0 THEN 0 ELSE 1 END
      WHERE id_blatu = s.id_blatu;
      
      -- Dodaj nowy rekord do tabeli ciecia
      INSERT INTO ciecia (id_ciecia, id_blatu, pozycja_x, pozycja_y)
      VALUES (ciecia_seq.NEXTVAL, s.id_blatu, r.dlugosc, r.szerokosc);

       v_id_ciecia := ciecia_seq.CURRVAL;

    --   INSERT INTO plan_ciec (id_planu, id_pozycji, id_ciecia, data_realizacji_ciecia)
    --   VALUES (seq_id_planu.NEXTVAL, v_id_pozycji, v_id_ciecia, SYSDATE);
      
      -- Dodaj dwa różne odpadki do tabeli surowce, dlugosc = poziomo, szerokosc = pionowo 
      
      IF v_obrocono = FALSE THEN
       IF (s.szerokosc - r.szerokosc  > 1)  THEN
        INSERT INTO surowce (id_blatu, dlugosc, szerokosc, ilosc, magazynowany)
        VALUES (surowce_seq.NEXTVAL, r.dlugosc, s.szerokosc - r.szerokosc, 1, 1);
      END IF;
      
      IF (s.dlugosc - r.dlugosc  > 1)   THEN
        INSERT INTO surowce (id_blatu, dlugosc, szerokosc, ilosc, magazynowany)
        VALUES (surowce_seq.NEXTVAL, s.dlugosc- r.dlugosc,s.szerokosc , 1, 1);
      END IF;
      v_wykonano := TRUE;
    END IF;

    IF v_obrocono = TRUE AND NOT v_wykonano THEN
       IF (s.szerokosc - r.dlugosc > 1)  THEN
        INSERT INTO surowce (id_blatu, dlugosc, szerokosc, ilosc, magazynowany)
        VALUES (surowce_seq.NEXTVAL, r.szerokosc, s.szerokosc - r.dlugosc, 1, 1);
      END IF;
      
      IF (s.dlugosc - r.szerokosc   > 1)   THEN
        INSERT INTO surowce (id_blatu, dlugosc, szerokosc, ilosc, magazynowany)
        VALUES (surowce_seq.NEXTVAL, s.dlugosc- r.szerokosc,s.szerokosc  , 1, 1);
      END IF;
    END IF;
     



    
        IF r.ilosc > 1 THEN
            UPDATE pozycje
          SET ilosc = ilosc - 1,
             termin_realizacji = SYSDATE
          WHERE id_pozycji = r.id_pozycji;
        ELSE
            UPDATE pozycje
          SET wykonano = 1,
            termin_realizacji = SYSDATE
          WHERE id_pozycji = r.id_pozycji;
        END IF;  
         
        INSERT INTO historia_ciec (id_historii, id_ciecia, id_pozycji)
       VALUES (historia_ciec_seq.NEXTVAL, v_id_ciecia, v_id_pozycji );
    END
COMMIT;
END optymalizuj_rozkroj;
/