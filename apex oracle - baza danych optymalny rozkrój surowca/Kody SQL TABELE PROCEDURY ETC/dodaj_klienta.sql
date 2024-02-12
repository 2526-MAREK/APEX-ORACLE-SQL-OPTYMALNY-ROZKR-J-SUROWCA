create or replace FUNCTION dodaj_klienta(
    p_imie IN klienci.imie%TYPE, 
    p_nazwisko IN klienci.nazwisko%TYPE, 
    p_numer_telefonu IN klienci.numer_telefonu%TYPE, 
    p_data_przybycia IN klienci.data_przybycia%TYPE) 
    RETURN klienci.id_klienta%TYPE IS
  v_id_klienta klienci.id_klienta%TYPE;
BEGIN
  BEGIN
    SELECT id_klienta INTO v_id_klienta
    FROM klienci
    WHERE numer_telefonu = p_numer_telefonu
      AND data_przybycia = p_data_przybycia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_id_klienta := NULL;
  END;
  
  IF v_id_klienta IS NULL THEN
    SELECT COALESCE(MAX(id_klienta), 0) + 1 INTO v_id_klienta FROM klienci;
    
    INSERT INTO klienci(id_klienta, imie, nazwisko, numer_telefonu, data_przybycia) 
    VALUES(v_id_klienta, p_imie, p_nazwisko, p_numer_telefonu, p_data_przybycia);

    DBMS_OUTPUT.PUT_LINE('Nowy klient dodany. Id_klienta: ' || v_id_klienta);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Klient istnieje. Id_klienta: ' || v_id_klienta);
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('v_id_klienta: ' || v_id_klienta);
  
  RETURN v_id_klienta;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wystąpił inny wyjątek: ' || SQLERRM);
    RETURN NULL;
END;
/