@ Copyright (c) 2019 Travis Bemann
@
@ This program is free software: you can redistribute it and/or modify
@ it under the terms of the GNU General Public License as published by
@ the Free Software Foundation, either version 3 of the License, or
@ (at your option) any later version.
@
@ This program is distributed in the hope that it will be useful,
@ but WITHOUT ANY WARRANTY; without even the implied warranty of
@ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@ GNU General Public License for more details.
@
@ You should have received a copy of the GNU General Public License
@ along with this program.  If not, see <http://www.gnu.org/licenses/>.

	@@ Assemble a move immediate instruction
	define_word "mov-imm,", visible_flag
_asm_mov_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, #7
	ands r0, r1
	movs r1, #0xFF
	ands tos, r1
	lsls r0, r0, #8
	orrs tos, r0
	ldr r0, =0x2000
	orrs tos, r0
	bl _current_comma_2
	pop {pc}	

	@@ Assemble a logical shift left immediate instruction
	define_word "lsl-imm,", visible_flag
_asm_lsl_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, #7
	ands r0, r1
	movs r1, #0xFF
	ands tos, r1
	lsls r0, r0, #8
	orrs tos, r0
	movs r1, tos
	pull_tos
	movs r0, #0x1F
	ands tos, r0
	lsls tos, tos, #6
	orrs tos, r1
	bl _current_comma_2
	pop {pc}	

	@@ Assemble an reverse subtract immediate from zero instruction
	define "neg,", visible_flag
_asm_neg:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, #7
	ands tos, r1
	ands r0, r1
	lsls tos, tos, #3
	orrs tos, r0
	ldr r0, =0x4240
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Compile a blx (register) instruction
	define_word "blx-reg,", visible_flag
_asm_blx_reg:
	push {rl}
	movs r0, #0xF
	ands tos, r0
	lsls tos, tos, #3
	ldr r0, =0x4780
	orrs tos, r0
	bl _current_comma_2
	pop {pc}
	
	.ifdef thumb2

	@@ Call a word at an address
	define_word "call,", visible_flag
_asm_call:	
	push {rl}
	bl _current_here
	movs r0, tos
	pull_tos
	movs r1, tos
	subs tos, tos, r0
	ldr r2, =0x00FFFFFF
	cmp tos, r2
	bgt 1f
	ldr r2, =0xFF000000
	cmp tos, r2
	blt 1f
	bl _asm_bl
	pop {pc}
1:	movs tos, r1
	adds tos, #1
	push_tos
	movs tos, #1
	bl _asm_literal
	push_tos
	movs tos, #1
	bl _asm_blx_reg
	pop {pc}
	
	@@ Compile a bl instruction
	define_word "bl,", visible_flag
_asm_bl:
	push {rl}
	movs r0, tos
	lsrs tos, tos, #12
	ldr r1, =0x3FF
	ands tos, r1
	lsls r1, r0, #24
	movs r2, #1
	ands r1, r2
	lsls r2, r1, #10
	orrs tos, r2
	ldr r2, =0xF000
	orrs tos, r2
	push {r0, r1}
	bl _current_comma_2
	pop {r0, r1}
	push_tos
	movs tos, r0
	lsrs tos, tos, #1
	ldr r2, =0x7FF
	ands tos, r2
	lsrs r2, r0, #22
	movs r3, #1
	ands r2, r3
	mvn r2, r2
	eor r2, r1
	ands r2, r3
	lsls r2, r2, #11
	orrs tos, r2
	lsrs r2, r0, #23
	ands r2, r3
	mvn r2, r2
	eor r2, r1
	ands r2, r3
	lsls r2, r2, #13
	orrs tos, r2
	ldr r2, =0xD000
	orrs tos, r2
	bl _current_comma_2
	pop {pc}

	@@ Compile a move 16-bit immediate instruction
	define_word "mov-16-imm,", visible_flag
_asm_mov_16_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, tos
	lsrs tos, tos, #11
	movs r5, #1
	ands tos, r5
	lsls tos, tos, #10
	movs r3, r1
	lsrs r3, r3, #12
	orrs tos, r3
	movs r3, #0xF240
	orrs tos, r3
	push {r0, r1}
	bl _current_comma_2
	pop {r0, r1}
	push_tos
	movs tos, r1
	movs r5, #0xFF
	ands tos, r5
	lsrs r1, r1, #8
	movs r5, #7
	ands r1, r5
	lsls r1, r1, #12
	orrs tos, r1
	movs r5, #0xF
	ands r0, r5
	lsls r0, r0, #8
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Compile a move top 16-bit immediate instruction
	define_word "movt-imm,", visible_flag
_asm_movt_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, tos
	lsrs tos, tos, #11
	movs r5, #1
	ands tos, r5
	lsls tos, tos, #10
	movs r3, r1
	lsrs r3, r3, #12
	orrs tos, r3
	ldr r3, =0xF2C0
	orrs tos, r3
	push {r0, r1}
	bl _current_comma_2
	pop {r0, r1}
	push_tos
	movs tos, r1
	movs r5, #0xFF
	ands tos, r5
	lsrs r1, r1, #8
	movs r5, #7
	ands r1, r5
	lsls r1, r1, #12
	orrs tos, r1
	movs r5, #0xF
	ands r0, r5
	lsls r0, r0, #8
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Assemble a literal
	define_word "literal,", visible_flag
_asm_literal:
	push {lr}
	movs r0, tos
	pull_tos
	cmp tos, #0
	blt 1f
	movs r5, #0xFF
	cmp tos, r5
	bgt 2f
	push_tos
	movs tos, r0
	bl _asm_mov_imm
	pop {pc}
2:	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm
	pop {pc}
1:	neg tos, tos
	movs r5, #0xFF
	cmp tos, r5
	bgt 3f
	push_tos
	movs tos, r0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	bl _asm_neg
	pop {pc}
3:	ldr r1, =0xFFFF
	cmp tos, r1
	bgt 4f
	push_tos
	movs tos, r0
	push {r0}
	bl _asm_ldr_long_imm
	pop {r0}
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	bl _asm_neg
	pop {pc}
4:	neg tos, tos
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm
	pop {pc}
	
	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm,", visible_flag
_asm_ldr_long_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, tos
	ldr r2, =0xFFFF
	ands tos, r2
	mov r2, #0xFF
	cmp tos, r2
	bgt 1f
	push_tos
	mov tos, r0
	push {r0, r1}
	bl _asm_mov_imm
	pop {r0, r1}
2:	ldr r2, =0x7FFF
	cmp r1, r2
	ble 3f
	push_tos
	movs tos, r1
	lsrs tos, tos, #16
	ands tos, r2
	push_tos
	movs tos, r0
	bl _asm_movt_imm
	pop {pc}
1:	push_tos
	movs tos, r0
	push {r0, r1}
	bl _asm_mov_16_imm
	pop {r0, r1}
	b 2b
3:	pop {pc}
	
	@@ Assemble an unconditional branch
	define_word "b,", visible_flag
_asm_b:	push {lr}
	ldr r0, =1023
	cmp tos, r0
	ble 1f
	ldr r0, =8388607
	cmp tos, r0
	ble 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-1024
	cmp tos, r0
	bge 3f
	ldr r0, =-8388608
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	bl _asm_b_32
3:	bl _asm_b_16
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq,", visible_flag
_asm_beq:
	push {lr}
	ldr r0, =127
	cmp tos, r0
	ble 1f
	ldr r0, =524287
	cmp tos, r0
	ble 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-128
	cmp tos, r0
	bge 3f
	ldr r0, =-524288
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	bl _asm_beq_32
3:	bl _asm_beq_16
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b-back!", visible_flag
_asm_b_back:
	push {lr}
	movs r1, tos
	pull_tos
	ldr r0, =8388607
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-8388608
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	push_tos
	movs tos, r1
	bl _asm_b_32_back
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-back!", visible_flag
_asm_beq_back:
	push {lr}
	movs r1, tos
	pull_tos
	ldr r0, =524287
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-524288
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	push_tos
	movs tos, r1
	bl _asm_beq_32_back
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b-32,", visible_flag
_asm_b_32:
	push {lr}
	movs r0, tos
	lsrs tos, tos, #11
	ldr r1, =0x3FF
	ands tos, r1
	lsrs r1, r0, #23
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #10
	orr tos, r1
	ldr r1, =0xF000
	orr tos, r1
	push {r0}
	bl _current_comma_2
	pop {r0}
	push_tos
	mov tos, r0
	ldr r1, =0x7FF
	ands tos, r1
	lsrs r1, r0, #21
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #11
	orr tos, r1
	lsrs r1, r0, #22
	ands r1, r2
	lsls r1, r1, #13
	orr tos, r1
	ldr r1, =0x9000
	orr tos, r1
	bl _current_comma_2
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-32,", visible_flag
_asm_beq_32:
	push {lr}
	push {lr}
	movs r0, tos
	lsrs tos, tos, #11
	ldr r1, =0x3FF
	ands tos, r1
	lsrs r1, r0, #19
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #10
	orr tos, r1
	ldr r1, =0xF000
	orr tos, r1
	push {r0}
	bl _current_comma_2
	pop {r0}
	push_tos
	mov tos, r0
	ldr r1, =0x7FF
	ands tos, r1
	lsrs r1, r0, #17
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #11
	orr tos, r1
	lsrs r1, r0, #18
	ands r1, r2
	lsls r1, r1, #13
	orr tos, r1
	ldr r1, =0x8000
	orr tos, r1
	bl _current_comma_2
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b-32-back!", visible_flag
_asm_b_32_back:
	push {lr}
	movs r3, tos
	pull_tos
	movs r0, tos
	lsrs tos, tos, #11
	ldr r1, =0x3FF
	ands tos, r1
	lsrs r1, r0, #23
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #10
	orr tos, r1
	ldr r1, =0xF000
	orr tos, r1
	push_tos
	movs tos, r3
	push {r0, r3}
	bl _store_current_2
	pop {r0, r3}
	push_tos
	mov tos, r0
	ldr r1, =0x7FF
	ands tos, r1
	lsrs r1, r0, #21
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #11
	orr tos, r1
	lsrs r1, r0, #22
	ands r1, r2
	lsls r1, r1, #13
	orr tos, r1
	ldr r1, =0x9000
	orr tos, r1
	push_tos
	movs tos, r3
	add tos, #2
	bls _store_current_2
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-32-back!", visible_flag
_asm_beq_32_back:
	push {lr}
	movs r3, tos
	pull_tos
	movs r0, tos
	lsrs tos, tos, #11
	ldr r1, =0x3FF
	ands tos, r1
	lsrs r1, r0, #19
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #10
	orr tos, r1
	ldr r1, =0xF000
	orr tos, r1
	push_tos
	movs tos, r3
	push {r0, r3}
	bl _store_current_2
	pop {r0, r3}
	push_tos
	mov tos, r0
	ldr r1, =0x7FF
	ands tos, r1
	lsrs r1, r0, #17
	movs r2, #1
	ands r1, r2
	lsls r1, r1, #11
	orr tos, r1
	lsrs r1, r0, #18
	ands r1, r2
	lsls r1, r1, #13
	orr tos, r1
	ldr r1, =0x8000
	orr tos, r1
	push_tos
	movs tos, r3
	adds tos, #2
	bl _store_current_2
	pop {pc}

	.else

	@@ Call a word at an address
	define_word "call,", visible_flag
_asm_call:	
	push {rl}
	bl _current_here
	movs r0, tos
	pull_tos
	movs r1, tos
	subs tos, tos, r0
	ldr r2, =0x003FFFFF
	cmp tos, r2
	bgt 1f
	ldr r2, =0xFFC00000
	cmp tos, r2
	blt 1f
	bl _asm_bl
	pop {pc}
1:	movs tos, r1
	adds tos, #1
	push_tos
	movs tos, #1
	bl _asm_literal
	push_tos
	movs tos, #1
	bl _asm_blx_reg
	pop {pc}

	@@ Compile a bl instruction
	define_word "bl,", visible_flag
_asm_bl:
	push {rl}
	movs r0, tos
	lsrs tos, tos, #12
	ldr r1, =0x7FF
	ands tos, r1
	ldr r2, =0xF000
	orrs tos, r2
	push {r0}
	bl _current_comma_2
	pop {r0}
	push_tos
	movs tos, r0
	lsrs tos, tos, #1
	ldr r2, =0x7FF
	ands tos, r2
	ldr r2, =0xF800
	orrs tos, r2
	bl _current_comma_2
	pop {pc}

	@@ Assemble a literal
	define_word "literal,", visible_flag
_asm_literal:
	push {lr}
	movs r0, tos
	pull_tos
	cmp tos, #0
	blt 1f
	movs r1, #0xFF
	cmp tos, r1
	bgt 2f
	push_tos
	movs tos, r0
	bl _asm_mov_imm
	pop {pc}
2:	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm
	pop {pc}
1:	neg tos, tos
	movs r0, #0xFF
	cmp tos, r0
	bgt 2f
	push_tos
	movs tos, r0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	bl _asm_neg
	pop {pc}
2:	push_tos
	movs tos, r0
	push {r0}
	bl _asm_ldr_long_imm
	pop {r0}
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	bl _asm_neg
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm,", visible_flag
_asm_ldr_long_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, tos
	lsrs r1, r1, #24
	bne 1f
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_1st_zero
	pop {pc}
1:	movs r2, tos
	mv tos, r1
	push_tos
	mv tos, r0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	movs r1, r2
	lsrs r1, r1, #16
	movs r3, #0xFF
	ands r1, r3
	bne 1f
	push_tos
	movs tos, r2
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_2nd_zero
	pop {pc}
1:	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r1, r2}
	bl _asm_lsl_imm
	pop {r0, r1, r2}
	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	movs r1, r2
	ldr r1, r1, #8
	movs r3, #0xFF
	ands r1, r3
	bne 1f
	push_tos
	movs tos, r2
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_3rd_zero
	pop {pc}
1:	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r1, r2}
	bl _asm_lsl_imm
	pop {r0, r1, r2}
	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-1st-zero,", visible_flag
_asm_ldr_long_imm_1st_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r2, tos
	movs r1, r2
	lsrs r1, r1, #16
	movs r3, #0xFF
	ands r1, r3
	bne 1f
	push_tos
	movs tos, r2
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_1st_2nd_zero
	pop {pc}
1:	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	movs r1, r2
	ldr r1, r1, #8
	movs r3, #0xFF
	ands r1, r3
	bne 1f
	push_tos
	movs tos, r2
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_1st_3rd_zero
	pop {pc}
1:	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r1, r2}
	bl _asm_lsl_imm
	pop {r0, r1, r2}
	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-2nd-zero,", visible_flag
_asm_ldr_long_imm_2nd_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, tos
	movs r1, r2
	ldr r1, r1, #8
	movs r3, #0xFF
	ands r1, r3
	bne 1f
	push_tos
	movs tos, r2
	push_tos
	movs tos, r0
	bl _asm_ldr_long_imm_2nd_3rd_zero
	pop {pc}
1:	push_tos
	movs tos, #16
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r1, r2}
	bl _asm_lsl_imm
	pop {r0, r1, r2}
	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-1st-2nd-zero,", visible_flag
_asm_ldr_long_imm_1st_2nd_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r2, tos
	movs r1, r2
	ldr r1, r1, #8
	movs r3, #0xFF
	ands r1, r3
	push_tos
	movs tos, r1
	push_tos
	movs tos, #0
	push {r0, r2}
	bl _asm_mov_imm
	pop {r0, r2}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_orr
	pop {r0, r2}
	push_tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-1st-3rd-zero,", visible_flag
_asm_ldr_long_imm_3rd_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r2, tos
	movs tos, #8
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-1st-3rd-zero,", visible_flag
_asm_ldr_long_imm_1st_3rd_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r2, tos
	movs tos, #16
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble a long load register immediate pseudo-opcode
	define_word "ldr-long-imm-2nd-3rd-zero,", visible_flag
_asm_ldr_long_imm_2nd_3rd_zero:
	push {lr}
	movs r0, tos
	pull_tos
	movs r2, tos
	movs tos, #24
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	push {r0, r2}
	bl _asm_lsl_imm
	pop {r0, r2}
	movs r3, #0xFF
	ands r2, r3
	bne 1f
	pop {pc}
1:	push_tos
	movs tos, r2
	push_tos
	movs tos, #0
	push {r0}
	bl _asm_mov_imm
	pop {r0}
	push_tos
	movs tos, #0
	push_tos
	movs tos, r0
	push_tos
	movs tos, r0
	bl _asm_orr
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b,", visible_flag
_asm_b:	push {lr}
	ldr r0, =1023
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-1024
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	bl _asm_b_16
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq,", visible_flag
_asm_beq:
	push {lr}
	ldr r0, =127
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-128
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	bl _asm_beq_16
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b-back!", visible_flag
_asm_b_back:
	push {lr}
	movs r1, tos
	pull_tos
	ldr r0, =1023
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-1024
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	push_tos
	movs tos, r1
	bl _asm_b_16_back
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-back!", visible_flag
_asm_beq_back:
	push {lr}
	movs r1, tos
	pull_tos
	ldr r0, =127
	cmp tos, r0
	ble 1f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
1:	ldr r0, =-128
	cmp tos, r0
	bge 2f
	ldr tos, =_out_of_range_branch
	bl _raise
	pop {pc}
2:	push_tos
	movs tos, r1
	bl _asm_beq_16_back
	pop {pc}

	.endif

	@@ Out of range branch exception
	define_word "out-of-range-branch", visible_flag
_out_of_range_branch:
	b . @ implement later
	
	@@ Assemble an unconditional branch
	define_word "b-16,", visible_flag
_asm_b_16:
	push {lr}
	ldr r0, =0xE000
	ldr r1, =0x7FF
	ands tos, r1
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-16,", visible_flag
_asm_beq_16:
	push {lr}
	ldr r0, =0xD000
	movs r1, #0xFF
	ands tos, r1
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Assemble an unconditional branch
	define_word "b-16-back!", visible_flag
_asm_b_16_back:
	push {lr}
	movs r2, tos
	pull_tos
	ldr r0, =0xE000
	ldr r1, =0x7FF
	ands tos, r1
	orrs tos, r0
	push_tos
	movs tos, r2
	bl _store_current_2
	pop {pc}

	@@ Assemble a branch on equal zero instruction
	define_word "beq-16-back!", visible_flag
_asm_beq_16_back:
	push {lr}
	movs r2, tos
	pull_tos
	ldr r0, =0xD000
	movs r1, #0xFF
	ands tos, r1
	orrs tos, r0
	push_tos
	movs tos, r2
	bl _store_current_2
	pop {pc}

	@@ Assemble a compare to immediate instruction
	define_word "cmp-imm,", visible_flag
_asm_cmp_imm:
	push {lr}
	movs r0, tos
	pull_tos
	movs r1, #7
	ands r0, r1
	movs r1, #0xFF
	ands tos, r1
	lsls r0, r0, #8
	orrs tos, r0
	ldr r0, =0x2800
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Assemble a logical shift left immediate instruction
	define_word "lsl-imm,", visible_flag
_asm_lsl_imm:
	push {lr}
	movs r0, tos
	movs r1, #7
	ands r0, r1
	pull_tos
	ands tos, r1
	lsls tos, tos, #3
	orrs r0, tos
	pull_tos
	movs r1, #0x1F
	ands tos, r1
	lsls tos, tos, #6
	orrs tos, r0
	bl _current_comma_2
	pop {pc}

	@@ Assemble an or instruction
	define_word "orr,", visible_flag
_asm_orr:
	push {lr}
	movs r1, #7
	ands tos, r1
	movs r0, tos
	pull_tos
	ands tos, r1
	lsls tos, tos, #3
	orrs tos, r0
	movs r0, #0x43
	lsls r0, r0, #8
	orrs tos, r0
	bl _current_comma_2
	pop {pc}
