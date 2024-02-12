create or replace PROCEDURE uruchom_sekwencje_ciec(v_wybor_algorytmu IN NUMBER, v_ilosc_zamowien_w_sekwencji IN NUMBER)
IS
    suma_ilosci_w_tabeli_pozycje NUMBER;
    liczba_wierszy NUMBER;
    v_result VARCHAR2(200);
    v_min_data         DATE;
BEGIN
  SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;

    --WHILE suma_ilosci_w_tabeli_pozycje > 10 LOOP

        IF suma_ilosci_w_tabeli_pozycje > v_ilosc_zamowien_w_sekwencji THEN
            przenies_pozycje(suma_ilosci_w_tabeli_pozycje, v_ilosc_zamowien_w_sekwencji);
        END IF;

        wykonaj_serie_ciec(v_wybor_algorytmu, v_ilosc_zamowien_w_sekwencji);

        SELECT COUNT(*) INTO liczba_wierszy FROM pozycje_oczekujace;    
        
          IF liczba_wierszy != 0 THEN
                przenies_pozycje_oczekujace(v_ilosc_zamowien_w_sekwencji);
           END IF;    

        SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;
        SELECT COUNT(*) INTO liczba_wierszy FROM pozycje_oczekujace;

        WHILE liczba_wierszy != 0 LOOP
            wykonaj_serie_ciec(v_wybor_algorytmu, v_ilosc_zamowien_w_sekwencji);

            SELECT COUNT(*) INTO liczba_wierszy FROM pozycje_oczekujace;

            IF liczba_wierszy != 0 THEN
                przenies_pozycje_oczekujace(v_ilosc_zamowien_w_sekwencji);
           END IF;    
            
            SELECT COUNT(*) INTO liczba_wierszy FROM pozycje_oczekujace;
        END LOOP;

        SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;
        

        IF suma_ilosci_w_tabeli_pozycje = v_ilosc_zamowien_w_sekwencji THEN
        WHILE suma_ilosci_w_tabeli_pozycje <= v_ilosc_zamowien_w_sekwencji LOOP
                IF v_wybor_algorytmu = 1 THEN
            v_result := planuj_ciecia_heurestycznie_FNC; -- assume 1 for wybor_algorytmu
        ELSE
            v_result := planuj_ciecia_heurestycznie_dlugosci_FNC_NEW;
        END IF;
            IF v_result = 'Nie znaleziono odpowiedniego surowca, dodaj surowce do magazynu !!!' THEN
                RAISE_APPLICATION_ERROR(-20000, v_result);
            END IF;
                SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;
            END LOOP;
            END IF;

      -- Sprawdzenie daty zaplanownaego zamowienia
    SELECT MIN(termin_realizacji) INTO v_min_data FROM pozycje WHERE wykonano = 0;

    -- IF suma_ilosci_w_tabeli_pozycje = 10 OR (SYSDATE - v_min_data) >= 3 THEN
    --     planuj_ciecia_heurestycznie;
    -- END IF;

  
END uruchom_sekwencje_ciec;
/