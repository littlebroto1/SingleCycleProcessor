#from model import model

import cocotb
from cocotb.types import Range, LogicArray
from cocotb.binary import BinaryValue
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test4_17(dut):

    """Single Cycle Processor"""

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    print("\n### SINGLE CYCLE PROCESSOR GROUP 1 ###")

    # initialize memory
    instr = bytearray(1024)
    instr[0:4*5] = bytes.fromhex("e3a03000e3a01004e5831008e5934008e0840004")
    #instr[0:4] = bytes.fromhex("e3a03000")
    mem = bytearray(1024)

    dut.reset.value = 1
    await FallingEdge(dut.clk);
    dut.reset.value = 0

    # dut.Instr.value = BinaryValue(bytes(instr[0:4]))
    # await FallingEdge(dut.clk);

    while (True):
        PC = dut.PC.value

        print("\nPC:\t\t", PC.buff.hex())

        instruction = instr[PC:PC+4]
        print("Instruction:\t", bytes(instruction).hex())

        dut.Instr.value = BinaryValue(bytes(instruction))

        Addr = dut.MemAddr.value
        WE = dut.MemWrite.value

        if (bool(WE) == True):
            mem[Addr:Addr+4] = dut.WriteData.value.buff

        if (Addr.is_resolvable):
            print("MemAddr:\t", Addr.buff.hex())
            dut.ReadData.value = BinaryValue(bytes(mem[Addr:Addr+4]))

        print("Memory [0 to 16]:\n" + mem[0:16].hex('\n',4))
        
        if (instruction == bytearray(4)):
            break;

        await FallingEdge(dut.clk);
        
    print("\n\n")
    #print("\n\nR0: ", dut.dp.rf.__getattr__('rf[0]').value.integer)

