playBufferBarbeuk:
	LDA substate
	CMP #INITIALIZE
	BEQ loadInit
	JMP noBactchInit


;START INITIALIZE
loadInit:
	JSR disableNmi
	
	LDA #$23
	STA arg1
	LDA #$08
	STA arg2
	JSR loadbarbeuk
	
	;palette attributes
	LDX #$00
	LDA PPUSTATUS         ; read PPU status to reset the high/low latch
	LDA #$23
	STA PPUADDR             ; write the high byte of $2000 address
	LDA #$C8
	STA PPUADDR             ; write the low byte of $2000 address
.attributeLoop:
	LDA #%01010101
	STA PPUDATA
	INX
	CPX #$08
	BNE .attributeLoop	
	
	LDX #$00
	LDA PPUSTATUS         ; read PPU status to reset the high/low latch
	LDA #$23
	STA PPUADDR             ; write the high byte of $2000 address
	LDA #$F0
	STA PPUADDR             ; write the low byte of $2000 address
.attributeLoop2:
	LDA #%01010101
	STA PPUDATA
	INX
	CPX #$10
	BNE .attributeLoop2	
	
	LDA #HIGH(ADRBLOBUFF1)
	STA pointerBCurrHi
	LDA #LOW(ADRBLOBUFF1)
	STA pointerBCurrLo
	
	LDA #HIGH(ADRBLOBUFF2)
	STA pointerBLastHi
	LDA #LOW(ADRBLOBUFF2)
	STA pointerBLastLo
	
	; LDX #$01
	; LDY #$03
	; JSR placeBlob
	
	LDA #$00
	STA frame
	STA tilePFrame
	STA timeframe
	STA textpos
	
	LDA #$11
	STA	texttics
	
	LDA #$00
	STA PosX
	STA PosY
	
	LDA #$80
	STA textwait
	
	LDA #NORM
	STA substate
	
	;initialize seed
	LDA #$13
	STA r_seed
	
	ldx #LOW(weAreNumber2_3_music_data)	;initialize using the first song data, as it contains the DPCM sound effect
	ldy #HIGH(weAreNumber2_3_music_data)
	lda #$00					;PAL mode
	jsr FamiToneInit			;init FamiTone
		
	LDA #$08
	STA cameraY
	
	JSR enableNmi
	

	
	 LDA #0
	 JSR FamiToneMusicPlay
	
	JMP GameEngineDone
;END INITIALIZE

noBactchInit:
	INC timeframe
	;JSR frameBuffSlct
	
	CLC
	LDA PosX	;PosX est le flag de fin de traitement de la frame
	CMP #$00
	BEQ .frameUpdate 
	JMP .noFrameUpdate
.frameUpdate:
	
	JSR copyBuffer
	;JSR copyAndDecBuffer
	
	JSR frameBuffSlct
	
	LDA timeframe
	STA $42
	
	;JSR printText
	

	; CLC
	; LDA frame
	; TAX
	; LDA (sinTable),x
	; AND #%11100000
	; ROR A
	; ROR A
	; ROR A
	; ROR A
	; ROR A
	; TAX
	; LDY #$03
	; JSR placeBlob
	
	; CLC
	; LDA frame
	; AND #%00111111
	; ROL A
	; ROL A
	; TAX
	; LDA (sinTable),x
	; AND #%11100000
	; ROR A
	; ROR A
	; ROR A
	; ROR A
	; ROR A
	
	; TAX
	; TAY
	; JSR placeBlob
	
	LDA pointerBCurrHi
	STA pointer1Hi
	LDA pointerBCurrLo
	STA pointer1Lo
	
;	LDY #$00
;.fillloop:
;	LDA frame
;	;LDA #$04
;	AND #%00000111
;	STA [pointer1Lo],y
;	INY
;	CPY #$00
;	BNE .fillloop

	JSR fireBuffer

;	CLC
;	LDA frame
;	AND #%00011110
;	ROR A
;	CLC
;	ADC #$F0
;	TAY
;	LDA #$0F
;	STA [pointer1Lo],y
;	CPY  #$F0
;	BEQ .isfirst
;	DEY
;	JMP .isnotfirst
;.isfirst:
;	LDY #$FF
;.isnotfirst:
;	LDA #$00
;	STA [pointer1Lo],y

;	LDY #$F0
;.clearloop:
;	LDA #$00
;	STA [pointer1Lo],y
;	INY
;	CPY #$00
;	BNE .clearloop

;	LDX frame
;	LDA (sinTable),x
;	AND #%11110000
;	ROR A
;	ROR A
;	ROR A
;	ROR A
;	CLC
;	ADC #$E0
;	TAY
;	LDA #$0F
;	STA [pointer1Lo],y
	
	;LDA frame
	JSR rand_8
	STA temp
	LDY #$F1
.braiseloop:
	LDA temp
	AND #%00000001
	CMP #$00
	BEQ .noFlame
	LDA #$0F
	JMP .isFlame
.noFlame:
	LDA #$04
.isFlame:
	STA	[pointer1Lo],y
	CLC
	ROR temp
	INY
	CPY #$F8
	BNE .braiseloop
	
	JSR rand_8
	STA temp
	LDY #$F8
.braiseloop2:
	LDA temp
	AND #%00000001
	CMP #$00
	BEQ .noFlame2
	LDA #$0F
	JMP .isFlame2
.noFlame2:
	LDA #$04
.isFlame2:
	STA	[pointer1Lo],y
	CLC
	ROR temp
	INY
	CPY #$FF
	BNE .braiseloop2


;	LDA #$00
;	STA temp
;	LDY #$00
;.fillSinLoop:
;	;TYA
;	;CLC
;	;ADC frame
;	;TAX
;	LDX temp
;	LDA (sinTable),x
;	AND #%11110000
;	ROR A
;	ROR A
;	ROR A
;	ROR A
;	;ROR A
;	AND #%00000111
;	STA [pointer1Lo],y
;	
;	INY
;	TYA
;	AND	#%00001111
;	CMP #$00
;	BNE .dontaddy
;	INC temp
;.dontaddy:
;	CPY #$00
;	BNE .fillSinLoop

;	LDY #$00
;.fillloop:
;	TYA
;	;LDA $40
;	CLC
;	ADC frame
;	AND #%00000111
;	STA [pointer1Lo],y
;	INY
;	CPY #$00
;	BNE .fillloop

;	LDY frame
;	LDA #$08
;	STA [pointer1Lo],y
;	DEY
;	LDA #$00
;	STA [pointer1Lo],y
	
	CLC
	INC frame
	LDA #$00
	STA timeframe
.noFrameUpdate:
	
	; JSR oneTulePerFrame
	; JSR allNotVoid
	JSR drawDiff
	JSR printText
	
;	LDA PosX
;	CMP #$00
;	BNE .notFrameFinished
;	
;	JSR copyBuffer
;	;JSR copyAndDecBuffer
;	CLC
;	INC frame
;.notFrameFinished:
	
	jsr FamiToneUpdate  
	
	JMP GameEngineDone
	
; --- FUNCTIONS ---

;---	
oneTulePerFrame:
	;get tile to update
	LDA time
	TAX
	LDA ADRBLOBUFF1,x
	STA temp
	
	;get x/y of the tile
	CLC
	LDA time
	AND #%00001111
	TAX
	LDA time
	AND #%11110000
	ROR A
	ROR A
	ROR A
	ROR A
	TAY
	

	JSR setPPUADDR
	
	; add tule to PPU buffer
	LDX pointerBufferW
	LDA #$01	; 1 tule à la fois
	STA PPUBUFFERW, x
	TAY
	INX
	LDA pointerPPUHi
	STA PPUBUFFERW, x
	INX
	LDA pointerPPULo
	STA PPUBUFFERW, x
	INX
blobTestLoop:
	LDA temp	; tule to print
	STA PPUBUFFERW, x
	INX
	DEY
	CPY #$00
	BNE blobTestLoop
	STX pointerBufferW	
	
	RTS
	
;---	
allNotVoid:
	LDX #$FF
allNotVoidLoop:
	INX
	CPX #$FF
	BEQ endAllNotVoid
	LDA ADRBLOBUFF1,x
	CMP #$00
	BEQ allNotVoidLoop
	STA temp1
	
	CLC
	TXA
	STA temp		;save X in temp
	AND #%00001111
	TAX
	LDA temp
	AND #%11110000
	ROR A
	ROR A
	ROR A
	ROR A
	TAY
	
	JSR setPPUADDR
	
	;comptage du nombre de tules non vides
	LDY #$00
	LDX temp
.tuleCounterLoop:
	LDA ADRBLOBUFF1,x
	INY
	INX
	CMP #$00
	BNE .tuleCounterLoop
	
	LDX pointerBufferW
	; LDA #$01	; 1 tule à la fois
	TYA
	STA PPUBUFFERW, x
	INX
	LDA pointerPPUHi
	STA PPUBUFFERW, x
	INX
	LDA pointerPPULo
	STA PPUBUFFERW, x
	INX
	
	LDY temp
.tuleReaderLoop:
	LDA ADRBLOBUFF1,y
	STA PPUBUFFERW, x
	INX
	INY
	CMP #$00
	BNE .tuleReaderLoop
	STX pointerBufferW
	
	; TAX
	; LDA ADRBLOBUFF1,x ; tule to print
	; STA PPUBUFFERW, x
; .allNotVoidTestLoop:
	; LDA temp1	; tule to print
	; STA PPUBUFFERW, x
	; INX
	; DEY
	; CPY #$00
	; BNE .allNotVoidTestLoop
	; STX pointerBufferW	
	
	; LDA temp
	TYA
	TAX
	JMP allNotVoidLoop
	
endAllNotVoid:
	RTS
	
;---	
drawDiff:
	LDA #$00
	STA tilePFrame	;init tilePFrame
	
	;LDX #$FF
	LDX PosX	;charge en X la première position à traiter
	STX temp
.drawDiffLoop:
	
	;STX temp	;met X em temporaire
	;INX
	; CPX #$00
	; BEQ .endDrawDiffByBuff
	
	LDY temp	;load tempoarire en Y

	LDA [pointerBCurrLo],y	;Compare pointerBCurrLo et pointerBLastLo
	CMP [pointerBLastLo],y
	BNE .printThis			;si différent, on print
	;BEQ .drawDiffLoop
	
	INX						;incrémente X
	STX temp				;met X em temporaire
	CPX #$00				
	;BEQ .endDrawDiffByBuff	;si X = 0 on arrète de traiter
	BNE .drawDiffLoop
	JMP .endDrawDiffByBuff
	;JMP .drawDiffLoop		;sinon on traite suivant
	
.printThis						;on print

	;LDA #BLOBMAXTILE
	;SEC
	;SBC tilePFrame
	LDA #$20
	STA temp2
	
	LDX #$01 					; init de X		
	INY
.tuleDiffCounterLoop:	
	CPX temp2
	BEQ .stopTuleDiffCounterLoop	
	;INX							;on incrémente X
	;INY							;on incrémente Y
	;si nouvelle ligne, refaire un message (utile si largeur buffer != largeur écran)
	TYA
	AND #%00001111
	CMP #$00
	BEQ .stopTuleDiffCounterLoop
	
	LDA [pointerBCurrLo],y
	CMP [pointerBLastLo],y
	BEQ .stopTuleDiffCounterLoop
	INX							;on incrémente X
	INY							;on incrémente Y
	;BNE .tuleDiffCounterLoop
	JMP .tuleDiffCounterLoop
.stopTuleDiffCounterLoop:
	STX counter					; counter : nb de tuiles à update à la suite
	TXA
	STA $43
	
	;CLC
	;ADC tilePFrame
	;CMP #BLOBMAXTILE
	;BCS .endDrawDiff
	
	; set la position du message
	CLC
	LDA temp
	AND #%00001111
	ADC #$08	; center the frame
	TAX
	LDA temp
	AND #%11110000
	ROR A
	ROR A
	ROR A
	ROR A
	CLC			; center the frame
	ADC #$08	; center the frame
	TAY
	;
	JSR setPPUADDR
	;set la longueur du message
	LDX pointerBufferW
	LDA counter	
	STA PPUBUFFERW, x
	INX
	LDA pointerPPUHi
	STA PPUBUFFERW, x
	INX
	LDA pointerPPULo
	STA PPUBUFFERW, x
	INX
	
	INC tilePFrame
	INC tilePFrame
	INC tilePFrame
	INC tilePFrame
	
	LDY temp
.tuleDiffReaderLoop:	
	LDA [pointerBCurrLo],y
	STA PPUBUFFERW, x
	INY
	INX
	INC tilePFrame
	DEC counter
	;INC temp			; test
	LDA counter
	CMP #$00
	BNE .tuleDiffReaderLoop
	STX pointerBufferW
	STY temp
	
	TYA
	TAX
	
	CPX #$00
	BEQ .endDrawDiffByBuff
	CLC
	LDA tilePFrame
	CMP #BLOBMAXTILE
	BCS .endDrawDiff
	
	JMP .drawDiffLoop
.endDrawDiffByBuff:


.endDrawDiff:
	;Save position in buffer in PosX
	LDA temp
	STA PosX
	STA $41
	STA $05F0
	LDA tilePFrame
	STA $40
	RTS
	
	
copyBuffer:
	LDY #$00
.copyBufferLoop1:
	LDA [pointerBCurrLo],y
	STA [pointerBLastLo],y
	INY
	CPY #$00
	BNE .copyBufferLoop1
	RTS
	
;---
; copy and decrese
; current buffer to last one
copyAndDecMinusBuffer:
	LDY #$00
.copyBufferLoop:
	LDA frame
	AND #%00000001
	CMP #$00
	BNE .1
	LDA [pointerBCurrLo],y
	; SEC
	; SBC #BLOBDEC
	; BCC .setToZero
	; JMP .setDecValue
; .setToZero:
	; LDA #$00
; .setDecValue:

	CLC
	ROR A
	JMP .2
.1:
	;LDA #$00
	LDA [pointerBCurrLo],y
.2:
	STA [pointerBLastLo],y
	INY
	CPY #$00
	BNE .copyBufferLoop
	RTS
	
copyAndDecBuffer:
	LDY #$00
.copyBufferLoop:
	LDA [pointerBCurrLo],y
	; SEC
	; SBC #BLOBDEC
	; BCC .setToZero
	; JMP .setDecValue
; .setToZero:
	; LDA #$00
; .setDecValue:

	CLC
	ROR A
	CLC
	ROR A
	;LDA #$00
	STA [pointerBLastLo],y
	INY
	CPY #$00
	BNE .copyBufferLoop
	RTS
	
fireBuffer:
	;LDY #$00
	LDX #$00
	; il va y avoir un bug sur les bord mais on verra + tard.
.fireBufferLoop:
	LDA #$00
	STA temp
	TXA
	CLC
	ADC	#$0F
	TAY
	LDA [pointerBCurrLo],y
	CLC
	ROR A
	CLC
	ROR A
	CLC
	ADC temp
	STA temp
	INY
	LDA [pointerBCurrLo],y
	CLC
	ROR A
	CLC
	ADC temp
	STA temp
	INY
	LDA [pointerBCurrLo],y
	CLC
	ROR A
	CLC
	ROR A
	CLC
	ADC temp
	STA temp
	TXA
	TAY
	LDA temp	
	STA [pointerBCurrLo],y
	INX
	CPX #$F0
	BNE .fireBufferLoop
	RTS
	
;---
;flip buffer eatch frame
frameBuffSlct:
	LDA frame
	AND #%00000001
	CMP #$00
	BEQ .isOdd
	LDA #HIGH(ADRBLOBUFF2)
	STA pointerBCurrHi
	LDA #LOW(ADRBLOBUFF2)
	STA pointerBCurrLo
	
	LDA #HIGH(ADRBLOBUFF1)
	STA pointerBLastHi
	LDA #LOW(ADRBLOBUFF1)
	STA pointerBLastLo
	JMP .endFrameBuffSlct
	
.isOdd:
	LDA #HIGH(ADRBLOBUFF1)
	STA pointerBCurrHi
	LDA #LOW(ADRBLOBUFF1)
	STA pointerBCurrLo
	
	LDA #HIGH(ADRBLOBUFF2)
	STA pointerBLastHi
	LDA #LOW(ADRBLOBUFF2)
	STA pointerBLastLo	
.endFrameBuffSlct:
	RTS
	
	
loadbarbeuk:
	LDX #$00
	LDA PPUSTATUS         ; read PPU status to reset the high/low latch
	LDA arg1
	STA PPUADDR             ; write the high byte of $2000 address
	LDA arg2
	STA PPUADDR             ; write the low byte of $2000 address

.barbeukLoop:
	LDA (barbeuk),x
	STA PPUDATA
	INX
	TXA
	AND #%00001111
	CMP #$00
	BNE .dontgapbarbeuk
	;calcul du second argument
	LDA arg2
	CLC
	ADC #$20
	STA arg2
	;calcul du premier argument
	LDA arg1
	ADC #$00	;on ajoute la retenue
	STA arg1
	; write
	LDA PPUSTATUS         ; read PPU status to reset the high/low latch
	LDA arg1
	STA PPUADDR             ; write the high byte of $2000 address
	LDA arg2
	STA PPUADDR 
.dontgapbarbeuk:
	CPX #$60
	BNE .barbeukLoop
	
	RTS
	
printText:

	LDA textwait
	CMP #$00
	BEQ .textdontwait
	DEC textwait
	JMP .notPrintText
.textdontwait:
	
	DEC texttics
	LDA texttics
	CMP #$00
	BNE .notPrintText
	LDX textpos
	LDA (text),x
;	SEC
;	SBC #$20
	STA temp
	STA $50
	
	LDA #$20
	STA pointerPPUHi
	TXA
	AND #%00010000
	CMP #$00
	BNE .secondLine
	TXA
	AND #%00001111
	CLC
	ADC #$A8
	STA pointerPPULo
	JMP .firstLine
.secondLine:
	TXA
	AND #%00001111
	CLC
	ADC #$C8
	STA pointerPPULo
.firstLine:
	
	LDX pointerBufferW
	LDA #$01			;printLong
	STA PPUBUFFERW, x
	INX
	LDA pointerPPUHi
	STA PPUBUFFERW, x
	INX
	LDA pointerPPULo
	STA PPUBUFFERW, x
	INX
	LDA temp
	STA PPUBUFFERW, x
	
	STX pointerBufferW
	
	INC tilePFrame
	INC tilePFrame
	INC tilePFrame
	INC tilePFrame
	
	LDA #$08
	STA	texttics
	INC textpos
	
	LDA textpos
	AND #%00011111
	CMP #$00
	BNE .textdontwait2
	LDA #$80
	STA textwait

.textdontwait2:
	
	;LDA	textpos
	;CMP #$80
	;BNE .notPrintText
	;LDA #$00
	;STA textpos
	
.notPrintText:
	RTS