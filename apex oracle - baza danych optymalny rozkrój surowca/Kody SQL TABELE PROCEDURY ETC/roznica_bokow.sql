create or replace FUNCTION roznica_bokow(p_dlugosc1 NUMBER, p_szerokosc1 NUMBER, p_dlugosc2 NUMBER, p_szerokosc2 NUMBER)
RETURN NUMBER
IS
BEGIN
  RETURN ABS(p_dlugosc1 - p_dlugosc2) + ABS(p_szerokosc1 - p_szerokosc2);
END roznica_bokow;
/