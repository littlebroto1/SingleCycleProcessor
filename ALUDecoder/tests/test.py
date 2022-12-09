from model import model

import cocotb
from cocotb.triggers import Timer
from cocotb.types import LogicArray, Logic, Range

@cocotb.test()
async def test_ALUDecoder(dut):
    ALUOp = [Logic(x) for x in range(0, 2)]
    cmd = [LogicArray(x, Range(3, 'downto', 0)) for x in range(0, 2**4)]
    S = [Logic(x) for x in range(0, 2)]
    
    for ALUOp in ALOp:
        for cmd in cmd:
            for S in S:
                dut.NoWrite.value = NoWrite
                dut.ALUControl.value = ALUControl
                dut.FlagW.value = FlagW
                dut.AddSrc.value = AddSrc

    modelResult = model(ALUOp, cmd, S)
    
    assert NoWrite == modelResult["NoResult"], f"HDL vs MODEL: {NoWrite} vs {int(modelResult['NoWrite'])}"
    assert ALUControl == modelResult["ALUControl"].integer, f"HDL vs MODEL: {NoWrite} vs {int(modelResult['NoWrite'])}"
    assert FlagW == modelResult["FlagW"].integer,
    assert AddSrc == modelResult["AddSrc"],
