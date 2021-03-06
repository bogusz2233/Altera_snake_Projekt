library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE KSZTALTY IS


procedure PROSTOKAT (VARIABLE SIZE_X, SIZE_Y, POS_X, POS_Y :integer; 
							SIGNAL CUR_X,CUR_Y :IN INTEGER; 
							signal DRAW_RECT :out std_logic);
						
							
procedure CIRCLE (VARIABLE SIZE, POS_X,POS_Y :integer; 
							SIGNAL CUR_X,CUR_Y :IN INTEGER; 
							signal DRAW_CIRCLE :out std_logic);

END KSZTALTY;


PACKAGE BODY KSZTALTY IS
	--CUR_X, CUR_Y  OBECNIE PRZETWARZANY PISKEL
	--SIZE_X, SIZE_Y WIELKOSC ELEMENTU
	--POS_X , POS_Y OBECNA POZYCJA ELEMENTU
	-- DRAW_RECT SYGNAL POTWIERDZAJACY RYSOWANIE ELEMENTU
	
	PROCEDURE PROSTOKAT (VARIABLE SIZE_X, SIZE_Y,POS_X,POS_Y :integer;
								SIGNAL CUR_X,CUR_Y :IN INTEGER; 
								signal DRAW_RECT :out std_logic) IS
		BEGIN
			IF(CUR_X >= POS_X AND CUR_X < POS_X + SIZE_X) AND (CUR_Y >= POS_Y AND CUR_Y < POS_Y + SIZE_Y) THEN
				DRAW_RECT <='1';
			ELSE
				DRAW_RECT <='0';
			END IF;
	
	END PROSTOKAT;
	
	procedure CIRCLE (VARIABLE SIZE, POS_X,POS_Y :integer; 
							SIGNAL CUR_X,CUR_Y :IN INTEGER; 
							signal DRAW_CIRCLE :out std_logic) IS
		
		VARIABLE SUMA_X,SUMA_Y		:INTEGER;
		BEGIN
			SUMA_X := (CUR_X - POS_X - SIZE) * (CUR_X - POS_X - SIZE);
			SUMA_Y := (CUR_Y - POS_Y - SIZE) * (CUR_Y - POS_Y - SIZE);
			
			IF (( SUMA_X + SUMA_Y)<= (SIZE * SIZE)) THEN 
				DRAW_CIRCLE <= '1';
			ELSE 
				DRAW_CIRCLE <= '0';
			END IF;
		
	END CIRCLE;

END KSZTALTY;
