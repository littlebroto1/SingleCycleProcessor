from model import model

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.types import *

@cocotb.test()
async def test4_17(dut):
    instruction = int(input("Input Instruction: "))
    instr = LogicArray(instruction, Range(31, 'downto', 0))
    Cond = instr[31:28]
    Op = instr[27:26]
    Funct = instr[25:20]
    Rd = instr[15:12]
    Flags = LogicArray(0,Range(3,'downto',0))
    dut.Cond.value = Cond
    dut.Op.value = Op
    dut.Funct.value = Funct
    dut.Rd.value = Rd
    dut.Flags.value = Flags
    await Timer(1, unit='ns')
