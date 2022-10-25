
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _isCrossTurn=R5
	.DEF _gameStarter=R4
	.DEF _x=R6
	.DEF _x_msb=R7
	.DEF _y=R8
	.DEF _y_msb=R9
	.DEF _moveNo=R10
	.DEF _moveNo_msb=R11
	.DEF _key=R12
	.DEF _key_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x0

_0x3:
	.DB  0x64,0x64,0x64,0x64,0x64,0x64,0x64,0x64
	.DB  0x64
_0x0:
	.DB  0x55,0x73,0x72,0x3A,0x20,0x25,0x64,0x0
	.DB  0x63,0x6D,0x70,0x3A,0x20,0x25,0x64,0x0
	.DB  0x50,0x6C,0x61,0x79,0x65,0x72,0x20,0x77
	.DB  0x6F,0x6E,0x0,0x43,0x6F,0x6D,0x70,0x75
	.DB  0x74,0x65,0x72,0x20,0x77,0x6F,0x6E,0x0
	.DB  0x44,0x72,0x61,0x77,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _board
	.DW  _0x3*2

	.DW  0x0B
	.DW  _0xD
	.DW  _0x0*2+16

	.DW  0x0D
	.DW  _0xD+11
	.DW  _0x0*2+27

	.DW  0x05
	.DW  _0xD+24
	.DW  _0x0*2+40

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/1/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdio.h>
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;#define INF 100
;#define USER 1
;#define COMPUTER 0
;// Declare your global variables here
;char board[3][3] = {INF, INF, INF, INF, INF, INF, INF, INF, INF};

	.DSEG
;bool isCrossTurn = 1, gameStarter = 1;
;int x, y, moveNo = 1;
;int key, comScore = 0, usrScore = 0;
;
;// functions
;void init();
;void initGame();
;void drawCrossOrCircle(int x, int y, bool isCross);
;char readkey(int *x, int *y);
;void updateBoard(int x, int y, bool isCrossTurn);
;void handup();
;int evaluate(char board[3][3]); // 1 => winner: cross, 0 => winner: circle, -INF => draw, ongoing => INF
;void computerToMove(char board[3][3], int *x, int *y, int moveNo, bool turn);
;
;// utility
;bool moveForWin(int *x, int *y, bool turn);
;bool moveForNotToLose(int *x, int *y, bool turn);
;bool randMove(int *x, int *y);
;void printScoreBoard() {
; 0000 003A void printScoreBoard() {

	.CSEG
_printScoreBoard:
; .FSTART _printScoreBoard
; 0000 003B     char str[16];
; 0000 003C     glcd_line(1, 1, 11, 11);
	SBIW R28,16
;	str -> Y+0
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(11)
	CALL _glcd_line
; 0000 003D     glcd_line(1, 11, 11, 1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _glcd_line
; 0000 003E     glcd_circle(7, 20, 6);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(6)
	CALL _glcd_circle
; 0000 003F 
; 0000 0040     sprintf(str, "Usr: %d", usrScore);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_usrScore
	LDS  R31,_usrScore+1
	CALL SUBOPT_0x0
; 0000 0041     glcd_outtextxy(15, 5, str);
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _glcd_outtextxy
; 0000 0042     sprintf(str, "cmp: %d", comScore);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,8
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_comScore
	LDS  R31,_comScore+1
	CALL SUBOPT_0x0
; 0000 0043     glcd_outtextxy(15, 18, str);
	LDI  R30,LOW(18)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _glcd_outtextxy
; 0000 0044     }
	ADIW R28,16
	RET
; .FEND
;    /*
;    glcd_putcharxy(0, 10, board[0][0] + 48);
;    glcd_putcharxy(0, 20, board[1][0]+ 48);
;    glcd_putcharxy(0, 30, board[2][0]+ 48);
;
;    glcd_putcharxy(15, 10, board[0][1]+ 48);
;    glcd_putcharxy(15, 20, board[1][1]+ 48);
;    glcd_putcharxy(15, 30, board[2][1]+ 48);
;
;    glcd_putcharxy(30, 10, board[0][2]+ 48);
;    glcd_putcharxy(30, 20, board[1][2]+ 48);
;    glcd_putcharxy(30, 30, board[2][2]+ 48);
;    */
;   // glcd_putcharxy(0, 40, key + 48);
;
;void main(void)
; 0000 0055 {
_main:
; .FSTART _main
; 0000 0056 // Declare your local variables here
; 0000 0057     init();
	RCALL _init
; 0000 0058     initGame();
	RCALL _initGame
; 0000 0059     moveNo++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 005A while (1)
_0x4:
; 0000 005B       {
; 0000 005C       // Place your code here
; 0000 005D       if (isCrossTurn == 1) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x7
; 0000 005E             key = readkey(&x, &y); // human turn
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RCALL _readkey
	MOV  R12,R30
	CLR  R13
; 0000 005F         } else {
	RJMP _0x8
_0x7:
; 0000 0060             key = 2; // dumy value
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 0061             computerToMove(board, &x, &y, moveNo, isCrossTurn); // computer turn
	LDI  R30,LOW(_board)
	LDI  R31,HIGH(_board)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	MOV  R26,R5
	RCALL _computerToMove
; 0000 0062         }
_0x8:
; 0000 0063         //key = readkey(&x, &y);
; 0000 0064         if (board[x][y] != INF)
	MOVW R30,R6
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	ADD  R30,R8
	ADC  R31,R9
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BREQ _0x9
; 0000 0065             key = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R12,R30
; 0000 0066 
; 0000 0067         if (key != 100) {
_0x9:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R12
	CPC  R31,R13
	BRNE PC+2
	RJMP _0xA
; 0000 0068             drawCrossOrCircle(x, y, isCrossTurn);
	ST   -Y,R7
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	MOV  R26,R5
	RCALL _drawCrossOrCircle
; 0000 0069             updateBoard(x, y, isCrossTurn);
	ST   -Y,R7
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	MOV  R26,R5
	RCALL _updateBoard
; 0000 006A             key = evaluate(board);
	LDI  R26,LOW(_board)
	LDI  R27,HIGH(_board)
	RCALL _evaluate
	MOVW R12,R30
; 0000 006B 
; 0000 006C             if (key != INF) {
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0xB
; 0000 006D                 //glcd_clear();
; 0000 006E                 if (key == USER) {
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0xC
; 0000 006F                     glcd_outtextxy(1, 50, "Player won");
	CALL SUBOPT_0x1
	__POINTW2MN _0xD,0
	CALL _glcd_outtextxy
; 0000 0070                     usrScore++;
	LDI  R26,LOW(_usrScore)
	LDI  R27,HIGH(_usrScore)
	CALL SUBOPT_0x2
; 0000 0071                 }
; 0000 0072                 else if (key == COMPUTER) {
	RJMP _0xE
_0xC:
	MOV  R0,R12
	OR   R0,R13
	BRNE _0xF
; 0000 0073                     glcd_outtextxy(1, 50, "Computer won");
	CALL SUBOPT_0x1
	__POINTW2MN _0xD,11
	CALL _glcd_outtextxy
; 0000 0074                     comScore++;
	LDI  R26,LOW(_comScore)
	LDI  R27,HIGH(_comScore)
	CALL SUBOPT_0x2
; 0000 0075                 }
; 0000 0076                 else if (key == -INF)
	RJMP _0x10
_0xF:
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x11
; 0000 0077                     glcd_outtextxy(1, 50, "Draw");
	CALL SUBOPT_0x1
	__POINTW2MN _0xD,24
	CALL _glcd_outtextxy
; 0000 0078                 delay_ms(100);
_0x11:
_0x10:
_0xE:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0079                 isCrossTurn = gameStarter;
	MOV  R5,R4
; 0000 007A                 gameStarter = !gameStarter;
	MOV  R30,R4
	CALL __LNEGB1
	MOV  R4,R30
; 0000 007B                 initGame();
	RCALL _initGame
; 0000 007C 
; 0000 007D             }
; 0000 007E             isCrossTurn = !isCrossTurn;
_0xB:
	MOV  R30,R5
	CALL __LNEGB1
	MOV  R5,R30
; 0000 007F             moveNo++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0080             handup();
	RCALL _handup
; 0000 0081         }
; 0000 0082 
; 0000 0083 
; 0000 0084       }
_0xA:
	RJMP _0x4
; 0000 0085 }
_0x12:
	RJMP _0x12
; .FEND

	.DSEG
_0xD:
	.BYTE 0x1D
;
;
;bool moveForWin(int *x, int *y, bool turn) {
; 0000 0088 _Bool moveForWin(int *x, int *y, _Bool turn) {

	.CSEG
_moveForWin:
; .FSTART _moveForWin
; 0000 0089     if (board[0][0] == turn && board[0][1] == turn && board[0][2] == INF) {
	ST   -Y,R26
;	*x -> Y+3
;	*y -> Y+1
;	turn -> Y+0
	CALL SUBOPT_0x3
	BRNE _0x14
	CALL SUBOPT_0x4
	BRNE _0x14
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 008A         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 008B         return true;
; 0000 008C     }
; 0000 008D     if (board[0][0] == turn && board[0][2] == turn && board[0][1] == INF) {
_0x13:
	CALL SUBOPT_0x3
	BRNE _0x17
	CALL SUBOPT_0x7
	BRNE _0x17
	__GETB2MN _board,1
	CPI  R26,LOW(0x64)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 008E         *x = 0; *y = 1;
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 008F         return true;
; 0000 0090     }
; 0000 0091     if (board[0][1] == turn && board[0][2] == turn && board[0][0] == INF) {
_0x16:
	CALL SUBOPT_0x4
	BRNE _0x1A
	CALL SUBOPT_0x7
	BRNE _0x1A
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 0092         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 0093         return true;
; 0000 0094     }
; 0000 0095 
; 0000 0096     if (board[1][0] == turn && board[1][1] == turn && board[1][2] == INF) {
_0x19:
	CALL SUBOPT_0x8
	BRNE _0x1D
	CALL SUBOPT_0x9
	BRNE _0x1D
	__GETB2MN _board,5
	CPI  R26,LOW(0x64)
	BREQ _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 0097         *x = 1; *y = 2;
	CALL SUBOPT_0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0098         return true;
; 0000 0099     }
; 0000 009A     if (board[1][0] == turn && board[1][2] == turn && board[1][1] == INF) {
_0x1C:
	CALL SUBOPT_0x8
	BRNE _0x20
	CALL SUBOPT_0xB
	BRNE _0x20
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 009B         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 009C         return true;
; 0000 009D     }
; 0000 009E     if (board[1][1] == turn && board[1][2] == turn && board[1][0] == INF) {
_0x1F:
	CALL SUBOPT_0x9
	BRNE _0x23
	CALL SUBOPT_0xB
	BRNE _0x23
	__GETB2MN _board,3
	CPI  R26,LOW(0x64)
	BREQ _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 009F         *x = 1; *y = 0;
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00A0         return true;
; 0000 00A1     }
; 0000 00A2 
; 0000 00A3     if (board[2][0] == turn && board[2][1] == turn && board[2][2] == INF) {
_0x22:
	CALL SUBOPT_0xC
	BRNE _0x26
	CALL SUBOPT_0xD
	BRNE _0x26
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00A4         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00A5         return true;
; 0000 00A6     }
; 0000 00A7     if (board[2][0] == turn && board[2][2] == turn && board[2][1] == INF) {
_0x25:
	CALL SUBOPT_0xC
	BRNE _0x29
	CALL SUBOPT_0xF
	BRNE _0x29
	__GETB2MN _board,7
	CPI  R26,LOW(0x64)
	BREQ _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 00A8         *x = 2; *y = 1;
	CALL SUBOPT_0xE
	RJMP _0x2120013
; 0000 00A9         return true;
; 0000 00AA     }
; 0000 00AB     if (board[2][1] == turn && board[2][2] == turn && board[2][0] == INF) {
_0x28:
	CALL SUBOPT_0xD
	BRNE _0x2C
	CALL SUBOPT_0xF
	BRNE _0x2C
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 00AC         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00AD         return true;
; 0000 00AE     }
; 0000 00AF 
; 0000 00B0     if (board[0][0] == turn && board[1][0] == turn && board[2][0] == INF) {
_0x2B:
	CALL SUBOPT_0x3
	BRNE _0x2F
	CALL SUBOPT_0x8
	BRNE _0x2F
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 00B1         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00B2         return true;
; 0000 00B3     }
; 0000 00B4     if (board[2][0] == turn && board[1][0] == turn && board[0][0] == INF) {
_0x2E:
	CALL SUBOPT_0xC
	BRNE _0x32
	CALL SUBOPT_0x8
	BRNE _0x32
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x33
_0x32:
	RJMP _0x31
_0x33:
; 0000 00B5         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00B6         return true;
; 0000 00B7     }
; 0000 00B8     if (board[0][0] == turn && board[2][0] == turn && board[1][0] == INF) {
_0x31:
	CALL SUBOPT_0x3
	BRNE _0x35
	CALL SUBOPT_0xC
	BRNE _0x35
	__GETB2MN _board,3
	CPI  R26,LOW(0x64)
	BREQ _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 00B9         *x = 1; *y = 0;
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00BA         return true;
; 0000 00BB     }
; 0000 00BC 
; 0000 00BD     if (board[0][1] == turn && board[1][1] == turn && board[2][1] == INF) {
_0x34:
	CALL SUBOPT_0x4
	BRNE _0x38
	CALL SUBOPT_0x9
	BRNE _0x38
	__GETB2MN _board,7
	CPI  R26,LOW(0x64)
	BREQ _0x39
_0x38:
	RJMP _0x37
_0x39:
; 0000 00BE         *x = 2; *y = 1;
	CALL SUBOPT_0xE
	RJMP _0x2120013
; 0000 00BF         return true;
; 0000 00C0     }
; 0000 00C1     if (board[2][1] == turn && board[1][1] == turn && board[0][1] == INF) {
_0x37:
	CALL SUBOPT_0xD
	BRNE _0x3B
	CALL SUBOPT_0x9
	BRNE _0x3B
	__GETB2MN _board,1
	CPI  R26,LOW(0x64)
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 00C2         *x = 0; *y = 1;
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 00C3         return true;
; 0000 00C4     }
; 0000 00C5     if (board[0][1] == turn && board[2][1] == turn && board[1][1] == INF) {
_0x3A:
	CALL SUBOPT_0x4
	BRNE _0x3E
	CALL SUBOPT_0xD
	BRNE _0x3E
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 00C6         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 00C7         return true;
; 0000 00C8     }
; 0000 00C9 
; 0000 00CA     if (board[0][2] == turn && board[1][2] == turn && board[2][2] == INF) {
_0x3D:
	CALL SUBOPT_0x7
	BRNE _0x41
	CALL SUBOPT_0xB
	BRNE _0x41
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 00CB         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00CC         return true;
; 0000 00CD     }
; 0000 00CE     if (board[2][2] == turn && board[1][2] == turn && board[0][2] == INF) {
_0x40:
	CALL SUBOPT_0xF
	BRNE _0x44
	CALL SUBOPT_0xB
	BRNE _0x44
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 00CF         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00D0         return true;
; 0000 00D1     }
; 0000 00D2     if (board[0][2] == turn && board[2][2] == turn && board[1][2] == INF) {
_0x43:
	CALL SUBOPT_0x7
	BRNE _0x47
	CALL SUBOPT_0xF
	BRNE _0x47
	__GETB2MN _board,5
	CPI  R26,LOW(0x64)
	BREQ _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 00D3         *x = 1; *y = 2;
	CALL SUBOPT_0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00D4         return true;
; 0000 00D5     }
; 0000 00D6 
; 0000 00D7 
; 0000 00D8     if (board[0][0] == turn && board[1][1] == turn && board[2][2] == INF) {
_0x46:
	CALL SUBOPT_0x3
	BRNE _0x4A
	CALL SUBOPT_0x9
	BRNE _0x4A
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
; 0000 00D9         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00DA         return true;
; 0000 00DB     }
; 0000 00DC     if (board[0][0] == turn && board[2][2] == turn && board[1][1] == INF) {
_0x49:
	CALL SUBOPT_0x3
	BRNE _0x4D
	CALL SUBOPT_0xF
	BRNE _0x4D
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00DD         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 00DE         return true;
; 0000 00DF     }
; 0000 00E0     if (board[2][2] == turn && board[1][1] == turn && board[0][0] == INF) {
_0x4C:
	CALL SUBOPT_0xF
	BRNE _0x50
	CALL SUBOPT_0x9
	BRNE _0x50
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 00E1         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00E2         return true;
; 0000 00E3     }
; 0000 00E4 
; 0000 00E5     if (board[2][0] == turn && board[1][1] == turn && board[0][2] == INF) {
_0x4F:
	CALL SUBOPT_0xC
	BRNE _0x53
	CALL SUBOPT_0x9
	BRNE _0x53
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 00E6         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00E7         return true;
; 0000 00E8     }
; 0000 00E9     if (board[2][0] == turn && board[0][2] == turn && board[1][1] == INF) {
_0x52:
	CALL SUBOPT_0xC
	BRNE _0x56
	CALL SUBOPT_0x7
	BRNE _0x56
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x57
_0x56:
	RJMP _0x55
_0x57:
; 0000 00EA         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 00EB         return true;
; 0000 00EC     }
; 0000 00ED     if (board[0][2] == turn && board[1][1] == turn && board[2][0] == INF) {
_0x55:
	CALL SUBOPT_0x7
	BRNE _0x59
	CALL SUBOPT_0x9
	BRNE _0x59
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 00EE         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00EF         return true;
; 0000 00F0     }
; 0000 00F1     return false;
_0x58:
	LDI  R30,LOW(0)
	RJMP _0x2120014
; 0000 00F2 
; 0000 00F3 }
; .FEND
;bool moveForNotToLose(int *x, int *y, bool turn) {
; 0000 00F4 _Bool moveForNotToLose(int *x, int *y, _Bool turn) {
_moveForNotToLose:
; .FSTART _moveForNotToLose
; 0000 00F5     if (board[0][0] == !turn && board[0][1] == !turn && board[0][2] == INF) {
	ST   -Y,R26
;	*x -> Y+3
;	*y -> Y+1
;	turn -> Y+0
	CALL SUBOPT_0x10
	BRNE _0x5C
	__GETB2MN _board,1
	CALL SUBOPT_0x11
	BRNE _0x5C
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
; 0000 00F6         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 00F7         return true;
; 0000 00F8     }
; 0000 00F9     if (board[0][0] == !turn && board[0][2] == !turn && board[0][1] == INF) {
_0x5B:
	CALL SUBOPT_0x10
	BRNE _0x5F
	__GETB2MN _board,2
	CALL SUBOPT_0x11
	BRNE _0x5F
	__GETB2MN _board,1
	CPI  R26,LOW(0x64)
	BREQ _0x60
_0x5F:
	RJMP _0x5E
_0x60:
; 0000 00FA         *x = 0; *y = 1;
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 00FB         return true;
; 0000 00FC     }
; 0000 00FD     if (board[0][1] == !turn && board[0][2] == !turn && board[0][0] == INF) {
_0x5E:
	CALL SUBOPT_0x12
	BRNE _0x62
	CALL SUBOPT_0x13
	BRNE _0x62
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 00FE         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 00FF         return true;
; 0000 0100     }
; 0000 0101 
; 0000 0102     if (board[1][0] == !turn && board[1][1] == !turn && board[1][2] == INF) {
_0x61:
	CALL SUBOPT_0x14
	BRNE _0x65
	CALL SUBOPT_0x15
	BRNE _0x65
	__GETB2MN _board,5
	CPI  R26,LOW(0x64)
	BREQ _0x66
_0x65:
	RJMP _0x64
_0x66:
; 0000 0103         *x = 1; *y = 2;
	CALL SUBOPT_0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0104         return true;
; 0000 0105     }
; 0000 0106     if (board[1][0] == !turn && board[1][2] == !turn && board[1][1] == INF) {
_0x64:
	CALL SUBOPT_0x14
	BRNE _0x68
	CALL SUBOPT_0x16
	BRNE _0x68
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 0107         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 0108         return true;
; 0000 0109     }
; 0000 010A     if (board[1][1] == !turn && board[1][2] == !turn && board[1][0] == INF) {
_0x67:
	CALL SUBOPT_0x15
	BRNE _0x6B
	CALL SUBOPT_0x16
	BRNE _0x6B
	__GETB2MN _board,3
	CPI  R26,LOW(0x64)
	BREQ _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
; 0000 010B         *x = 1; *y = 0;
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 010C         return true;
; 0000 010D     }
; 0000 010E 
; 0000 010F     if (board[2][0] == !turn && board[2][1] == !turn && board[2][2] == INF) {
_0x6A:
	CALL SUBOPT_0x17
	BRNE _0x6E
	CALL SUBOPT_0x18
	BRNE _0x6E
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 0110         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0111         return true;
; 0000 0112     }
; 0000 0113     if (board[2][0] == !turn && board[2][2] == !turn && board[2][1] == INF) {
_0x6D:
	CALL SUBOPT_0x17
	BRNE _0x71
	CALL SUBOPT_0x19
	BRNE _0x71
	__GETB2MN _board,7
	CPI  R26,LOW(0x64)
	BREQ _0x72
_0x71:
	RJMP _0x70
_0x72:
; 0000 0114         *x = 2; *y = 1;
	CALL SUBOPT_0xE
	RJMP _0x2120013
; 0000 0115         return true;
; 0000 0116     }
; 0000 0117     if (board[2][1] == !turn && board[2][2] == !turn && board[2][0] == INF) {
_0x70:
	CALL SUBOPT_0x18
	BRNE _0x74
	CALL SUBOPT_0x19
	BRNE _0x74
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0x75
_0x74:
	RJMP _0x73
_0x75:
; 0000 0118         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 0119         return true;
; 0000 011A     }
; 0000 011B 
; 0000 011C     if (board[0][0] == !turn && board[1][0] == !turn && board[2][0] == INF) {
_0x73:
	CALL SUBOPT_0x10
	BRNE _0x77
	__GETB2MN _board,3
	CALL SUBOPT_0x11
	BRNE _0x77
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0x78
_0x77:
	RJMP _0x76
_0x78:
; 0000 011D         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 011E         return true;
; 0000 011F     }
; 0000 0120     if (board[2][0] == !turn && board[1][0] == !turn && board[0][0] == INF) {
_0x76:
	CALL SUBOPT_0x17
	BRNE _0x7A
	CALL SUBOPT_0x14
	BRNE _0x7A
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
; 0000 0121         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 0122         return true;
; 0000 0123     }
; 0000 0124     if (board[0][0] == !turn && board[2][0] == !turn && board[1][0] == INF) {
_0x79:
	CALL SUBOPT_0x10
	BRNE _0x7D
	__GETB2MN _board,6
	CALL SUBOPT_0x11
	BRNE _0x7D
	__GETB2MN _board,3
	CPI  R26,LOW(0x64)
	BREQ _0x7E
_0x7D:
	RJMP _0x7C
_0x7E:
; 0000 0125         *x = 1; *y = 0;
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
; 0000 0126         return true;
; 0000 0127     }
; 0000 0128 
; 0000 0129     if (board[0][1] == !turn && board[1][1] == !turn && board[2][1] == INF) {
_0x7C:
	CALL SUBOPT_0x12
	BRNE _0x80
	CALL SUBOPT_0x15
	BRNE _0x80
	__GETB2MN _board,7
	CPI  R26,LOW(0x64)
	BREQ _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 012A         *x = 2; *y = 1;
	CALL SUBOPT_0xE
	RJMP _0x2120013
; 0000 012B         return true;
; 0000 012C     }
; 0000 012D     if (board[2][1] == !turn && board[1][1] == !turn && board[0][1] == INF) {
_0x7F:
	CALL SUBOPT_0x18
	BRNE _0x83
	CALL SUBOPT_0x15
	BRNE _0x83
	__GETB2MN _board,1
	CPI  R26,LOW(0x64)
	BREQ _0x84
_0x83:
	RJMP _0x82
_0x84:
; 0000 012E         *x = 0; *y = 1;
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 012F         return true;
; 0000 0130     }
; 0000 0131     if (board[0][1] == !turn && board[2][1] == !turn && board[1][1] == INF) {
_0x82:
	CALL SUBOPT_0x12
	BRNE _0x86
	CALL SUBOPT_0x18
	BRNE _0x86
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x87
_0x86:
	RJMP _0x85
_0x87:
; 0000 0132         *x = 1; *y = 1;
	RJMP _0x2120012
; 0000 0133         return true;
; 0000 0134     }
; 0000 0135 
; 0000 0136     if (board[0][2] == !turn && board[1][2] == !turn && board[2][2] == INF) {
_0x85:
	CALL SUBOPT_0x13
	BRNE _0x89
	CALL SUBOPT_0x16
	BRNE _0x89
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x8A
_0x89:
	RJMP _0x88
_0x8A:
; 0000 0137         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0138         return true;
; 0000 0139     }
; 0000 013A     if (board[2][2] == !turn && board[1][2] == !turn && board[0][2] == INF) {
_0x88:
	CALL SUBOPT_0x19
	BRNE _0x8C
	CALL SUBOPT_0x16
	BRNE _0x8C
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x8D
_0x8C:
	RJMP _0x8B
_0x8D:
; 0000 013B         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 013C         return true;
; 0000 013D     }
; 0000 013E     if (board[0][2] == !turn && board[2][2] == !turn && board[1][2] == INF) {
_0x8B:
	CALL SUBOPT_0x13
	BRNE _0x8F
	CALL SUBOPT_0x19
	BRNE _0x8F
	__GETB2MN _board,5
	CPI  R26,LOW(0x64)
	BREQ _0x90
_0x8F:
	RJMP _0x8E
_0x90:
; 0000 013F         *x = 1; *y = 2;
	CALL SUBOPT_0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0140         return true;
; 0000 0141     }
; 0000 0142 
; 0000 0143     if (board[0][0] == !turn && board[1][1] == !turn && board[2][2] == INF) {
_0x8E:
	CALL SUBOPT_0x10
	BRNE _0x92
	__GETB2MN _board,4
	CALL SUBOPT_0x11
	BRNE _0x92
	__GETB2MN _board,8
	CPI  R26,LOW(0x64)
	BREQ _0x93
_0x92:
	RJMP _0x91
_0x93:
; 0000 0144         *x = 2; *y = 2;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120011
; 0000 0145         return true;
; 0000 0146     }
; 0000 0147     if (board[0][0] == !turn && board[2][2] == !turn && board[1][1] == INF) {
_0x91:
	CALL SUBOPT_0x10
	BRNE _0x95
	__GETB2MN _board,8
	CALL SUBOPT_0x11
	BRNE _0x95
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x96
_0x95:
	RJMP _0x94
_0x96:
; 0000 0148         *x = 1; *y = 1;
_0x2120012:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2120013:
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2120011:
	ST   X+,R30
	ST   X,R31
; 0000 0149         return true;
	LDI  R30,LOW(1)
_0x2120014:
	ADIW R28,5
	RET
; 0000 014A     }
; 0000 014B     if (board[2][2] == !turn && board[1][1] == !turn && board[0][0] == INF) {
_0x94:
	CALL SUBOPT_0x19
	BRNE _0x98
	CALL SUBOPT_0x15
	BRNE _0x98
	LDS  R26,_board
	CPI  R26,LOW(0x64)
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
; 0000 014C         *x = 0; *y = 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1A
; 0000 014D         return true;
	JMP  _0x212000E
; 0000 014E     }
; 0000 014F 
; 0000 0150     if (board[2][0] == !turn && board[1][1] == !turn && board[0][2] == INF) {
_0x97:
	CALL SUBOPT_0x17
	BRNE _0x9B
	CALL SUBOPT_0x15
	BRNE _0x9B
	__GETB2MN _board,2
	CPI  R26,LOW(0x64)
	BREQ _0x9C
_0x9B:
	RJMP _0x9A
_0x9C:
; 0000 0151         *x = 0; *y = 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1B
; 0000 0152         return true;
	LDI  R30,LOW(1)
	JMP  _0x212000E
; 0000 0153     }
; 0000 0154     if (board[2][0] == !turn && board[0][2] == !turn && board[1][1] == INF) {
_0x9A:
	CALL SUBOPT_0x17
	BRNE _0x9E
	CALL SUBOPT_0x13
	BRNE _0x9E
	__GETB2MN _board,4
	CPI  R26,LOW(0x64)
	BREQ _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
; 0000 0155         *x = 1; *y = 1;
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1C
; 0000 0156         return true;
	LDI  R30,LOW(1)
	JMP  _0x212000E
; 0000 0157     }
; 0000 0158     if (board[0][2] == !turn && board[1][1] == !turn && board[2][0] == INF) {
_0x9D:
	CALL SUBOPT_0x13
	BRNE _0xA1
	CALL SUBOPT_0x15
	BRNE _0xA1
	__GETB2MN _board,6
	CPI  R26,LOW(0x64)
	BREQ _0xA2
_0xA1:
	RJMP _0xA0
_0xA2:
; 0000 0159         *x = 2; *y = 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1A
; 0000 015A         return true;
	JMP  _0x212000E
; 0000 015B     }
; 0000 015C     return false;
_0xA0:
	LDI  R30,LOW(0)
	JMP  _0x212000E
; 0000 015D }
; .FEND
;bool randMove(int *x, int *y) {
; 0000 015E _Bool randMove(int *x, int *y) {
_randMove:
; .FSTART _randMove
; 0000 015F     int i, j;
; 0000 0160     for (i = 0; i < 3; i++) {
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*x -> Y+6
;	*y -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0xA4:
	__CPWRN 16,17,3
	BRGE _0xA5
; 0000 0161         for (j = 0; j < 3; j++) {
	__GETWRN 18,19,0
_0xA7:
	__CPWRN 18,19,3
	BRGE _0xA8
; 0000 0162             if (board[i][j] == INF) {
	CALL SUBOPT_0x1D
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BRNE _0xA9
; 0000 0163                 *x = i; *y = j;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X+,R16
	ST   X,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R18
	ST   X,R19
; 0000 0164                 return true;
	LDI  R30,LOW(1)
	RJMP _0x2120010
; 0000 0165             }
; 0000 0166         }
_0xA9:
	__ADDWRN 18,19,1
	RJMP _0xA7
_0xA8:
; 0000 0167     }
	__ADDWRN 16,17,1
	RJMP _0xA4
_0xA5:
; 0000 0168     return false;
	LDI  R30,LOW(0)
_0x2120010:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; 0000 0169 }
; .FEND
;
;void computerToMove(char board[3][3], int *x, int *y, int moveNo, bool turn) {
; 0000 016B void computerToMove(char board[3][3], int *x, int *y, int moveNo, _Bool turn) {
_computerToMove:
; .FSTART _computerToMove
; 0000 016C     if (moveNo == 1) {
	ST   -Y,R26
;	board -> Y+7
;	*x -> Y+5
;	*y -> Y+3
;	moveNo -> Y+1
;	turn -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,1
	BRNE _0xAA
; 0000 016D         *x = 2;
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x1B
; 0000 016E         *y = 2;
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 016F         return;
	RJMP _0x212000F
; 0000 0170     }
; 0000 0171 
; 0000 0172     if (moveNo == 2) {
_0xAA:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,2
	BREQ PC+2
	RJMP _0xAB
; 0000 0173         // corner
; 0000 0174         if (board[0][0] == !turn || board[2][2] == !turn
; 0000 0175                 || board[2][0] == !turn || board[0][2] == !turn) {
	CALL SUBOPT_0x1E
	BREQ _0xAD
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+8
	CALL SUBOPT_0x1F
	BREQ _0xAD
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+6
	CALL SUBOPT_0x1F
	BREQ _0xAD
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+2
	CALL SUBOPT_0x1F
	BRNE _0xAC
_0xAD:
; 0000 0176 
; 0000 0177                 *x = 1; *y = 1;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0178                 return;
	RJMP _0x212000F
; 0000 0179         }
; 0000 017A 
; 0000 017B         // mid-corner
; 0000 017C         if (board[0][1] == !turn) {
_0xAC:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+1
	CALL SUBOPT_0x1F
	BRNE _0xAF
; 0000 017D             *x = 2; *y = 1;
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x21
; 0000 017E             return;
	RJMP _0x212000F
; 0000 017F         }
; 0000 0180         if (board[1][0] == !turn) {
_0xAF:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+3
	CALL SUBOPT_0x1F
	BRNE _0xB0
; 0000 0181             *x = 1; *y = 2;
	CALL SUBOPT_0x20
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 0182             return;
	RJMP _0x212000F
; 0000 0183         }
; 0000 0184         if (board[2][1] == !turn) {
_0xB0:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+7
	CALL SUBOPT_0x1F
	BRNE _0xB1
; 0000 0185             *x = 0; *y = 1;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
; 0000 0186             return;
	RJMP _0x212000F
; 0000 0187         }
; 0000 0188         if (board[1][2] == !turn) {
_0xB1:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+5
	CALL SUBOPT_0x1F
	BRNE _0xB2
; 0000 0189             *x = 1; *y = 0;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x5
	ST   X+,R30
	ST   X,R31
; 0000 018A             return;
	RJMP _0x212000F
; 0000 018B         }
; 0000 018C 
; 0000 018D         // mid
; 0000 018E         if (board[1][1] == !turn) {
_0xB2:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+4
	CALL SUBOPT_0x1F
	BRNE _0xB3
; 0000 018F             *x = 0; *y = 0;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x5
	ST   X+,R30
	ST   X,R31
; 0000 0190             return;
	RJMP _0x212000F
; 0000 0191         }
; 0000 0192 
; 0000 0193     }
_0xB3:
; 0000 0194 
; 0000 0195     if (moveNo == 3) {
_0xAB:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,3
	BREQ PC+2
	RJMP _0xB4
; 0000 0196         if (board[1][1] == !turn) {
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+4
	CALL SUBOPT_0x1F
	BRNE _0xB5
; 0000 0197             *x = 0; *y = 0;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x5
	ST   X+,R30
	ST   X,R31
; 0000 0198             return;
	RJMP _0x212000F
; 0000 0199         }
; 0000 019A 
; 0000 019B 
; 0000 019C         if (board[0][0] == !turn) {
_0xB5:
	CALL SUBOPT_0x1E
	BRNE _0xB6
; 0000 019D             *x = 0; *y = 2;
	CALL SUBOPT_0x22
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 019E             return;
	RJMP _0x212000F
; 0000 019F         }
; 0000 01A0         if (board[2][0] == !turn) {
_0xB6:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+6
	CALL SUBOPT_0x1F
	BRNE _0xB7
; 0000 01A1             *x = 0; *y = 0;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x5
	ST   X+,R30
	ST   X,R31
; 0000 01A2             return;
	RJMP _0x212000F
; 0000 01A3         }
; 0000 01A4         if (board[0][2] == !turn) {
_0xB7:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+2
	CALL SUBOPT_0x1F
	BRNE _0xB8
; 0000 01A5             *x = 0; *y = 0;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x5
	ST   X+,R30
	ST   X,R31
; 0000 01A6             return;
	RJMP _0x212000F
; 0000 01A7         }
; 0000 01A8 
; 0000 01A9         if (board[1][0] == !turn) {
_0xB8:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+3
	CALL SUBOPT_0x1F
	BRNE _0xB9
; 0000 01AA             *x = 0; *y = 2;
	CALL SUBOPT_0x22
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 01AB             return;
	RJMP _0x212000F
; 0000 01AC         }
; 0000 01AD         if (board[0][1] == !turn ) {
_0xB9:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+1
	CALL SUBOPT_0x1F
	BRNE _0xBA
; 0000 01AE             *x = 0; *y = 2;
	CALL SUBOPT_0x22
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 01AF             return;
	RJMP _0x212000F
; 0000 01B0         }
; 0000 01B1         if (board[2][1] == !turn) {
_0xBA:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+7
	CALL SUBOPT_0x1F
	BRNE _0xBB
; 0000 01B2             *x = 0; *y = 2;
	CALL SUBOPT_0x22
	CALL SUBOPT_0xE
	ST   X+,R30
	ST   X,R31
; 0000 01B3             return;
	RJMP _0x212000F
; 0000 01B4         }
; 0000 01B5         if (board[1][2] == !turn) {
_0xBB:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+5
	CALL SUBOPT_0x1F
	BRNE _0xBC
; 0000 01B6             *x = 1; *y = 1;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 01B7             return;
	RJMP _0x212000F
; 0000 01B8         }
; 0000 01B9     }
_0xBC:
; 0000 01BA 
; 0000 01BB     if (moveNo == 4) {
_0xB4:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,4
	BRNE _0xBD
; 0000 01BC          if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BREQ _0xBE
; 0000 01BD             return;
	RJMP _0x212000F
; 0000 01BE         if (moveForNotToLose(x, y, turn))
_0xBE:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BREQ _0xBF
; 0000 01BF             return;
	RJMP _0x212000F
; 0000 01C0         if (randMove(x, y))
_0xBF:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	BREQ _0xC0
; 0000 01C1             return;
	RJMP _0x212000F
; 0000 01C2 
; 0000 01C3     }
_0xC0:
; 0000 01C4 
; 0000 01C5     if (moveNo == 5) {
_0xBD:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,5
	BRNE _0xC1
; 0000 01C6         if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BREQ _0xC2
; 0000 01C7             return;
	RJMP _0x212000F
; 0000 01C8         if (moveForNotToLose(x, y, turn))
_0xC2:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BREQ _0xC3
; 0000 01C9             return;
	RJMP _0x212000F
; 0000 01CA         if (randMove(x, y))
_0xC3:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	BREQ _0xC4
; 0000 01CB             return;
	RJMP _0x212000F
; 0000 01CC     }
_0xC4:
; 0000 01CD 
; 0000 01CE     if (moveNo == 6) {
_0xC1:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,6
	BRNE _0xC5
; 0000 01CF         if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BREQ _0xC6
; 0000 01D0             return;
	RJMP _0x212000F
; 0000 01D1         if (moveForNotToLose(x, y, turn))
_0xC6:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BREQ _0xC7
; 0000 01D2             return;
	RJMP _0x212000F
; 0000 01D3         if (randMove(x, y))
_0xC7:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	BREQ _0xC8
; 0000 01D4             return;
	RJMP _0x212000F
; 0000 01D5     }
_0xC8:
; 0000 01D6 
; 0000 01D7     if (moveNo == 7) {
_0xC5:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,7
	BRNE _0xC9
; 0000 01D8         if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BRNE _0x212000F
; 0000 01D9             return;
; 0000 01DA         if (moveForNotToLose(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BRNE _0x212000F
; 0000 01DB             return;
; 0000 01DC         if (randMove(x, y))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	BRNE _0x212000F
; 0000 01DD             return;
; 0000 01DE     }
; 0000 01DF 
; 0000 01E0     if (moveNo == 8) {
_0xC9:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,8
	BRNE _0xCD
; 0000 01E1         if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BRNE _0x212000F
; 0000 01E2             return;
; 0000 01E3         if (moveForNotToLose(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BRNE _0x212000F
; 0000 01E4             return;
; 0000 01E5         if (randMove(x, y))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	BRNE _0x212000F
; 0000 01E6             return;
; 0000 01E7     }
; 0000 01E8 
; 0000 01E9     if (moveNo == 9) {
_0xCD:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,9
	BRNE _0xD1
; 0000 01EA         if (moveForWin(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	BRNE _0x212000F
; 0000 01EB             return;
; 0000 01EC         if (moveForNotToLose(x, y, turn))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	BRNE _0x212000F
; 0000 01ED             return;
; 0000 01EE         if (randMove(x, y))
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
; 0000 01EF             return;
; 0000 01F0     }
; 0000 01F1 
; 0000 01F2 }
_0xD1:
_0x212000F:
	ADIW R28,9
	RET
; .FEND
;
;int evaluate(char board[3][3]) {
; 0000 01F4 int evaluate(char board[3][3]) {
_evaluate:
; .FSTART _evaluate
; 0000 01F5     if (board[0][0] + board[0][1] + board[0][2] == 3 ||
	CALL SUBOPT_0x27
;	board -> Y+0
; 0000 01F6             board[1][0] + board[1][1] + board[1][2] == 3 ||
; 0000 01F7             board[2][0] + board[2][1] + board[2][2] == 3)
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	SBIW R26,3
	BREQ _0xD6
	CALL SUBOPT_0x2A
	SBIW R26,3
	BREQ _0xD6
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	SBIW R26,3
	BRNE _0xD5
_0xD6:
; 0000 01F8         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	JMP  _0x212000A
; 0000 01F9 
; 0000 01FA     if (board[0][0] + board[1][0] + board[2][0] == 3 ||
_0xD5:
; 0000 01FB             board[0][1] + board[1][1] + board[2][1] == 3 ||
; 0000 01FC             board[0][2] + board[1][2] + board[2][2] == 3)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,3
	BREQ _0xD9
	CALL SUBOPT_0x2F
	SBIW R26,3
	BREQ _0xD9
	CALL SUBOPT_0x30
	SBIW R26,3
	BRNE _0xD8
_0xD9:
; 0000 01FD         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	JMP  _0x212000A
; 0000 01FE 
; 0000 01FF     if (board[0][0] + board[0][1] + board[0][2] == 0 ||
_0xD8:
; 0000 0200             board[1][0] + board[1][1] + board[1][2] == 0 ||
; 0000 0201             board[2][0] + board[2][1] + board[2][2] == 0)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x29
	SBIW R26,0
	BREQ _0xDC
	CALL SUBOPT_0x2A
	SBIW R26,0
	BREQ _0xDC
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	SBIW R26,0
	BRNE _0xDB
_0xDC:
; 0000 0202         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x212000A
; 0000 0203 
; 0000 0204     if (board[0][0] + board[1][0] + board[2][0] == 0 ||
_0xDB:
; 0000 0205             board[0][1] + board[1][1] + board[2][1] == 0 ||
; 0000 0206             board[0][2] + board[1][2] + board[2][2] == 0)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,0
	BREQ _0xDF
	CALL SUBOPT_0x2F
	SBIW R26,0
	BREQ _0xDF
	CALL SUBOPT_0x30
	SBIW R26,0
	BRNE _0xDE
_0xDF:
; 0000 0207         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x212000A
; 0000 0208 
; 0000 0209 
; 0000 020A     if (board[0][0] + board[1][1] + board[2][2] == 3 ||
_0xDE:
; 0000 020B             board[2][0] + board[1][1] + board[0][2] == 3)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	SBIW R26,3
	BREQ _0xE2
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL SUBOPT_0x33
	LDD  R30,Z+2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,3
	BRNE _0xE1
_0xE2:
; 0000 020C             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	JMP  _0x212000A
; 0000 020D 
; 0000 020E     if (board[0][0] + board[1][1] + board[2][2] == 0 ||
_0xE1:
; 0000 020F             board[2][0] + board[1][1] + board[0][2] == 0)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	SBIW R26,0
	BREQ _0xE5
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL SUBOPT_0x33
	LDD  R30,Z+2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,0
	BRNE _0xE4
_0xE5:
; 0000 0210             return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x212000A
; 0000 0211 
; 0000 0212     if (board[0][0] + board[0][1] + board[0][2]
_0xE4:
; 0000 0213             + board[1][0] + board[1][1] + board[1][2]
; 0000 0214             + board[2][0] + board[2][1] + board[2][2] == 5)
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x29
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+3
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x33
	LDD  R30,Z+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x2B
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x32
	SBIW R26,5
	BRNE _0xE7
; 0000 0215                 return -INF;
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	JMP  _0x212000A
; 0000 0216 
; 0000 0217     return INF;
_0xE7:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	JMP  _0x212000A
; 0000 0218 }
; .FEND
;
;void updateBoard(int x, int y, bool isCrossTurn){
; 0000 021A void updateBoard(int x, int y, _Bool isCrossTurn){
_updateBoard:
; .FSTART _updateBoard
; 0000 021B     board[x][y] = isCrossTurn ? 1: 0;
	CALL SUBOPT_0x34
;	x -> Y+3
;	y -> Y+1
;	isCrossTurn -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0xE8
	LDI  R30,LOW(1)
	RJMP _0xE9
_0xE8:
	LDI  R30,LOW(0)
_0xE9:
	ST   X,R30
; 0000 021C }
	JMP  _0x212000E
; .FEND
;
;void handup() {
; 0000 021E void handup() {
_handup:
; .FSTART _handup
; 0000 021F     int q, p;
; 0000 0220     while(readkey(&q, &p) != 100);
	CALL __SAVELOCR4
;	q -> R16,R17
;	p -> R18,R19
_0xEB:
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _readkey
	POP  R18
	POP  R19
	POP  R16
	POP  R17
	CPI  R30,LOW(0x64)
	BRNE _0xEB
; 0000 0221     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0222     while(readkey(&q, &p) != 100);
_0xEE:
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _readkey
	POP  R18
	POP  R19
	POP  R16
	POP  R17
	CPI  R30,LOW(0x64)
	BRNE _0xEE
; 0000 0223 }
	JMP  _0x212000B
; .FEND
;
;char readkey(int *x, int *y) {
; 0000 0225 char readkey(int *x, int *y) {
_readkey:
; .FSTART _readkey
; 0000 0226     PORTD.4 = 0;
	ST   -Y,R27
	ST   -Y,R26
;	*x -> Y+2
;	*y -> Y+0
	CBI  0x12,4
; 0000 0227     PORTD.5 = 1;
	SBI  0x12,5
; 0000 0228     PORTD.6 = 1;
	SBI  0x12,6
; 0000 0229     PORTD.7 = 1;
	SBI  0x12,7
; 0000 022A     if (PIND.0 == 0) {
	SBIC 0x10,0
	RJMP _0xF9
; 0000 022B         *x = 0;
	CALL SUBOPT_0x35
; 0000 022C         *y = 0;
	CALL SUBOPT_0x36
; 0000 022D         return 7;
	LDI  R30,LOW(7)
	JMP  _0x212000C
; 0000 022E     }
; 0000 022F     if (PIND.1 == 0) {
_0xF9:
	SBIC 0x10,1
	RJMP _0xFA
; 0000 0230         *x = 1;
	CALL SUBOPT_0x37
; 0000 0231         *y = 0;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x36
; 0000 0232         return 4;
	LDI  R30,LOW(4)
	JMP  _0x212000C
; 0000 0233     }
; 0000 0234     if (PIND.2 == 0) {
_0xFA:
	SBIC 0x10,2
	RJMP _0xFB
; 0000 0235         *x = 2;
	CALL SUBOPT_0x38
; 0000 0236         *y = 0;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1A
; 0000 0237         return 1;
	JMP  _0x212000C
; 0000 0238     }
; 0000 0239     if (PIND.3 == 0)
_0xFB:
	SBIC 0x10,3
	RJMP _0xFC
; 0000 023A         return 100;
	LDI  R30,LOW(100)
	JMP  _0x212000C
; 0000 023B 
; 0000 023C     PORTD.4 = 1;
_0xFC:
	SBI  0x12,4
; 0000 023D     PORTD.5 = 0;
	CBI  0x12,5
; 0000 023E     PORTD.6 = 1;
	SBI  0x12,6
; 0000 023F     PORTD.7 = 1;
	SBI  0x12,7
; 0000 0240     if (PIND.0 == 0) {
	SBIC 0x10,0
	RJMP _0x105
; 0000 0241         *x = 0;
	CALL SUBOPT_0x35
; 0000 0242         *y = 1;
	CALL SUBOPT_0x1C
; 0000 0243         return 8;
	LDI  R30,LOW(8)
	JMP  _0x212000C
; 0000 0244     }
; 0000 0245     if (PIND.1 == 0){
_0x105:
	SBIC 0x10,1
	RJMP _0x106
; 0000 0246         *x = 1;
	CALL SUBOPT_0x37
; 0000 0247         *y = 1;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1C
; 0000 0248         return 5;
	LDI  R30,LOW(5)
	JMP  _0x212000C
; 0000 0249     }
; 0000 024A     if (PIND.2 == 0){
_0x106:
	SBIC 0x10,2
	RJMP _0x107
; 0000 024B         *x = 2;
	CALL SUBOPT_0x38
; 0000 024C         *y = 1;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1C
; 0000 024D         return 2;
	LDI  R30,LOW(2)
	JMP  _0x212000C
; 0000 024E     }
; 0000 024F     if (PIND.3 == 0)
_0x107:
	SBIC 0x10,3
	RJMP _0x108
; 0000 0250         return 100;
	LDI  R30,LOW(100)
	JMP  _0x212000C
; 0000 0251 
; 0000 0252     PORTD.4 = 1;
_0x108:
	SBI  0x12,4
; 0000 0253     PORTD.5 = 1;
	SBI  0x12,5
; 0000 0254     PORTD.6 = 0;
	CBI  0x12,6
; 0000 0255     PORTD.7 = 1;
	SBI  0x12,7
; 0000 0256     if (PIND.0 == 0){
	SBIC 0x10,0
	RJMP _0x111
; 0000 0257         *x = 0;
	CALL SUBOPT_0x35
; 0000 0258         *y = 2;
	CALL SUBOPT_0x1B
; 0000 0259         return 9;
	LDI  R30,LOW(9)
	JMP  _0x212000C
; 0000 025A     }
; 0000 025B     if (PIND.1 == 0){
_0x111:
	SBIC 0x10,1
	RJMP _0x112
; 0000 025C         *x = 1;
	CALL SUBOPT_0x37
; 0000 025D         *y = 2;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1B
; 0000 025E         return 6;
	LDI  R30,LOW(6)
	JMP  _0x212000C
; 0000 025F     }
; 0000 0260     if (PIND.2 == 0){
_0x112:
	SBIC 0x10,2
	RJMP _0x113
; 0000 0261         *x = 2;
	CALL SUBOPT_0x38
; 0000 0262         *y = 2;
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1B
; 0000 0263         return 3;
	LDI  R30,LOW(3)
	JMP  _0x212000C
; 0000 0264     }
; 0000 0265     if (PIND.3 == 0)
_0x113:
	SBIC 0x10,3
	RJMP _0x114
; 0000 0266         return 100;
	LDI  R30,LOW(100)
	JMP  _0x212000C
; 0000 0267 
; 0000 0268     return 100;
_0x114:
	LDI  R30,LOW(100)
	JMP  _0x212000C
; 0000 0269 }
; .FEND
;
;void initGame() {
; 0000 026B void initGame() {
_initGame:
; .FSTART _initGame
; 0000 026C     int i, j;
; 0000 026D     for (i = 0; i < 3; i++) {
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x116:
	__CPWRN 16,17,3
	BRGE _0x117
; 0000 026E         for(j = 0; j < 3; j++){
	__GETWRN 18,19,0
_0x119:
	__CPWRN 18,19,3
	BRGE _0x11A
; 0000 026F             board[i][j] = INF;
	CALL SUBOPT_0x1D
	LDI  R26,LOW(100)
	STD  Z+0,R26
; 0000 0270         }
	__ADDWRN 18,19,1
	RJMP _0x119
_0x11A:
; 0000 0271     }
	__ADDWRN 16,17,1
	RJMP _0x116
_0x117:
; 0000 0272     moveNo = 0;
	CLR  R10
	CLR  R11
; 0000 0273 
; 0000 0274     glcd_clear();
	CALL _glcd_clear
; 0000 0275     printScoreBoard();
	RCALL _printScoreBoard
; 0000 0276     glcd_setlinestyle(2,GLCD_LINE_SOLID);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x39
; 0000 0277     glcd_line(65, 22, 127, 22);
	LDI  R30,LOW(65)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R30,LOW(127)
	ST   -Y,R30
	LDI  R26,LOW(22)
	CALL _glcd_line
; 0000 0278     glcd_line(65, 43, 127, 43);
	LDI  R30,LOW(65)
	ST   -Y,R30
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(127)
	ST   -Y,R30
	LDI  R26,LOW(43)
	CALL _glcd_line
; 0000 0279     glcd_line(85, 1, 85, 63);
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDI  R26,LOW(63)
	CALL _glcd_line
; 0000 027A     glcd_setlinestyle(1,GLCD_LINE_SOLID);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x39
; 0000 027B     glcd_line(107, 1, 107, 63);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(63)
	CALL _glcd_line
; 0000 027C }
	JMP  _0x212000B
; .FEND
;
;
;void drawCrossOrCircle(int x, int y, bool isCross) {
; 0000 027F void drawCrossOrCircle(int x, int y, _Bool isCross) {
_drawCrossOrCircle:
; .FSTART _drawCrossOrCircle
; 0000 0280     if (board[x][y] != INF)
	CALL SUBOPT_0x34
;	x -> Y+3
;	y -> Y+1
;	isCross -> Y+0
	LD   R26,X
	CPI  R26,LOW(0x64)
	BREQ _0x11B
; 0000 0281         return;
	JMP  _0x212000E
; 0000 0282 
; 0000 0283     if (isCross == 1) {
_0x11B:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x11C
; 0000 0284         y = 70 + 21 * y;
	CALL SUBOPT_0x3A
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x3B
; 0000 0285         x = 5 + 21 * x;
	ADIW R30,5
	CALL SUBOPT_0x3C
; 0000 0286         glcd_line(y, x, y + 11, x + 11);
	LDD  R30,Y+3
	SUBI R30,-LOW(11)
	ST   -Y,R30
	LDD  R26,Y+6
	SUBI R26,-LOW(11)
	CALL _glcd_line
; 0000 0287         glcd_line(y + 11, x, y, x + 11);
	LDD  R30,Y+1
	SUBI R30,-LOW(11)
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+6
	SUBI R26,-LOW(11)
	CALL _glcd_line
; 0000 0288     }
; 0000 0289     else {
	RJMP _0x11D
_0x11C:
; 0000 028A         y = 76 + 21 * y;
	CALL SUBOPT_0x3A
	SUBI R30,LOW(-76)
	SBCI R31,HIGH(-76)
	CALL SUBOPT_0x3B
; 0000 028B         x = 11 + 21 * x;
	ADIW R30,11
	CALL SUBOPT_0x3C
; 0000 028C         glcd_circle(y, x, 6);
	LDI  R26,LOW(6)
	CALL _glcd_circle
; 0000 028D     }
_0x11D:
; 0000 028E }
	JMP  _0x212000E
; .FEND
;
;void init()
; 0000 0291 {
_init:
; .FSTART _init
; 0000 0292    // Variable used to store graphic display
; 0000 0293 // controller initialization data
; 0000 0294 GLCDINIT_t glcd_init_data;
; 0000 0295 
; 0000 0296 // Input/Output Ports initialization
; 0000 0297 // Port A initialization
; 0000 0298 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0299 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 029A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 029B PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 029C 
; 0000 029D // Port B initialization
; 0000 029E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 029F DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 02A0 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02A1 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 02A2 
; 0000 02A3 // Port C initialization
; 0000 02A4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02A5 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 02A6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02A7 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 02A8 
; 0000 02A9 // Port D initialization
; 0000 02AA // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02AB DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 02AC // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 02AD PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 02AE 
; 0000 02AF // Timer/Counter 0 initialization
; 0000 02B0 // Clock source: System Clock
; 0000 02B1 // Clock value: Timer 0 Stopped
; 0000 02B2 // Mode: Normal top=0xFF
; 0000 02B3 // OC0 output: Disconnected
; 0000 02B4 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 02B5 TCNT0=0x00;
	OUT  0x32,R30
; 0000 02B6 OCR0=0x00;
	OUT  0x3C,R30
; 0000 02B7 
; 0000 02B8 // Timer/Counter 1 initialization
; 0000 02B9 // Clock source: System Clock
; 0000 02BA // Clock value: Timer1 Stopped
; 0000 02BB // Mode: Normal top=0xFFFF
; 0000 02BC // OC1A output: Disconnected
; 0000 02BD // OC1B output: Disconnected
; 0000 02BE // Noise Canceler: Off
; 0000 02BF // Input Capture on Falling Edge
; 0000 02C0 // Timer1 Overflow Interrupt: Off
; 0000 02C1 // Input Capture Interrupt: Off
; 0000 02C2 // Compare A Match Interrupt: Off
; 0000 02C3 // Compare B Match Interrupt: Off
; 0000 02C4 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 02C5 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 02C6 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02C7 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02C8 ICR1H=0x00;
	OUT  0x27,R30
; 0000 02C9 ICR1L=0x00;
	OUT  0x26,R30
; 0000 02CA OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02CB OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02CC OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02CD OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02CE 
; 0000 02CF // Timer/Counter 2 initialization
; 0000 02D0 // Clock source: System Clock
; 0000 02D1 // Clock value: Timer2 Stopped
; 0000 02D2 // Mode: Normal top=0xFF
; 0000 02D3 // OC2 output: Disconnected
; 0000 02D4 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 02D5 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 02D6 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02D7 OCR2=0x00;
	OUT  0x23,R30
; 0000 02D8 
; 0000 02D9 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02DA TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 02DB 
; 0000 02DC // External Interrupt(s) initialization
; 0000 02DD // INT0: Off
; 0000 02DE // INT1: Off
; 0000 02DF // INT2: Off
; 0000 02E0 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 02E1 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 02E2 
; 0000 02E3 // USART initialization
; 0000 02E4 // USART disabled
; 0000 02E5 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 02E6 
; 0000 02E7 // Analog Comparator initialization
; 0000 02E8 // Analog Comparator: Off
; 0000 02E9 // The Analog Comparator's positive input is
; 0000 02EA // connected to the AIN0 pin
; 0000 02EB // The Analog Comparator's negative input is
; 0000 02EC // connected to the AIN1 pin
; 0000 02ED ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02EE SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02EF 
; 0000 02F0 // ADC initialization
; 0000 02F1 // ADC disabled
; 0000 02F2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02F3 
; 0000 02F4 // SPI initialization
; 0000 02F5 // SPI disabled
; 0000 02F6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02F7 
; 0000 02F8 // TWI initialization
; 0000 02F9 // TWI disabled
; 0000 02FA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02FB 
; 0000 02FC // Graphic Display Controller initialization
; 0000 02FD // The KS0108 connections are specified in the
; 0000 02FE // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 02FF // DB0 - PORTC Bit 0
; 0000 0300 // DB1 - PORTC Bit 1
; 0000 0301 // DB2 - PORTC Bit 2
; 0000 0302 // DB3 - PORTC Bit 3
; 0000 0303 // DB4 - PORTC Bit 4
; 0000 0304 // DB5 - PORTC Bit 5
; 0000 0305 // DB6 - PORTC Bit 6
; 0000 0306 // DB7 - PORTC Bit 7
; 0000 0307 // E - PORTB Bit 0
; 0000 0308 // RD /WR - PORTB Bit 1
; 0000 0309 // RS - PORTB Bit 2
; 0000 030A // /RST - PORTB Bit 4
; 0000 030B // CS1 - PORTB Bit 3
; 0000 030C // CS2 - PORTB Bit 5
; 0000 030D 
; 0000 030E // Specify the current font for displaying text
; 0000 030F glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0310 // No function is used for reading
; 0000 0311 // image data from external memory
; 0000 0312 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0313 // No function is used for writing
; 0000 0314 // image data to external memory
; 0000 0315 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0316 
; 0000 0317 glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0318 
; 0000 0319 
; 0000 031A }
	JMP  _0x2120009
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	JMP  _0x212000E
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x2
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x212000E:
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x36
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x3D
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x3D
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x3E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3F
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x3D
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3F
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3F
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x42
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x212000D
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x42
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x212000D:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G103:
; .FSTART _ks0108_enable_G103
	nop
	SBI  0x18,0
	nop
	RET
; .FEND
_ks0108_disable_G103:
; .FSTART _ks0108_disable_G103
	CBI  0x18,0
	CBI  0x18,3
	CBI  0x18,5
	RET
; .FEND
_ks0108_rdbus_G103:
; .FSTART _ks0108_rdbus_G103
	ST   -Y,R17
	RCALL _ks0108_enable_G103
	IN   R17,19
	CBI  0x18,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G103:
; .FSTART _ks0108_busy_G103
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,1
	CBI  0x18,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2060003
	SBI  0x18,3
	RJMP _0x2060004
_0x2060003:
	CBI  0x18,3
_0x2060004:
	SBRS R17,1
	RJMP _0x2060005
	SBI  0x18,5
	RJMP _0x2060006
_0x2060005:
	CBI  0x18,5
_0x2060006:
_0x2060007:
	RCALL _ks0108_rdbus_G103
	ANDI R30,LOW(0x80)
	BRNE _0x2060007
	LDD  R17,Y+0
	RJMP _0x212000A
; .FEND
_ks0108_wrcmd_G103:
; .FSTART _ks0108_wrcmd_G103
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G103
	CALL SUBOPT_0x43
	RJMP _0x212000A
; .FEND
_ks0108_setloc_G103:
; .FSTART _ks0108_setloc_G103
	__GETB1MN _ks0108_coord_G103,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G103
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G103
	__GETB1MN _ks0108_coord_G103,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G103,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G103
	RET
; .FEND
_ks0108_gotoxp_G103:
; .FSTART _ks0108_gotoxp_G103
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G103,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G103,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G103,2
	RCALL _ks0108_setloc_G103
	RJMP _0x212000A
; .FEND
_ks0108_nextx_G103:
; .FSTART _ks0108_nextx_G103
	LDS  R26,_ks0108_coord_G103
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G103,R26
	CPI  R26,LOW(0x80)
	BRLO _0x206000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G103,R30
_0x206000A:
	LDS  R30,_ks0108_coord_G103
	ANDI R30,LOW(0x3F)
	BRNE _0x206000B
	LDS  R30,_ks0108_coord_G103
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G103,2
	RCALL _ks0108_gotoxp_G103
_0x206000B:
	RET
; .FEND
_ks0108_wrdata_G103:
; .FSTART _ks0108_wrdata_G103
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G103,1
	RCALL _ks0108_busy_G103
	SBI  0x18,2
	CALL SUBOPT_0x43
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G103:
; .FSTART _ks0108_rddata_G103
	__GETB2MN _ks0108_coord_G103,1
	RCALL _ks0108_busy_G103
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,1
	SBI  0x18,2
	RCALL _ks0108_rdbus_G103
	RET
; .FEND
_ks0108_rdbyte_G103:
; .FSTART _ks0108_rdbyte_G103
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x44
	RCALL _ks0108_rddata_G103
	RCALL _ks0108_setloc_G103
	RCALL _ks0108_rddata_G103
	RJMP _0x212000A
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,4
	SBI  0x18,4
	SBI  0x17,3
	SBI  0x17,5
	RCALL _ks0108_disable_G103
	CBI  0x18,4
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,4
	LDI  R17,LOW(0)
_0x206000C:
	CPI  R17,2
	BRSH _0x206000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G103
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G103
	RJMP _0x206000C
_0x206000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x206000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20600AC
_0x206000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20600AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	CALL SUBOPT_0x39
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2060015
	LDI  R16,LOW(255)
_0x2060015:
_0x2060016:
	CPI  R19,8
	BRSH _0x2060018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G103
	LDI  R17,LOW(0)
_0x2060019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x206001B
	MOV  R26,R16
	CALL SUBOPT_0x45
	RJMP _0x2060019
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G103
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
_0x212000B:
	CALL __LOADLOCR4
_0x212000C:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x206001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x206001C
_0x206001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120006
_0x206001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G103
	MOV  R17,R30
	RCALL _ks0108_setloc_G103
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x206001F
	OR   R17,R16
	RJMP _0x2060020
_0x206001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2060020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G103
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120006
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRSH _0x2060022
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x2060021
_0x2060022:
	LDI  R30,LOW(0)
	RJMP _0x212000A
_0x2060021:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _ks0108_rdbyte_G103
	MOV  R1,R30
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2060024
	LDI  R30,LOW(1)
	RJMP _0x2060025
_0x2060024:
	LDI  R30,LOW(0)
_0x2060025:
_0x212000A:
	ADIW R28,2
	RET
; .FEND
_ks0108_wrmasked_G103:
; .FSTART _ks0108_wrmasked_G103
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G103
	MOV  R17,R30
	RCALL _ks0108_setloc_G103
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x206002B
	CPI  R30,LOW(0x8)
	BRNE _0x206002C
_0x206002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x206002D
_0x206002C:
	CPI  R30,LOW(0x3)
	BRNE _0x206002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2060030
_0x206002F:
	CPI  R30,0
	BRNE _0x2060031
_0x2060030:
_0x206002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2060032
_0x2060031:
	CPI  R30,LOW(0x2)
	BRNE _0x2060033
_0x2060032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2060029
_0x2060033:
	CPI  R30,LOW(0x1)
	BRNE _0x2060034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2060029
_0x2060034:
	CPI  R30,LOW(0x4)
	BRNE _0x2060029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2060029:
	MOV  R26,R17
	CALL SUBOPT_0x45
	LDD  R17,Y+0
_0x2120009:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2060037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2060037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2060037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2060036
_0x2060037:
	RJMP _0x2120008
_0x2060036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2060039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2060039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x206003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x206003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x206003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x206003F
	RJMP _0x2120008
_0x206003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2060042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2060041
	RJMP _0x2120008
_0x2060041:
_0x2060042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2060044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2060043
_0x2060044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x46
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2060046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2060048
	MOV  R17,R16
_0x2060049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206004B
	CALL SUBOPT_0x47
	RJMP _0x2060049
_0x206004B:
	RJMP _0x2060046
_0x2060048:
_0x2060043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x206004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x46
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x206004D
	SUBI R19,-LOW(1)
_0x206004D:
	LDI  R18,LOW(0)
_0x206004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2060050
	LDD  R17,Y+14
_0x2060051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2060053
	CALL SUBOPT_0x47
	RJMP _0x2060051
_0x2060053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x46
	RJMP _0x206004E
_0x2060050:
_0x206004C:
_0x206003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2060054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2060057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2060058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x206005D
	CPI  R30,LOW(0x3)
	BRNE _0x206005E
_0x206005D:
	RJMP _0x206005F
_0x206005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2060060
_0x206005F:
	RJMP _0x2060061
_0x2060060:
	CPI  R30,LOW(0x8)
	BRNE _0x2060062
_0x2060061:
	RJMP _0x2060063
_0x2060062:
	CPI  R30,LOW(0x6)
	BRNE _0x2060064
_0x2060063:
	RJMP _0x2060065
_0x2060064:
	CPI  R30,LOW(0x9)
	BRNE _0x2060066
_0x2060065:
	RJMP _0x2060067
_0x2060066:
	CPI  R30,LOW(0xA)
	BRNE _0x206005B
_0x2060067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x44
_0x206005B:
_0x2060069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x206006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x206006C
	RCALL _ks0108_rddata_G103
	RCALL _ks0108_setloc_G103
	CALL SUBOPT_0x48
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G103
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G103
	RJMP _0x206006D
_0x206006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2060071
	LDI  R21,LOW(0)
	RJMP _0x2060072
_0x2060071:
	CPI  R30,LOW(0xA)
	BRNE _0x2060070
	LDI  R21,LOW(255)
	RJMP _0x2060072
_0x2060070:
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2060079
	CPI  R30,LOW(0x8)
	BRNE _0x206007A
_0x2060079:
_0x2060072:
	CALL SUBOPT_0x4A
	MOV  R21,R30
	RJMP _0x206007B
_0x206007A:
	CPI  R30,LOW(0x3)
	BRNE _0x206007D
	COM  R21
	RJMP _0x206007E
_0x206007D:
	CPI  R30,0
	BRNE _0x2060080
_0x206007E:
_0x206007B:
	MOV  R26,R21
	CALL SUBOPT_0x45
	RJMP _0x2060077
_0x2060080:
	CALL SUBOPT_0x4B
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G103
_0x2060077:
_0x206006D:
	RJMP _0x2060069
_0x206006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2060081
_0x2060058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2060082
_0x2060057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2060083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2060084
_0x2060083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2060084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2060088
_0x2060089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x206008B
	CALL SUBOPT_0x4C
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x4D
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x48
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2060089
_0x206008B:
	RJMP _0x2060087
_0x2060088:
	CPI  R30,LOW(0x9)
	BRNE _0x206008C
	LDI  R21,LOW(0)
	RJMP _0x206008D
_0x206008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2060093
	LDI  R21,LOW(255)
_0x206008D:
	CALL SUBOPT_0x4A
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2060090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2060092
	CALL SUBOPT_0x4B
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G103
	RJMP _0x2060090
_0x2060092:
	RJMP _0x2060087
_0x2060093:
_0x2060094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2060096
	CALL SUBOPT_0x4E
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G103
	RJMP _0x2060094
_0x2060096:
_0x2060087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2060097
	RJMP _0x2060056
_0x2060097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2060098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20600AD
_0x2060098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20600AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2060082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x206009D
_0x206009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20600A0
	CALL SUBOPT_0x4C
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x4D
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x48
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x206009E
_0x20600A0:
	RJMP _0x206009C
_0x206009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20600A1
	LDI  R21,LOW(0)
	RJMP _0x20600A2
_0x20600A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20600A8
	LDI  R21,LOW(255)
_0x20600A2:
	CALL SUBOPT_0x4A
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20600A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20600A7
	CALL SUBOPT_0x4B
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G103
	RJMP _0x20600A5
_0x20600A7:
	RJMP _0x206009C
_0x20600A8:
_0x20600A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20600AB
	CALL SUBOPT_0x4E
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G103
	RJMP _0x20600A9
_0x20600AB:
_0x206009C:
_0x2060081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2060054
_0x2060056:
_0x2120008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x27
	CALL __CPW02
	BRLT _0x2080003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120002
_0x2080003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2080004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2120002
_0x2080004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x27
	CALL __CPW02
	BRLT _0x2080005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120002
_0x2080005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2080006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2120002
_0x2080006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120002
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	RJMP _0x2120002
; .FEND
_glcd_getcharw_G104:
; .FSTART _glcd_getcharw_G104
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x4F
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x208000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x208000B:
	CALL SUBOPT_0x50
	STD  Y+7,R0
	CALL SUBOPT_0x50
	STD  Y+6,R0
	CALL SUBOPT_0x50
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x208000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x208000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x208000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x208000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x208000E
	SUBI R20,-LOW(1)
_0x208000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x208000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120007
_0x208000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2080010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2080012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2080010
_0x2080012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G104:
; .FSTART _glcd_new_line_G104
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x51
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x4F
	SBIW R30,0
	BRNE PC+2
	RJMP _0x208001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2080020
	RJMP _0x2080021
_0x2080020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G104
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2080022
	CALL __LOADLOCR6
	RJMP _0x2120004
_0x2080022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	CALL SUBOPT_0x52
	__CPWRN 16,17,129
	BRLO _0x2080023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G104
_0x2080023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x51
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x51
	CALL SUBOPT_0x53
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x51
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x53
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2080024
_0x2080021:
	RCALL _glcd_new_line_G104
	CALL __LOADLOCR6
	RJMP _0x2120004
_0x2080024:
_0x208001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	RJMP _0x2120004
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2080025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2080027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2080025
_0x2080027:
	LDD  R17,Y+0
_0x2120006:
	ADIW R28,5
	RET
; .FEND
_glcd_putpixelm_G104:
; .FSTART _glcd_putpixelm_G104
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x208003E
	LDS  R30,_glcd_state
	RJMP _0x208003F
_0x208003E:
	__GETB1MN _glcd_state,1
_0x208003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2080041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2080041:
	LD   R30,Y
	RJMP _0x2120001
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2120002
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2080042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2080043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G104
	RJMP _0x2120005
_0x2080043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2080044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2080045
_0x2080044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2080045:
_0x2080047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2080049:
	CALL SUBOPT_0x54
	BRSH _0x208004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G104
	STD  Y+7,R30
	RJMP _0x2080049
_0x208004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2080047
	RJMP _0x208004C
_0x2080042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x208004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x208004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x208011B
_0x208004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x208011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2080051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2080053:
	CALL SUBOPT_0x54
	BRSH _0x2080055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x55
	STD  Y+7,R30
	RJMP _0x2080053
_0x2080055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2080051
	RJMP _0x2080056
_0x208004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2080057:
	CALL SUBOPT_0x54
	BRLO PC+2
	RJMP _0x2080059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x208005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x208005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x208005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x208005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G104
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x208005C
_0x208005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x56
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2080060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x57
_0x2080060:
	ST   -Y,R17
	CALL SUBOPT_0x55
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x208005E
	RJMP _0x2080061
_0x208005C:
_0x2080063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x56
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2080065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x57
_0x2080065:
	ST   -Y,R17
	CALL SUBOPT_0x55
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2080063
_0x2080061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2080057
_0x2080059:
_0x2080056:
_0x208004C:
_0x2120005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_plot8_G104:
; .FSTART _glcd_plot8_G104
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x52
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x58
	LDD  R30,Y+16
	CALL SUBOPT_0x59
	BREQ _0x2080073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2080075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x5A
	BRLT _0x2080077
	CALL SUBOPT_0x5B
	BRGE _0x2080078
_0x2080077:
	RJMP _0x2080076
_0x2080078:
_0x2080073:
	TST  R19
	BRMI _0x2080079
	CALL SUBOPT_0x5C
_0x2080079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x208007B
	__CPWRN 18,19,2
	BRGE _0x208007C
_0x208007B:
	RJMP _0x208007A
_0x208007C:
	CALL SUBOPT_0x5D
	BRNE _0x208007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x208007D:
_0x208007A:
_0x2080076:
_0x2080075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x208007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2080081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x5E
	BRLT _0x2080083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x5F
	BRGE _0x2080084
_0x2080083:
	RJMP _0x2080082
_0x2080084:
_0x208007F:
	CALL SUBOPT_0x60
	BRLO _0x2080085
	CALL SUBOPT_0x61
	BRNE _0x2080086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2080086:
_0x2080085:
_0x2080082:
_0x2080081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2080087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2080089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x208008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x5E
	BRLT _0x208008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x5F
	BRGE _0x208008E
_0x208008D:
	RJMP _0x208008C
_0x208008E:
_0x2080089:
	TST  R19
	BRMI _0x208008F
	CALL SUBOPT_0x5C
_0x208008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2080091
	__CPWRN 18,19,2
	BRGE _0x2080092
_0x2080091:
	RJMP _0x2080090
_0x2080092:
	CALL SUBOPT_0x5D
	BRNE _0x2080093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2080093:
_0x2080090:
_0x208008C:
_0x208008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2080095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2080097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x5A
	BRLT _0x2080099
	CALL SUBOPT_0x5B
	BRGE _0x208009A
_0x2080099:
	RJMP _0x2080098
_0x208009A:
_0x2080095:
	CALL SUBOPT_0x60
	BRLO _0x208009B
	CALL SUBOPT_0x61
	BRNE _0x208009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x208009C:
_0x208009B:
_0x2080098:
_0x2080097:
_0x2080087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x52
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x58
	LDD  R30,Y+15
	CALL SUBOPT_0x59
	BREQ _0x208009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20800A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20800A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20800A3
_0x20800A2:
	RJMP _0x20800A1
_0x20800A3:
_0x208009E:
	TST  R19
	BRMI _0x20800A4
	CALL SUBOPT_0x5C
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20800A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x62
	BRNE _0x20800A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20800A6:
_0x20800A5:
_0x20800A4:
_0x20800A1:
_0x20800A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20800A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20800AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x5A
	BRLT _0x20800AC
	CALL SUBOPT_0x5B
	BRGE _0x20800AD
_0x20800AC:
	RJMP _0x20800AB
_0x20800AD:
_0x20800A8:
	CALL SUBOPT_0x60
	BRLO _0x20800AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x63
	BRNE _0x20800AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20800AF:
_0x20800AE:
_0x20800AB:
_0x20800AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20800B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20800B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20800B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x5A
	BRLT _0x20800B6
	CALL SUBOPT_0x5B
	BRGE _0x20800B7
_0x20800B6:
	RJMP _0x20800B5
_0x20800B7:
_0x20800B2:
	TST  R19
	BRMI _0x20800B8
	CALL SUBOPT_0x5C
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20800BA
	__CPWRN 16,17,2
	BRGE _0x20800BB
_0x20800BA:
	RJMP _0x20800B9
_0x20800BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x62
	BRNE _0x20800BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20800BC:
_0x20800B9:
_0x20800B8:
_0x20800B5:
_0x20800B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20800BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20800C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x5E
	BRLT _0x20800C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x5F
	BRGE _0x20800C3
_0x20800C2:
	RJMP _0x20800C1
_0x20800C3:
_0x20800BE:
	CALL SUBOPT_0x60
	BRLO _0x20800C5
	__CPWRN 16,17,2
	BRGE _0x20800C6
_0x20800C5:
	RJMP _0x20800C4
_0x20800C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x63
	BRNE _0x20800C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20800C7:
_0x20800C4:
_0x20800C1:
_0x20800C0:
_0x20800B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G104:
; .FSTART _glcd_line2_G104
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_line
	CALL __LOADLOCR4
_0x2120004:
	ADIW R28,8
	RET
; .FEND
_glcd_quadrant_G104:
; .FSTART _glcd_quadrant_G104
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20800C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20800C8
_0x20800C9:
	RJMP _0x2120003
_0x20800C8:
	__GETBRMN 21,_glcd_state,8
_0x20800CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20800CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20800CE
	RJMP _0x2120003
_0x20800CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x20800D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20800D2
	CALL SUBOPT_0x64
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G104
	CALL SUBOPT_0x64
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G104
	RJMP _0x20800D3
_0x20800D2:
	CALL SUBOPT_0x64
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G104
_0x20800D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20800D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x208011C
_0x20800D4:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
_0x208011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20800D0
	RJMP _0x20800CB
_0x20800CD:
_0x2120003:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G104
	RJMP _0x2120001
; .FEND

	.CSEG

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120002:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120001
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120001
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120001
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120001
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120001
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120001:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D
_board:
	.BYTE 0x9
_comScore:
	.BYTE 0x2
_usrScore:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
_ks0108_coord_G103:
	.BYTE 0x3

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(15)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x3:
	LD   R30,Y
	LDS  R26,_board
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	__GETB2MN _board,1
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x6:
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x7:
	__GETB2MN _board,2
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	__GETB2MN _board,3
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x9:
	__GETB2MN _board,4
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xA:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	__GETB2MN _board,5
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xC:
	__GETB2MN _board,6
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	__GETB2MN _board,7
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xE:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xF:
	__GETB2MN _board,8
	LD   R30,Y
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x10:
	LD   R30,Y
	CALL __LNEGB1
	LDS  R26,_board
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:229 WORDS
SUBOPT_0x11:
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	__GETB2MN _board,1
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
	__GETB2MN _board,2
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	__GETB2MN _board,3
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x15:
	__GETB2MN _board,4
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	__GETB2MN _board,5
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x17:
	__GETB2MN _board,6
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	__GETB2MN _board,7
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x19:
	__GETB2MN _board,8
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	__MULBNWRU 16,17,3
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	ADD  R30,R18
	ADC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LD   R26,X
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x1F:
	LD   R30,Y
	CALL __LNEGB1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x22:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x23:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	LDD  R26,Y+4
	CALL _moveForWin
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDD  R26,Y+4
	CALL _moveForNotToLose
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL _randMove
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LD   R26,X
	CLR  R27
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x29:
	LDD  R30,Z+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2A:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+3
	LDI  R31,0
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+8
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	LD   R26,Y
	LDD  R27,Y+1
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDD  R30,Z+3
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2F:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+1
	LDI  R31,0
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x30:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	LDI  R31,0
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+8
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x31:
	LDD  R30,Z+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDD  R30,Z+8
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	ST   -Y,R26
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(3)
	CALL __MULB1W2U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	STD  Y+1,R30
	STD  Y+1+1,R31
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	STD  Y+3,R30
	STD  Y+3+1,R31
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
	CALL _ks0108_enable_G103
	JMP  _ks0108_disable_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	CALL _ks0108_wrdata_G103
	JMP  _ks0108_nextx_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x47:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x48:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G103
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4E:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x54:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G104

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x59:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5A:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x60:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x62:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x63:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
