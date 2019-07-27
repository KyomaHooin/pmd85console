;
;  ████   █   █  ████    █
;  █▒▒▒█  ██ ██▒  █▒▒█    ▒
;  █▒  █▒ █▒█ █▒  █▒ █▒ ██   █ ██    ████
;  ████ ▒ █▒█▒█▒  █▒ █▒  █▒  ██ ▒█  █ ▒▒▒▒
;  █▒▒▒▒  █▒ ▒█▒  █▒ █▒  █▒  █▒▒ █▒  ███
;  █▒     █▒  █▒  █▒ █▒  █▒  █▒  █▒   ▒▒█
;  █▒     █▒  █▒ ████ ▒ ███  █▒  █▒ ████ ▒
;   ▒      ▒   ▒  ▒▒▒▒   ▒▒▒  ▒   ▒  ▒▒▒▒
;
;
;
;

                NOJUMPS

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_Jxx               procedury obsluhujici skoky typu Jxx                   ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL JMP
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JNZ
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jz      LNX_JxxNext           ;neskace se => dalsi
                else
                  jz      LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JNC
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jc      LNX_JxxNext           ;neskace se => dalsi
                else
                  jc      LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JPO
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jp      LNX_JxxNext           ;neskace se => dalsi
                else
                  jp      LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JP
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  js      LNX_JxxNext           ;neskace se => dalsi
                else
                  js      LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JZ
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jnz     LNX_JxxNext           ;neskace se => dalsi
                else
                  jnz     LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JC
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jnc     LNX_JxxNext           ;neskace se => dalsi
                else
                  jnc     LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JPE
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jnp     LNX_JxxNext           ;neskace se => dalsi
                else
                  jnp     LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JM
                sahf                            ;nastavit flagy
                ife     CB_NextFlg
                  jns     LNX_JxxNext           ;neskace se => dalsi
                else
                  jns     LN_JxxNext
                endif
                mov     RPC,ds:[RPC]            ;adresa skoku
                Next

;

 MkL JxxNext
                add     RPC,2                   ;vynechat adresu skoku
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_Cxx               procedury obsluhujici volani typu Cxx                  ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL CNZ
                sahf
                ife     CB_NextFlg
                  jnz     LNX_CALL              ;skace se => CALL
                else
                  jnz     LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CNC
                sahf
                ife     CB_NextFlg
                  jnc     LNX_CALL              ;skace se => CALL
                else
                  jnc     LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CPO
                sahf
                ife     CB_NextFlg
                  jnp     LNX_CALL              ;skace se => CALL
                else
                  jnp     LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CP
                sahf
                ife     CB_NextFlg
                  jns     LNX_CALL              ;skace se => CALL
                else
                  jns     LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CZ
                sahf
                ife     CB_NextFlg
                  jz      LNX_CALL              ;skace se => CALL
                else
                  jz      LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CC
                sahf
                ife     CB_NextFlg
                  jc      LNX_CALL              ;skace se => CALL
                else
                  jc      LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CPE
                sahf
                ife     CB_NextFlg
                  jp      LNX_CALL              ;skace se => CALL
                else
                  jp      LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CM
                sahf
                ife     CB_NextFlg
                  js      LNX_CALL              ;skace se => CALL
                else
                  js      LN_CALL
                endif
                add     RPC,2                   ;neskace se => vynechat adresu
                Next

;

 MkL CALL
                add     RPC,2                   ;navratova adresa
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,ds:[RPC-2]          ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_Rxx               procedury obsluhujici volani typu Rxx                  ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL RET
                mov     RPC,ds:[RSP]
                add     RSP,2
                Next

;

 MkL RNZ
                sahf
                ife     CB_NextFlg
                  jnz     LNX_RET               ;skace se => RET
                else
                  jnz     LN_RET
                endif
                Next

;

 MkL RNC
                sahf
                ife     CB_NextFlg
                  jnc     LNX_RET               ;skace se => RET
                else
                  jnc     LN_RET
                endif
                Next

;

 MkL RPO
                sahf
                ife     CB_NextFlg
                  jnp     LNX_RET               ;skace se => RET
                else
                  jnp     LN_RET
                endif
                Next

;

 MkL RP
                sahf
                ife     CB_NextFlg
                  jns     LNX_RET               ;skace se => RET
                else
                  jns     LN_RET
                endif
                Next

;

 MkL RZ
                sahf
                ife     CB_NextFlg
                  jz      LNX_RET               ;skace se => RET
                else
                  jz      LN_RET
                endif
                Next

;

 MkL RC
                sahf
                ife     CB_NextFlg
                  jc      LNX_RET               ;skace se => RET
                else
                  jc      LN_RET
                endif
                Next

;

 MkL RPE
                sahf
                ife     CB_NextFlg
                  jp      LNX_RET               ;skace se => RET
                else
                  jp      LN_RET
                endif
                Next

;

 MkL RM
                sahf
                ife     CB_NextFlg
                  js      LNX_RET               ;skace se => RET
                else
                  js      LN_RET
                endif
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_RSTx              procedury obsluhujici volani typu RSTx                 ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL RST0
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,0                   ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST1
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,8                   ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST2
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,2*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST3
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,3*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST4
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,4*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST5
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,5*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST6
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,6*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;

 MkL RST7
                sub     RSP,2                   ;snizit zasobnik
                mov     ds:[RSP],RPC            ;zapsat navratovou adresu
                mov     RPC,7*8                 ;adresa volani
                DispW   RSP                     ;osetrit SP ve VRAM

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_LXIx              procedury obsluhujici prirazeni typu LXI r,w           ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL LXIB
                mov     RBC,ds:[RPC]            ;parametr instrukce
                add     RPC,2                   ;na dalsi instrukci
                Next

;

 MkL LXID
                mov     RDE,ds:[RPC]            ;parametr instrukce
                add     RPC,2                   ;na dalsi instrukci
                Next

;

 MkL LXIH
                mov     RHL,ds:[RPC]            ;parametr instrukce
                add     RPC,2                   ;na dalsi instrukci
                Next

;

 MkL LXISP
                mov     RSP,ds:[RPC]            ;parametr instrukce
                add     RPC,2                   ;na dalsi instrukci
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_MVIx              procedury obsluhujici prirazeni typu MVI r,b           ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL MVIB
                mov     RB,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVIC
                mov     RC,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVID
                mov     RD,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVIE
                mov     RE,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVIH
                mov     RH,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVIL
                mov     RL,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;

 MkL MVIM
                sahf                            ;uvolnit AH
                mov     ah,ds:[RPC]             ;parametr instrukce
                mov     RM,ah                   ;zapsat do M
                lahf                            ;obnovit AH
                inc     RPC
                DispB   RHL,RM

;

 MkL MVIA
                mov     RA,ds:[RPC]             ;parametr instrukce
                inc     RPC                     ;na dalsi instrukci
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_INXx              procedury obsluhujici inkrementaci typu INX r          ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL INXB
                inc     RBC
                Next

;

 MkL INXD
                inc     RDE
                Next

;

 MkL INXH
                inc     RHL
                Next

;

 MkL INXSP
                inc     RSP
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_INRx              procedury obsluhujici inkrementaci typu INR r          ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL INRB
                sahf
                inc     RB
                lahf
                Next

;

 MkL INRC
                sahf
                inc     RC
                lahf
                Next

;

 MkL INRD
                sahf
                inc     RD
                lahf
                Next

;

 MkL INRE
                sahf
                inc     RE
                lahf
                Next

;

 MkL INRH
                sahf
                inc     RH
                lahf
                Next

;

 MkL INRL
                sahf
                inc     RL
                lahf
                Next

;

 MkL INRM
                sahf
                inc     RM
                lahf
                DispB   RHL,RM

;

 MkL INRA
                sahf
                inc     RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_DCXx              procedury obsluhujici dekrementaci typu DCX r          ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL DCXB
                dec     RBC
                Next

;

 MkL DCXD
                dec     RDE
                Next

;

 MkL DCXH
                dec     RHL
                Next

;

 MkL DCXSP
                dec     RSP
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_DCRx              procedury obsluhujici dekrementaci typu DCR r          ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL DCRB
                sahf
                dec     RB
                lahf
                Next

;

 MkL DCRC
                sahf
                dec     RC
                lahf
                Next

;

 MkL DCRD
                sahf
                dec     RD
                lahf
                Next

;

 MkL DCRE
                sahf
                dec     RE
                lahf
                Next

;

 MkL DCRH
                sahf
                dec     RH
                lahf
                Next

;

 MkL DCRL
                sahf
                dec     RL
                lahf
                Next

;

 MkL DCRM
                sahf
                dec     RM
                lahf
                DispB   RHL,RM

;

 MkL DCRA
                sahf
                dec     RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_MOVxx             procedury obsluhujici presun typu MOV r,r              ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL MOVBC
                mov     RB,RC
                Next

;

 MkL MOVBD
                mov     RB,RD
                Next

;

 MkL MOVBE
                mov     RB,RE
                Next

;

 MkL MOVBH
                mov     RB,RH
                Next

;

 MkL MOVBL
                mov     RB,RL
                Next

;

 MkL MOVBM
                mov     RB,RM
                Next

;

 MkL MOVBA
                mov     RB,RA
                Next

;

 MkL MOVCB
                mov     RC,RB
                Next

;

 MkL MOVCD
                mov     RC,RD
                Next

;

 MkL MOVCE
                mov     RC,RE
                Next

;

 MkL MOVCH
                mov     RC,RH
                Next

;

 MkL MOVCL
                mov     RC,RL
                Next

;

 MkL MOVCM
                mov     RC,RM
                Next

;

 MkL MOVCA
                mov     RC,RA
                Next

;

 MkL MOVDB
                mov     RD,RB
                Next

;

 MkL MOVDC
                mov     RD,RC
                Next

;

 MkL MOVDE
                mov     RD,RE
                Next

;

 MkL MOVDH
                mov     RD,RH
                Next

;

 MkL MOVDL
                mov     RD,RL
                Next

;

 MkL MOVDM
                mov     RD,RM
                Next

;

 MkL MOVDA
                mov     RD,RA
                Next

;

 MkL MOVEB
                mov     RE,RB
                Next

;

 MkL MOVEC
                mov     RE,RC
                Next

;

 MkL MOVED
                mov     RE,RD
                Next

;

 MkL MOVEH
                mov     RE,RH
                Next

;

 MkL MOVEL
                mov     RE,RL
                Next

;

 MkL MOVEM
                mov     RE,RM
                Next

;

 MkL MOVEA
                mov     RE,RA
                Next

;

 MkL MOVHB
                mov     RH,RB
                Next

;

 MkL MOVHC
                mov     RH,RC
                Next

;

 MkL MOVHD
                mov     RH,RD
                Next

;

 MkL MOVHE
                mov     RH,RE
                Next

;

 MkL MOVHL
                mov     RH,RL
                Next

;

 MkL MOVHM
                mov     RH,RM
                Next

;

 MkL MOVHA
                mov     RH,RA
                Next

;

 MkL MOVLB
                mov     RL,RB
                Next

;

 MkL MOVLC
                mov     RL,RC
                Next

;

 MkL MOVLD
                mov     RL,RD
                Next

;

 MkL MOVLE
                mov     RL,RE
                Next

;

 MkL MOVLH
                mov     RL,RH
                Next

;

 MkL MOVLM
                mov     RL,RM
                Next

;

 MkL MOVLA
                mov     RL,RA
                Next

;

 MkL MOVMB
                mov     RM,RB
                DispB   RHL,RB

;

 MkL MOVMC
                mov     RM,RC
                DispB   RHL,RC

;

 MkL MOVMD
                mov     RM,RD
                DispB   RHL,RD

;

 MkL MOVME
                mov     RM,RE
                DispB   RHL,RE

;

 MkL MOVMH
                mov     RM,RH
                DispB   RHL,RH

;

 MkL MOVML
                mov     RM,RL
                DispB   RHL,RL

;

 MkL MOVMA
                mov     RM,RA
                DispB   RHL,RA

;

 MkL MOVAB
                mov     RA,RB
                Next

;

 MkL MOVAC
                mov     RA,RC
                Next

;

 MkL MOVAD
                mov     RA,RD
                Next

;

 MkL MOVAE
                mov     RA,RE
                Next

;

 MkL MOVAH
                mov     RA,RH
                Next

;

 MkL MOVAL
                mov     RA,RL
                Next

;

 MkL MOVAM
                mov     RA,RM
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_DADx              procedury obsluhujici soucet typu DAD r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL DADB
                ror     RF,1                    ;pripravit pro prepis CF
                add     RHL,RBC                 ;soucet
                rcl     RF,1                    ;zapsat CF
                Next

;

 MkL DADD
                ror     RF,1                    ;pripravit pro prepis CF
                add     RHL,RDE                 ;soucet
                rcl     RF,1                    ;zapsat CF
                Next

;

 MkL DADH
                ror     RF,1                    ;pripravit pro prepis CF
                add     RHL,RHL                 ;soucet
                rcl     RF,1                    ;zapsat CF
                Next

;

 MkL DADSP
                ror     RF,1                    ;pripravit pro prepis CF
                add     RHL,RSP                 ;soucet
                rcl     RF,1                    ;zapsat CF
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_ADDx              procedury obsluhujici soucet typu ADD r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL ADDB
                add     RA,RB
                lahf
                Next

;

 MkL ADDC
                add     RA,RC
                lahf
                Next

;

 MkL ADDD
                add     RA,RD
                lahf
                Next

;

 MkL ADDE
                add     RA,RE
                lahf
                Next

;

 MkL ADDH
                add     RA,RH
                lahf
                Next

;

 MkL ADDL
                add     RA,RL
                lahf
                Next

;

 MkL ADDM
                add     RA,RM
                lahf
                Next

;

 MkL ADDA
                add     RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_ADCx              procedury obsluhujici soucet typu ADC r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL ADCB
                sahf
                adc     RA,RB
                lahf
                Next

;

 MkL ADCC
                sahf
                adc     RA,RC
                lahf
                Next

;

 MkL ADCD
                sahf
                adc     RA,RD
                lahf
                Next

;

 MkL ADCE
                sahf
                adc     RA,RE
                lahf
                Next

;

 MkL ADCH
                sahf
                adc     RA,RH
                lahf
                Next

;

 MkL ADCL
                sahf
                adc     RA,RL
                lahf
                Next

;

 MkL ADCM
                sahf
                adc     RA,RM
                lahf
                Next

;

 MkL ADCA
                sahf
                adc     RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_SUBx              procedury obsluhujici soucet typu SUB r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL SUBB
                sub     RA,RB
                lahf
                Next

;

 MkL SUBC
                sub     RA,RC
                lahf
                Next

;

 MkL SUBD
                sub     RA,RD
                lahf
                Next

;

 MkL SUBE
                sub     RA,RE
                lahf
                Next

;

 MkL SUBH
                sub     RA,RH
                lahf
                Next

;

 MkL SUBL
                sub     RA,RL
                lahf
                Next

;

 MkL SUBM
                sub     RA,RM
                lahf
                Next

;

 MkL SUBA
                sub     RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_SBBx              procedury obsluhujici soucet typu SBB r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL SBBB
                sahf
                sbb     RA,RB                   ;pridat parametr
                lahf
                Next

;

 MkL SBBC
                sahf
                sbb     RA,RC                   ;pridat parametr
                lahf
                Next

;

 MkL SBBD
                sahf
                sbb     RA,RD                   ;pridat parametr
                lahf
                Next

;

 MkL SBBE
                sahf
                sbb     RA,RE                   ;pridat parametr
                lahf
                Next

;

 MkL SBBH
                sahf
                sbb     RA,RH                   ;pridat parametr
                lahf
                Next

;

 MkL SBBL
                sahf
                sbb     RA,RL                   ;pridat parametr
                lahf
                Next

;

 MkL SBBM
                sahf
                sbb     RA,RM                   ;pridat parametr
                lahf
                Next

;

 MkL SBBA
                sahf
                sbb     RA,RA                   ;pridat parametr
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_ANAx              procedury obsluhujici soucin typu ANA r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL ANAB
                and     RA,RB
                lahf
                Next

;

 MkL ANAC
                and     RA,RC
                lahf
                Next

;

 MkL ANAD
                and     RA,RD
                lahf
                Next

;

 MkL ANAE
                and     RA,RE
                lahf
                Next

;

 MkL ANAH
                and     RA,RH
                lahf
                Next

;

 MkL ANAL
                and     RA,RL
                lahf
                Next

;

 MkL ANAM
                and     RA,RM
                lahf
                Next

;

 MkL ANAA
                and     RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_XRAx              procedury obsluhujici soucet typu XRA r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL XRAB
                xor     RA,RB
                lahf
                Next

;

 MkL XRAC
                xor     RA,RC
                lahf
                Next

;

 MkL XRAD
                xor     RA,RD
                lahf
                Next

;

 MkL XRAE
                xor     RA,RE
                lahf
                Next

;

 MkL XRAH
                xor     RA,RH
                lahf
                Next

;

 MkL XRAL
                xor     RA,RL
                lahf
                Next

;

 MkL XRAM
                xor     RA,RM
                lahf
                Next

;

 MkL XRAA
                xor     RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_ORAx              procedury obsluhujici soucet typu ORA r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL ORAB
                or      RA,RB
                lahf
                Next

;

 MkL ORAC
                or      RA,RC
                lahf
                Next

;

 MkL ORAD
                or      RA,RD
                lahf
                Next

;

 MkL ORAE
                or      RA,RE
                lahf
                Next

;

 MkL ORAH
                or      RA,RH
                lahf
                Next

;

 MkL ORAL
                or      RA,RL
                lahf
                Next

;

 MkL ORAM
                or      RA,RM
                lahf
                Next

;

 MkL ORAA
                or      RA,RA
                lahf
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_CMPx              procedury obsluhujici rozdil typu CMP r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL CMPB
                cmp     RA,RB
                lahf                    ;nastavit RF
                Next

;

 MkL CMPC
                cmp     RA,RC
                lahf                    ;nastavit RF
                Next

;

 MkL CMPD
                cmp     RA,RD
                lahf                    ;nastavit RF
                Next

;

 MkL CMPE
                cmp     RA,RE
                lahf                    ;nastavit RF
                Next

;

 MkL CMPH
                cmp     RA,RH
                lahf                    ;nastavit RF
                Next

;

 MkL CMPL
                cmp     RA,RL
                lahf                    ;nastavit RF
                Next

;

 MkL CMPM
                cmp     RA,RM
                lahf                    ;nastavit RF
                Next

;

 MkL CMPA
                cmp     RA,RA
                lahf                    ;nastavit RF
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_POPx              procedury obsluhujici presun typu POP r                ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL POPB
                mov     RBC,ds:[RSP]
                add     RSP,2                   ;posunout pointer
                Next

;

 MkL POPD
                mov     RDE,ds:[RSP]
                add     RSP,2                   ;posunout pointer
                Next

;

 MkL POPH
                mov     RHL,ds:[RSP]
                add     RSP,2                   ;posunout pointer
                Next

;

 MkL POPPSW
                mov     RPSW,ds:[RSP]
                xchg    RA,RF                   ;do spravneho poradi
                add     RSP,2                   ;posunout pointer
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_PUSHx             procedury obsluhujici presun typu PUSH r               ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL PUSHB
                sub     RSP,2
                mov     ds:[RSP],RBC
                DispW   RSP

;

 MkL PUSHD
                sub     RSP,2
                mov     ds:[RSP],RDE
                DispW   RSP

;

 MkL PUSHH
                sub     RSP,2
                mov     ds:[RSP],RHL
                DispW   RSP

;

 MkL PUSHPSW
                sub     RSP,2
                xchg    RA,RF                   ;do spravneho poradi
                mov     ds:[RSP],RPSW
                xchg    RA,RF
                DispW   RSP

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxIx              procedury obsluhujici operace typu xxI r               ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL ADI
                add     RA,ds:[RPC]             ;parametr
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;

 MkL ACI
                sahf
                adc     RA,ds:[RPC]             ;parametr
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;

 MkL SUI
                sub     RA,ds:[RPC]
                lahf
                inc     RPC
                Next

;

 MkL SBI
                sahf
                sbb     RA,ds:[RPC]
                lahf
                inc     RPC
                Next

;

 MkL ANI
                and     RA,ds:[RPC]             ;parametr
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;

 MkL ORI
                or      RA,ds:[RPC]             ;parametr
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;

 MkL XRI
                xor     RA,ds:[RPC]             ;parametr
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;

 MkL CPI
                cmp     RA,ds:[RPC]
                lahf                            ;obnovit flagy
                inc     RPC
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxxx              ostatni operace s pameti (STAX,SHLD,STA,LDAX,LHLD,LDA) ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL STAXB
                mov     si,RBC                  ;do adresovatelneho
                mov     ds:[si],RA               ;registru
                DispB   SI,RA

;

 MkL STAXD
                mov     si,RDE                  ;do adresovatelneho
                mov     ds:[si],RA               ;registru
                DispB   SI,RA

;

 MkL LDAXB
                mov     si,RBC                  ;do adresovatelneho
                mov     RA,ds:[si]               ;registru
                Next

;

 MkL LDAXD
                mov     si,RDE                  ;do adresovatelneho
                mov     RA,ds:[si]               ;registru
                Next

;

 MkL STA
                mov     si,ds:[RPC]             ;parametr
                mov     ds:[si],RA
                add     RPC,2
                DispB   SI,RA

;

 MkL LDA
                mov     si,ds:[RPC]             ;parametr
                mov     RA,ds:[si]
                add     RPC,2
                Next

;

 MkL SHLD
                mov     si,ds:[RPC]             ;parametr
                mov     ds:[si],RHL
                add     RPC,2
                DispW   SI

;

 MkL LHLD
                mov     si,ds:[RPC]             ;parametr
                mov     RHL,ds:[si]
                add     RPC,2
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxxx              ostatni registrove operace (rotace,DAA,STC,CMA,CMC)    ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL RLC
                sahf
                rol     RA,1
                lahf
                Next

;

 MkL RRC
                sahf
                ror     RA,1
                lahf
                Next

;

 MkL RAL
                sahf
                rcl     RA,1
                lahf
                Next

;

 MkL RAR
                sahf
                rcr     RA,1
                lahf
                Next

;

 MkL DAA
                sahf
                daa
                lahf
                Next

;

 MkL CMA
                not     RA
                Next

;

 MkL STC
                or      RF,1                    ;CF = 1
                Next

;

 MkL CMC
                xor     RF,1                    ;not(CF)
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxHL              operace s adresaci pres HL (XTHL,PCHL,SPHL,XCHG)       ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL XTHL
                mov     si,[ds:RSP]             ;Segment Override Handler
                mov     [ds:RSP],RHL             ;neosetruje instrukci XCHG,
                mov     RHL,si                    ;proto se musi presouvat
                DispW   RSP                        ;pomoci MOV

;

 MkL PCHL
                mov     RPC,RHL
                Next

;

 MkL SPHL
                mov     RSP,RHL
                Next

;

 MkL XCHG
                xchg    RDE,RHL
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxxx              operace s porty (IN,OUT)                               ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;

 MkL IN
                mov     si,ds:[RPC]             ;adresa portu
                and     si,0FFh                 ;najit prislusnou rutinu
                shl     si,1
                inc     RPC                     ;na dalsi instrukci
                ife     CB_NextFlg
                  jmp     cs:FWX_Tbl_IN[si]     ;vykonat rutinu
                else
                  jmp     cs:FW_Tbl_IN[si]
                endif

;

 MkL IN_1E
                mov     RA,[cs:VB_MgIn_Dat]     ;data z USARTu
                mov     [cs:VB_MgIn_Flg],0      ;oznacit precteni
                Next

;

 MkL IN_1F
                call    PN_Stat_MGF             ;stav USARTu do AL=RA
                Next                            ;frcet

;

 MkL IN_4C
                mov     RA,cs:VB_Joy_State1     ;stav joysticku
                and     RA,cs:VB_Joy_State2      ;se sklada ze trech
                and     RA,cs:VB_Joy_State3       ;masek
                Next

;

 MkL IN_7C
                test    cs:VW_PRN_Adr,-1        ;je LPT ?
                ife     CB_NextFlg
                  jz      LNX_NoIN              ;ne => dal
                else
                  jz      LN_NoIN
                endif

                push    dx
                mov     dx,cs:VW_PRN_Adr        ;LPT1 Data
                in      RA,dx
                pop     dx
                Next

;

 MkL IN_7D
                test    cs:VW_PRN_Adr,-1        ;je LPT1 ?
                ife     CB_NextFlg
                  jz      LNX_NoIN              ;ne => dal
                else
                  jz      LN_NoIN
                endif

                push    dx
                mov     dx,cs:VW_PRN_Adr        ;LPT1 Status
                inc     dx
                in      RA,dx
                pop     dx
                Next

;

 MkL IN_7E
                test    cs:VW_PRN_Adr,-1        ;je LPT1 ?
                ife     CB_NextFlg
                  jz      LNX_NoIN              ;ne => dal
                else
                  jz      LN_NoIN
                endif

                push    dx
                mov     dx,cs:VW_PRN_Adr        ;LPT1 Ctrl
                add     dx,2
                in      RA,dx
                pop     dx
                Next

;

 MkL NoIN
                mov     RA,-1                   ;definovat prazdne porty
                Next

;

 MkL IN_F4
                mov     RA,cs:VB_Port_F4        ;hodnota
                Next

;

 MkL IN_F5
                mov     si,word ptr cs:VB_Port_F4
                and     si,0Fh                  ;izolovat sloupce
                mov     RA,cs:FB_Key_Cols[si]   ;prislusna hodnota
                and     RA,cs:VB_Key_Shift      ;pridat Shift a Stop
                Next

;

 MkL IN_F6
                mov     RA,cs:VB_Port_F6        ;hodnota
                Next

;

 MkL OUT
                mov     si,ds:[RPC]             ;adresa portu
                and     si,0FFh                 ;najit prislusnou rutinu
                shl     si,1
                inc     RPC                     ;na dalsi instrukci
                ife     CB_NextFlg
                  jmp     cs:FWX_Tbl_OUT[si]    ;vykonat rutinu
                else
                  jmp     cs:FW_Tbl_OUT[si]
                endif

;

 MkL NoOUT
                Next

;

 MkL OUT_1E
                call    PN_Save_MGF             ;ulozit data
                Next

;

 MkL OUT_7C
                push    dx
                mov     dx,cs:VW_PRN_Adr        ;LPT1 Ctrl
                or      dx,dx                   ;je LPT1 ?

                ife     CB_NextFlg
                  jz      LNX_OUT_7C_NoP        ;ne => dal
                else
                  jz      LN_OUT_7C_NoP
                endif

                out     dx,RA

 MkL OUT_7C_NoP
                pop     dx
                Next

;

 MkL OUT_7E
                push    dx
                mov     dx,cs:VW_PRN_Adr        ;LPT Ctrl
                or      dx,dx                   ;je LPT ?

                ife     CB_NextFlg
                  jz      LNX_OUT_7E_NoP        ;ne => dal
                else
                  jz      LN_OUT_7E_NoP
                endif

                add     dx,2
                push    ax
                and     RA,0Fh
                out     dx,RA
                pop     ax

 MkL OUT_7E_NoP
                pop     dx
                Next

;

 MkL OUT_F4
                mov     cs:VB_Port_F4,RA        ;zapsat hodnotu portu
                Next

;

 MkL OUT_F6
                mov     cs:VB_Port_F6,RA        ;schovat hodnotu

 MkL OUT_F7_Cnt
                test    cs:VB_Sound_Flg,-1      ;delat zvuk ?
                ife     CB_NextFlg
                  jz      LNX_OUT_F6_NoS        ;ne => dal
                else
                  jz      LN_OUT_F6_NoS
                endif

                push    ax

                mov     si,ax
                and     si,7                    ;izolovat bity pro sluchatko

                cli
                mov     al,0B6h
                out     43h,al                  ;CNT 2 jako delicka
                in      al,61h
                and     al,not 3
                or      al,cs:FB_Tbl_S61[si]    ;hodnota portu 61h (bity 0,1)
                out     61h,al
                mov     al,cs:FB_Tbl_L42[si]    ;nastaveni delicky
                out     42h,al
                mov     al,cs:FB_Tbl_H42[si]
                out     42h,al
                sti

                pop     ax

 MkL OUT_F6_NoS
                test    cs:VB_LED_Flg,-1        ;delat LED ?
                ife     CB_NextFlg
                  jz      LNX_OUT_F6_NoL        ;ne => dal
                else
                  jz      LN_OUT_F6_NoL
                endif

                push    ax
                push    cx

                mov     ah,0EDh                 ;Set Kbd LED
                call    PN_Keybd_Cmd
                mov     ah,cs:VB_Port_F6        ;hodnota portu
                shr     ah,1
                shr     ah,1                    ;izolovat stav LED
                and     ah,3
                call    PN_Keybd_Cmd

                pop     cx
                pop     ax

 MkL OUT_F6_NoL
                Next

;

 MkL OUT_F7
                or      RA,RA                   ;testnout ridici slovo
                ife     CB_NextFlg
                  js      LNX_OUT_F7_NoC        ;programuje rezimy => ven
                else
                  js      LN_OUT_F7_NoC
                endif

                mov     si,cx                   ;schovat CX

                mov     cl,al                   ;vyrobit posunutou jednicku
                and     cl,0Eh
                shr     cl,1                    ;v CL cislo nastavovaneho bitu
                mov     ch,1
                shl     ch,cl                   ;v CH log. 1 na pozici bitu

                test    RA,1                    ;bude se nastavovat do 1 ?
                ife     CB_NextFlg
                  jz      LNX_OUT_F7_Clr        ;ne => nastavit do 0
                else
                  jz      LN_OUT_F7_Clr
                endif

                or      cs:VB_Port_F6,ch        ;nastavit dany bit portu do 1
                mov     cx,si                   ;obnovit CX

                ife     CB_NextFlg
                  jmp     LNX_OUT_F7_Cnt  ;pokracovat na OUT F6
                else
                  jmp     LN_OUT_F7_Cnt
                endif


 MkL OUT_F7_Clr
                neg     ch                      ;predelat jednicku na masku
                and     cs:VB_Port_F6,ch        ;nastavit dany bit portu do 0
                mov     cx,si                   ;obnovit CX
                ife     CB_NextFlg
                  jmp     LNX_OUT_F7_Cnt        ;pokracovat na OUT F6
                else
                  jmp     LN_OUT_F7_Cnt
                endif


 MkL OUT_F7_NoC
                Next

;
;╔═════════════════════════════════════════════════════════════════════════════╗
;║ LN_xxxx              NOP a HLT                                              ║
;╚═════════════════════════════════════════════════════════════════════════════╝
;
 MkL NOP
                Next                            ;nic nedelat

;

 MkL HLT
                dec     RPC                     ;na kod HLT

                mov     cs:VW_Step_Adr,offset LN_Dbg_Err        ;chybova rutina
                mov     cs:VW_Err_Msg,offset FB_HLT_Msg         ;hlaska

                ret                             ;ukoncit simulaci

;
;;;
;;;;;
;;;
;

                JUMPS

