#from model import model

import cocotb
from cocotb.types import Range, LogicArray
from cocotb.binary import BinaryValue
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test4_17(dut):

    """Test that d propagates to q"""

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    # initialize memory
    instr = bytearray(1024)
    instr[0:4*7] = bytes.fromhex("e3a00001e1a00080e3a01000e5810004e5914004e0800004e1a00000")
    mem = bytearray(1024)

    dut.reset.value = 1
    await FallingEdge(dut.clk);
    dut.reset.value = 0

    dut.Instr.value = BinaryValue(bytes(instr[0:4]))
    await FallingEdge(dut.clk);

    while (True):
        PC = dut.PC.value

        print("\nPC: ", PC)

        instruction = instr[PC:PC+4]
        print("Instruction: ", instruction)

        dut.Instr.value = BinaryValue(bytes(instruction))

        Addr = dut.MemAddr.value
        WE = dut.MemWrite.value

        print("Addr: ", Addr)

        if (bool(WE) == True):
            mem[Addr:Addr+4] = dut.WriteData.value.buff

        dut.ReadData.value = BinaryValue(bytes(mem[Addr:Addr+4]))

        print(mem[0:16])
        
        if (instruction == bytearray(4)):
            break;

        await FallingEdge(dut.clk);
        

