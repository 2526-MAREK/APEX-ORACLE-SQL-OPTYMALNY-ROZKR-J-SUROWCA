create or replace PROCEDURE dodaj_zamowienie(p_id_klienta IN pozycje.id_klienta%TYPE, p_ilosc IN pozycje.ilosc%TYPE, p_dlugosc IN pozycje.dlugosc%TYPE, p_szerokosc IN pozycje.szerokosc%TYPE, p_termin_realizacji IN pozycje.termin_realizacji%TYPE) IS
  v_id_pozycji pozycje.id_pozycji%TYPE;
BEGIN
  SELECT COALESCE(MAX(id_pozycji), 0) + 1 INTO v_id_pozycji FROM pozycje;
  
  INSERT INTO pozycje(id_pozycji, id_klienta, ilosc, dlugosc, szerokosc, termin_realizacji, wykonano) VALUES(v_id_pozycji, p_id_klienta, p_ilosc, p_dlugosc, p_szerokosc, p_termin_realizacji, 0);
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/