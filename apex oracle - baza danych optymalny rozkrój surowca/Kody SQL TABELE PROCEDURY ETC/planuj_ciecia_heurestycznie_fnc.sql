create or replace FUNCTION planuj_ciecia_heurestycznie_FNC
RETURN VARCHAR2 IS
  CURSOR cur_pozycje IS
    SELECT *
    FROM pozycje WHERE WYKONANO = 0
    ORDER BY powierzchnia(dlugosc, szerokosc) DESC;
  
  v_dopasowana_pozycja pozycje%ROWTYPE;
  v_dopasowany_surowiec surowce%ROWTYPE;
  v_min_roznica_powierzchni NUMBER := 999999999;
  v_roznica_powierzchni NUMBER;
  v_obrocono BOOLEAN := FALSE;

  NO_MATCH_FOUND EXCEPTION;
BEGIN
    v_min_roznica_powierzchni := 999999999;
  FOR r_pozycja IN cur_pozycje LOOP

    FOR r_surowiec IN (SELECT * FROM surowce WHERE magazynowany = 1) LOOP
      IF (r_surowiec.dlugosc >= r_pozycja.dlugosc AND r_surowiec.szerokosc >= r_pozycja.szerokosc) OR (r_surowiec.dlugosc >= r_pozycja.szerokosc AND r_surowiec.szerokosc >= r_pozycja.dlugosc) THEN

        --IF (r_surowiec.dlugosc >= r_pozycja.dlugosc AND r_surowiec.szerokosc >= r_pozycja.szerokosc) THEN
        IF (r_surowiec.dlugosc >= r_pozycja.dlugosc AND r_surowiec.szerokosc >= r_pozycja.szerokosc) THEN
            v_obrocono := FALSE;
        END IF;

         IF (r_surowiec.dlugosc >= r_pozycja.szerokosc AND r_surowiec.szerokosc >= r_pozycja.dlugosc) THEN 
            v_obrocono := TRUE;
        END IF;

        v_roznica_powierzchni := powierzchnia(r_surowiec.dlugosc, r_surowiec.szerokosc) - powierzchnia(r_pozycja.dlugosc, r_pozycja.szerokosc);
        
          IF v_roznica_powierzchni < v_min_roznica_powierzchni THEN
            v_min_roznica_powierzchni := v_roznica_powierzchni;
            v_dopasowany_surowiec := r_surowiec;
            v_dopasowana_pozycja := r_pozycja;

          END IF;

      END IF;
    END LOOP;



      IF v_min_roznica_powierzchni <> 999999999 THEN
        optymalizuj_rozkroj(v_dopasowana_pozycja.id_pozycji, v_dopasowany_surowiec.id_blatu, v_obrocono);
      ELSE
        RAISE NO_MATCH_FOUND;
      END IF;

    
  END LOOP;
  
  RETURN 'Planowanie ciecia zakończone sukcesem';

EXCEPTION
  WHEN NO_MATCH_FOUND THEN
    RETURN 'Nie znaleziono odpowiedniego surowca, dodaj surowce do magazynu !!!';
END planuj_ciecia_heurestycznie_FNC;
/