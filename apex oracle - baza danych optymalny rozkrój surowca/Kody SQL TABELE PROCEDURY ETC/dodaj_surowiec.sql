create or replace FUNCTION dodaj_surowiec(
  p_dlugosc IN surowce.dlugosc%TYPE,
  p_szerokosc IN surowce.szerokosc%TYPE,
  p_ilosc IN surowce.ilosc%TYPE
) RETURN surowce.id_blatu%TYPE IS
  v_id_blatu surowce.id_blatu%TYPE;
BEGIN
  SELECT COALESCE(MAX(id_blatu), 0) + 1 INTO v_id_blatu FROM surowce;
  
  INSERT INTO surowce(id_blatu, dlugosc, szerokosc, ilosc, magazynowany)
  VALUES(v_id_blatu, p_dlugosc, p_szerokosc, p_ilosc, 1);
  
  RETURN v_id_blatu;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/