create or replace FUNCTION powierzchnia(p_dlugosc NUMBER, p_szerokosc NUMBER)
RETURN NUMBER
IS
BEGIN
  RETURN p_dlugosc * p_szerokosc;
END powierzchnia;
/