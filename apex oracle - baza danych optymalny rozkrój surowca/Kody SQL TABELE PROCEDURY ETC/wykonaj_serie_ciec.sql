create or replace PROCEDURE wykonaj_serie_ciec(v_wybor_algorytmu IN NUMBER, v_ilosc_zamowien_w_sekwencji IN NUMBER)
IS
    suma_ilosci_w_tabeli_pozycje NUMBER;
    v_result VARCHAR2(200);
BEGIN
    SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;

    IF suma_ilosci_w_tabeli_pozycje = v_ilosc_zamowien_w_sekwencji THEN
        SELECT SUM(ilosc) INTO suma_ilosci_w_tabeli_pozycje FROM pozycje WHERE wykonano = 0;
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
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END wykonaj_serie_ciec;
/