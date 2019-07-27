;
;   ███               ████   █   █  ████
;  █ ▒▒█   █          █▒▒▒█  ██ ██▒  █▒▒█
;  █▒   ▒   ▒         █▒  █▒ █▒█ █▒  █▒ █▒
;   ███   ██   ████   ████ ▒ █▒█▒█▒  █▒ █▒
;    ▒▒█   █▒  █▒█▒█  █▒▒▒▒  █▒ ▒█▒  █▒ █▒
;  █   █▒  █▒  █▒█▒█▒ █▒     █▒  █▒  █▒ █▒
;   ███ ▒ ███  █▒█▒█▒ █▒     █▒  █▒ ████ ▒
;    ▒▒▒   ▒▒▒  ▒ ▒ ▒  ▒      ▒   ▒  ▒▒▒▒
;
;
;
;

SP_Code         segment para

                assume  cs:SP_Code,ds:SP_Code

                org     100h                            ;.COM
LN_Cde_Beg      label   near

;

LN_Begin:       jmp     LN_Install

;
;;;
;;;;
;;;
;

FB_Prg_Head     db      'Simulátor PMD 85    [SimPMD 1.11 - 92/08/20]    Ceres Soft (R)',0Dh,0Ah,'$'

FB_Pref_Err     db      'SimPMD:  $'
FB_Err_DOS      db      'Nezbytná verze DOSu 3.20 nebo vyšší ',0dh,0ah,'$'
FB_Err_Mem      db      'Nedostatek paměti ',0dh,0ah,'$'
FB_Err_EGA      db      'Nezbytná karta EGA 128k nebo vyšší ',0dh,0ah,'$'

;

FB_Main_Txt     db      CB_Set_Curs,0,9,CB_Set_Bold,'Simulátor PMD 85    '
                db      '[SimPMD 1.11 - 92/08/20]    '
                db      'Ceres Soft (R)'
                db      CB_Set_Norm
                db      CB_Set_Curs,22,3,'Zvuk'
                db      CB_Set_Curs,22,12,' LED'
                db      CB_Set_Curs,22,22,' 482stick'
                db      CB_Set_Curs,22,37,' Auto EoF'
                db      CB_Set_Curs,22,52,' Tisk'
                db      CB_Set_Curs,22,64,' Přenos'
                db      0

FB_Yes_Txt      db      'ANO',0
FB_No_Txt       db      'NE ',0

FB_NoP_Txt      db      '----',0
FB_Prt_Txt      db      'LPT'
VB_PrtTxt_Nr    db      ' ',0

;

FB_Dbg_Stat     db      CB_Set_Curs,25,25
                db      'A=',0,'  BC=',0,'  DE=',0,'  HL=',0
                db      '  SP=',0,'  M=',0

FB_Flg_Names    db      'SZ',0,'H',0,'P',0,'C'

;

FB_Mnu_Txt      db      CB_Set_Curs,25,2,CB_Set_Norm,'Výběr:   ',0

;

FB_Main_Mnu     db      CB_Set_Bold,'S',CB_Set_Norm,'imulace '
                db      CB_Set_Bold,'R',CB_Set_Norm,'eset '
                db      's',CB_Set_Bold,'O',CB_Set_Norm,'ubory '
                db      CB_Set_Bold,'D',CB_Set_Norm,'ebugger '
                db      CB_Set_Bold,'N',CB_Set_Norm,'astavení '
                db      CB_Set_Bold,'K',CB_Set_Norm,'onec'
                db      0
                db      'S'
                dw      LN_Start
                db      'R'
                dw      LN_Reset
                db      'O'
                dw      LN_Files
                db      'D'
                dw      LN_Debugger
                db      'N'
                dw      LN_SetUp
                db      'K'
                dw      LN_End
                db      0

;

FB_SetUp_Mnu    db      'z',CB_Set_Bold,'V',CB_Set_Norm,'uk '
                db      CB_Set_Bold,'L',CB_Set_Norm,'ED '
                db      CB_Set_Bold,'4',CB_Set_Norm,'82stick '
                db      CB_Set_Bold,'M',CB_Set_Norm,'G-vstup '
                db      'M',CB_Set_Bold,'G',CB_Set_Norm,'-výstup '
                db      CB_Set_Bold,'A',CB_Set_Norm,'uto-EoF '
                db      CB_Set_Bold,'T',CB_Set_Norm,'isk '
                db      CB_Set_Bold,'P',CB_Set_Norm,'řenos '
                db      CB_Set_Bold,'Z',CB_Set_Norm,'pět'
                db      0
                db      'V'
                dw      LN_Sound
                db      'L'
                dw      LN_LED
                db      '4'
                dw      LN_482stick
                db      'M'
                dw      LN_MgIn
                db      'G'
                dw      LN_MgOut
                db      'A'
                dw      LN_AutoEoF
                db      'T'
                dw      LN_Print
                db      'P'
                dw      LN_Trans
                db      'Z'
                dw      LN_Main
                db      0

;

FB_Files_Mnu    db      CB_Set_Bold,'N',CB_Set_Norm,'ačíst '
                db      CB_Set_Bold,'U',CB_Set_Norm,'ložit '
                db      CB_Set_Bold,'V',CB_Set_Norm,'ymazat '
                db      CB_Set_Bold,'P',CB_Set_Norm,'řejmenovat '
                db      CB_Set_Bold,'A',CB_Set_Norm,'dresář '
                db      CB_Set_Bold,'Z',CB_Set_Norm,'pět'
                db      0
                db      'N'
                dw      LN_Load
                db      'U'
                dw      LN_Save
                db      'V'
                dw      LN_Delete
                db      'P'
                dw      LN_Rename
                db      'A'
                dw      LN_ChDir
                db      'Z'
                dw      LN_Main
                db      0

;

FB_Dbg_Key      db      0Dh
                dw      LN_Dbg_Step
                db      'Y'
                dw      LN_Dbg_Y
                db      'R'
                dw      LN_Dbg_R
                db      'F'
                dw      LN_Dbg_F
                db      'Z'
                dw      LN_Dbg_Z
                db      'X'
                dw      LN_Dbg_X
                db      'O'
                dw      LN_Dbg_O
                db      'I'
                dw      LN_Dbg_I
                db      'A'
                dw      LN_Dbg_A
                db      'B'
                dw      LN_Dbg_B
                db      'D'
                dw      LN_Dbg_D
                db      'H'
                dw      LN_Dbg_H
                db      'S'
                dw      LN_Dbg_S
                db      'P'
                dw      LN_Dbg_P
                db      'Q'
                dw      LN_Dbg_End
                db      0

;

FB_SimOk_Msg    db      'Simulátor připraven',0
FB_Run_Msg      db      'Přerušení simulace stiskem ESC',0
FB_Break_Msg    db      'Simulace přerušena stiskem ESC',0
FB_Reset_Msg    db      'Simulátor uveden do stavu po RESETu',0
FB_HLT_Msg      db      'Simulace zastavena na instrukci HLT',0
FB_SegOr_Msg    db      'Neočekávaný přístup na adresu 0FFFFh - stiskněte RESET',0
FB_FOpen_Msg    db      'Soubor otevřen',0
FB_LdOk_Msg     db      'V pořádku načteno '
FB_LLen_Msg     db      'XXXX bajtů',0
FB_SvOk_Msg     db      'V pořádku uloženo '
FB_SLen_Msg     db      'XXXX bajtů',0
FB_DelOk_Msg    db      'Soubor vymazán',0
FB_RenOk_Msg    db      'Soubor přejmenován',0
FB_CDOk_Msg     db      'Adresář nastaven jako aktivní',0
FB_MgOEr_Msg    db      'Nelze otevřít soubor pro výstup na magnetofon',0
FB_MgIEr_Msg    db      'Nelze otevřít soubor pro vstup z magnetofonu',0
FB_MgOOp_Msg    db      'Soubor pro výstup na magnetofon otevřen',0
FB_MgIOp_Msg    db      'Soubor pro vstup z magnetofonu otevřen',0
FB_MgOCl_Msg    db      'Soubor pro výstup na magnetofon uzavřen',0
FB_MgICl_Msg    db      'Soubor pro vstup z magnetofonu uzavřen',0
FB_AtBrk_Msg    db      'Dosažena adresa breakpointu',0

;

FB_DosErr_Msg   db      0                               ;0 - No Error
                db      0                               ;1 - Invalid function
                db      'Soubor nebyl nalezen',0        ;2 - File not found
                db      'Adresář nebyl nalezen',0       ;3 - Path not found
                db      'Příliš mnoho '
                db      'otevřených souborů',0          ;4 - Too many open files
                db      'Přístup odepřen',0             ;5 - Access denied
                db      0                               ;6 - Invalid handle
                db      0                               ;7 - MCBs destroyed
                db      0                               ;8 - Insufficient memory
                db      0                               ;9 - Invalid MCB address
                db      0                               ;A - Invalid environment
                db      0                               ;B - Invalid format
                db      0                               ;C - Invalid access code
                db      0                               ;D - Invalid data
                db      0                               ;E - Reserved
                db      'Uveden chybný disk',0          ;F - Invalid drive spec.
                db      0                               ;10 - Att. to remove c.d.
                db      'Nelze přenášet mezi '
                db      'různými disky',0               ;11 - Not same device
                db      0                               ;12 - No more files
                db      'Disk chráněn proti zápisu',0   ;13 - Write protect
                db      'Neznámý kód jednotky',0        ;14 - Unknown unit
                db      'Disk není připraven',0         ;15 - Drive not ready
                db      0                               ;16 - Unknown command
                db      'Chybná data na disku',0        ;17 - Bad CRC
                db      0                               ;18 - Bad rq. struct. len
                db      'Chyba při posunu diskové '
                db      'hlavy',0                       ;19 - Seek error
                db      'Neznámý typ média',0           ;1A - Unknown media
                db      'Sektor nebyl nalezen',0        ;1B - Sector not found
                db      0                               ;1C - Paper out
                db      'Chyba při zápisu',0            ;1D - Write fault
                db      'Chyba při čtení',0             ;1E - Read fault
FB_XErr_Msg     db      'Neurčená chyba',0              ;1F - General error

CW_MaxDOS_Err   equ     1Fh             ;posledni implementovana chyba DOSu

;

FB_FName_Rq     db      'Soubor:   ',0
FB_NName_Rq     db      'Jméno:   ',0
FB_PName_Rq     db      'Adresář:   ',0
FB_Addr_Rq      db      'Adresa:   ',0
FB_Size_Rq      db      'Délka:   ',0

FB_RegA_Rq      db      'PSW:   ',0
FB_RegB_Rq      db      'BC:   ',0
FB_RegD_Rq      db      'DE:   ',0
FB_RegH_Rq      db      'HL:   ',0
FB_RegS_Rq      db      'SP:   ',0
FB_RegP_Rq      db      'PC:   ',0

;

CB_Line_Len     equ     65              ;max. delka zadavaneho radku

FB_FName_1      db      CB_Line_Len dup (0)
FB_FName_2      db      CB_Line_Len dup (0)
FB_FOrg         db      CB_Line_Len dup (0)
FB_FSize        db      CB_Line_Len dup (0)

FB_MgIn_FName   db      CB_Line_Len dup (0)
FB_MgOut_FName  db      CB_Line_Len dup (0)

FB_Dbg_Val      db      CB_Line_Len dup (0)

VW_File_Hnd     dw      ?
VW_File_Org     dw      ?               ;pro ulozeni handleru a zacatku souboru

VW_MGIn_Ofs     dw      0               ;offsety v bufferech (nebo 0 - nejde
VW_MGOut_Ofs    dw      0                ;otevrit, 1 - pripraven k otevreni)

VW_MgIn_End     dw      ?               ;offset konce dat v bufferu MgIn

VB_MgIn_Dat     db      0               ;posledni bajt z magnetofonu
VB_MgIn_Flg     db      0               ;priznak platnosti VB_MgIn_Dat

VW_MGIn_Hnd     dw      ?               ;handlery souboru
VW_MGOut_Hnd    dw      ?                ;pro MGF

;

CW_Acc_Port     equ     3CEh            ;adresa ridiciho registru EGA

CB_Set_Bold     equ     1Fh             ;zvyseny jas
CB_Set_Norm     equ     1Eh             ;normalni jas
CB_Set_Curs     equ     1Dh             ;nastaveni kurzoru

FB_EGA_Col      db      0,3Ch,3Ah,7,3Fh,3Eh,0,3Ah       ;paleta pro EGA kartu
                db      0,3Ch,3Ah,7,3Fh,3Eh,3Ah,3Ah
                db      0                               ;barva borderu

;

VB_Sound_Flg    db      -1              ;priznak zapnuteho zvuku
VB_LED_Flg      db      0               ;priznak zapnutych LED
VB_EoF_Flg      db      -1              ;priznak zapnuteho Time-Out pro EoF
VB_Stick_Flg    db      0               ;priznak simulace 482stick
VB_PRN_Flg      db      0               ;cislo portu pro tisk (0, 1=LPT1 ...)
VB_TRN_Flg      db      0               ;cislo portu pro prenos (0, 1=LPT1 ...)

VB_EoF_Timer    db      ?               ;timer pro EoF na I08
VB_I08_Busy     db      0               ;flag pro vyvolani I08

;

VW_EGA_Seg      dw      0A000h          ;segment VRAM EGA
VW_Sim_Seg      dw      ?               ;segment simulatoru
VW_PMD_Seg      dw      ?               ;segment programu PMD
VW_Ins_Seg      dw      ?               ;segment tabulky instrukci

VW_Step_Adr     dw      ?                       ;adresa krokovaci rutiny
VW_Err_Msg      dw      FB_SimOk_Msg            ;adresa stavove zpravy
VW_Brk_Inst     dw      ?                       ;adresa breakpointu pri behu
VW_Brk_Adr      dw      0                       ;breakpoint nastaveny pomoci I

VW_Reg_PSW      dw      0               ;registry PMD (HIGH PSW je A)
VW_Reg_BC       dw      0
VW_Reg_DE       dw      0
VW_Reg_HL       dw      0
VW_Reg_SP       dw      8000h
VW_Reg_PC       dw      8000h

;

VB_Old_VMode    db      ?               ;video rezim radice

VD_Old_I08      dd      ?               ;puvodni vektor I08
VD_Old_I09      dd      ?               ;puvodni vektor I09
VD_Old_I0D      dd      ?               ;puvodni vektor I0D
VD_Old_I1B      dd      ?               ;puvodni vektor I1B

;

VW_Cursor       dw      ?               ;pozice kurzoru (radek, sloupec)

;

FW_Tbl_Tbl      dw      FW_Disp1_Tbl             ;adresy tabulek pro
                dw      FW_Disp2_Tbl              ;prevod dat ve VRAM

FW_Tbl_Msk      dw      0000111100000000b               ;masky pro zapis
                dw      0000000011110000b                ;do VRAM EGA

FB_Tbl_S61      db      0,3,3,3,2,2,2,2                 ;port 61h podle PC0-2
FB_Tbl_L42      db      0,0A8h,29h,54h,0,0,0,0          ;CNT2 low podle PC0-2
FB_Tbl_H42      db      0,4,1,2,0,0,0,0                 ;CNT2 high podle PC0-2

;

FB_Key_Cols     db      16 dup (?)      ;sloupce klavesnice
VB_Key_Shift    db      ?               ;stavy Shift a Stop

VB_Joy_State1   db      ?               ;stav kolmych smeru a fire joysticku
VB_Joy_State2   db      ?               ;stav smeru 7 a 3 (keypad) joysticku
VB_Joy_State3   db      ?               ;stav smeru 9 a 1 (keypad) joysticku

VB_TxE_Cnt      db      ?               ;pocet testu na 1Fh zbyvajicich do TxE

VW_PRN_Adr      dw      0               ;adresa portu pro tisk nebo 0
VW_TRN_Adr      dw      0               ;adresa portu pro prenos nebo 0

VB_Port_F4      db      0               ;stav portu 0F4h
VB_Port_F6      db      0               ;stav portu 0F5h

;
;;;
;;;;
;;;
;

ST_Joy_Key      struc
  VB_JK_Code    db      ?                       ;Scan kod klavesy
  VW_JK_Var     dw      ?                       ;offset menene promenne
  VB_JK_AND     db      0FFh                    ;maska pro AND
  VB_JK_OR      db      0                       ;maska pro OR
ST_Joy_Key      ends

FB_Joy_Keys     ST_Joy_Key      <39h,VB_Joy_State1,not 16,>
                ST_Joy_Key      <47h,VB_Joy_State2,not (2+8),>
                ST_Joy_Key      <48h,VB_Joy_State1,not 2,>
                ST_Joy_Key      <49h,VB_Joy_State3,not (2+4),>
                ST_Joy_Key      <4Bh,VB_Joy_State1,not 8,>
                ST_Joy_Key      <4Dh,VB_Joy_State1,not 4,>
                ST_Joy_Key      <4Fh,VB_Joy_State3,not (1+8),>
                ST_Joy_Key      <50h,VB_Joy_State1,not 1,>
                ST_Joy_Key      <51h,VB_Joy_State2,not (1+4),>

                ST_Joy_Key      <39h+80h,VB_Joy_State1,,16>
                ST_Joy_Key      <47h+80h,VB_Joy_State2,,2+8>
                ST_Joy_Key      <48h+80h,VB_Joy_State1,,2>
                ST_Joy_Key      <49h+80h,VB_Joy_State3,,2+4>
                ST_Joy_Key      <4Bh+80h,VB_Joy_State1,,8>
                ST_Joy_Key      <4Dh+80h,VB_Joy_State1,,4>
                ST_Joy_Key      <4Fh+80h,VB_Joy_State3,,1+8>
                ST_Joy_Key      <50h+80h,VB_Joy_State1,,1>
                ST_Joy_Key      <51h+80h,VB_Joy_State2,,1+4>

CW_JoyKeys_Nr   =       (offset $ - offset FB_Joy_Keys) / size ST_Joy_Key

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ FB_Tbl_PMDIns        tabulka pro disassemblovani instrukci PMD              ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Tvar tabulky :       1 bajt typ                                             ║
;║                         bity 0-1 ... delka instrukce - 1                    ║
;║                         bit 2 ...... cislo v bitech 3-5                     ║
;║                         bit 3 ...... podminka v bitech 3-5                  ║
;║                         bit 4 ...... registrovy par s SP v bitech 4-5       ║
;║                         bit 5 ...... registrovy par s PSW v bitech 4-5      ║
;║                         bit 6 ...... zdrojovy registr v bitech 0-2          ║
;║                         bit 7 ...... cilovy registr v bitech 3-5            ║
;║                      1 bajt instrukce po masce                              ║
;║                      4 bajty nazev instrukce doplneny nulami                ║
;╚═════════════════════════════════════════════════════════════════════════════╝

I_Nr            equ     4               ;definice hodnot pro zapis bajtu
I_Con           equ     8                ;podminky do tabulky instrukci
I_RSP           equ     16                ;a pro jejich vyhodnocovani
I_RPSW          equ     32                 ;pri disassemblovani a
I_Src           equ     64                  ;assemblovani
I_Dst           equ     128

;

FB_Tbl_PMDIns   db      0,76h,'HLT',0                   ;HLT musi predchazet
                db      I_Src+I_Dst,40h,'MOV',0          ;MOV

                db      I_Dst+1,6,'MVI',0
                db      I_RSP+2,1,'LXI' ,0

                db      2,32h,'STA',0                   ;STA a SHLD musi
                db      2,22h,'SHLD'                     ;predchazet STAX
                db      I_RSP,2,'STAX'

                db      2,3Ah,'LDA',0                   ;LDA a LHLD musi
                db      2,2Ah,'LHLD'                     ;predchazet LDAX
                db      I_RSP,0Ah,'LDAX'


                db      I_RPSW,0C5h,'PUSH'
                db      I_RPSW,0C1h,'POP',0

                db      0,0E3h,'XTHL'
                db      0,0F9h,'SPHL'
                db      0,0E9h,'PCHL'
                db      0,0EBh,'XCHG'

                db      2,0C3h,'JMP',0
                db      2,0CDh,'CALL'
                db      0,0C9h,'RET',0
                db      I_Nr,0C7h,'RST',0

                db      I_Dst,4,'INR',0
                db      I_Dst,5,'DCR',0
                db      I_RSP,3,'INX',0
                db      I_RSP,0Bh,'DCX',0

                db      I_Src,80h,'ADD',0
                db      I_Src,88h,'ADC',0
                db      1,0C6h,'ADI',0
                db      1,0CEh,'ACI',0
                db      I_RSP,9,'DAD',0

                db      I_Src,90h,'SUB',0
                db      I_Src,98h,'SBB',0
                db      1,0D6h,'SUI',0
                db      1,0DEh,'SBI',0

                db      I_Src,0A0h,'ANA',0
                db      I_Src,0A8h,'XRA',0
                db      I_Src,0B0h,'ORA',0
                db      I_Src,0B8h,'CMP',0
                db      1,0E6h,'ANI',0
                db      1,0EEh,'XRI',0
                db      1,0F6h,'ORI',0
                db      1,0FEh,'CPI',0

                db      0,7,'RLC',0
                db      0,0Fh,'RRC',0
                db      0,17h,'RAL',0
                db      0,1Fh,'RAR',0

                db      0,2Fh,'CMA',0
                db      0,37h,'STC',0
                db      0,3Fh,'CMC',0
                db      0,27h,'DAA',0

                db      1,0DBh,'IN',0,0
                db      1,0D3h,'OUT',0

                db      0,0FBh,'EI',0,0
                db      0,0F3h,'DI',0,0
                db      0,0,'NOP',0

                db      I_Con+2,0C2h,'J',0,0,0
                db      I_Con+2,0C4h,'C',0,0,0
                db      I_Con,0C0h,'R',0,0,0

CB_PMDIns_Nr    equ     (offset $ - offset FB_Tbl_PMDIns) / 6

                db      1,0,'DB',0,0            ;tady zustane pointer po hledani

;

FB_Tbl_Cond     db      'NZZ',0,'NCC',0,'POPE'  ;tabulka moznych podminek skoku
                db      'P',0,'M',0

FB_Tbl_Reg      db      'BCDEHLMA'              ;tabulka registru

FB_Tbl_RPSW     db      'B',0,0,0,'D',0,0,0     ;tabulka registrovych paru s PSW
                db      'H',0,0,0,'PSW',0

FB_Tbl_RSP      db      'B',0,'D',0,'H',0,'SP'  ;tabulka registrovych paru s SP

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ Key                  makro pro zapis klaves a jejich masek do tabulky       ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:               radek, ve kterem je klavesa u PMD 85 (K0 v radku 1)    ║
;║                      sloupec, ve kterem je klavesa u PMD 85 (K0 ve sl. 1)   ║
;║ Vystup:              bajt maska pro stisk na 0F5h, bajt sloupec na 0F4h     ║
;╚═════════════════════════════════════════════════════════════════════════════╝

Key             macro   CB_Row,CB_Column

                if      CB_Row eq 0
                  db      -1,0
                else
                  db      not(1 shl (CB_Row-1))
                  db      CB_Column-1
                endif

endm

;

FW_Tbl_Key      label   word

                Key     0                       ;00
                Key     0                       ;01 - Esc
                Key     2,1                     ;02 - 1 - 1
                Key     2,2                     ;03 - 2 - 2
                Key     2,3                     ;04 - 3 - 3
                Key     2,4                     ;05 - 4 - 4
                Key     2,5                     ;06 - 5 - 5
                Key     2,6                     ;07 - 6 - 6

                Key     2,7                     ;08 - 7 - 7
                Key     2,8                     ;09 - 8 - 8
                Key     2,9                     ;0A - 9 - 9
                Key     2,10                    ;0B - 0 - 0
                Key     2,11                    ;0C - - - _
                Key     2,12                    ;0D - + - }
                Key     3,13                    ;0E - BkSp - Left
                Key     0                       ;0F - Tab

                Key     3,1                     ;10 - Q - Q
                Key     3,2                     ;11 - W - W
                Key     3,3                     ;12 - E - E
                Key     3,4                     ;13 - R - R
                Key     3,5                     ;14 - T - T
                Key     3,6                     ;15 - Y - Z
                Key     3,7                     ;16 - U - U
                Key     3,8                     ;17 - I - I

                Key     3,9                     ;18 - O - O
                Key     3,10                    ;19 - P - P
                Key     3,11                    ;1A - [ - @
                Key     3,12                    ;1B - ] - \
                Key     5,15                    ;1C - Enter - EOL
                Key     0                       ;1D - Ctrl
                Key     4,1                     ;1E - A - A
                Key     4,2                     ;1F - S - S

                Key     4,3                     ;20 - D - D
                Key     4,4                     ;21 - F - F
                Key     4,5                     ;22 - G - G
                Key     4,6                     ;23 - H - H
                Key     4,7                     ;24 - J - J
                Key     4,8                     ;25 - K - K
                Key     4,9                     ;26 - L - L
                Key     4,10                    ;27 - ; - ;

                Key     4,11                    ;28 - ' - :
                Key     4,12                    ;29 - ` - ]
                Key     0                       ;2A - LShift
                Key     0                       ;2B - \
                Key     5,2                     ;2C - Z - Y
                Key     5,3                     ;2D - X - X
                Key     5,4                     ;2E - C - C
                Key     5,5                     ;2F - V - V

                Key     5,6                     ;30 - B - B
                Key     5,7                     ;31 - N - N
                Key     5,8                     ;32 - M - M
                Key     5,9                     ;33 - , - ,
                Key     5,10                    ;34 - . - .
                Key     5,11                    ;35 - / - /
                Key     0                       ;36 - RShift
                Key     0                       ;37 - PrtScr

                Key     0                       ;38 - Alt
                Key     5,1                     ;39 - Space - Space
                Key     0                       ;3A - Caps
                Key     1,1                     ;3B - F1 - K0
                Key     1,2                     ;3C - F2 - K1
                Key     1,3                     ;3D - F3 - K2
                Key     1,4                     ;3E - F4 - K3
                Key     1,5                     ;3F - F5 - K4

                Key     1,6                     ;40 - F6 - K5
                Key     1,7                     ;41 - F7 - K6
                Key     1,8                     ;42 - F8 - K7
                Key     1,9                     ;43 - F9 - K8
                Key     1,10                    ;44 - F10 - K9
                Key     0                       ;45 - Num
                Key     0                       ;46 - Scr
                Key     2,13                    ;47 - Home - Ins

                Key     2,14                    ;48 - Up - Del
                Key     2,15                    ;49 - PgUp - Clr
                Key     0                       ;4A - K-
                Key     3,13                    ;4B - Left - Left
                Key     3,14                    ;4C - K5 - Home
                Key     3,15                    ;4D - Right - Right
                Key     1,15                    ;4E - K+ - Rcl
                Key     4,13                    ;4F - End - LLeft

                Key     4,14                    ;50 - Down - End
                Key     4,15                    ;51 - PgDn - RRight
                Key     1,13                    ;52 - Ins - Wrk
                Key     1,14                    ;53 - Del - CD
                Key     0                       ;54 - SysRq
                Key     0                       ;55
                Key     0                       ;56
                Key     1,11                    ;57 - F11 - K10

                Key     1,12                    ;58 - F12 - K11

CB_Max_Key      equ     (offset $ - offset FW_Tbl_Key)/2-1

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ Inst                 makro pro zapis offsetu rutiny do tabulky              ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:               pripona navesti zacatku rutiny                         ║
;╚═════════════════════════════════════════════════════════════════════════════╝

Inst            macro   LabelName

                dw      offset LN_&LabelName

endm

;

FW_Tbl_Ins      label   word

                Inst    NOP                  ;00 NOP
                Inst    LXIB                 ;01 LXI B,w
                Inst    STAXB                ;02 STAX B
                Inst    INXB                 ;03 INX B
                Inst    INRB                 ;04 INR B
                Inst    DCRB                 ;05 DCR B
                Inst    MVIB                 ;06 MVI B,b
                Inst    RLC                  ;07 RLC
                Inst    NOP                  ;08 NOP
                Inst    DADB                 ;09 DAD B
                Inst    LDAXB                ;0A LDAX B
                Inst    DCXB                 ;0B DCX B
                Inst    INRC                 ;0C INR C
                Inst    DCRC                 ;0D DCR C
                Inst    MVIC                 ;0E MVI C,b
                Inst    RRC                  ;0F RRC

                Inst    NOP                  ;10 NOP
                Inst    LXID                 ;11 LXI D,w
                Inst    STAXD                ;12 STAX D
                Inst    INXD                 ;13 INX D
                Inst    INRD                 ;14 INR D
                Inst    DCRD                 ;15 DCR D
                Inst    MVID                 ;16 MVI D,b
                Inst    RAL                  ;17 RAL
                Inst    NOP                  ;18 NOP
                Inst    DADD                 ;19 DAD D
                Inst    LDAXD                ;1A LDAX D
                Inst    DCXD                 ;1B DCX D
                Inst    INRE                 ;1C INR E
                Inst    DCRE                 ;1D DCR E
                Inst    MVIE                 ;1E MVI E,b
                Inst    RAR                  ;1F RAR

                Inst    NOP                  ;20 NOP
                Inst    LXIH                 ;21 LXI H,w
                Inst    SHLD                 ;22 SHLD w
                Inst    INXH                 ;23 INX H
                Inst    INRH                 ;24 INR H
                Inst    DCRH                 ;25 DCR H
                Inst    MVIH                 ;26 MVI H,b
                Inst    DAA                  ;27 DAA
                Inst    NOP                  ;28 NOP
                Inst    DADH                 ;29 DAD H
                Inst    LHLD                 ;2A LHLD w
                Inst    DCXH                 ;2B DCX H
                Inst    INRL                 ;2C INR L
                Inst    DCRL                 ;2D DCR L
                Inst    MVIL                 ;2E MVI L,b
                Inst    CMA                  ;2F CMA

                Inst    NOP                  ;30 NOP
                Inst    LXISP                ;31 LXI SP,w
                Inst    STA                  ;32 STA w
                Inst    INXSP                ;33 INX SP
                Inst    INRM                 ;34 INR M
                Inst    DCRM                 ;35 DCR M
                Inst    MVIM                 ;36 MVI M,b
                Inst    STC                  ;37 STC
                Inst    NOP                  ;38 NOP
                Inst    DADSP                ;39 DAD DP
                Inst    LDA                  ;3A LDA w
                Inst    DCXSP                ;3B DCX SP
                Inst    INRA                 ;3C INR A
                Inst    DCRA                 ;3D DCR A
                Inst    MVIA                 ;3E MVI A,b
                Inst    CMC                  ;3F CMC

                Inst    NOP                  ;40 MOV B,B
                Inst    MOVBC                ;41 MOV B,C
                Inst    MOVBD                ;42 MOV B,D
                Inst    MOVBE                ;43 MOV B,E
                Inst    MOVBH                ;44 MOV B,H
                Inst    MOVBL                ;45 MOV B,L
                Inst    MOVBM                ;46 MOV B,M
                Inst    MOVBA                ;47 MOV B,A
                Inst    MOVCB                ;48 MOV C,B
                Inst    NOP                  ;49 MOV C,C
                Inst    MOVCD                ;4A MOV C,D
                Inst    MOVCE                ;4B MOV C,E
                Inst    MOVCH                ;4C MOV C,H
                Inst    MOVCL                ;4D MOV C,L
                Inst    MOVCM                ;4E MOV C,M
                Inst    MOVCA                ;4F MOV C,A

                Inst    MOVDB                ;50 MOV D,B
                Inst    MOVDC                ;51 MOV D,C
                Inst    NOP                  ;52 MOV D,D
                Inst    MOVDE                ;53 MOV D,E
                Inst    MOVDH                ;54 MOV D,H
                Inst    MOVDL                ;55 MOV D,L
                Inst    MOVDM                ;56 MOV D,M
                Inst    MOVDA                ;57 MOV D,A
                Inst    MOVEB                ;58 MOV E,B
                Inst    MOVEC                ;59 MOV E,C
                Inst    MOVED                ;5A MOV E,D
                Inst    NOP                  ;5B MOV E,E
                Inst    MOVEH                ;5C MOV E,H
                Inst    MOVEL                ;5D MOV E,L
                Inst    MOVEM                ;5E MOV E,M
                Inst    MOVEA                ;5F MOV E,A

                Inst    MOVHB                ;60 MOV H,B
                Inst    MOVHC                ;61 MOV H,C
                Inst    MOVHD                ;62 MOV H,D
                Inst    MOVHE                ;63 MOV H,E
                Inst    NOP                  ;64 MOV H,H
                Inst    MOVHL                ;65 MOV H,L
                Inst    MOVHM                ;66 MOV H,M
                Inst    MOVHA                ;67 MOV H,A
                Inst    MOVLB                ;68 MOV L,B
                Inst    MOVLC                ;69 MOV L,C
                Inst    MOVLD                ;6A MOV L,D
                Inst    MOVLE                ;6B MOV L,E
                Inst    MOVLH                ;6C MOV L,H
                Inst    NOP                  ;6D MOV L,L
                Inst    MOVLM                ;6E MOV L,M
                Inst    MOVLA                ;6F MOV L,A

                Inst    MOVMB                ;70 MOV M,B
                Inst    MOVMC                ;71 MOV M,C
                Inst    MOVMD                ;72 MOV M,D
                Inst    MOVME                ;73 MOV M,E
                Inst    MOVMH                ;74 MOV M,H
                Inst    MOVML                ;75 MOV M,L
                Inst    HLT                  ;76 HLT
                Inst    MOVMA                ;77 MOV M,A
                Inst    MOVAB                ;78 MOV A,B
                Inst    MOVAC                ;79 MOV A,C
                Inst    MOVAD                ;7A MOV A,D
                Inst    MOVAE                ;7B MOV A,E
                Inst    MOVAH                ;7C MOV A,H
                Inst    MOVAL                ;7D MOV A,L
                Inst    MOVAM                ;7E MOV A,M
                Inst    NOP                  ;7F MOV A,A

                Inst    ADDB                 ;80 ADD B
                Inst    ADDC                 ;81 ADD C
                Inst    ADDD                 ;82 ADD D
                Inst    ADDE                 ;83 ADD E
                Inst    ADDH                 ;84 ADD H
                Inst    ADDL                 ;85 ADD L
                Inst    ADDM                 ;86 ADD M
                Inst    ADDA                 ;87 ADD A
                Inst    ADCB                 ;88 ADC B
                Inst    ADCC                 ;89 ADC C
                Inst    ADCD                 ;8A ADC D
                Inst    ADCE                 ;8B ADC E
                Inst    ADCH                 ;8C ADC H
                Inst    ADCL                 ;8D ADC L
                Inst    ADCM                 ;8E ADC M
                Inst    ADCA                 ;8F ADC A

                Inst    SUBB                 ;90 SUB B
                Inst    SUBC                 ;91 SUB C
                Inst    SUBD                 ;92 SUB D
                Inst    SUBE                 ;93 SUB E
                Inst    SUBH                 ;94 SUB H
                Inst    SUBL                 ;95 SUB L
                Inst    SUBM                 ;96 SUB M
                Inst    SUBA                 ;97 SUB A
                Inst    SBBB                 ;98 SBB B
                Inst    SBBC                 ;99 SBB C
                Inst    SBBD                 ;9A SBB D
                Inst    SBBE                 ;9B SBB E
                Inst    SBBH                 ;9C SBB H
                Inst    SBBL                 ;9D SBB L
                Inst    SBBM                 ;9E SBB M
                Inst    SBBA                 ;9F SBB A

                Inst    ANAB                 ;A0 ANA B
                Inst    ANAC                 ;A1 ANA C
                Inst    ANAD                 ;A2 ANA D
                Inst    ANAE                 ;A3 ANA E
                Inst    ANAH                 ;A4 ANA H
                Inst    ANAL                 ;A5 ANA L
                Inst    ANAM                 ;A6 ANA M
                Inst    ANAA                 ;A7 ANA A
                Inst    XRAB                 ;A8 XRA B
                Inst    XRAC                 ;A9 XRA C
                Inst    XRAD                 ;AA XRA D
                Inst    XRAE                 ;AB XRA E
                Inst    XRAH                 ;AC XRA H
                Inst    XRAL                 ;AD XRA L
                Inst    XRAM                 ;AE XRA M
                Inst    XRAA                 ;AF XRA A

                Inst    ORAB                 ;B0 ORA B
                Inst    ORAC                 ;B1 ORA C
                Inst    ORAD                 ;B2 ORA D
                Inst    ORAE                 ;B3 ORA E
                Inst    ORAH                 ;B4 ORA H
                Inst    ORAL                 ;B5 ORA L
                Inst    ORAM                 ;B6 ORA M
                Inst    ORAA                 ;B7 ORA A
                Inst    CMPB                 ;B8 CMP B
                Inst    CMPC                 ;B9 CMP C
                Inst    CMPD                 ;BA CMP D
                Inst    CMPE                 ;BB CMP E
                Inst    CMPH                 ;BC CMP H
                Inst    CMPL                 ;BD CMP L
                Inst    CMPM                 ;BE CMP M
                Inst    CMPA                 ;BF CMP A

                Inst    RNZ                  ;C0 RNZ
                Inst    POPB                 ;C1 POPB
                Inst    JNZ                  ;C2 JNZ w
                Inst    JMP                  ;C3 JMP w
                Inst    CNZ                  ;C4 CNZ w
                Inst    PUSHB                ;C5 PUSH B
                Inst    ADI                  ;C6 ADI b
                Inst    RST0                 ;C7 RST 0
                Inst    RZ                   ;C8 RZ
                Inst    RET                  ;C9 RET
                Inst    JZ                   ;CA JZ w
                Inst    NOP                  ;CB NOP
                Inst    CZ                   ;CC CZ w
                Inst    CALL                 ;CD CALL w
                Inst    ACI                  ;CE ACI b
                Inst    RST1                 ;CF RST 1

                Inst    RNC                  ;D0 RNC
                Inst    POPD                 ;D1 POPD
                Inst    JNC                  ;D2 JNC w
                Inst    OUT                  ;D3 OUT b
                Inst    CNC                  ;D4 CNC w
                Inst    PUSHD                ;D5 PUSH D
                Inst    SUI                  ;D6 SUI b
                Inst    RST2                 ;D7 RST 2
                Inst    RC                   ;D8 RC
                Inst    NOP                  ;D9 NOP
                Inst    JC                   ;DA JC w
                Inst    IN                   ;DB IN b
                Inst    CC                   ;DC CC w
                Inst    NOP                  ;DD NOP
                Inst    SBI                  ;DE SBI b
                Inst    RST3                 ;DF RST 3

                Inst    RPO                  ;E0 RPO
                Inst    POPH                 ;E1 POPH
                Inst    JPO                  ;E2 JPO w
                Inst    XTHL                 ;E3 XTHL
                Inst    CPO                  ;E4 CPO w
                Inst    PUSHH                ;E5 PUSH H
                Inst    ANI                  ;E6 ANI b
                Inst    RST4                 ;E7 RST 4
                Inst    RPE                  ;E8 RPE
                Inst    PCHL                 ;E9 PCHL
                Inst    JPE                  ;EA JPE w
                Inst    XCHG                 ;EB XCHG
                Inst    CPE                  ;EC CPE w
                Inst    NOP                  ;ED NOP
                Inst    XRI                  ;EE XRI b
                Inst    RST5                 ;EF RST 5

                Inst    RP                   ;F0 RP
                Inst    POPPSW               ;F1 POP PSW
                Inst    JP                   ;F2 JP w
                Inst    NOP                  ;F3 DI
                Inst    CP                   ;F4 CP w
                Inst    PUSHPSW              ;F5 PUSH PSW
                Inst    ORI                  ;F6 ORI b
                Inst    RST6                 ;F7 RST 6
                Inst    RM                   ;F8 RM
                Inst    SPHL                 ;F9 SPHL
                Inst    JM                   ;FA JM w
                Inst    NOP                  ;FB EI
                Inst    CM                   ;FC CM w
                Inst    NOP                  ;FD NOP
                Inst    CPI                  ;FE CPI b
                Inst    RST7                 ;FF RST 7

                .erre   (offset $ - offset FW_Tbl_Ins) eq 512

;
;;;
;;;;
;;;
;


;╔═════════════════════════════════════════════════════════════════════════════╗
;║ Prirazeni registru v simulatoru                                             ║
;╚═════════════════════════════════════════════════════════════════════════════╝

RA              equ     AL
RF              equ     AH
RPSW            equ     AX

RB              equ     CH
RC              equ     CL
RBC             equ     CX

RD              equ     DH
RE              equ     DL
RDE             equ     DX

RH              equ     BH
RL              equ     BL
RHL             equ     BX

RM              equ     byte ptr ds:[RHL]

RSP             equ     BP
RPC             equ     DI

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ Next         makro provadejici skok na rutinu instrukce adresovane v RPC    ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Podle hodnoty CB_NextFlg rozvine bud provedeni nasledujici instrukce, nebo  ║
;║ ukonceni simulace skokem na cs:VW_StopAdr. Obe moznosti jsou stejne dlouhe. ║
;╚═════════════════════════════════════════════════════════════════════════════╝

Next            macro

                ife     CB_NextFlg
                  retn                   ;;zastavit simulaci (1b)
                  nop                    ;;delky obou moznosti rozvinuti
                  retn                    ;;musi souhlasit a musi jit
                  dec   RPC                ;;prepnout v libovolne
                  retn                      ;;chvili
                  dec   RPC
                  retn
                  nop
                else
                  mov     si,ds:[RPC]    ;;instrukce (2b)
                  inc     RPC            ;;++PC (1b)
                  shl     si,1           ;;adresa v tabulce (2b)
                  jmp     es:[si]        ;;skok na rutinu (3b)
                endif

endm

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ MkL          makro definujici navesti pred instrukci                        ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup        pripona navesti vytvarene instrukce                            ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Podle hodnoty CB_NextFlg nadefinuje bud LN_XXX nebo LNX_XXX.                ║
;╚═════════════════════════════════════════════════════════════════════════════╝

MkL             macro   LabelName

                ife     CB_NextFlg
LNX_&LabelName:
                else
LN_&LabelName:
                endif

endm

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ Port                 makro pro zapis adresy obsluzne rutiny IN a OUT        ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup        pripona jmena obsluzne rutiny portu                            ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ V zavislosti na hodnote CB_NextFlg prelozi bud jako DW offset LN_XXX nebo   ║
;║ jako DW offset LNX_XXX.                                                     ║
;╚═════════════════════════════════════════════════════════════════════════════╝

Port            macro   ProcName

                ife     CB_NextFlg
                  dw      offset LNX_&ProcName
                else
                  dw      offset LN_&ProcName
                endif

endm

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ DispB        makro zajistujici prevod zapisovaneho bajtu do VRAM EGA        ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:       registr s adresou (Rxx nebo SI) - nutne UpCase                ║
;║              registr s daty (Rxx) - nutne UpCase  (umi i RM)               ║
;║ Nici:        SI                                                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Testne adresu, pokud je ve VRAM, prevede, vzdy pokracuje na Next.           ║
;║ Nejlepe chodi s parametry SI,RL.                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

DispB           macro   Reg_Adr,Reg_Dat
                local   LN_DispB_V

                cmp     Reg_Adr,0C000h          ;;ve VRAM ?
                jae     LN_DispB_V              ;;ano => prevod
                Next

LN_DispB_V:     ifdif   <&Reg_Adr>,<SI>         ;;pokud adresa neni v SI,
                  mov     si,Reg_Adr             ;;presunout ji tam
                endif

                push    bx
                push    di

                ifdif   <&Reg_Dat>,<RL>         ;;pokud data nejsou v BL,
                  mov     bl,Reg_Dat             ;;presunout je tam
                endif

                xor     bh,bh                   ;;pripravit bajt na hledani v
                shl     bl,1                     ;;tabulce obrazu

                shl     si,1                    ;;adresu na tabulku
                mov     di,011b                 ;;tabulka masek je mensi
                and     di,si                   ;;offset v tabulce masek

                add     bx,cs:FW_Tbl_Tbl[di]    ;;spravna tabulka obrazu
                mov     di,cs:FW_Tbl_Msk[di]    ;;spravna maska
                mov     si,cs:FW_Tbl_Adr-32768[si]      ;;adresa v EGA VRAM

                mov     ds,cs:VW_EGA_Seg        ;;segment VRAM
                and     di,ds:[si]              ;;zamaskovat obsah VRAM
                or      di,cs:[bx]              ;;pridat zobrazovane bajty
                mov     ds:[si],di              ;;zobrazit
                mov     ds,cs:VW_PMD_Seg        ;;puvodni DS

                pop     di
                pop     bx

                Next                            ;;pokracovat

endm

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ DispW        makro zajistujici prevod 2 bajtu do VRAM EGA                   ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:       registr s adresou zapsanych dat (Rxx nebo SI) - nutne UpCase  ║
;║ Nici:        SI                                                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Testne adresu, pokud je ve VRAM, prevede, vzdy pokracuje na Next.           ║
;╚═════════════════════════════════════════════════════════════════════════════╝

DispW           macro   Reg_Adr
                local   LN_DispW_B,LN_DispW_S,LN_DispW_E

                cmp     Reg_Adr,0BFFFh          ;;ve VRAM ?
                jae     LN_DispW_B              ;;ano => prevod
                Next

LN_DispW_B:     ifdif   <&Reg_Adr>,<SI>         ;;pokud adresa neni v SI,
                  mov     si,Reg_Adr             ;;presunout ji tam
                endif

                push    bx
                push    cx
                push    di

                mov     bx,ds:[si]              ;;2 bajty dat do BX
                mov     cl,bh                   ;;horni schovat do CL
                xor     ch,ch                   ;;CH = 0

                mov     ds,cs:VW_EGA_Seg        ;;segment VRAM

                shl     si,1                    ;;na offset v tabulce
                cmp     si,0C000h shl 1         ;;je prvni bajt ve VRAM ?
                jb      LN_DispW_S              ;;ne => brat az druhy

                push    si
                mov     bh,ch                   ;;= 0

                shl     bl,1                    ;;offset v tabulce obrazu
                mov     di,011b                 ;;tabulka masek je mensi
                and     di,si                   ;;offset v tabulce masek

                add     bx,cs:FW_Tbl_Tbl[di]    ;;spravna tabulka obrazu
                mov     bx,cs:[bx]              ;;spravny obraz
                mov     di,cs:FW_Tbl_Msk[di]    ;;spravna maska
                mov     si,cs:FW_Tbl_Adr-32768[si]      ;;adresa v EGA VRAM

                and     di,ds:[si]              ;;zamaskovat obsah VRAM
                or      bx,di                   ;;pridat zobrazovane bajty
                mov     ds:[si],bx              ;;zobrazit

                pop     si                      ;;adresa ve VRAM
LN_DispW_S:     add     si,2                    ;;na dalsi bajt
                jc      LN_DispW_E              ;;druhy bajt neni ve VRAM

                mov     bx,cx                   ;;druhy bajt
                shl     bl,1                    ;;offset v tabulce obrazu
                mov     di,011b                 ;;tabulka masek je mensi
                and     di,si                   ;;offset v tabulce masek

                add     bx,cs:FW_Tbl_Tbl[di]    ;;spravna tabulka obrazu
                mov     bx,cs:[bx]              ;;spravny obraz
                mov     di,cs:FW_Tbl_Msk[di]    ;;spravna maska
                mov     si,cs:FW_Tbl_Adr-32768[si]      ;;adresa v EGA VRAM

                and     di,ds:[si]              ;;zamaskovat obsah VRAM
                or      bx,di                   ;;pridat zobrazovane bajty
                mov     ds:[si],bx              ;;zobrazit

LN_DispW_E:     mov     ds,cs:VW_PMD_Seg        ;;puvodni DS

                pop     di
                pop     cx
                pop     bx

                Next                            ;;pokracovat

endm

;
;;;
;;;;
;;;
;

CB_NextFlg      =       -1                      ;prekladat tabulky pro beh
LN_InstNext:
                include PMDport.asm             ;tabulky rutin IN a OUT
                include PMDins.asm              ;vykonne rutiny simulatoru

CB_NextFlg      =       0                       ;prekladat tabulky pro ladeni
LN_InstStep:
                include PMDport.asm             ;tabulky rutin IN a OUT
                include PMDins.asm              ;vykonne rutiny simulatoru

LN_InstLast:
CW_InstDif      equ     offset LN_InstStep - offset LN_InstNext

;
;;;
;;;;
;;;
;

FB_Tbl_Chr      label   byte
                include PMDfont.asm             ;znakova sada

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PF_My_I08            osetreni Auto-EoF na INT 08                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PF_My_I08       proc    far
;
                push    bp                              ;pozice v zasobniku
                mov     bp,sp

                pushf
                call    cs:dword ptr VD_Old_I08         ;zavolat puvodni vektor

                inc     cs:VB_EoF_Timer                 ;posunout cas pro EoF

                inc     cs:VB_I08_Busy                  ;proti rekurzi
                cmp     cs:VB_I08_Busy,1                ;jiz vyvolan ?
                jne     PF_I08_End                      ;ano => ven

                test    cs:VB_EoF_Flg,-1                ;je EoF zapnuto ?
                jz      PF_I08_End                      ;ne => ven
                cmp     cs:VW_MgOut_Ofs,1               ;je soubor otevreny ?
                jbe     PF_I08_End                      ;ne => ven
                cmp     cs:VB_EoF_Timer,55              ;3 vteriny ?
                jb      PF_I08_End                      ;ne => ven

                push    si

                mov     si,cs                           ;segment simulatoru
                cmp     si,ss:[bp+4]                    ;volal simulator ?
                jne     PF_I08_NoSim                    ;ne => ven

                push    ds                              ;schovava SI,DS a ES,
                push    es                               ;ktere nici PN_Rest_XX

                call    PN_Rest_PC                      ;do kontextu PC
                call    PN_Flush_MgOut                  ;zavrit MG vystup
                mov     VW_Err_Msg,offset FB_MgOCl_Msg  ;zprava o uzavreni
                call    PN_Disp_Msg                     ;vypsat ji
                call    PN_Set_White
                call    PN_Rest_PMD                     ;do kontextu PMD

                pop     es
                pop     ds

PF_I08_NoSim:   pop     si

PF_I08_End:     dec     cs:VB_I08_Busy                  ;rekurentni citac
                pop     bp
                iret

PF_My_I08       endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PF_My_I09            osetreni preruseni z klavesnice                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PF_My_I09       proc    far
;
                push    bp                      ;schovat SP pro pripadnou
                mov     bp,sp                    ;zmenu navratove adresy
                push    ax
                push    bx
                push    ds

                mov     ax,cs
                mov     ds,ax                   ;svuj segment

                in      al,60h                  ;Scan kod

                test    VB_Stick_Flg,-1         ;je Joy ?
                jz      PF_I09_NoJoy            ;ne => dal

                push    cx

                lea     bx,FB_Joy_Keys          ;tabulka klaves pro Joy
                mov     cx,CW_JoyKeys_Nr        ;pocet klaves v tabulce
PF_I09_JoyKey:  cmp     al,ds:[bx]              ;shodna klavesa ?
                jne     PF_I09_NextJoy          ;ne => dal

                push    si

                mov     si,VW_JK_Var[bx]        ;ano => menena promenna
                mov     al,VB_JK_AND[bx]        ;zmenit masku
                and     ds:[si],al
                mov     al,VB_JK_OR[bx]
                or      ds:[si],al

                pop     si
                pop     cx
                jmp     PF_I09_End

PF_I09_NextJoy: add     bx,size ST_Joy_Key      ;vsechny klavesy joysticku
                loop    PF_I09_JoyKey

                pop     cx                      ;nebyl joy => zkusit ostatni

PF_I09_NoJoy:   mov     bl,al                   ;Scan do BX
                xor     bh,bh

                test    bl,80h                  ;uvolneni klavesy ?
                jnz     PF_I09_Rel              ;ano

                cmp     bl,1                    ;Esc ?
                je      PF_I09_Esc
                cmp     bl,1Dh                  ;Ctrl - Stop
                je      PF_I09_PStop
                cmp     bl,2Ah                  ;LShift - Shift
                je      PF_I09_PShift
                cmp     bl,36h                  ;RShift - Shift
                je      PF_I09_PShift

                cmp     bl,CB_Max_Key
                ja      PF_I09_End              ;neznama => ignorovat

                shl     bx,1                            ;na index v tabulce
                mov     al,byte ptr FW_Tbl_Key[bx]      ;maska
                mov     bl,byte ptr FW_Tbl_Key[bx+1]    ;sloupec u PMD
                and     FB_Key_Cols[bx],al              ;oznacit stisk

PF_I09_End:     in      al,61h                  ;odblokovat klavesnici
                mov     ah,al
                or      al,80h
                out     61h,al
                mov     al,ah
                out     61h,al

                mov     al,20h                  ;EoI
                out     20h,al

                pop     ds
                pop     bx
                pop     ax
                pop     bp

                iret

;

PF_I09_Rel:     and     bl,7Fh                  ;odstranit priznak uvolneni

                cmp     bl,1Dh                  ;Ctrl - Stop
                je      PF_I09_RStop
                cmp     bl,2Ah                  ;LShift - Shift
                je      PF_I09_RShift
                cmp     bl,36h                  ;RShift - Shift
                je      PF_I09_RShift

                cmp     bl,CB_Max_Key
                ja      PF_I09_End              ;neznama => ignorovat

                shl     bx,1                            ;na index v tabulce
                mov     al,byte ptr FW_Tbl_Key[bx]      ;maska
                mov     bl,byte ptr FW_Tbl_Key[bx+1]    ;sloupec u PMD
                not     al
                or      FB_Key_Cols[bx],al              ;oznacit uvolneni
                jmp     short PF_I09_End

;

PF_I09_PStop:   and     VB_Key_Shift,10111111b  ;oznacit stisk
                jmp     short PF_I09_End

PF_I09_PShift:  and     VB_Key_Shift,11011111b  ;oznacit stisk
                jmp     short PF_I09_End

PF_I09_RStop:   or      VB_Key_Shift,01000000b  ;oznacit uvolneni
                jmp     short PF_I09_End

PF_I09_RShift:  or      VB_Key_Shift,00100000b  ;oznacit uvolneni
                jmp     short PF_I09_End

;

PF_I09_Esc:     cmp     word ptr ss:[bp+2],offset LN_InstNext   ;pokud bezi
                jb      PF_I09_No2nd                             ;prvni sada
                cmp     word ptr ss:[bp+2],offset LN_InstStep     ;instrukci,
                jae     PF_I09_No2nd                               ;prepnout
                mov     ax,cs                                       ;do druhe
                cmp     ax,ss:[bp+4]
                jne     PF_I09_No2nd
                add     word ptr ss:[bp+2],CW_InstDif   ;prepnuti sady
PF_I09_No2nd:   mov     VW_Step_Adr,offset LN_Dbg_Err   ;nastavit Single Step
                mov     VW_Err_Msg,offset FB_Break_Msg  ;zprava o preruseni
                jmp     PF_I09_End

PF_My_I09       endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PF_My_I0D            osetreni Segment Override Exception                    ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PF_My_I0D       proc    far
;
                push    bp
                mov     bp,sp
                push    ax
                push    bx
                push    cx
                push    ds

                mov     ax,cs
                cmp     ss:[bp+4],ax            ;volano ze simulatoru ?
                jne     PF_I0D_Other            ;ne => puvodni vektor

                mov     ds,ax                   ;=CS

                mov     bx,ss:[bp+2]            ;offset provinile instrukce
                mov     al,ds:[bx]              ;operacni kod
                inc     bx

                cmp     al,3Eh                  ;predpona pro DS ?
                jne     PF_I0D_NoDS             ;ne
                mov     al,ds:[bx]
                inc     bx                      ;ano => az dalsi bajt

PF_I0D_NoDS:    mov     ah,ds:[bx]              ;zpusob adresace
                and     ah,0C0h                 ;izolovat pole MOD
                jz      PF_I0D_NoDisp           ;displacement je 0
                cmp     ah,40h                  ;displacement 1 bajt
                jne     PF_I0D_ErrIns           ;neosetrena adresace
                mov     cx,2                    ;preskakovane bajty

PF_I0D_Inst:    mov     ah,ds:[bx]              ;jeste jednou adresace
                and     ah,38h                  ;izolovat pouzity registr
                shr     ah,1                     ;do bitu 0-2
                shr     ah,1
                shr     ah,1

                add     bx,cx                   ;najit nasledujici instrukci
                mov     ss:[bp+2],bx            ;zapsat jako navratovou adresu

                cmp     al,89h                  ;MOV reg,mem ?
                je      PF_I0D_ToMem
                cmp     al,8Bh                  ;MOV mem,reg ?
                je      PF_I0D_ToReg

PF_I0D_ErrIns:  mov     VW_Err_Msg,offset FB_SegOr_Msg
                call    PN_Disp_Msg                             ;zpravu

                cli                             ;nedefinovana operace =>
                jmp     $                        ;zablokovat PC

;

PF_I0D_NoDisp:  mov     ah,ds:[bx]              ;znovu zpusob adresace
                and     ah,7                    ;nechat pole R/M
                cmp     ah,6
                je      PF_I0D_ErrIns           ;neosetrena adresace
                mov     cx,1                    ;preskakovane bajty
                jmp     short PF_I0D_Inst

;

PF_I0D_Other:   pop     ds
                pop     cx
                pop     bx
                pop     ax
                pop     bp

                jmp     [cs:dword ptr VD_Old_I0D]

;

PF_I0D_ToMem:   and     VB_I0D_WrReg,not 7      ;vytvorit instrukci MOV BX,xx
                or      VB_I0D_WrReg,ah

                pop     ds
                pop     cx
                pop     bx
                pop     ax
                pop     bp

                push    bx
                db      8Bh                     ;MOV reg16,r/m16
VB_I0D_WrReg    db      0D8h                    ;reg16=BX,r/m16=reg

                mov     ds:[0FFFFh],bl          ;zapsat hodnotu nadvakrat
                mov     ds:[0],bh
                pop     bx

                iret

;

PF_I0D_ToReg:   and     VB_I0D_RdReg,not 7      ;vytvorit instrukci MOV xx,im16
                or      VB_I0D_RdReg,ah

                pop     ds

                mov     bl,ds:[0FFFFh]          ;nacist hodnotu nadvakrat
                mov     bh,ds:[0]
                mov     cs:VW_I0D_RdVal,bx      ;do MOV xx,im16

                pop     cx
                pop     bx
                pop     ax
                pop     bp

VB_I0D_RdReg    db      0B8h                    ;MOV reg16,im
VW_I0D_RdVal    dw      ?

                iret

PF_My_I0D       endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PF_My_I1B            IRET pro zablokovani Ctrl-Break                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PF_My_I1B       proc    far
;
                iret

PF_My_I1B       endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PF_My_I24            Critical Error Handler, vzdy vraci FAIL (AL=3)         ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PF_My_I24       proc    far
;
                mov     al,3
                iret

PF_My_I24       endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Blink         nastavi EGA radic pro kresbu na blikajicim pozadi      ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Blink    proc    near
;
                push    bx
                mov     bx,607h                 ;0 - 0110, 1 - 1110
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_Blink    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Bold          nastavi EGA radic pro kresbu ve zvysene intenzite      ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Bold     proc    near
;
                push    bx
                mov     bx,11                   ;0 - 0000, 1 - 0100
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_Bold     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Norm          nastavi EGA radic pro kresbu v normalni intenzite      ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Norm     proc    near
;
                push    bx
                mov     bx,13                   ;0 - 0000, 1 - 0010
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_Norm     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Red           nastavi EGA radic pro kresbu v cervene                 ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Red      proc    near
;
                push    bx
                mov     bx,14                   ;0 - 0000, 1 - 0001
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_Red      endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Yellow        nastavi EGA radic pro kresbu ve zlute                  ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Yellow   proc    near
;
                push    bx
                mov     bx,10                   ;0 - 0000, 1 - 0101
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_Yellow   endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_White         nastavi EGA radic pro kresbu v bile                    ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_White    proc    near
;
                push    bx
                mov     bx,12                   ;0 - 0000, 1 - 0011
                call    PN_Set_Color
                pop     bx

                ret

PN_Set_White    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_Color         nastavi EGA radic pro kresbu ve vybrane barve          ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       BH              hodnota Set/Reset registru                     ║
;║              BL              hodnota Enable Set/Reset registru              ║
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_Color    proc    near
;
                push    ax
                push    dx

                mov     dx,CW_Acc_Port          ;Graph Cntl Addr

                xor     al,al                   ;na Set/Reset registr
                out     dx,al
                inc     dx
                mov     al,bh
                out     dx,al
                dec     dx

                mov     al,1                    ;na Enable Set/Reset registr
                out     dx,al
                inc     dx
                mov     al,bl
                out     dx,al

                pop     dx
                pop     ax

                ret

PN_Set_Color    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_CO                vykresli na obrazovku znak na pozici kurzoru           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       AL      ASCII kod znaku (KeybCS)                               ║
;║ Nici:        nic                                                            ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Neovlada zadne ridici kody => lze tisknout znaky s ASCII 0-255.             ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_CO           proc    near
;
                push    ax
                push    cx
                push    dx
                push    si
                push    di
                push    es

                mov     ah,13                   ;vyska znaku je 13 radek
                mul     ah                      ;prepocitat na offset
                mov     si,offset FB_Tbl_Chr
                add     si,ax                   ;offset v tabulce znaku

                mov     ax,VW_Cursor            ;pozice kurzoru
                mov     cl,ah                   ;schovat sloupec
                xor     ah,ah
                xor     ch,ch
                mov     dx,80*13                ;pocet bajtu na znakovy radek
                mul     dx                      ;vynasobit
                add     ax,cx                   ;+ pozice na radku
                mov     di,ax

                mov     es,VW_EGA_Seg           ;segment EGA VRAM
                mov     cx,13                   ;vyska znaku
                cld
PN_CO_DChr:     movsb
                add     di,80-1                 ;vykreslit cely znak
                loop    PN_CO_DChr

                inc     byte ptr VW_Cursor+1    ;na dalsi znak

                pop     es
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     ax

                ret

PN_CO           endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_ClrEOL            smaze obrazovku do konce radku                         ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        AL,CX                                                          ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_ClrEOL       proc    near
;
                mov     cx,79                           ;znaku na radku
                sub     cl,byte ptr VW_Cursor+1         ;zbytek do konce radku
                mov     al,' '                          ;vyplnit mezerami
PN_CE_Clear:    call    PN_CO
                loop    PN_CE_Clear

                ret

PN_ClrEol       endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_DTxt              vypise na obrazovku text od pozice kurzoru             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       SI      ASCIIZ retezec textu                                   ║
;║ Vystup:      SI      adresa za ukoncovaci nulou                             ║
;║ Nici:        AL,(AX)                                                        ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Ovlada ridici kody definovane v konstantach.                                ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_DTxt         proc    near
;
                cld
PN_DT_Rd:       lodsb

                or      al,al                   ;konec textu
                jz      PN_DT_End
                cmp     al,CB_Set_Bold          ;zvyseny jas
                je      PN_DT_SB
                cmp     al,CB_Set_Norm          ;normalni jas
                je      PN_DT_RB
                cmp     al,CB_Set_Curs          ;nastavit kurzor
                je      PN_DT_SC

                call    PN_CO                   ;vytisknout znak
                jmp     short PN_DT_Rd

PN_DT_SB:       call    PN_Set_Bold             ;vyssi intenzita
                jmp     short PN_DT_Rd

PN_DT_RB:       call    PN_Set_Norm             ;normalni intenzita
                jmp     short PN_DT_Rd

PN_DT_SC:       lodsw                           ;nova pozice
                mov     VW_Cursor,ax
                jmp     short PN_DT_Rd

PN_DT_End:      ret

PN_DTxt         endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Disp_Msg          vypise nastavenou zpravu                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        hafo                                                           ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Disp_Msg     proc    near
;
                call    PN_Set_Bold                     ;hlasku psat vyrazne
                mov     VW_Cursor,2*256+23
                mov     si,VW_Err_Msg                   ;hlaseni o stavu
                call    PN_DTxt
                call    PN_ClrEOL                       ;smazat zbytek radku
                call    PN_Set_Norm                     ;zpatky do zelene

                ret

PN_Disp_Msg     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Disp_Stat         vypise stavove informace                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        hafo                                                           ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Disp_Stat    proc    near
;
                call    PN_Set_Yellow                   ;prepinace psat zlute

                mov     VW_Cursor,8*256+22
                mov     al,VB_Sound_Flg
                call    PN_DS_DispFlg                   ;informace o prepinacich

                mov     VW_Cursor,18*256+22
                mov     al,VB_LED_Flg
                call    PN_DS_DispFlg

                mov     VW_Cursor,33*256+22
                mov     al,VB_Stick_Flg
                call    PN_DS_DispFlg

                mov     VW_Cursor,48*256+22
                mov     al,VB_EoF_Flg
                call    PN_DS_DispFlg

                mov     VW_Cursor,59*256+22
                mov     al,VB_PRN_Flg
                call    PN_DS_DispPrt

                mov     VW_Cursor,73*256+22
                mov     al,VB_TRN_Flg
                call    PN_DS_DispPrt

                call    PN_Set_Norm             ;zpatky do zelene

                ret

;

PN_DS_DispFlg:  lea     si,[FB_Yes_Txt]
                or      al,al
                jnz     PN_DS_DF_Yes
                mov     si,offset FB_No_Txt
PN_DS_DF_Yes:   call    PN_Dtxt
                ret

;

PN_DS_DispPrt:  lea     si,[FB_NoP_Txt]
                or      al,al
                jz      PN_DS_DP_Empty
                lea     si,[FB_Prt_Txt]
                add     al,'0'
                mov     [VB_PrtTxt_Nr],al
PN_DS_DP_Empty: call    PN_Dtxt
                ret

PN_Disp_Stat    endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Disp_AX           vypise v HEX obsah AX                                  ║
;║ PN_Disp_AL           vypise v HEX obsah AL                                  ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       AL(AX)          vypisovane cislo                               ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Disp_Acc     proc    near
;
PN_Disp_AX:     xchg    ah,al           ;vypsat AH
                call    PN_Disp_AL
                xchg    ah,al

PN_Disp_AL:     call    PN_DA_Upper     ;horni pulku AL

PN_DA_Upper:    rol     al,1            ;cislo do AL bity 0-3
                rol     al,1
                rol     al,1
                rol     al,1
                push    ax
                and     al,0Fh          ;jen cislo
                add     al,'0'          ;na ASCII
                cmp     al,'9'           ;vcetne HEX znaku
                jbe     PN_DA_NoHex
                add     al,'A'-'0'-10
PN_DA_NoHex:    call    PN_CO
                pop     ax

                ret

PN_Disp_Acc     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Write_Nr          zapise cislo v HEX do ASCII retezce                    ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       AX      zapisovane cislo                                       ║
;║              DI      adresa 4 bajtu pro ASCII tvar                          ║
;║ Vystup:      DI      adresa za 4 bajty                                      ║
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Write_Nr     proc    near
;
                push    cx

                mov     cx,404h         ;CH - pocet cisel, CL - bity na cislici
PN_WN_Main:     rol     ax,cl           ;cislo do AL bity 0-3
                push    ax
                and     al,0Fh          ;jen cislo
                add     al,'0'          ;na ASCII
                cmp     al,'9'           ;vcetne HEX znaku
                jbe     PN_WN_NoHex
                add     al,'A'-'0'-10
PN_WN_NoHex:    mov     ds:[di],al
                pop     ax
                inc     di              ;na dalsi pozici
                dec     ch              ;pro vsechny 4 cislice
                jnz     PN_WN_Main

                pop     cx

                ret

PN_Write_Nr     endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Dos_Err           umisti do VW_Err_Msg adresu hlasky z DOS fn 59h        ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Dos_Err      proc    near
;
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di

                push    ds
                push    es

                xor     bx,bx                   ;verze chybove informace
                mov     ah,59h                  ;Get Extended Error
                int     21h

                pop     es                      ;tato sluzba DOSu nici
                pop     ds                       ;i registry DS a ES

                cmp     ax,CW_MaxDOS_Err        ;prekrocen limit chyb ?
                ja      PN_DE_UnknErr           ;ano => neznama chyba
                or      ax,ax                   ;zadna chyba
                jz      PN_DE_UnknErr           ;ano => neznama chyba

                mov     si,offset FB_DosErr_Msg-1       ;seznam hlaseni
PN_DE_Search:   inc     si
PN_DE_NextMsg:  test    byte ptr ds:[si],-1     ;preskocit na dalsi hlasku
                jnz     PN_DE_Search
                inc     si
                dec     ax
                jnz     PN_DE_NextMsg

PN_DE_Found:    test    byte ptr ds:[si],-1     ;existuje text hlasky ?
                jnz     PN_DE_MsgOk             ;ano => zapsat
PN_DE_UnknErr:  mov     si,offset FB_XErr_Msg   ;ne => obecna hlaska
PN_DE_MsgOk:    mov     VW_Err_Msg,si           ;zapsat hlasku

                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax

                ret

PN_Dos_Err      endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_Menu              vykresli menu, necha vybrat a skoci na danou rutinu    ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       DX              adresa dat menu                                ║
;╚═════════════════════════════════════════════════════════════════════════════╝

LN_Menu         label   near
;
                mov     si,offset FB_Mnu_Txt    ;kurzor + hlavicka
                call    PN_DTxt

                mov     si,dx                   ;text menu
                call    PN_DTxt
                call    PN_ClrEOL

LN_Mn_Key:      call    PN_CI                   ;klavesu
                lea     di,[si-3]               ;adresa tabulky - 3

LN_Mn_Search:   add     di,3
                test    byte ptr ds:[di],-1     ;konec tabulky ?
                jz      LN_Mn_Key               ;ano => dalsi klavesu
                cmp     al,ds:[di]              ;shodna klavesa ?
                jne     LN_Mn_Search            ;ne => dal

                mov     VW_Cursor,2*256+25      ;smazat text menu
                call    PN_ClrEOL
                jmp     ds:[di+1]               ;vyvolat rutinu

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Draw_Box          vykresli na obrazovku obdelnik                         ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       DI              adresa leveho horniho rohu ve VRAM             ║
;║              BX              vyska obdelniku v bodech - 2                   ║
;║              CX              sirka obdelniku v bajtech - 2                  ║
;║ Nici:        AL,CX,DX,SI,DI,ES                                              ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Draw_Box     proc    near
;
                mov     es,VW_EGA_Seg           ;bude se cmarat do VRAM
                cld

                mov     si,di                   ;schovat adresu rohu
                mov     dx,cx                   ;schovat sirku obdelniku

                mov     al,00000111b
                stosb                           ;levy horni roh
                mov     al,11111111b
                rep stosb                       ;horni cara
                mov     al,11100000b
                stosb                           ;pravy horni roh

                mov     cx,bx
                mov     al,00100000b            ;prava cara
PN_DB_Draw1:    add     di,79
                stosb
                loop    PN_DB_Draw1

                mov     di,si                   ;puvodni roh
                add     di,80                   ;o radek pod nej

                mov     cx,bx
                mov     al,00000100b
PN_DB_Draw2:    stosb
                add     di,79                   ;leva cara
                loop    PN_DB_Draw2

                mov     al,00000111b
                stosb                           ;levy dolni roh
                mov     cx,dx
                mov     al,11111111b
                rep stosb                       ;dolni cara
                mov     al,11100000b
                stosb                           ;pravy dolni roh

                ret

PN_Draw_Box     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Draw_Scr          vykresli na obrazovku zakladni informace               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        AX,CX,DI,ES                                                    ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Draw_Scr     proc    near
;
                call    PN_Set_Red              ;ramecky cervene

                mov     di,(640-2*288)/16-1+13*80       ;udelat ramecek
                mov     cx,2*288/8                       ;pro obrazovku
                mov     bx,256+2                          ;PMD
                call    PN_Draw_Box

                mov     di,21*13*80+7*80
                mov     cx,78                           ;ramecek dole
                mov     bx,4*13+10
                call    PN_Draw_Box

                mov     di,24*13*80+5*80+1
                mov     cx,76                           ;rozdelit spodni
                mov     bx,1                             ;ramecek
                call    PN_Draw_Box

                mov     si,offset FB_Main_Txt           ;nazev programu,
                call    PN_DTxt                          ;texty oken adt.

                ret

PN_Draw_Scr     endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_CI                nacte klavesu sluzbou INT 16h BIOSu, z pismen UpCase   ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vystup:      AX      ASCII kod znaku a SCAN kod                             ║
;║ Nici:        nic                                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_CI           proc    near
;
                xor     ax,ax
                int     16h                     ;klavesu cist BIOSem

                cmp     al,'a'
                jb      PN_CI_End               ;z pismen delat UpCase
                cmp     al,'z'
                ja      PN_CI_End

                sub     al,'a'-'A'

PN_CI_End:      ret

PN_CI           endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Keybd_Cmd         posle do klavesnice prikaz                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       AH      prikaz pro klavesnici                                  ║
;║ Nici:        AL,CX                                                          ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Procedura nevraci stav provedene operace.                                   ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Keybd_Cmd    proc    near
;
                cli

                in      al,60h                  ;vyprazdnit buffer

                xor     cx,cx                   ;pro Time-Out
PN_KC_TstIn:    in      al,64h                  ;stavovy registr
                test    al,2                    ;cekat na Ready-In
                je      PN_KC_RdyIn             ;je to tady
                loop    PN_KC_TstIn             ;nedockal se => ven
                jmp     short PN_KC_End

PN_KC_RdyIn:    mov     al,ah                   ;datovy bajt
                out     60h,al                  ;vyslat do klavesnice

                xor     cx,cx                   ;pro Time-Out
PN_KC_TstOut:   in      al,64h                  ;pockat na Acknowledge
                test    al,1
                jne     PN_KC_RdyOut            ;je to tady
                loop    PN_KC_TstOut            ;neni => ven
                jmp     short PN_KC_End

PN_KC_RdyOut:   mov     al,20h                  ;smazat pozadavek preruseni
                out     20h,al                   ;od klavesnice

PN_KC_End:      sti                             ;netestovat 0FAh poslane zpatky
                ret

PN_Keybd_Cmd    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Read_Line         nacte z klavesnice radek                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       SI      ASCIIZ prompt                                          ║
;║              BX      buffer pro radek s implicitnim textem (ASCIIZ)         ║
;║ Vystup:      CF      1 => vyskocil stiskem ESC, 0 => Enter                  ║
;║ Nici:        AX,CX,DX                                                       ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Read_Line    proc    near
;
                push    si
                push    di

                mov     VW_Cursor,2*256+25      ;vstupni radek
                call    PN_DTxt                 ;vytisknout prompt

                mov     dl,-1                   ;priznak prvni klavesy
                mov     si,bx                   ;pozice na radku
                lea     di,[bx-1]               ;najit konec implicitniho textu
PN_RL_ImpLen:   inc     di                       ;(ukonceny nulou)
                test    byte ptr ds:[di],-1
                jnz     PN_RL_ImpLen

PN_RL_Main:     push    VW_Cursor               ;schovat pozici vypisu
                push    bx                       ;a zacatek radku

                mov     cx,CB_Line_Len          ;nejvyssi pocet znaku + 1
                xor     dh,dh                   ;priznak vytisteni kurzoru
PN_RL_Disp:     mov     al,ds:[bx]              ;znak z bufferu
                cmp     bx,si                   ;kurzor ?
                jne     PN_RL_NoCurs            ;ne => nic
                or      dh,dh                   ;byl uz kurzor ?
                jnz     PN_RL_NoCurs            ;ano => nic
                call    PN_Set_Blink            ;ne => blikajici pozadi
                not     dh                      ;priznak kurzoru
PN_RL_NoCurs:   call    PN_CO                   ;vytisknout znak
                or      dh,dh                   ;byl kurzor ?
                jz      PN_RL_NoNorm            ;ne
                call    PN_Set_Norm             ;ano => zpet na normalni znaky
PN_RL_NoNorm:   cmp     bx,di                   ;na konci textu ?
                je      PN_RL_NoNext            ;ano => neposouvat
                inc     bx
PN_RL_NoNext:   loop    PN_RL_Disp              ;pro cely radek

                pop     bx                      ;adresa zacatku radku
                pop     VW_Cursor                ;a jeji pozice ve VRAM

PN_RL_Key:      call    PN_CI                   ;klavesu

                cmp     al,' '
                jb      PN_RL_Ctrl              ;osetrit ridici kody
                cmp     al,'~'
                ja      PN_RL_Ctrl

                or      dl,dl                   ;prvni klavesa ?
                jz      PN_RL_Not1st            ;ne => nic
                mov     di,bx                   ;ano => vymazat radek
                mov     byte ptr ds:[bx],0
                xor     dl,dl                   ;zrusit priznak prvni klavesy

PN_RL_Not1st:   lea     cx,[bx+CB_Line_Len-1]   ;adresa konce radku
                cmp     cx,di                   ;je plny radek ?
                je      PN_RL_Key               ;ano => ignorovat

                push    di                      ;posunout pismena v bufferu
PN_RL_Insert:   mov     ah,ds:[di]               ;o jedno doprava
                mov     ds:[di+1],ah
                dec     di
                cmp     di,si                   ;posun az od pozice na radku
                jae     PN_RL_Insert
                pop     di
                inc     di                      ;radek je ted o jeden znak delsi

                mov     ds:[si],al              ;zapsat znak
                inc     si                      ;posunout pozici na radku
                jmp     PN_RL_Main

;

PN_RL_Ctrl:     xor     dl,dl                   ;zrusit priznak prvni klavesy

                cmp     al,27                   ;Esc
                je      PN_RL_KEsc
                cmp     al,13                   ;Enter
                je      PN_RL_KEnter
                cmp     al,8                    ;BS
                je      PN_RL_KBS
                cmp     al,19                   ;Ctrl-S
                je      PN_RL_KLeft
                cmp     al,4                    ;Ctrl-D
                je      PN_RL_KRight
                cmp     al,25                   ;Ctrl-Y
                je      PN_RL_KClear
                or      al,al                   ;Extended Ascii
                jnz     PN_RL_Key
                cmp     ah,75                   ;Left
                je      PN_RL_KLeft
                cmp     ah,77                   ;Right
                je      PN_RL_KRight
                cmp     ah,83                   ;Del
                je      PN_RL_KDel
                cmp     ah,71                   ;Home
                je      PN_RL_KHome
                cmp     ah,79                   ;End
                je      PN_RL_KEnd
                jmp     PN_RL_Key

;

PN_RL_KEsc:     stc                             ;CF pro vystup z procedury
                pushf
                jmp     short PN_RL_KEscX

;

PN_RL_KEnter:   pushf                           ;CF = 0
PN_RL_KEscX:    mov     VW_Cursor,2*256+25      ;smazat radek
                call    PN_ClrEol
                popf                            ;nastavit CF

                pop     di
                pop     si

                ret

;

PN_RL_KDel:     cmp     si,di                   ;na konci radku ?
                je      PN_RL_Key               ;ano => ignorovat
                jmp     short PN_RL_KDelX       ;ne => umazat znak

;

PN_RL_KBS:      cmp     si,bx                   ;na zacatku radku ?
                je      PN_RL_Key               ;ano => ignorovat

                dec     si                      ;pozice bude o jeden znak
PN_RL_KDelX:    push    si                       ;vlevo
PN_RL_KBS1:     mov     al,ds:[si+1]            ;od pozice kurzoru posunout
                mov     ds:[si],al               ;vsechny znaky o jeden vlevo
                inc     si
                cmp     si,di                   ;az do konce radku
                jb      PN_RL_KBS1
                pop     si
                dec     di                      ;radek je o jeden znak kratsi
                jmp     PN_RL_Main

;

PN_RL_KLeft:    cmp     bx,si                   ;na zacatku radku ?
                je      PN_RL_Key               ;ano => ignorovat
                dec     si                      ;ne => o znak vlevo
                jmp     PN_RL_Main

;

PN_RL_KRight:   cmp     di,si                   ;na konci radku ?
                je      PN_RL_Key               ;ano => ignorovat
                inc     si                      ;ne => o znak vpravo
                jmp     PN_RL_Main

;

PN_RL_KClear:   mov     di,bx                   ;delka radku 0
                mov     byte ptr ds:[bx],0      ;oznacit konec

PN_RL_KHome:    mov     si,bx                   ;na zacatek radku
                jmp     PN_RL_Main

;

PN_RL_KEnd:     mov     si,di                   ;na konec radku
                jmp     PN_RL_Main

PN_Read_Line    endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Skip              nacte prvni znak ruzny od mezery                       ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       SI      adresa retezce                                         ║
;║ Vystup:      SI      adresa za prvnim znakem ruznym od mezery               ║
;║              AL      znak                                                   ║
;║              DF      = 0                                                    ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Skip         proc    near
;
                cld
PN_Sk_Main:     lodsb                   ;znak
                cmp     al,' '          ;najit prvni ruzny od mezery
                je      PN_Sk_Main

                ret

PN_Skip         endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Get_Nr            nacte cislo z retezce (preskakuje uvodni mezery)       ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       SI      adresa retezce                                         ║
;║ Vystup:      SI      adresa prvniho neciselneho znaku                       ║
;║              DX      nactene cislo                                          ║
;║              CF      cislo > 65535                                          ║
;║ Nici:        AX,BX,CL                                                       ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Precte cislo, tvar HEX, &DEC nebo %BIN. Pismena vyzaduje v UpCase.          ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Get_Nr       proc    near
;
                call    PN_Skip         ;vynechat mezery, nacist znak, DF = 0

                xor     dx,dx           ;cislo

                mov     bx,16           ;implicitni soustava
                cmp     al,'&'          ;prefix pro desitkovou ?
                je      PN_GN_Dec       ;ano => desitkova
                cmp     al,'%'          ;prefix pro dvojkovou ?
                jne     PN_GN_Hex       ;ne => pokracovat na sesnactkove

PN_GN_Bin:      mov     bx,2            ;nastavit dvojkovou soustavu
                jmp     short PN_GN_Main
PN_GN_Dec:      mov     bx,10           ;nastavit desitkovou soustavu
PN_GN_Main:     lodsb                   ;znak cisla
PN_GN_Hex:      sub     al,'0'          ;prevest na cislo
                jc      PN_GN_NoNum     ;neciselny znak
                cmp     al,9
                jbe     PN_GN_DecNum    ;cislice
                sub     al,'A'-'0'-10
                jc      PN_GN_NoNum     ;neciselny znak
                cmp     al,bl
                jae     PN_GN_NoNum     ;znak mimo zaklad soustavy

PN_GN_DecNum:   mov     cl,al           ;schovat znak
                mov     ax,dx
                mul     bx                      ;posunout cislo o rad
                jc      PN_GN_TooBig            ;preteklo => chyba
                mov     dl,cl                   ;cislo, DH = 0
                add     dx,ax                   ;pricist
                jmp     short PN_GN_Main        ;az do konce cisla

PN_GN_NoNum:    dec     si              ;na neciselny znak
                clc                     ;vynulovat priznak chyby
PN_GN_TooBig:   ret                     ;pri TooBig je CF=1

PN_Get_Nr       endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Run       spusti simulaci, vrati se po chybe nebo Break                  ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Run          proc    near
;
                mov     si,ds:[RPC]             ;instrukce
                inc     RPC                     ;++PC
                shl     si,1                    ;adresa v tabulce
                jmp     es:[si]                 ;skok na rutinu

PN_Run          endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Step      spusti simulaci na jeden krok, vrati se po nem, chybe a Break  ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Step         proc    near
;
                mov     si,ds:[RPC]             ;instrukce
                inc     RPC                     ;++PC
                shl     si,1                    ;adresa v tabulce
                mov     si,es:[si]              ;adresa rutiny
                add     si,CW_InstDif           ;do druhe sady rutin
                jmp     si                      ;skok na rutinu

PN_Step         endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Flush_MgIn        pokud je otevreny vstupni soubor MGF, uzavre ho        ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        (AX,BX)                                                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Flush_MgIn   proc    near
;
                cmp     VW_MgIn_Ofs,1           ;je otevreny soubor ?
                jbe     PN_FI_NotOpen           ;ne => jen nastavit promennou

                mov     bx,VW_MgIn_Hnd          ;handler souboru
                mov     ah,3Eh                  ;Close File
                int     21h

PN_FI_NotOpen:  mov     VW_MgIn_Ofs,0           ;oznacit jako uzavreny

                ret

PN_Flush_MgIn   endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Flush_MgOut       pokud je otevreny vystupni soubor MGF, uzavre ho       ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        (AX,BX,CX,DX)                                                  ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Flush_MgOut  proc    near
;
                cmp     VW_MgOut_Ofs,1          ;je otevreny soubor ?
                jbe     PN_FO_NotOpen           ;ne => jen nastavit promennou

                mov     dx,offset FB_MgOut_Bfr  ;zapsat zbytek dat z bufferu
                mov     cx,VW_MgOut_Ofs
                sub     cx,dx
                mov     bx,VW_MgOut_Hnd         ;handler souboru
                mov     ah,40h                  ;Write to File
                int     21h

                mov     ah,3Eh                  ;Close File
                int     21h

PN_FO_NotOpen:  mov     VW_MgOut_Ofs,0          ;oznacit jako uzavreny

                ret

PN_Flush_MgOut  endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Stat_MGF          vraci stav USARTu (port 1Fh)                           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vystup:      AL              stav USARTu                                    ║
;║              VB_MgIn_Dat     nacteny bajt                                   ║
;║              VB_MgIn_Flg     priznak platnosti nacteneho bajtu              ║
;║ Nici:        SI                                                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Pocita s volanim v kontextu PMD                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Stat_MGF     proc    near
;
                test    [cs:VB_MgIn_Flg],-1     ;byl precten posledni bajt ?
                jnz     PN_TM_AnyIn             ;ne => nechat ho byt

PN_TM_LoadCnt:  mov     si,[cs:VW_MgIn_Ofs]     ;stav bufferu
                cmp     si,1
                jb      PN_TM_TranIn            ;uzavren => zkusit komunikaci
                je      PN_TM_OpenIn            ;pripraven => zkusit otevrit

                cmp     si,[cs:VW_MgIn_End]     ;na konci bufferu ?
                jnb     PN_TM_ReadIn            ;ano => zkusit nacist

                mov     al,[cs:si]              ;precist znak z bufferu
                inc     si                      ;na dalsi pozici
                mov     [cs:VW_MgIn_Ofs],si     ;ulozit pozici v bufferu
                mov     [cs:VB_MgIn_Dat],al     ;pripravit ho pro IN 1Eh
                mov     [cs:VB_MgIn_Flg],-1     ;oznacit platnost znaku

PN_TM_AnyIn:    mov     si,[cs:VW_MgOut_Ofs]    ;stav vystupniho bufferu
                cmp     si,1
                jb      PN_TM_TranOut           ;uzavren => zkusit komunikaci

PN_TM_RdyOut:   mov     al,5                    ;TxR, TxE, RxE
PN_TM_AnyOut:   test    [cs:VB_MgIn_Flg],-1     ;platny vstup ?
                jz      PN_TM_NRdyIn            ;ne => nechat RxE
                or      al,2                    ;ano => pridat RxD

PN_TM_NRdyIn:   ret

;

PN_TM_TranIn:   test    [cs:VW_TRN_Adr],-1      ;bezi komunikace ?
                jz      PN_TM_AnyIn             ;ne => nechat RxE

                push    dx
                mov     dx,[cs:VW_TRN_Adr]      ;adresa komunikace

                inc     dx
                in      al,dx                   ;vstup
                and     al,11000000b
                cmp     al,11000000b            ;je "mam data" ?
                jne     PN_TM_TI_NoChr          ;ne => neni znak na vstupu

                dec     dx                      ;na vystup
                mov     al,00000010b
                out     dx,al                   ;poslat "chci data"

                inc     dx
PN_IB_Sync2:    in      al,dx
                and     al,11000000b            ;pockat na "vysilam"
                cmp     al,11000000b
                je      PN_IB_Sync2             ;nic => cekat dal
                cmp     al,10000000b
                jne     PN_TM_TI_NoChr          ;chyba => ven

;

                push    ax
                push    bx
                push    cx

                mov     ah,al                   ;schovat stav portu
                mov     cx,8                    ;8 bitu zpravy
                dec     dx                      ;na vystup
                xor     al,al
                out     dx,al                   ;poslat "prijimam"

PN_IB_Data1:    inc     dx
PN_IB_Data2:    in      al,dx                   ;pockat na zmenu na vstupu
                and     al,11000000b
                xor     al,ah
                jz      PN_IB_Data2             ;nic => cekat

                cmp     al,11000000b            ;zmena na vsech ?
                je      PN_IB_Err               ;ano => chyba a ven

                xor     ah,al                   ;schovat novy stav vstupu
                rol     al,1                    ;data narotovat do BL
                cmc
                rcr     bl,1

PN_IB_Ack1:     dec     dx                      ;na vystup
                in      al,dx
                xor     al,00000010b            ;potvrdit prijem
                out     dx,al

                loop    PN_IB_Data1             ;pro vsech 8 bitu

;

PN_IB_Close1:   inc     dx
PN_IB_Close2:   in      al,dx                   ;pockat na uzavreni
                and     al,11000000b
                xor     al,ah
                jz      PN_IB_Close2

                xor     ah,al                   ;novy stav vstupu
                inc     cx                      ;pro volani PN_IB_Ack1
                cmp     ah,01000000b            ;klidovy stav ?
                jne     PN_IB_Ack1              ;ne => potvrdit a cekat dal

                dec     dx
                mov     al,00000011b            ;ok => do klidoveho stavu
                out     dx,al                    ;a ven

                mov     [cs:VB_MgIn_Dat],bl     ;zapsat prectena data a
                mov     [cs:VB_MgIn_Flg],-1      ;potvrdit jejich platnost

PN_IB_Err:      pop     cx
                pop     bx
                pop     ax
PN_TM_TI_NoChr: pop     dx

                jmp     PN_TM_AnyIn             ;frcet na vystup

;

PN_TM_TranOut:  test    [cs:VW_TRN_Adr],-1      ;bezi komunikace ?
                jz      PN_TM_TimeOut           ;ne => testnout TimeOut

                push    dx
                mov     dx,[cs:VW_TRN_Adr]      ;adresa komunikace
                mov     al,00000001b            ;nastavit "mam data"
                out     dx,al
                inc     dx
                in      al,dx                   ;vraci "chci data" ?
                pop     dx

                and     al,11000000b
                jz      PN_TM_RdyOut            ;ano => dat TxR, TxE
                jmp     PN_TM_NRdyOut           ;ne => TxNR, TxNE

;

PN_TM_TimeOut:  test    [cs:VB_TxE_Cnt],-1      ;dosel timer pro vyslani ?
                jz      PN_TM_RdyOut            ;ano => TxR, TxE
                dec     [cs:VB_TxE_Cnt]         ;ne => posunout

PN_TM_NRdyOut:  xor     al,al                   ;nastavit TxNR, TxNE
                jmp     PN_TM_AnyOut            ;frcet dal

;

PN_TM_OpenIn:   call    PN_Rest_PC              ;do kontextu PC

                lea     dx,[FB_MgIn_FName]      ;zkusit otevrit soubor
                mov     ax,3D00h                 ;nahrazujici vstup z
                int     21h                       ;magnetofonu
                jc      PN_TM_ErrOpIn           ;chyba => ohlasit a frcet dal

                mov     [VW_MgIn_Hnd],ax                  ;prideleny handler
                mov     [VW_Err_Msg],offset FB_MgIOp_Msg  ;zprava o otevreni
                call    PN_Disp_Msg
                call    PN_Set_White

                jmp     PN_TM_LoadIn

;

PN_TM_ReadIn:   call    PN_Rest_PC

PN_TM_LoadIn:   lea     dx,[FB_MgIn_Bfr]        ;vstupni buffer
                mov     cx,CW_MgBfr_Len         ;jeho delka
                mov     bx,[VW_MgIn_Hnd]        ;vstupni handler
                mov     ah,3Fh
                int     21h                     ;nacist data
                jc      PN_TM_ErrRdIn           ;chyba => ohlasit a ven
                or      ax,ax                   ;nacteno neco ?
                jz      PN_TM_ErrRdIn           ;ne => ohlasit a ven

                add     ax,dx                   ;adresa za koncem dat
                mov     [VW_MgIn_End],ax        ;zapsat
                mov     [VW_MgIn_Ofs],dx        ;zacatek dat v bufferu

PN_TM_EndIn:    call    PN_Rest_PMD             ;vratit kontext PMD
                jmp     PN_TM_LoadCnt           ;frcet dal

;

PN_TM_ErrRdIn:  mov     ah,3Eh                  ;zavrit soubor
                int     21h

                mov     [VW_Err_Msg],offset FB_MgICl_Msg        ;text zpravy
PN_TM_ErrCnt:   call    PN_Disp_Msg                             ;vypsat
                call    PN_Set_White

                mov     [VW_MgIn_Ofs],0         ;priznak uzavreni vstupu

                jmp     PN_TM_EndIn             ;frcet dal

;

PN_TM_ErrOpIn:  mov     [VW_Err_Msg],offset FB_MgIEr_Msg        ;text zpravy
                jmp     PN_TM_ErrCnt                            ;vypsat atd.

PN_Stat_MGF     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Save_MGF          ulozi bajt na magnetofon                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       AL              bajt na ulozeni                                ║
;║ Nici:        SI                                                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Pocita s volanim v kontextu PMD                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Save_MGF     proc    near
;
                mov     si,[cs:VW_MgOut_Ofs]    ;stav bufferu
                cmp     si,1
                jb      PN_SM_TranOut           ;zavreny => zkusit komunikaci
                je      PN_SM_OpenOut           ;pripraveny => zkusit otevrit

                cmp     si,offset FB_MgOut_BfrE         ;na konci ?
                jnb     PN_SM_WrtOut                    ;ano => zapsat

PN_SM_EmpCnt:   mov     [cs:si],al              ;zapsat data
                inc     si
                mov     [cs:VW_MgOut_Ofs],si    ;schovat novou pozici
                mov     [cs:VB_EoF_Timer],0     ;cas pro AutoEoF

PN_SM_AnyOut:   mov     [cs:VB_TxE_Cnt],35      ;spustit timer pro TxE
                ret

;

PN_SM_TranOut:  test    [cs:VW_TRN_Adr],-1              ;bezi komunikace ?
                jz      PN_SM_AnyOut                    ;ne => do stoupy

                push    ax
                push    bx
                push    dx
                mov     dx,[cs:VW_TRN_Adr]      ;adresa komunikace
                mov     bl,al                   ;vysilany bajt

                mov     al,00000001b            ;nastavit "mam data"
                out     dx,al

                inc     dx
                in      al,dx                   ;vraci "chci data" ?
                and     al,11000000b
                jnz     PN_SM_TO_NoChr          ;ne => do stoupy

;

                push    cx

                dec     dx                      ;na vystup
                out     dx,al                   ;nastavit "vysilam" (AL = 0)

                inc     dx
PN_OB_Sync2:    in      al,dx
                and     al,11000000b            ;pockat na "prijimam"
                jz      PN_OB_Sync2
                cmp     al,10000000b
                jne     PN_OB_Err               ;chyba => ven

;

                mov     ah,al                   ;stav portu
                mov     cx,8                    ;8 bitu zpravy

PN_OB_Data1:    ror     bl,1                    ;vzit bit dat
                dec     dx                      ;na vystup
                in      al,dx
                jc      PN_OB_Data2
                xor     al,00000011b            ;bit se vysle zmenou jednoho
PN_OB_Data2:    xor     al,00000001b             ;z datovych vodicu
                out     dx,al

PN_OB_Ack1:     inc     dx
PN_OB_Ack2:     in      al,dx                   ;pockat na potvrzeni
                and     al,11000000b
                xor     al,ah
                jz      PN_OB_Ack2
                cmp     al,10000000b
                jne     PN_OB_Err               ;chyba => ven

                xor     ah,al                   ;novy stav portu
                loop    PN_OB_Data1

;

                dec     dx                      ;na vystup
                in      al,dx
                cmp     al,00000011b            ;v klidu ?
                jne     PN_OB_Close1            ;ne => hned uzavrit

                mov     al,00000010b            ;ano => signalizovat konec
                out     dx,al
                inc     cx
                jmp     PN_OB_Ack1              ;pockat na potvrzeni

PN_OB_Close1:   mov     al,00000011b            ;linku do klidu
                out     dx,al

                inc     dx
PN_OB_Close2:   in      al,dx
                test    al,01000000b            ;pockat na konec "prijimam"
                jz      PN_OB_Close2

PN_OB_Err:      pop     cx
PN_SM_TO_NoChr: pop     dx
                pop     bx
                pop     ax

                jmp     PN_SM_AnyOut            ;ven

;

PN_SM_OpenOut:  call    PN_Rest_PC

                lea     dx,[FB_MgOut_FName]     ;zkusit vytvorit vystupni
                xor     cx,cx                    ;soubor
                mov     ah,3Ch
                int     21h
                jc      PN_SM_ErrOpOut

                mov     [VW_MgOut_Hnd],ax                 ;prideleny handler
                mov     [VW_Err_Msg],offset FB_MgOOp_Msg  ;zprava o otevreni
                call    PN_Disp_Msg                       ;vytisknout ji
                call    PN_Set_White

PN_SM_SaveCnt:  call    PN_Rest_PMD

                mov     si,offset FB_MgOut_Bfr          ;prazdny buffer,
                jmp     PN_SM_EmpCnt                     ;ulozi se az dal

;

PN_SM_WrtOut:   call    PN_Rest_PC

                lea     dx,[FB_MgOut_Bfr]       ;ulozit data na disk
                mov     cx,CW_MgBfr_Len
                mov     bx,[VW_MgOut_Hnd]
                mov     ah,40h
                int     21h
                jc      PN_SM_ErrWrOut          ;chyba => zavrit a ven
                cmp     ax,cx                   ;zapsal vsechno ?
                jne     PN_SM_ErrWrOut          ;ne => jako chyba

                jmp     PN_SM_SaveCnt

;

PN_SM_ErrWrOut: mov     ah,3Eh                          ;zkusit Close
                int     21h

                mov     [VW_Err_Msg],offset FB_MgOCl_Msg        ;zprava
PN_SM_ErrCnt:   call    PN_Disp_Msg                             ;vypsat
                call    PN_Set_White

                mov     [VW_MgOut_Ofs],0                ;priznak chyby
                jmp     PN_SM_AnyOut                    ;ven

;

PN_SM_ErrOpOut: mov     [VW_Err_Msg],offset FB_MgOEr_Msg        ;zprava
                jmp     PN_SM_ErrCnt                            ;vypsat atd.

PN_Save_MGF     endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Rest_PCI          obnovi cast kontextu pro PC                            ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        hafo                                                           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Tato procedura obnovi vsechny nutne polozky, ktere nelze obnovovat pri      ║
;║ operacich s magnetofonovymi soubory.                                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Rest_PCI     proc    near
;
                in      al,61h                  ;Speaker Off
                and     al,not 3
                out     61h,al

                xor     ax,ax                   ;na promenne BIOSu
                mov     es,ax

                mov     ah,0EDh                 ;Kbd Lights
                call    PN_Keybd_Cmd
                mov     ah,es:[417h]            ;Kbd Flags
                mov     cl,4
                shr     ah,cl                   ;prislusne bity urcujici
                and     ah,7                     ;stav LED
                call    PN_Keybd_Cmd            ;nastavit LED pro BIOS

                push    ds                      ;obnovit INT 09
                mov     dx,word ptr VD_Old_I09
                mov     ds,word ptr VD_Old_I09+2
                mov     ax,2509h
                int     21h
                pop     ds

                push    ds                      ;obnovit INT 0D
                mov     dx,word ptr VD_Old_I0D
                mov     ds,word ptr VD_Old_I0D+2
                mov     ax,250Dh
                int     21h
                pop     ds

                call    PN_Set_Norm             ;normalni barvy

                ret

PN_Rest_PCI     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Rest_PC           uschova stav simulatoru PMD a obnovi cast stavu PC     ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        vzhledem k PN_Rest_PMD - SI,DS,ES                              ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Tato procedura obnovuje vsechny polozky nutne k praci magnetofonovych       ║
;║ sluzeb simulatoru. Zbytek obnovuje PN_Rest_PCI, musi se volat az po ..._PC. ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Rest_PC      proc    near
;
                mov     ds,[cs:VW_Sim_Seg]

                xchg    RA,RF                   ;spravna hodnota PSW
                mov     VW_Reg_PSW,RPSW
                mov     VW_Reg_BC,RBC
                mov     VW_Reg_DE,RDE
                mov     VW_Reg_HL,RHL
                mov     VW_Reg_SP,RSP
                mov     VW_Reg_PC,RPC

                push    ds                      ;obnovit INT 08
                mov     dx,word ptr VD_Old_I08
                mov     ds,word ptr VD_Old_I08+2
                mov     ax,2508h
                int     21h
                pop     ds

                ret

PN_Rest_PC      endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Rest_PMDI         obnovi cast kontextu PMD                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        hafo                                                           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Tato procedura obnovi vsechny nutne polozky, ktere nelze obnovovat pri      ║
;║ operacich s magnetofonovymi soubory.                                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Rest_PMDI    proc    near
;
                call    PN_Set_White            ;simulator bezi v bile

                mov     es,VW_Sim_Seg           ;segment simulatoru
                mov     di,offset FB_Key_Cols   ;vymazat pripadne zbytky
                mov     cx,size FB_Key_Cols      ;dat na portech klavesnice
                mov     al,-1
                cld
                rep stosb

                mov     VB_Key_Shift,7Fh        ;vynulovat stav Shift & Stop

                mov     VB_Joy_State1,0FFh      ;vynulovat stav joysticku
                mov     VB_Joy_State2,0FFh
                mov     VB_Joy_State3,0FFh

                mov     ax,350Dh                ;I0D
                int     21h
                mov     word ptr VD_Old_I0D,bx  ;stary vektor schovat
                mov     word ptr VD_Old_I0D+2,es
                mov     ah,25h
                mov     dx,offset PF_My_I0D
                int     21h                     ;novy I0D

                mov     ax,3509h                ;I09
                int     21h
                mov     word ptr VD_Old_I09,bx  ;stary vektor schovat
                mov     word ptr VD_Old_I09+2,es
                mov     ah,25h
                mov     dx,offset PF_My_I09
                int     21h                     ;novy I09

                mov     ah,0EDh                 ;Set Kbd LED
                call    PN_Keybd_Cmd
                mov     ah,VB_Port_F6           ;hodnota portu
                and     ah,VB_LED_Flg           ;pokud se nemaji nastavovat,
                shr     ah,1                     ;jen je zhasnout
                shr     ah,1                    ;izolovat stav LED
                and     ah,3
                call    PN_Keybd_Cmd

                mov     al,VB_Port_F6           ;hodnota portu
                and     ax,7                    ;izolovat bity pro sluchatko
                and     al,VB_Sound_Flg         ;pokud neni zvuk, vypnout
                mov     si,ax

                cli
                mov     al,0B6h
                out     43h,al                  ;CNT 2 jako delicka
                in      al,61h
                and     al,not 3
                or      al,FB_Tbl_S61[si]       ;hodnota portu 61h (bity 0,1)
                out     61h,al
                mov     al,FB_Tbl_L42[si]       ;nastaveni delicky
                out     42h,al
                mov     al,FB_Tbl_H42[si]
                out     42h,al
                sti

                ret

PN_Rest_PMDI    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Rest_PMD          uschova stav PC a nastavi cast kontextu PMD            ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        vzhledem k PN_Rest_PC - SI,DS,ES                               ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Tato procedura obnovuje vsechny polozky nutne k praci magnetofonovych       ║
;║ sluzeb simulatoru. Zbytek obnovuje PN_Rest_PMDI, volat az po ..._PMD.       ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Rest_PMD     proc    near
;
                mov     ax,3508h                ;I08
                int     21h
                mov     word ptr VD_Old_I08,bx  ;stary vektor schovat
                mov     word ptr VD_Old_I08+2,es
                mov     ah,25h
                mov     dx,offset PF_My_I08
                int     21h                     ;novy I08

                mov     RPSW,VW_Reg_PSW
                xchg    RA,RF                   ;spravna hodnota pro simulaci
                mov     RBC,VW_Reg_BC
                mov     RDE,VW_Reg_DE
                mov     RHL,VW_Reg_HL
                mov     RSP,VW_Reg_SP
                mov     RPC,VW_Reg_PC

                mov     es,VW_Ins_Seg
                mov     ds,VW_PMD_Seg

                ret

PN_Rest_PMD     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Scr_ReDraw        prekresli celou obrazovku PMD                          ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nici:        AX,BX,DX,SI,DI,ES                                              ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Scr_ReDraw   proc    near
;
                call    PN_Set_White            ;obrazovka bude bila

                push    ds

                mov     es,VW_EGA_Seg
                mov     ds,VW_PMD_Seg

                mov     si,0C000h               ;offset ve VRAM PMD
PN_SR_Main:     mov     bl,ds:[si]              ;bajt z VRAM
                xor     bh,bh
                shl     bl,1                    ;na adresu v tabulce
                mov     dx,cs:FW_Disp1_Tbl[bx]  ;najit obraz bajtu
                mov     bl,ds:[si+1]            ;dalsi bajt
                shl     bl,1
                mov     bx,cs:FW_Disp2_Tbl[bx]  ;obraz druheho bajtu
                or      dh,bl                   ;spojit do trojice bajtu
                mov     di,si                   ;najit adresu ve VRAM
                shl     di,1
                mov     di,cs:FW_Tbl_Adr-32768[di]
                mov     es:[di],dx              ;zapsat obraz
                mov     es:[di+2],bh
                add     si,2
                jnz     PN_SR_Main              ;pro celou VRAM

                pop     ds

                call    PN_Set_Norm             ;zpatky do zelene

                ret

PN_Scr_ReDraw   endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Make_Tbl          vytvori potrebne tabulky programu                      ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       nic                                                            ║
;║ Vystup:      nic                                                            ║
;║ Nici:        AX,BX,CX,DX,SI,DI,ES                                           ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Make_Tbl     proc    near
;
                mov     es,VW_PMD_Seg           ;vynulovat pamet PMD
                xor     di,di
                mov     cx,8000h
                mov     ax,di                   ;=0
                cld
                rep stosw

                mov     es,VW_Ins_Seg           ;segment tabulky instrukci
                xor     di,di
                mov     bx,65536/512            ;pocet tabulek v 64k
PN_MT_Copy:     mov     si,offset FW_Tbl_Ins    ;tabulka instrukci
                mov     cx,256                  ;delka 256*2
                rep movsw                       ;presunout
                dec     bx                      ;vyplnit celych 64k
                jnz     PN_MT_Copy

;

                mov     es,VW_Sim_Seg           ;segment programu
                mov     di,offset FW_Tbl_Adr    ;tabulka adres ve VRAM
                mov     ax,(640-2*288)/16+15*80 ;pocatecni offset
                mov     bx,256                  ;pocet vyplnovanych radku
PN_MT_MkAdr1:   mov     cx,48/2                 ;pocet viditelnych dvojic
PN_MT_MkAdr2:   stosw                           ;tabulka obsahuje posloupnost
                inc     ax                       ;adres urcujicich pozici daneho
                stosw                             ;bajtu ve VRAM EGA
                inc     ax                         ;(indexem je adresa v PMD)
                inc     ax
                loop    PN_MT_MkAdr2
                mov     cx,16                   ;pocet neviditelnych bajtu
PN_MT_MkAdr3:   mov     word ptr es:[di],28000  ;neviditelne bajty zapisuji
                inc     di                       ;za viditelnou VRAM EGA
                inc     di
                loop    PN_MT_MkAdr3
                add     ax,80-48/2*3            ;na dalsi radek u EGA
                dec     bx
                jnz     PN_MT_MkAdr1            ;pro celou VRAM PMD

;

                mov     di,offset FW_Disp1_Tbl          ;tabulka prevodu bajtu
                xor     bh,bh                           ;cislo prevadeneho bajtu

PN_MT_MkDisp11: mov     cx,6                            ;pocet bitu v bajtu
                xor     ax,ax
                mov     bl,bh                           ;cislo k prevodu
                shl     bl,1                            ;pripravit na
                shl     bl,1                             ;prevod
PN_MT_MkDisp12: shl     bl,1                            ;prevadeny bit do CF
                rcr     ax,1                            ;CF do AX bit 15
                rol     ax,1                            ;obnovit CF a AX 15->0
                ror     ax,1                            ;nechat CF a AX 0-15
                rcr     ax,1                            ;zdvojit prislusny bit
                loop    PN_MT_MkDisp12
                xchg    ah,al                           ;do spravneho poradi
                stosw                                   ;zapsat dany bajt
                inc     bh
                jns     PN_MT_MkDisp11                  ;do 128

                xor     bh,bh
PN_MT_MkDisp21: mov     cx,6                            ;pocet bitu v bajtu
                xor     ax,ax
                mov     bl,bh                           ;cislo k prevodu
                shl     bl,1                            ;pripravit na
                shl     bl,1                             ;prevod
PN_MT_MkDisp22: shl     bl,1                            ;prevadeny bit do CF
                rcr     ax,1                            ;CF do AX bit 15
                rol     ax,1                            ;obnovit CF a AX 15->0
                ror     ax,1                            ;nechat CF a AX 0-15
                rcr     ax,1                            ;zdvojit prislusny bit
                loop    PN_MT_MkDisp22
                mov     cl,4
                shr     ax,cl                           ;posun do spravne pozice
                xchg    ah,al
                stosw                                   ;zapsat dany bajt
                inc     bh
                jns     PN_MT_MkDisp21                  ;do 128

                ret

PN_Make_Tbl     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Close_EGA         obnovi video rezim                                     ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       nic                                                            ║
;║ Vystup:      nic                                                            ║
;║ Nici:        AX,BIOS                                                        ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Close_EGA    proc    near
;
                mov     al,VB_Old_VMode
                xor     ah,ah
                int     10h                     ;Set Video Mode

                ret

PN_Close_EGA    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Open_EGA          schova video rezim, nastavi 640x350x16                 ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       nic                                                            ║
;║ Vystup:      nic                                                            ║
;║ Nici:        AX,CX,DX,DI,ES,BIOS                                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Open_EGA     proc    near
;
                mov     ah,0Fh                  ;Get Video Mode
                int     10h
                mov     VB_Old_VMode,al         ;schovat

                mov     ax,10h                  ;Set Video Mode 640x350x16
                int     10h

                mov     bl,1                    ;povolit blikani
                mov     ax,1003h
                int     10h

                mov     es,VW_Sim_Seg
                mov     dx,offset FB_EGA_Col    ;nastavit paletu
                mov     ax,1002h
                int     10h

                ret

PN_Open_EGA     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Set_INTs          nastavi potrebne vektory                               ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Nici:        hafo                                                           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Nastavuje Critical Error a BIOS Break.                                      ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Set_INTs     proc    near
;
                mov     ax,351Bh                ;schovat I1B
                int     21h
                mov     word ptr VD_Old_I1B,bx
                mov     word ptr VD_Old_I1B+2,es
                mov     dx,offset PF_My_I1B     ;zakazat Break
                mov     ah,25h                   ;nastavenim INT 1Bh
                int     21h

                mov     dx,offset PF_My_I24     ;vlastni Critical Error
                mov     ax,2524h                 ;Handler
                int     21h

                ret

PN_Set_INTs     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Rest_INTs         obnovi zmenene vektory                                 ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Nici:        hafo                                                           ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Neobnovuje Critical Error, protoze ten je v PSP.                            ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Rest_INTs    proc    near
;
                push    ds
                mov     dx,word ptr VD_Old_I1B          ;puvodni vektor 1Bh
                mov     ds,word ptr VD_Old_I1B+2
                mov     ax,251Bh
                int     21h
                pop     ds

                ret

PN_Rest_INTs    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Alloc_Mem         alokuje pamet pro program a nastavi promenne segmentu  ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vstup:       nic                                                            ║
;║ Vystup:      nic                                                            ║
;║ Nici:        AX,BX,ES                                                       ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Alloc_Mem    proc    near
;
                mov     ax,cs
                mov     es,ax
                mov     bx,CW_Cde_Len+256/16
                mov     ah,4Ah                  ;Set Memory Block
                int     21h
                jc      LN_Err_Mem

                mov     bx,4096                 ;64k PMD
                mov     ah,48h
                int     21h
                jc      LN_Err_Mem
                mov     VW_PMD_Seg,ax           ;segment programu PMD

                mov     bx,4096                 ;64k INS
                mov     ah,48h
                int     21h
                jc      LN_Err_Mem
                mov     VW_Ins_Seg,ax           ;segment tabulky instrukci

                mov     VW_Sim_Seg,cs           ;segment simulatoru

                ret

PN_Alloc_Mem    endp

;
;;;
;;;;
;;;
;

LN_Err_EGA:     lea     si,FB_Err_EGA                   ;neni EGA
                jmp     short LN_Any_Err
LN_Err_Mem:     lea     si,FB_Err_Mem                   ;malo pameti
                jmp     short LN_Any_Err
LN_Err_DOS:     lea     si,FB_Err_DOS                   ;DOS < 3.20
LN_Any_Err:     lea     dx,FB_Pref_Err
                mov     ah,9                            ;tisk prefixu hlasky
                int     21h

                mov     dx,si                           ;tisk textu hlasky
                mov     ah,9
                int     21h

                mov     ax,4c01h                        ;ukoncit, chyba 1
                int     21h
                cli
                jmp     $

;
;;;
;;;;
;;;
;

LN_Install:     lea     sp,[LW_Stack]           ;zasobnik, SS=CS

                mov     dx,offset FB_Prg_Head
                mov     ah,9                    ;predstavit se
                int     21h

                mov     ah,30h                  ;zjistit verzi DOSu
                int     21h
                xchg    ah,al
                cmp     ax,300h+20
                jb      LN_Err_DOS              ;chodit az od 3.20

                mov     ah,12h                  ;EGA Extended Services
                mov     bl,10h                  ;Get Features
                int     10h
                cmp     bl,10h                  ;je EGA ?
                je      LN_Err_EGA              ;ne => ven
                or      bl,bl                   ;alespon 128k ?
                jz      LN_Err_EGA              ;ne => ven

;

                call    PN_Alloc_Mem            ;alokovat pamet
                call    PN_Set_INTs             ;nastavit vektory
                call    PN_Make_Tbl             ;vytvorit tabulky
                call    PN_Open_EGA             ;nastavit video rezim
                call    PN_Draw_Scr             ;vykreslit hlavicku
                call    PN_Disp_Stat            ;vypsat stav prepinacu

;

LN_Main_Msg:    call    PN_Disp_Msg             ;stavova hlaska
LN_Main:        mov     dx,offset FB_Main_Mnu   ;hlavni menu
                jmp     LN_Menu                 ;vybrat

;

LN_End:         call    PN_Flush_MgIn           ;uzavrit soubory imitujici
                call    PN_Flush_MgOut           ;magnetofon

                call    PN_Close_EGA            ;obnovit puvodni videorezim
                call    PN_Rest_INTs            ;puvodni vektory

                mov     ax,4C00h
                int     21h                     ;Exit 0
                cli
                jmp     $

;

LN_Start:       mov     VW_Err_Msg,offset FB_Run_Msg
                call    PN_Disp_Msg

                call    PN_Rest_PMDI            ;kontext PMD
                call    PN_Rest_PMD
                call    PN_Run                  ;spustit PMD
                call    PN_Rest_PC              ;zpet do kontextu PC
                call    PN_Rest_PCI

                jmp     LN_Main_Msg             ;vypsat hlasku a do menu

;

LN_Reset:       mov     VW_Reg_PC,8000h                 ;resetovat PC
                mov     VB_Port_F4,0                    ;vymazat hodnoty
                mov     VB_Port_F6,0                     ;portu

                mov     VW_Err_Msg,offset FB_Reset_Msg  ;hlaseni o resetu
                jmp     LN_Main_Msg                     ;vypsat a do menu

;
;;;
;;;;
;;;
;

;╔═════════════════════════════╗
;║ █████ ███ █     █████  ███  ║
;║ █      █  █     █     █   █ ║
;║ █      █  █     █     █     ║
;║ ███    █  █     ███    ███  ║
;║ █      █  █     █         █ ║
;║ █      █  █     █     █   █ ║
;║ █     ███ █████ █████  ███  ║
;╚═════════════════════════════╝

LN_Files_ClErr: call    PN_DOS_Err              ;schovat hlasku chyby
                mov     bx,VW_File_Hnd          ;handler souboru
                mov     ah,3Eh                  ;Close Handle
                int     21h
                jmp     short LN_Files_Msg      ;vypsat hlasku a do menu

LN_Files_Close: mov     bx,VW_File_Hnd          ;handler souboru
                mov     ah,3Eh                  ;Close Handle
                int     21h
                jnc     LN_Files_Msg            ;uzavreno Ok
LN_Files_Error: call    PN_DOS_Err              ;chyba => jeji hlasku
LN_Files_Msg:   call    PN_Disp_Msg
LN_Files:       mov     dx,offset FB_Files_Mnu
                jmp     LN_Menu

;

LN_Load_OpErr:  call    PN_DOS_Err              ;zpravu z DOSu
                call    PN_Disp_Msg             ;vypsat

LN_Load:        mov     si,offset FB_FName_Rq
                mov     bx,offset FB_FName_1    ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     dx,bx                   ;buffer se jmenem souboru
                mov     ax,3D00h                ;otevrit pro cteni
                int     21h
                jc      LN_Load_OpErr           ;chyba => hlasku a znova

                mov     VW_File_Hnd,ax                  ;prideleny handler
                mov     VW_Err_Msg,offset FB_FOpen_Msg  ;zprava o
                call    PN_Disp_Msg                      ;otevreni

LN_Load_Nr:     mov     si,offset FB_Addr_Rq
                mov     bx,offset FB_FOrg       ;nacist adresu ukladani
                call    PN_Read_Line
                jc      LN_Files_Close          ;ESC => uzavrit a ven

                mov     si,bx                   ;zacatek bufferu s cislem
                call    PN_Get_Nr               ;izolovat cislo
                jc      LN_Load_Nr              ;chyba => chtit znova
                call    PN_Skip                 ;nacist ukoncovaci znak
                or      al,al                   ;musi byt 0
                jnz     LN_Load_Nr              ;nebyl => znovu nacist

                xor     cx,cx
                sub     cx,dx                   ;nejvyssi pocet bajtu
                jnz     LN_Load_NotAll          ;pro adresu 0 vyjde
                dec     cx                       ;0, ale musi byt 0FFFFh
LN_Load_NotAll: mov     bx,VW_File_Hnd          ;prideleny handler
                mov     ah,3Fh
                mov     ds,VW_PMD_Seg           ;DS pro PMD
                int     21h                     ;nacist data
                mov     ds,cs:VW_Sim_Seg        ;puvodni DS
                jc      LN_Files_ClErr          ;chyba => uzavrit a ven

                mov     di,offset FB_LLen_Msg   ;zapsat nactenou delku
                call    PN_Write_Nr              ;do textu hlasky
                mov     VW_Err_Msg,offset FB_LdOk_Msg   ;pripravit hlasku

                call    PN_Scr_ReDraw           ;vykreslit obrazovku PMD
                jmp     LN_Files_Close

;

LN_Save_OpErr:  call    PN_DOS_Err              ;hlaska z DOSu
                call    PN_Disp_Msg             ;vypsat

LN_Save:        mov     si,offset FB_FName_Rq
                mov     bx,offset FB_FName_1    ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     dx,bx                   ;buffer se jmenem souboru
                xor     cx,cx                   ;atributy souboru
                mov     ah,3Ch                  ;vytvorit
                int     21h
                jc      LN_Save_OpErr           ;chyba => znovu

                mov     VW_File_Hnd,ax                  ;prideleny handler
                mov     VW_Err_Msg,offset FB_FOpen_Msg  ;zprava o
                call    PN_Disp_Msg                      ;otevreni

LN_Save_Nr1:    mov     si,offset FB_Addr_Rq
                mov     bx,offset FB_FOrg       ;nacist adresu ukladani
                call    PN_Read_Line
                jc      LN_Files_Close          ;ESC

                mov     si,bx                   ;zacatek bufferu s cislem
                call    PN_Get_Nr
                jc      LN_Save_Nr1             ;chyba v cisle
                call    PN_Skip                 ;nacist ukoncovaci znak
                or      al,al                   ;musi byt 0
                jnz     LN_Save_Nr1             ;nebyl => znovu nacist
                mov     VW_File_Org,dx          ;cislo OK => schovat

LN_Save_Nr2:    mov     si,offset FB_Size_Rq
                mov     bx,offset FB_FSize      ;nacist adresu ukladani
                call    PN_Read_Line
                jc      LN_Files_Close          ;ESC

                mov     si,bx                   ;zacatek bufferu s cislem
                call    PN_Get_Nr
                jc      LN_Save_Nr2             ;chyba v cisle
                call    PN_Skip                 ;nacist ukoncovaci znak
                or      al,al                   ;musi byt 0
                jnz     LN_Save_Nr2             ;nebyl => znovu nacist

                mov     cx,dx                   ;pozadovanou delku do CX
                mov     dx,VW_File_Org          ;adresa zapisu
                xor     ax,ax                   ;nejvyssi delku
                sub     ax,dx
                jz      LN_Save_SizeOk          ;pro adresu 0 je delka vzdy Ok
                cmp     ax,cx                   ;je kratsi nez pozadovana ?
                jae     LN_Save_SizeOk          ;ne => Ok
                mov     cx,ax                   ;maximalni delka dat
LN_Save_SizeOk: mov     bx,VW_File_Hnd          ;prideleny handler
                mov     ah,40h
                mov     ds,VW_PMD_Seg           ;DS pro PMD
                int     21h                     ;nacist data
                mov     ds,cs:VW_Sim_Seg        ;puvodni DS
                jc      LN_Files_ClErr          ;chyba => uzavrit a ven

                mov     di,offset FB_SLen_Msg   ;zapsat nactenou delku
                call    PN_Write_Nr              ;do textu hlasky
                mov     VW_Err_Msg,offset FB_SvOk_Msg   ;pripravit hlasku

                jmp     LN_Files_Close          ;zavrit soubor a ven

;

LN_Delete:      mov     si,offset FB_FName_Rq
                mov     bx,offset FB_FName_1    ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     dx,bx                   ;offset jmena souboru
                mov     ah,41h                  ;Delete File
                int     21h
                jc      LN_Files_Error

                mov     VW_Err_Msg,offset FB_DelOk_Msg
                jmp     LN_Files_Msg

;

LN_ChDir:       mov     si,offset FB_PName_Rq
                mov     bx,offset FB_FName_1    ;nacist jmeno adresare
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     dx,bx                   ;offset jmena adresare
                mov     ah,3Bh                  ;ChDir
                int     21h
                jc      LN_Files_Error

                mov     VW_Err_Msg,offset FB_CDOk_Msg
                jmp     LN_Files_Msg

;

LN_Rename:      mov     si,offset FB_FName_Rq
                mov     bx,offset FB_FName_1    ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     si,offset FB_NName_Rq
                mov     bx,offset FB_FName_2    ;nacist nove jmeno souboru
                call    PN_Read_Line
                jc      LN_Files                ;ESC

                mov     es,VW_Sim_Seg
                mov     di,bx                   ;offset noveho jmena souboru
                mov     dx,offset FB_FName_1    ;offset puvodniho jmena
                mov     ah,56h                  ;Rename File
                int     21h
                jc      LN_Files_Error

                mov     VW_Err_Msg,offset FB_RenOk_Msg
                jmp     LN_Files_Msg

;
;;;
;;;;
;;;
;

;╔═══════════════════════════════╗
;║  ███  █████ █████ █   █ ████  ║
;║ █   █ █     █ █ █ █   █ █   █ ║
;║ █     █       █   █   █ █   █ ║
;║  ███  ███     █   █   █ ████  ║
;║     █ █       █   █   █ █     ║
;║ █   █ █       █   █   █ █     ║
;║  ███  █████   █    ███  █     ║
;╚═══════════════════════════════╝

LN_SetUp_Stat:  call    PN_Disp_Stat                    ;vypsat stav prepinacu
LN_SetUp:       mov     dx,offset FB_SetUp_Mnu
                jmp     LN_Menu

;

LN_Sound:       not     VB_Sound_Flg
                jmp     short LN_SetUp_Stat

;

LN_LED:         not     VB_LED_Flg
                jmp     short LN_SetUp_Stat

;

LN_482stick:    not     VB_Stick_Flg
                jmp     short LN_SetUp_Stat

;

LN_MgIn:        call    PN_Flush_MgIn           ;uzavrit vstupni soubor

                mov     si,offset FB_FName_Rq
                mov     bx,offset FB_MGIn_FName ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_SetUp                ;ESC

                mov     VW_MgIn_Ofs,1           ;priznak "Pripraven k
                jmp     short LN_SetUp           ;otevreni"

;

LN_MgOut:       call    PN_Flush_MgOut          ;uzavrit vystupni soubor

                mov     si,offset FB_FName_Rq
                mov     bx,offset FB_MGOut_FName        ;nacist jmeno souboru
                call    PN_Read_Line
                jc      LN_SetUp                        ;ESC

                mov     VW_MgOut_Ofs,1                  ;priznak "Pripraven k
                jmp     short LN_SetUp                   ;otevreni"

;

LN_AutoEoF:     not     VB_EoF_Flg
                jmp     LN_SetUp_Stat

;

LN_Print:       mov     al,[VB_PRN_Flg]         ;vybrany printer port
                call    PN_Next_PRN             ;najit dalsi
                mov     [VB_PRN_Flg],al         ;zapsat cislo a adresu
                mov     [VW_PRN_Adr],dx
                jmp     LN_SetUp_Stat

;

LN_Trans:       mov     al,[VB_TRN_Flg]         ;vybrany printer port
                call    PN_Next_PRN             ;najit dalsi
                mov     [VB_TRN_Flg],al         ;zapsat cislo a adresu
                mov     [VW_TRN_Adr],dx
                mov     al,00000011b            ;linku do klidu
                out     dx,al
                jmp     LN_SetUp_Stat

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Next_PRN          najde dalsi dostupny printer port                      ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:       AL              cislo portu (0 - nic, 1 - LPT1 ...)            ║
;║ Vystup:      AL              nove cislo portu                               ║
;║              DX              adresa portu nebo 0                            ║
;║ Nici:        BX,ES                                                          ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Next_PRN     PROC    near
;
                cmp     al,4                    ;LPT4 ?
                jae     PN_NP_Off               ;ano => na 0

                xor     bx,bx                   ;do BIOSu
                mov     es,bx
                mov     bx,408h                 ;pole adres portu LPTx
                add     bl,al                   ;adresa pozadovaneho portu
                add     bl,al

                mov     dx,[es:bx]              ;vzit adresu portu
                inc     al                      ;odpovidajici cislo portu
                or      dx,dx                   ;je port ?
                jnz     PN_NP_Exit              ;adr<>0 => existuje a ven

PN_NP_Off:      xor     dx,dx
                xor     al,al                   ;nove cislo je 0

PN_NP_Exit:     ret

PN_Next_PRN     endp

;
;;;
;;;;
;;;
;

;╔═════════════════════════════════════════════════╗
;║ ████  █████ ████  █   █  ███   ███  █████ ████  ║
;║ █   █ █     █   █ █   █ █   █ █   █ █     █   █ ║
;║ █   █ █     █   █ █   █ █     █     █     █   █ ║
;║ █   █ ████  ████  █   █ █ ███ █ ███ ████  ████  ║
;║ █   █ █     █   █ █   █ █   █ █   █ █     █ █   ║
;║ █   █ █     █   █ █   █ █   █ █   █ █     █  █  ║
;║ ████  █████ ████   ███   ███   ███  █████ █   █ ║
;╚═════════════════════════════════════════════════╝

LN_Dbg_Brk:     mov     cs:VW_Err_Msg,offset FB_AtBrk_Msg
LN_Dbg_Err:     call    PN_Rest_PC              ;vratit kontext PC
                call    PN_Rest_PCI
                call    PN_Disp_Msg             ;vypsat stav simulace
LN_Debugger:    call    PN_Disp_Dbg             ;stav + nasled. inst. do ES:BX
LN_Dbg_Key:     call    PN_CI                   ;klavesu volby

                mov     si,offset FB_Dbg_Key-3  ;tabulka moznych klaves
LN_Dbg_FindK:   add     si,3
                test    byte ptr ds:[si],-1     ;konec tabulky ?
                jz      LN_Dbg_Key
                cmp     al,ds:[si]              ;shoda ?
                jne     LN_Dbg_FindK            ;ne => na dalsi klavesu

                mov     VW_Cursor,2*256+25      ;vypsat zvolenou klavesu
                call    PN_CO
                jmp     ds:[si+1]               ;vyvolat rutinu klavesy

;

LN_Dbg_Y:       mov     bx,VW_Brk_Adr           ;adresa breakpointu
LN_Dbg_X:       mov     VW_Brk_Inst,bx          ;breakpoint na nasledujici inst.
LN_Dbg_Fast:    call    PN_ClrEol                       ;smazat stavovy radek
                mov     VW_Err_Msg,offset FB_Run_Msg    ;zpravu o behu
                call    PN_Disp_Msg

                mov     VW_Step_Adr,offset LN_Dbg_FS
                call    PN_Rest_PMDI
                call    PN_Rest_PMD
LN_Dbg_FS:      call    PN_Step
                cmp     RPC,cs:VW_Brk_Inst      ;adresa zastaveni ?
                je      LN_Dbg_Brk              ;ano => zastavit
                jmp     [cs:VW_Step_Adr]        ;ne => pokracovat

;

LN_Dbg_R:       mov     bx,VW_Brk_Adr           ;adresa breakpointu
LN_Dbg_O:       mov     VW_Brk_Inst,bx          ;breakpoint na nasledujici inst.
LN_Dbg_Slow:    mov     VW_Err_Msg,offset FB_Run_Msg    ;zpravu o behu
                call    PN_Disp_Msg

                mov     VW_Step_Adr,offset LN_Dbg_SS
                call    PN_Rest_PMDI
LN_Dbg_SM:      call    PN_Rest_PMD
                call    PN_Step
                cmp     RPC,cs:VW_Brk_Inst      ;adresa zastaveni ?
                je      LN_Dbg_Err              ;ano => zastavit
                jmp     [cs:VW_Step_Adr]        ;ne => pokracovat
LN_Dbg_SS:      call    PN_Rest_PC              ;obnovit cast nutnou pro
                call    PN_Set_Norm              ;vypis & vypsat stav
                call    PN_Disp_Dbg
                call    PN_Set_White
                jmp     short LN_Dbg_SM         ;pokracovat

;

LN_Dbg_Z:       mov     bx,VW_Reg_SP            ;zasobnik PMD
                mov     al,es:[bx]              ;nacist po bajtech adresu na
                mov     ah,es:[bx+1]             ;zasobniku PMD
                mov     VW_Brk_Inst,ax          ;zapsat jako breakpoint
                jmp     short LN_Dbg_Fast

LN_Dbg_F:       mov     bx,VW_Reg_SP            ;zasobnik PMD
                mov     al,es:[bx]              ;nacist po bajtech adresu na
                mov     ah,es:[bx+1]             ;zasobniku PMD
                mov     VW_Brk_Inst,ax          ;zapsat jako breakpoint
                jmp     short LN_Dbg_Slow

;

LN_Dbg_Step:    call    PN_Rest_PMDI            ;do kontextu PMD
                call    PN_Rest_PMD
                call    PN_Step                 ;jeden krok
                call    PN_Rest_PC
                call    PN_Rest_PCI             ;do kontextu PC
                jmp     LN_Debugger

;

LN_Dbg_A:       mov     si,offset FB_RegA_Rq    ;propmt
                mov     di,offset VW_Reg_PSW    ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_B:       mov     si,offset FB_RegB_Rq    ;propmt
                mov     di,offset VW_Reg_BC     ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_D:       mov     si,offset FB_RegD_Rq    ;propmt
                mov     di,offset VW_Reg_DE     ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_H:       mov     si,offset FB_RegH_Rq    ;propmt
                mov     di,offset VW_Reg_HL     ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_S:       mov     si,offset FB_RegS_Rq    ;propmt
                mov     di,offset VW_Reg_SP     ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_P:       mov     si,offset FB_RegP_Rq    ;propmt
                mov     di,offset VW_Reg_PC     ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_I:       mov     si,offset FB_Addr_Rq    ;propmt pro adresu
                mov     di,offset VW_Brk_Adr    ;adresa, kam prijde vysledek
                jmp     short LN_Dbg_GetNr

LN_Dbg_NrErr:   pop     si                      ;obnovit prompt
LN_Dbg_GetNr:   call    PN_ClrEol               ;smazat stavovy radek debuggeru
                mov     bx,offset FB_Dbg_Val    ;radkovy buffer debuggeru
                call    PN_Read_Line            ;nacist radek
                jc      LN_Debugger             ;ESC => zpatky
                push    si                      ;schovat prompt
                mov     si,bx                   ;zacatek bufferu s cislem
                call    PN_Get_Nr               ;nacist cislo
                jc      LN_Dbg_GetNr            ;chyba v cisle
                call    PN_Skip                 ;nacist ukoncovaci znak
                or      al,al                   ;musi byt 0
                jnz     LN_Dbg_GetNr            ;nebyl => znovu nacist
                pop     si                      ;vycistit zasobnik
                mov     ds:[di],dx              ;zapsat cislo
                jmp     LN_Debugger              ;a frcet

;

LN_Dbg_End:     mov     VW_Cursor,2*256+25
                call    PN_ClrEol               ;smazat stavovy radek
                jmp     LN_Main                 ;do hlavniho menu

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Disp_Dbg          vytiskne radku debuggeru, nastavi VW_Next_Inst         ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vystup:      ES:BX           adresa nasledujici instrukce                   ║
;║ Nici:        AX,CX,SI                                                       ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Disp_Dbg     proc    near
;
                mov     es,VW_PMD_Seg           ;do segmentu PMD

                mov     VW_Cursor,4*256+25
                mov     ax,VW_Reg_PC
                call    PN_Disp_AX              ;PC

                mov     VW_Cursor,9*256+25
                mov     bx,ax                   ;=PC
                call    PN_Disp_Inst            ;vypsat instrukci, v BX dalsi

                mov     si,offset FB_Dbg_Stat   ;soubor textu debuggeru
                call    PN_DTxt
                mov     al,byte ptr VW_Reg_PSW+1
                call    PN_Disp_AL              ;A
                call    PN_DTxt
                mov     ax,VW_Reg_BC
                call    PN_Disp_AX              ;BC
                call    PN_DTxt
                mov     ax,VW_Reg_DE
                call    PN_Disp_AX              ;DE
                call    PN_DTxt
                mov     ax,VW_Reg_HL
                call    PN_Disp_AX              ;HL
                call    PN_DTxt
                mov     ax,VW_Reg_SP
                call    PN_Disp_AX              ;SP
                call    PN_DTxt
                mov     si,VW_Reg_HL
                mov     al,es:[si]
                call    PN_Disp_AL              ;M

                mov     VW_Cursor,73*256+25             ;pozice vypisu flagu
                mov     si,offset FB_Flg_Names          ;jmena flagu
                mov     cx,5                            ;pocet flagu
                mov     ah,byte ptr VW_Reg_PSW          ;registr flagu
                cld
PN_DD_DispFlg:  lodsb                           ;jmeno flagu
                or      al,al                   ;test na platnost
                rol     ah,1                    ;pripravit flag do CF
                jz      PN_DD_DispFlg           ;neplatny bit => dal
                jc      PN_DD_FlgOn             ;platny bit a nastaven => tisk
                mov     al,'-'                  ;neni nastaven => psat pomlcku
PN_DD_FlgOn:    call    PN_CO                   ;vypsat flag
                loop    PN_DD_DispFlg           ;pro vsechny flagy

                ret                             ;v BX adresa nasledujici inst.

PN_Disp_Dbg     endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Disp_Inst         vytiskne instrukci                                     ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:       BX      adresa instrukce                                       ║
;║              ES      segment instrukce                                      ║
;║ Vystup:      BX      adresa nasledujici instrukce                           ║
;║ Nici:        AX                                                             ║
;╟─────────────────────────────────────────────────────────────────────────────╢
;║ Vypsana instrukce ma delku 13 znaku, vypisuje se od pozice kurzoru.         ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Disp_Inst    proc    near
;
                push    cx
                push    dx
                push    si

                xor     dl,dl                   ;citac vypsanych znaku
                xor     ch,ch                   ;pro nasledujici je CH=0

                mov     ah,es:[bx]              ;kod instrukce
                call    PN_Fnd_Ins              ;najit instrukci
                jc      PN_DI_DB                ;nenasel => DB, pro DB se
                inc     bx                       ;neposouva BX
PN_DI_DB:       xchg    si,bx                   ;PC do SI, nazev do BX
                mov     cl,4                    ;max. delka jmena
                call    PN_DI_DspTxt            ;vypsat jmeno

                test    dh,I_Con                ;obsahuje podminku ?
                jz      PN_DI_NoCond            ;ne => dal
                mov     bl,ah                   ;kod instrukce
                and     bx,00111000b            ;izolovat podminku
                shr     bl,1                    ;udelat z podminky offset
                shr     bl,1                     ;v tabulce podminek
                add     bx,offset FB_Tbl_Cond     ;vypsat podminku
                mov     cl,2                    ;max. delka podminky
                call    PN_DI_DspTxt            ;vypsat

PN_DI_NoCond:   mov     cl,5                    ;vytisknout mezery az k moznemu
                call    PN_DI_PrtSp              ;parametru instrukce

                test    dh,I_Dst                ;cilovy registr ?
                jz      PN_DI_NoDst             ;ne => dal
                mov     bl,ah                   ;kod instrukce
                and     bx,00111000b            ;izolovat registr
                shr     bl,1                    ;vyrobit offset v tabulce
                shr     bl,1
                shr     bl,1
                mov     al,FB_Tbl_Reg[bx]       ;pismeno registru
                call    PN_CO
                inc     dl                      ;upravit pocet vytisklych znaku

PN_DI_NoDst:    test    dh,I_Src                ;zdrojovy registr ?
                jz      PN_DI_NoSrc             ;ne => dal
                cmp     dl,5                    ;ma byt carka ?
                je      PN_DI_DstNoC            ;ne => dal
                mov     al,','                  ;ano => vypsat
                call    PN_CO
                inc     dl                      ;pocet znaku
PN_DI_DstNoC:   mov     bl,ah                   ;kod instrukce
                and     bx,00111b               ;izolovat registr
                mov     al,FB_Tbl_Reg[bx]       ;pismeno registru
                call    PN_CO
                inc     dl                      ;upravit pocet vytisklych znaku

PN_DI_NoSrc:    test    dh,I_RPSW               ;registrove pary s PSW ?
                jz      PN_DI_NoRPSW            ;ne => dal
                mov     bl,ah                   ;kod instrukce
                and     bx,00110000b            ;izolovat kod reg. paru
                shr     bl,1                    ;na offset v tabulce
                shr     bl,1
                add     bx,offset FB_Tbl_RPSW   ;vypsat nazev reg. paru
                mov     cl,3                    ;max. delka
                call    PN_DI_DspTxt

PN_DI_NoRPSW:   test    dh,I_RSP                ;registrove pary s SP ?
                jz      PN_DI_NoRSP             ;ne => dal
                mov     bl,ah                   ;kod instrukce
                and     bx,00110000b            ;izolovat kod reg. paru
                shr     bl,1                    ;na offset v tabulce
                shr     bl,1
                shr     bl,1
                add     bx,offset FB_Tbl_RSP    ;vypsat nazev reg. paru
                mov     cl,2                    ;max. delka
                call    PN_DI_DspTxt

PN_DI_NoRSP:    test    dh,I_Nr                 ;cislo restartu ?
                jz      PN_DI_NoNr              ;ne => dal
                mov     al,ah                   ;kod instrukce
                and     al,00111000b            ;izolovat restart
                shr     al,1                    ;na cislo
                shr     al,1
                shr     al,1
                add     al,'0'                  ;na ASCII
                call    PN_CO                   ;vytisknout
                inc     dl                      ;upravit pozici

PN_DI_NoNr:     mov     bx,si                   ;adresa na instrukci

                test    dh,1                    ;cislo delky 1 ?
                jz      PN_DI_No1               ;ne => dal
                cmp     dl,6                    ;ma byt carka ?
                jne     PN_DI_Nr1NoC            ;ne => dal
                mov     al,','                  ;ano => vypsat
                call    PN_CO
                inc     dl                      ;upravit pocet vypsanych znaku
PN_DI_Nr1NoC:   mov     al,es:[bx]              ;vzit tisteny bajt
                call    PN_Disp_AL              ;vypsat
                inc     bx                      ;na nasledujici instrukci
                add     dl,2                    ;upravit pocet vypsanych znaku

PN_DI_No1:      test    dh,2                    ;cislo delky 2 ?
                jz      PN_DI_No2               ;ne => dal
                cmp     dl,5                    ;ma byt carka ?
                je      PN_DI_Nr2NoC            ;ne => dal
                mov     al,','                  ;ano => vypsat
                call    PN_CO
                inc     dl                      ;pocet znaku
PN_DI_Nr2NoC:   mov     al,es:[bx]              ;tistene cislo (cist nadvakrat
                mov     ah,es:[bx+1]             ;kvuli Exception 0Dh)
                call    PN_Disp_AX              ;vypsat
                add     bx,2                    ;na nasledujici instrukci

PN_DI_No2:      mov     cl,13                   ;doplnit mezerami na 13 znaku
                call    PN_DI_PrtSp

                pop     si
                pop     dx
                pop     cx

                ret

;

PN_DI_DspTxt:   mov     al,ds:[bx]              ;znak
                or      al,al                   ;konec textu ?
                jz      PN_DI_DspEnd            ;ano => ven
                call    PN_CO                   ;ne => tisk
                inc     bx                      ;na dalsi znak
                inc     dl                      ;pocet vytisklych znaku
                loop    PN_DI_DspTxt            ;do max. poctu znaku
PN_DI_DspEnd:   ret

;

PN_DI_PrtSp:    mov     al,' '                  ;vytisknout mezery az do
PN_DI_Space:    call    PN_CO                    ;pozice v CL
                inc     dl
                cmp     dl,cl
                jb      PN_DI_Space
                ret

PN_Disp_Inst    endp

;╔═════════════════════════════════════════════════════════════════════════════╗
;║ PN_Fnd_Ins           zkusi najit instrukci podle jejiho kodu v tabulce      ║
;╠═════════════════════════════════════════════════════════════════════════════╣
;║ Vstup:       AH      kod hledane instrukce                                  ║
;║ Vystup:      CF      1 => instrukce nebyla nalezena, ostatni reg. pro DB    ║
;║              DH      typ instrukce                                          ║
;║              SI      nazev instrukce z tabulky                              ║
;╚═════════════════════════════════════════════════════════════════════════════╝

PN_Fnd_Ins      proc    near
;
                push    cx

                mov     si,offset FB_Tbl_PMDIns         ;tabulka instrukci 8080
                mov     cx,CB_PMDIns_Nr                 ;pocet instrukci
                cld

PN_FI_Main:     lodsb                                   ;typ instrukce
                mov     dh,-1                           ;urcit spravnou masku
                test    al,10001100b                    ;data v bitech 3-5 ?
                jz      PN_FI_No35                      ;ne => nic
                and     dh,11000111b                    ;ano => v masce
PN_FI_No35:     test    al,01000000b                    ;data v bitech 0-2 ?
                jz      PN_FI_No02                      ;ne => nic
                and     dh,11111000b                    ;ano => v masce
PN_FI_No02:     test    al,00110000b                    ;data v bitech 4-5 ?
                jz      PF_FI_No45                      ;ne => nic
                and     dh,11001111b                    ;ano => v masce
PF_FI_No45:     and     dh,ah                           ;vzit zaklad instrukce
                cmp     dh,ds:[si]                      ;nasel ?
                jz      PN_FI_Found                     ;ano => ven
                add     si,5                            ;ne => na dalsi pozici
                loop    PN_FI_Main                       ;a opakovat

                stc                                     ;vubec nenasel => CF
                inc     si                              ;na data pro DB
PN_FI_Found:    mov     dh,ds:[si-1]                    ;vracet typ
                inc     si                              ;na text jmena

                pop     cx

                ret                                     ;bye bye

PN_Fnd_Ins      endp

;
;;;
;;;;
;;;
;

                even
LW_StkEnd       dw      1024 dup (?)            ;2k zasobnik programu
LW_Stack        label   word

;

                even
FW_Tbl_Adr      label   word                    ;32k prevodni tabulka adres
                org     $+32768

                even
FW_Disp1_Tbl    label   word                    ;256b prevodni tabulka prvnich
                org     $+256                    ;bajtu videa
FW_Disp2_Tbl    label   word                    ;256b prevodni tabulka druhych
                org     $+256                    ;bajtu videa


CW_MgBfr_Len    equ     2048

FB_MgIn_Bfr     label   byte                    ;2k vstupni buffer pro MGF
                org     $+CW_MgBfr_Len

FB_MgOut_Bfr    label   byte                    ;2k vystupni buffer pro MGF
                org     $+CW_MgBfr_Len
FB_MgOut_BfrE   label   byte

;

LN_Cde_End      label   near
CW_Cde_Len      equ     (offset LN_Cde_End-offset LN_Cde_Beg+15)/16

                .erre   CW_Cde_Len lt 0F000h

;

SP_Code         ends

                end             LN_Begin
