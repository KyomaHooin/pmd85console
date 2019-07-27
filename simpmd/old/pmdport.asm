;
;  ████   █   █  ████
;  █▒▒▒█  ██ ██▒  █▒▒█                        █
;  █▒  █▒ █▒█ █▒  █▒ █▒ ████    ███   █ ██   ███
;  ████ ▒ █▒█▒█▒  █▒ █▒ █▒▒▒█  █ ▒▒█  ██▒▒█   █▒▒
;  █▒▒▒▒  █▒ ▒█▒  █▒ █▒ █▒  █▒ █▒  █▒ █▒▒  ▒  █▒
;  █▒     █▒  █▒  █▒ █▒ █▒  █▒ █▒  █▒ █▒      █▒ █
;  █▒     █▒  █▒ ████ ▒ ████ ▒  ███ ▒ █▒       ██ ▒
;   ▒      ▒   ▒  ▒▒▒▒  █▒▒▒▒    ▒▒▒   ▒        ▒▒
;                       █▒
;                        ▒
;
;
;

                ife     CB_NextFlg              ;zvolit spravny nazev pole
FWX_Tbl_IN      label   word
                else
FW_Tbl_IN       label   word
                endif


                Port    NoIN                 ;00
                Port    NoIN                 ;01
                Port    NoIN                 ;02
                Port    NoIN                 ;03
                Port    NoIN                 ;04
                Port    NoIN                 ;05
                Port    NoIN                 ;06
                Port    NoIN                 ;07
                Port    NoIN                 ;08
                Port    NoIN                 ;09
                Port    NoIN                 ;0A
                Port    NoIN                 ;0B
                Port    NoIN                 ;0C
                Port    NoIN                 ;0D
                Port    NoIN                 ;0E
                Port    NoIN                 ;0F

                Port    NoIN                 ;10
                Port    NoIN                 ;11
                Port    NoIN                 ;12
                Port    NoIN                 ;13
                Port    NoIN                 ;14
                Port    NoIN                 ;15
                Port    NoIN                 ;16
                Port    NoIN                 ;17
                Port    IN_1E                ;18 8251 DATA (in/out)
                Port    IN_1F                ;19 8251 CWR (in)
                Port    IN_1E                ;1A 8251 DATA (in/out)
                Port    IN_1F                ;1B 8251 CWR (in)
                Port    IN_1E                ;1C 8251 DATA (in/out)
                Port    IN_1F                ;1D 8251 CWR (in)
                Port    IN_1E                ;1E 8251 DATA (in/out)
                Port    IN_1F                ;1F 8251 CWR (in)

                Port    NoIN                 ;20
                Port    NoIN                 ;21
                Port    NoIN                 ;22
                Port    NoIN                 ;23
                Port    NoIN                 ;24
                Port    NoIN                 ;25
                Port    NoIN                 ;26
                Port    NoIN                 ;27
                Port    NoIN                 ;28
                Port    NoIN                 ;29
                Port    NoIN                 ;2A
                Port    NoIN                 ;2B
                Port    NoIN                 ;2C
                Port    NoIN                 ;2D
                Port    NoIN                 ;2E
                Port    NoIN                 ;2F

                Port    NoIN                 ;30
                Port    NoIN                 ;31
                Port    NoIN                 ;32
                Port    NoIN                 ;33
                Port    NoIN                 ;34
                Port    NoIN                 ;35
                Port    NoIN                 ;36
                Port    NoIN                 ;37
                Port    NoIN                 ;38
                Port    NoIN                 ;39
                Port    NoIN                 ;3A
                Port    NoIN                 ;3B
                Port    NoIN                 ;3C
                Port    NoIN                 ;3D
                Port    NoIN                 ;3E
                Port    NoIN                 ;3F

                Port    NoIN                 ;40
                Port    NoIN                 ;41
                Port    NoIN                 ;42
                Port    NoIN                 ;43
                Port    NoIN                 ;44
                Port    NoIN                 ;45
                Port    NoIN                 ;46
                Port    NoIN                 ;47
                Port    IN_4C                ;48 Joy data 8255 PA (in)
                Port    NoIN                 ;49
                Port    NoIN                 ;4A
                Port    NoIN                 ;4B
                Port    IN_4C                ;4C Joy data 8255 PA (in)
                Port    NoIN                 ;4D
                Port    NoIN                 ;4E
                Port    NoIN                 ;4F

                Port    NoIN                 ;50
                Port    NoIN                 ;51
                Port    NoIN                 ;52
                Port    NoIN                 ;53
                Port    NoIN                 ;54
                Port    NoIN                 ;55
                Port    NoIN                 ;56
                Port    NoIN                 ;57
                Port    NoIN                 ;58
                Port    NoIN                 ;59
                Port    NoIN                 ;5A
                Port    NoIN                 ;5B
                Port    NoIN                 ;5C
                Port    NoIN                 ;5D
                Port    NoIN                 ;5E
                Port    NoIN                 ;5F

                Port    NoIN                 ;60
                Port    NoIN                 ;61
                Port    NoIN                 ;62
                Port    NoIN                 ;63
                Port    NoIN                 ;64
                Port    NoIN                 ;65
                Port    NoIN                 ;66
                Port    NoIN                 ;67
                Port    NoIN                 ;68
                Port    NoIN                 ;69
                Port    NoIN                 ;6A
                Port    NoIN                 ;6B
                Port    NoIN                 ;6C
                Port    NoIN                 ;6D
                Port    NoIN                 ;6E
                Port    NoIN                 ;6F

                Port    NoIN                 ;70
                Port    NoIN                 ;71
                Port    NoIN                 ;72
                Port    NoIN                 ;73
                Port    NoIN                 ;74
                Port    NoIN                 ;75
                Port    NoIN                 ;76
                Port    NoIN                 ;77
                Port    IN_7C                ;78 LPT1 Data 8255 PA (out)
                Port    IN_7D                ;79 LPT1 Status 8255 PB (in)
                Port    IN_7E                ;7A LPT1 Ctrl 8255 PC (out)
                Port    NoIN                 ;7B
                Port    IN_7C                ;7C LPT1 Data 8255 PA (out)
                Port    IN_7D                ;7D LPT1 Status 8255 PB (in)
                Port    IN_7E                ;7E LPT1 Ctrl 8255 PC (out)
                Port    NoIN                 ;7F

                Port    IN_F4                ;80 Keybd Col 8255 PA (out)
                Port    IN_F5                ;81 Keybd Row 8255 PB (in)
                Port    IN_F6                ;82 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;83
                Port    IN_F4                ;84 Keybd Col 8255 PA (out)
                Port    IN_F5                ;85 Keybd Row 8255 PB (in)
                Port    IN_F6                ;86 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;87
                Port    NoIN                 ;88
                Port    NoIN                 ;89
                Port    NoIN                 ;8A
                Port    NoIN                 ;8B
                Port    NoIN                 ;8C
                Port    NoIN                 ;8D
                Port    NoIN                 ;8E
                Port    NoIN                 ;8F

                Port    IN_F4                ;90 Keybd Col 8255 PA (out)
                Port    IN_F5                ;91 Keybd Row 8255 PB (in)
                Port    IN_F6                ;92 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;93
                Port    IN_F4                ;94 Keybd Col 8255 PA (out)
                Port    IN_F5                ;95 Keybd Row 8255 PB (in)
                Port    IN_F6                ;96 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;97
                Port    NoIN                 ;98
                Port    NoIN                 ;99
                Port    NoIN                 ;9A
                Port    NoIN                 ;9B
                Port    NoIN                 ;9C
                Port    NoIN                 ;9D
                Port    NoIN                 ;9E
                Port    NoIN                 ;9F

                Port    IN_F4                ;A0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;A1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;A2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;A3
                Port    IN_F4                ;A4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;A5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;A6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;A7
                Port    NoIN                 ;A8
                Port    NoIN                 ;A9
                Port    NoIN                 ;AA
                Port    NoIN                 ;AB
                Port    NoIN                 ;AC
                Port    NoIN                 ;AD
                Port    NoIN                 ;AE
                Port    NoIN                 ;AF

                Port    IN_F4                ;B0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;B1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;B2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;B3
                Port    IN_F4                ;B4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;B5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;B6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;B7
                Port    NoIN                 ;B8
                Port    NoIN                 ;B9
                Port    NoIN                 ;BA
                Port    NoIN                 ;BB
                Port    NoIN                 ;BC
                Port    NoIN                 ;BD
                Port    NoIN                 ;BE
                Port    NoIN                 ;BF

                Port    IN_F4                ;C0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;C1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;C2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;C3
                Port    IN_F4                ;C4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;C5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;C6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;C7
                Port    NoIN                 ;C8
                Port    NoIN                 ;C9
                Port    NoIN                 ;CA
                Port    NoIN                 ;CB
                Port    NoIN                 ;CC
                Port    NoIN                 ;CD
                Port    NoIN                 ;CE
                Port    NoIN                 ;CF

                Port    IN_F4                ;D0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;D1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;D2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;D3
                Port    IN_F4                ;D4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;D5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;D6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;D7
                Port    NoIN                 ;D8
                Port    NoIN                 ;D9
                Port    NoIN                 ;DA
                Port    NoIN                 ;DB
                Port    NoIN                 ;DC
                Port    NoIN                 ;DD
                Port    NoIN                 ;DE
                Port    NoIN                 ;DF

                Port    IN_F4                ;E0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;E1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;E2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;E3
                Port    IN_F4                ;E4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;E5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;E6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;E7
                Port    NoIN                 ;E8
                Port    NoIN                 ;E9
                Port    NoIN                 ;EA
                Port    NoIN                 ;EB
                Port    NoIN                 ;EC
                Port    NoIN                 ;ED
                Port    NoIN                 ;EE
                Port    NoIN                 ;EF

                Port    IN_F4                ;F0 Keybd Col 8255 PA (out)
                Port    IN_F5                ;F1 Keybd Row 8255 PB (in)
                Port    IN_F6                ;F2 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;F3
                Port    IN_F4                ;F4 Keybd Col 8255 PA (out)
                Port    IN_F5                ;F5 Keybd Row 8255 PB (in)
                Port    IN_F6                ;F6 Spkr/LED 8255 PC (out)
                Port    NoIN                 ;F7
                Port    NoIN                 ;F8
                Port    NoIN                 ;F9
                Port    NoIN                 ;FA
                Port    NoIN                 ;FB
                Port    NoIN                 ;FC
                Port    NoIN                 ;FD
                Port    NoIN                 ;FE
                Port    NoIN                 ;FF

;
;;;
;;;;;
;;;
;

                ife     CB_NextFlg              ;zvolit spravny nazev pole
FWX_Tbl_OUT     label   word
                else
FW_Tbl_OUT      label   word
                endif


                Port    NoOUT                ;00
                Port    NoOUT                ;01
                Port    NoOUT                ;02
                Port    NoOUT                ;03
                Port    NoOUT                ;04
                Port    NoOUT                ;05
                Port    NoOUT                ;06
                Port    NoOUT                ;07
                Port    NoOUT                ;08
                Port    NoOUT                ;09
                Port    NoOUT                ;0A
                Port    NoOUT                ;0B
                Port    NoOUT                ;0C
                Port    NoOUT                ;0D
                Port    NoOUT                ;0E
                Port    NoOUT                ;0F

                Port    NoOUT                ;10
                Port    NoOUT                ;11
                Port    NoOUT                ;12
                Port    NoOUT                ;13
                Port    NoOUT                ;14
                Port    NoOUT                ;15
                Port    NoOUT                ;16
                Port    NoOUT                ;17
                Port    OUT_1E               ;18 8251 DATA (in/out)
                Port    NoOUT                ;19 8251 CWR (in)
                Port    OUT_1E               ;1A 8251 DATA (in/out)
                Port    NoOUT                ;1B 8251 CWR (in)
                Port    OUT_1E               ;1C 8251 DATA (in/out)
                Port    NoOUT                ;1D 8251 CWR (in)
                Port    OUT_1E               ;1E 8251 DATA (in/out)
                Port    NoOUT                ;1F 8251 CWR (in)

                Port    NoOUT                ;20
                Port    NoOUT                ;21
                Port    NoOUT                ;22
                Port    NoOUT                ;23
                Port    NoOUT                ;24
                Port    NoOUT                ;25
                Port    NoOUT                ;26
                Port    NoOUT                ;27
                Port    NoOUT                ;28
                Port    NoOUT                ;29
                Port    NoOUT                ;2A
                Port    NoOUT                ;2B
                Port    NoOUT                ;2C
                Port    NoOUT                ;2D
                Port    NoOUT                ;2E
                Port    NoOUT                ;2F

                Port    NoOUT                ;30
                Port    NoOUT                ;31
                Port    NoOUT                ;32
                Port    NoOUT                ;33
                Port    NoOUT                ;34
                Port    NoOUT                ;35
                Port    NoOUT                ;36
                Port    NoOUT                ;37
                Port    NoOUT                ;38
                Port    NoOUT                ;39
                Port    NoOUT                ;3A
                Port    NoOUT                ;3B
                Port    NoOUT                ;3C
                Port    NoOUT                ;3D
                Port    NoOUT                ;3E
                Port    NoOUT                ;3F

                Port    NoOUT                ;40
                Port    NoOUT                ;41
                Port    NoOUT                ;42
                Port    NoOUT                ;43
                Port    NoOUT                ;44
                Port    NoOUT                ;45
                Port    NoOUT                ;46
                Port    NoOUT                ;47
                Port    NoOUT                ;48
                Port    NoOUT                ;49
                Port    NoOUT                ;4A
                Port    NoOUT                ;4B
                Port    NoOUT                ;4C
                Port    NoOUT                ;4D
                Port    NoOUT                ;4E
                Port    NoOUT                ;4F

                Port    NoOUT                ;50
                Port    NoOUT                ;51
                Port    NoOUT                ;52
                Port    NoOUT                ;53
                Port    NoOUT                ;54
                Port    NoOUT                ;55
                Port    NoOUT                ;56
                Port    NoOUT                ;57
                Port    NoOUT                ;58
                Port    NoOUT                ;59
                Port    NoOUT                ;5A
                Port    NoOUT                ;5B
                Port    NoOUT                ;5C
                Port    NoOUT                ;5D
                Port    NoOUT                ;5E
                Port    NoOUT                ;5F

                Port    NoOUT                ;60
                Port    NoOUT                ;61
                Port    NoOUT                ;62
                Port    NoOUT                ;63
                Port    NoOUT                ;64
                Port    NoOUT                ;65
                Port    NoOUT                ;66
                Port    NoOUT                ;67
                Port    NoOUT                ;68
                Port    NoOUT                ;69
                Port    NoOUT                ;6A
                Port    NoOUT                ;6B
                Port    NoOUT                ;6C
                Port    NoOUT                ;6D
                Port    NoOUT                ;6E
                Port    NoOUT                ;6F

                Port    NoOUT                ;70
                Port    NoOUT                ;71
                Port    NoOUT                ;72
                Port    NoOUT                ;73
                Port    NoOUT                ;74
                Port    NoOUT                ;75
                Port    NoOUT                ;76
                Port    NoOUT                ;77
                Port    OUT_7C               ;78 LPT1 Data 8255 PA (out)
                Port    NoOUT                ;79 LPT1 Status 8255 PB (in)
                Port    OUT_7E               ;7A LPT1 Ctrl 8255 PC (out)
                Port    NoOUT                ;7B
                Port    OUT_7C               ;7C LPT1 Data 8255 PA (out)
                Port    NoOUT                ;7D LPT1 Status 8255 PB (in)
                Port    OUT_7E               ;7E LPT1 Ctrl 8255 PC (out)
                Port    NoOUT                ;7F

                Port    OUT_F4               ;80 Keybd Col 8255 PA (out)
                Port    NoOUT                ;81 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;82 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;83 8255 CWR (out)
                Port    OUT_F4               ;84 Keybd Col 8255 PA (out)
                Port    NoOUT                ;85 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;86 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;87 8255 CWR (out)
                Port    NoOUT                ;88
                Port    NoOUT                ;89
                Port    NoOUT                ;8A
                Port    NoOUT                ;8B
                Port    NoOUT                ;8C
                Port    NoOUT                ;8D
                Port    NoOUT                ;8E
                Port    NoOUT                ;8F

                Port    OUT_F4               ;90 Keybd Col 8255 PA (out)
                Port    NoOUT                ;91 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;92 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;93 8255 CWR (out)
                Port    OUT_F4               ;94 Keybd Col 8255 PA (out)
                Port    NoOUT                ;95 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;96 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;97 8255 CWR (out)
                Port    NoOUT                ;98
                Port    NoOUT                ;99
                Port    NoOUT                ;9A
                Port    NoOUT                ;9B
                Port    NoOUT                ;9C
                Port    NoOUT                ;9D
                Port    NoOUT                ;9E
                Port    NoOUT                ;9F

                Port    OUT_F4               ;A0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;A1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;A2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;A3 8255 CWR (out)
                Port    OUT_F4               ;A4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;A5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;A6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;A7 8255 CWR (out)
                Port    NoOUT                ;A8
                Port    NoOUT                ;A9
                Port    NoOUT                ;AA
                Port    NoOUT                ;AB
                Port    NoOUT                ;AC
                Port    NoOUT                ;AD
                Port    NoOUT                ;AE
                Port    NoOUT                ;AF

                Port    OUT_F4               ;B0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;B1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;B2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;B3 8255 CWR (out)
                Port    OUT_F4               ;B4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;B5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;B6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;B7 8255 CWR (out)
                Port    NoOUT                ;B8
                Port    NoOUT                ;B9
                Port    NoOUT                ;BA
                Port    NoOUT                ;BB
                Port    NoOUT                ;BC
                Port    NoOUT                ;BD
                Port    NoOUT                ;BE
                Port    NoOUT                ;BF

                Port    OUT_F4               ;C0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;C1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;C2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;C3 8255 CWR (out)
                Port    OUT_F4               ;C4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;C5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;C6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;C7 8255 CWR (out)
                Port    NoOUT                ;C8
                Port    NoOUT                ;C9
                Port    NoOUT                ;CA
                Port    NoOUT                ;CB
                Port    NoOUT                ;CC
                Port    NoOUT                ;CD
                Port    NoOUT                ;CE
                Port    NoOUT                ;CF

                Port    OUT_F4               ;D0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;D1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;D2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;D3 8255 CWR (out)
                Port    OUT_F4               ;D4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;D5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;D6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;D7 8255 CWR (out)
                Port    NoOUT                ;D8
                Port    NoOUT                ;D9
                Port    NoOUT                ;DA
                Port    NoOUT                ;DB
                Port    NoOUT                ;DC
                Port    NoOUT                ;DD
                Port    NoOUT                ;DE
                Port    NoOUT                ;DF

                Port    OUT_F4               ;E0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;E1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;E2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;E3 8255 CWR (out)
                Port    OUT_F4               ;E4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;E5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;E6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;E7 8255 CWR (out)
                Port    NoOUT                ;E8
                Port    NoOUT                ;E9
                Port    NoOUT                ;EA
                Port    NoOUT                ;EB
                Port    NoOUT                ;EC
                Port    NoOUT                ;ED
                Port    NoOUT                ;EE
                Port    NoOUT                ;EF

                Port    OUT_F4               ;F0 Keybd Col 8255 PA (out)
                Port    NoOUT                ;F1 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;F2 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;F3 8255 CWR (out)
                Port    OUT_F4               ;F4 Keybd Col 8255 PA (out)
                Port    NoOUT                ;F5 Keybd Row 8255 PB (in)
                Port    OUT_F6               ;F6 Spkr/LED 8255 PC (out)
                Port    OUT_F7               ;F7 8255 CWR (out)
                Port    NoOUT                ;F8
                Port    NoOUT                ;F9
                Port    NoOUT                ;FA
                Port    NoOUT                ;FB
                Port    NoOUT                ;FC
                Port    NoOUT                ;FD
                Port    NoOUT                ;FE
                Port    NoOUT                ;FF

;
;;;
;;;;;
;;;
;

