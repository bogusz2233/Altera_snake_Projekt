LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.KSZTALTY.ALL;
use WORK.FUNCTIONS.ALL;

ENTITY CENTRAL_UNIT IS
PORT(
---------------------------------------------------------------------------
------------------------WYSWIETLANIE---------------------------------------
---------------------------------------------------------------------------
		
			VPOS					:IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			HPOS					:IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			RGB					:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			CLK					:IN STD_LOGIC;
			
---------------------------------------------------------------------------
------------------------RUCH--PLAYER---------------------------------------
---------------------------------------------------------------------------

			UP,DOWN,LFT,RGT 	:IN STD_LOGIC;
			CLK_RUCH				:IN STD_LOGIC;-- SPRAWDZENIE CZY JAKIŚ PRZYCISK RUCHU JEST WCISNIETY
			CLK_ZMIANA			:IN STD_LOGIC; -- ZMIANA POŁOZENIE  PLAYER, ZMIANA, TAKTOWANIE CALEJ LOGIKI GRY
			
			-------TESTOWY CZY GRACZ WSZEDL NA COINS ----
			TEST_1 				:OUT STD_LOGIC;
			----WEJSCIE RESETUJACE GRE----------
			RESET					:IN STD_LOGIC;
			WYS_SEG7_2			:OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			WYS_SEG7_1			:OUT UNSIGNED(6 DOWNTO 0)
		);
-----------------------------------------------------------------------



END CENTRAL_UNIT;

ARCHITECTURE MAIN OF CENTRAL_UNIT IS

-- resolution  640x480 

		SIGNAL X, Y 		:INTEGER RANGE 0 TO 2000;
		
		
		--PARAMETRY PLAYERA POZYCJA I ROZMIAR
		SHARED VARIABLE SIZE_X 					:INTEGER :=25;
		SHARED VARIABLE SIZE_Y					:INTEGER :=25;
		SHARED VARIABLE POSITION_X 			:INTEGER RANGE -100 TO 640 :=120 + 8 * SIZE_X ;
		SHARED VARIABLE POSITION_Y 			:INTEGER RANGE -100 TO 480 :=40 + 8 * SIZE_Y;
		SIGNAL DRAW_PLAYER 						:STD_LOGIC;
-------KIERUNEK PORUSZANIEQSIE PLAYERA-------------
		SIGNAL DIR_U, DIR_D, DIR_L, DIR_R	:STD_LOGIC :='0';
-----------------------------------------------------
------TLO--------------------------------------------
		SIGNAL DRAW_BACKGROUND					:STD_LOGIC;
		SHARED VARIABLE POSITIONBCK_X			:INTEGER RANGE 90 TO 150:=120;
		SHARED VARIABLE POSITIONBCK_Y			:INTEGER RANGE 20 TO 50:=40;
		SHARED VARIABLE SIZEBCK_X				:INTEGER RANGE 300 TO 500:=400;
		SHARED VARIABLE SIZEBCK_Y				:INTEGER RANGE 200 TO 500:=400;
-----------------------------------------------------		
-----------------------------------------------------
		SHARED VARIABLE SIZEC_X 				:INTEGER :=12;
		SHARED VARIABLE SIZEC_Y					:INTEGER :=12;
		SHARED VARIABLE POSITIONC_X 			:INTEGER RANGE -100 TO 640 :=120;
		SHARED VARIABLE POSITIONC_Y 			:INTEGER RANGE -100 TO 480 :=40;
		SIGNAL DRAW_COINS							:STD_LOGIC;
		SIGNAL DOTKNIECIE							:STD_LOGIC;

		
		 
		
		
		
-----------------------------------------------------
-----------------------------------------------------

--TABLE SHOWING A TYPE OF OBJECT TO DISPLAY
type COL is array (0 to 16, 0 to 16) of integer RANGE 0 TO 10;

SIGNAL WYS_OBRAZU: COL;


		BEGIN
		-- aktualna pozycja rendowanego pisksela
		X 	<=	TO_INTEGER (UNSIGNED(HPOS));
		Y	<=	TO_INTEGER (UNSIGNED(VPOS));
		
		TEST_1 <= NOT DOTKNIECIE ;	--SPRAWDZA CZY PLAYER NAJECHAŁ NA COINSA	
		
		PLAYER: PROSTOKAT(SIZE_X, SIZE_Y,POSITION_X , POSITION_Y, X, Y, DRAW_PLAYER);
		TLO	: PROSTOKAT(SIZEBCK_X, SIZEBCK_Y, POSITIONBCK_X, POSITIONBCK_Y, X, Y, DRAW_BACKGROUND);
		COINS : CIRCLE(SIZEC_X, POSITIONC_X, POSITIONC_Y, X, Y, DRAW_COINS);

		DRAWING: PROCESS(CLK)
			BEGIN
					IF(DRAW_PLAYER = '1') THEN 
						RGB<="100";
					ELSIF(DRAW_COINS ='1') THEN
						RGB<="001";
					ELSIF (DRAW_BACKGROUND	='1') THEN
						RGB<="000";
					ELSE 
						RGB<="111";
					END IF;
						
			END PROCESS;
---------------------------- RUCH  ------------------------
----------------------UP,DOWN,LFT,RGT ---------------------
		STERING: PROCESS(CLK_RUCH)
			BEGIN
			
				IF(RESET = '1' OR DOTKNIECIE  = '1' )THEN 
					DIR_U <='0';
					DIR_D <='0';
					DIR_L <='0';
					DIR_R <='0';
				ELSIF(CLK_RUCH'EVENT AND CLK_RUCH ='1') THEN
					IF UP = '1' OR DOWN = '1' OR LFT = '1' OR RGT = '1' THEN
						DIR_U <='0';
						DIR_D <='0';
						DIR_L <='0';
						DIR_R <='0';
						IF UP ='1' THEN 
							DIR_U <='1';
						END IF;
						
						IF DOWN ='1' THEN 
							DIR_D <='1';
						END IF;
						
						IF LFT ='1' THEN 
							DIR_L <='1';
						END IF;
						
						IF RGT ='1' THEN 
							DIR_R <='1';
						END IF;
					END IF;
				END IF;
		END PROCESS;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


		UPDATE: PROCESS(CLK_ZMIANA)
		--RUCH CIAGLE O 20 PIKSELI
			BEGIN
			IF(RESET = '1')THEN 
				POSITION_X 	:=120 + 200;
				POSITION_Y  :=40 + 200;
			ELSIF(CLK_ZMIANA'EVENT AND CLK_ZMIANA ='1') THEN
			
			
			---ZMIANA POŁOZENIA GRACZA-----------------------
				IF DIR_U = '1' THEN
					POSITION_y := POSITION_Y - SIZE_Y;
				ELSIF DIR_D = '1' THEN
					POSITION_Y := POSITION_Y + SIZE_Y;
				ELSIF DIR_L ='1' THEN 
					POSITION_X := POSITION_X - SIZE_X;
				ELSIF DIR_R = '1'THEN 
					POSITION_X := POSITION_X + SIZE_X;
				END IF;
				
			------------SPRAWDZENIE CZY GRACZ NIE WSZEDL NA COINS---
			IF (POSITION_X >= POSITIONC_X  AND POSITION_X <= POSITIONC_X + SIZEC_X) 
			AND (POSITION_Y >= POSITIONC_Y AND POSITION_Y <= POSITIONC_Y + SIZEC_Y) THEN
					DOTKNIECIE  <= '1';
			ELSE 
					DOTKNIECIE <= '0';
			END IF;
			
			END IF;
		END PROCESS;
		
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------	
	LOGIC:PROCESS(CLK_ZMIANA)
		------POSITIN LOGIC OF PLAYER -----------------------------------------------		
		VARIABLE ALL_PLACE :INTEGER := 640;
		VARIABLE RES:INTEGER := 16;
		VARIABLE XXX		 :INTEGER RANGE 0 TO RES + 1;
		BEGIN
		XXX := WYS_TO_LOGIC (ALL_PLACE,POSITIONBCK_X	,POSITIONBCK_X + SIZEBCK_X,POSITION_X , RES);
		WYS_SEG7_1	<=TO_UNSIGNED(XXX,7);
	
			
	END PROCESS;			

END MAIN;


--