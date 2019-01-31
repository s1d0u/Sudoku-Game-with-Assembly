#
# automate.s ... on a 10 x 10 grid
# problème de croissance de cellules
# dans un espace limité
#

      .data

N:    .word 10  # nombre de lignes de la grille
M:    .word 10  # nombre de colonnes de la grille

iter: .word 4   # nombre d'iterations

grid:           # grille de cellules
      .byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
      .byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
      .byte 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
      .byte 0, 0, 1, 0, 1, 0, 0, 0, 0, 0
      .byte 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
      .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0
      .byte 0, 0, 0, 1, 0, 0, 1, 0, 0, 0
      .byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
      .byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
      .byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0

othergrid: .space 100

#
# Si vous avez d'autres déclarations que vous voulez 
# inclure et utiliser dans votre programme mettez les 
# en dessous entre les marqueurs indiqués
#
# VOS_DECLARATIONS_COMMENCENT_ICI
 size:    .word 10
	  .eqv data_size 1
espace:	  .asciiz  "  "
sdl:      .asciiz  "\n"
# VOS_DECLARAcTIONS_FINISSENT_ICI

      .text
      .globl main

### Votre fonction principale main doit être implémentée entre    ### 
### les marqueurs VOTRE_CODE_COMMENCE_ICI et VOTRE_CODE_FINI_ICI  ###

main:
# VOTRE_CODE_COMMENCE_ICI
	li $t0,0		#i=0
	li $t1,0 		#j=0
	
	loopADD:
	la $a0,grid		#base addresse
	lw $a1,size		#load la taille de la matrice 
	
	jal addresse 
	
	
	beq $t0,$zero,case1	#if i=0 goto case1
	
	beq $t1,9,case2		#if j=9 goto case2
	
	beq $t0,9,case3		#if j=9 goto case3
	
	beq $t0,9,etq		#if i=9 && j=9 goto case4
etq:    beq $t1,9,case4

	bge $t0,1,etc		#if 1=<i>=8 &&  1=<j>=8 goto case5
etc:	ble $t0,8,etc1
etc1:	bge $t1,1,etc2
etc2:	ble $t1,8,case5
	
	addi $t1,$t1,1      	#j++
	blt $t1,$a1,loopADD 	#j<10 
	
	mult $t1,$0         	#j=0
	
	addi $t0,$t0,1    	#i++
	blt $t0,$a1,loopADD 	#i<100
	
# VOTRE_CODE_FINI_ICI
   
   li $v0, 10       # exit code service 
   syscall          # for syscall

### Vos éventuelles fonctions doivent être implémentées en dessous !    ###
### entre les marqueurs VOTRE_CODE_COMMENCE_ICI et VOTRE_CODE_FINI_ICI  ###

# VOTRE_CODE_COMMENCE_ICI
addresse:
	mul $t2,$t0,$a1     	#t2= rowindex *collsize
	add $t2,$t2,$t1		#t2=t2+collindex	
	mul $t2,$t2,data_size	#*datasize
	add $t2,$t2,$a0		#+base addresse 
	
	lb $t3,($t2)
	jr $ra
#########################################################	
	case1:
	
	addi $t1,$t1,1  #i++
	jal addresse  	#goto 
	move $s1,$t3
	sgt $a0,$s1,$zero # si 
	
	addi $t0,$t0,1
	jal addresse
	move $s2,$t3
	sgt $a0,$s2,$zero
	
	addi $t1,$t1,1
	jal addresse 
	move $s3,$t3
	sgt $a0,$s3,$zero
	
	jal afficher 
	jal esspace
	
	subi $t1,$t1,2
	subi $t0,$t0,1
	jr $ra
	
####################################################################	
	case2:
	
	subi $t1,$t1,1
	jal addresse 
	move $s1,$t3
	sgt $a0,$s1,$zero
	
	addi $t0,$t0,1
	jal addresse
	move $s2,$t3
	sgt $a0,$s2,$zero
	
	addi $t1,$t1,1
	jal addresse 
	move $s3,$t3
	sgt $a0,$s3,$zero
	
	jal afficher 
	jal SDL
	
	subi $t0,$t0,1
	jr $ra
	
	jr $ra
###################################################################
	case3:
	addi $t1,$t1,1
	jal addresse 
	move $s1,$t3
	sgt $a0,$s1,$zero
	
	subi $t0,$t0,1
	jal addresse
	move $s2,$t3
	sgt $a0,$s2,$zero
	
	subi $t1,$t1,1
	jal addresse 
	move $s3,$t3
	sgt $a0,$s3,$zero
	
	jal afficher 
	jal esspace
	
	addi $t0,$t0,1
	jr $ra
	
###################################################################
	case4:
	subi $t1,$t1,1
	jal addresse 
	move $s1,$t3
	sgt $a0,$s1,$zero
	
	subi $t0,$t0,1
	jal addresse
	move $s2,$t3
	sgt $a0,$s2,$zero
	
	addi $t1,$t1,1
	jal addresse 
	move $s3,$t3
	sgt $a0,$s3,$zero
	
	jal afficher 
	jal esspace
	
	addi $t0,$t0,1
	jr $ra
	
###################################################################
case5:
	addi $t1,$t1,1
	jal addresse 
	move $s1,$t3
	sgt $a0,$s1,$zero
	
	addi $t0,$t0,1
	jal addresse
	move $s2,$t3
	sgt $a0,$s2,$zero
	
	subi $t1,$t1,1
	jal addresse 
	move $s3,$t3
	sgt $a0,$s3,$zero
	
	subi $t0,$t0,1
	jal addresse 
	move $s4,$t3
	sgt $a0,$s4,$zero
	
	jal afficher 
	jal esspace
	
	addi $t1,$t1,1
	jr $ra
	
###################################################################
	afficher :
	li $v0,1
	syscall
	jr $ra
	esspace:
	la $a0,espace
	li $v0,9
	syscall
	jr $ra
	SDL:
	la $a0,sdl
	li $v0,9
	syscall
	jr $ra
	
# VOTRE_CODE_FINI_ICI


