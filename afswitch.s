		SECTION AFSWITCH,CODE

		movem.l	d1-d7/a1-a6,-(a7)
		bset	#5,(a0)			; Argument in Kleinuchstaben ändern
		cmpi.b	#"e",(a0)		; Argument="e": Filter/LED an
		beq.b	ENABL
		cmpi.b	#"d",(a0)		; Argument="d": Filter/LED aus
		beq.b	DISABL
		cmpi.b	#"s",(a0)		; Argument="s": Filter/LED umschalten
		beq.b	SWITCH
		cmpi.b	#"h",(a0)		; Argument="h": Help-Text anzeigen
		beq.b	HELP
		cmpi.b	#"?",(a0)		; Argument="?": Help-Text anzeigen
		beq.b	HELP
		btst	#1,$bfe001		; Audiofilter an?
		beq.b	CLEAN			; wenn ja, Ende
		moveq	#5,d0			; sonst Exit mit Returncode 5
		bra.b	EXIT			; falsches oder gar kein Argument: Ende

ENABL:	bclr	#1,$bfe001		; löscht Bit 1 von $BFE001 -> Filter an
		bra.b	CLEAN

DISABL:	bset	#1,$bfe001		; setzt Bit 1 von $BFE001 -> Filter aus
		bra.b	CLEAN

SWITCH:	bchg	#1,$bfe001		; ändert Bit 1 von $BFE001

CLEAN:	moveq	#0,d0
EXIT:	movem.l	(a7)+,d1-d7/a1-a6
		rts

HELP:	move.l	4.w,a6			; Adresse der Execbase in A6
		cmpi.w	#$1f,$14(a6)	; exec.library < V.31 (Kick1.1)?
		bmi.b	CLEAN			; wenn ja, Ende
		lea		LNAME(PC),a1	; A1 zeigt auf LibName
		moveq	#0,d0			; DOS-Version nicht prüfen
		jsr		-$228(a6)		; OpenLibrary (dos.library öffnen)
		move.l	d0,d4			; DOS-Base in D4 sichern
		movea.l	d4,a5			; ...und in A5
		jsr		-$3c(a5)		; LVOOutput (hole Standart-Output)
		move.l	d0,d1			; sichere dessen Adresse in D1
		lea		MSG+5(PC),a0
		move.l	a0,d2			; Help-Text in D2 sichern
		move.l	#LNAME-MSG-5,d3	; Größe des Text-Puffers in D3
		jsr		-$30(a5)		; LVOWrite (schreibe in Standart-Output)
		movea.l	d4,a1			; DOS-Base in A1
		jsr		-$19e(a6)		; CloseLibrary (schließe dos.library)
		bra.b	CLEAN

MSG:	dc.b	"$VER:AFSwitch 1.6 - switches audio filter (11.01.2026) © P.Düren",10,10
		dc.b	"Options are:	E	Enable filter",10
		dc.b	"				D	Disable filter",10
		dc.b	"				S	Switch current state",10
		dc.b	"				H or ?	this text... obviously",10
		dc.b	"Without argument AFS will exit with code 5 (WARN) if filter is off.",10,10
LNAME:	dc.b	"dos.library",0


;--- Testskript zum Abfragen des Returncodes: -------------------------------
;
;echo "Audio filter is " NOLINE
;afs
;if WARN
;	echo "off."
;else
;	echo "on."
;endif
;
;----------------------------------------------------------------------------
