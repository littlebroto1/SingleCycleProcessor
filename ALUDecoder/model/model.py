from typing import Tuple
from cocotb.types import LogicArray, Logic, Range

def model(ALUOp: Logic, cmd: LogicArray, S: Logic):
    """model of ALUDecoder"""
    
    # outputs
    NoWrite = Logic(0)
    ALUControl = LogicArray(0, Range(1, "downto", 0))
    FlagW = LogicArray(0, Range(1, "downto", 0))
    AddSrc = logic(0)
    
    if (bool(ALUOp) == False):
       return [ALUControl, FlagW, NoWrite]
    else :
       switch(cmd):
            case LogicArray('0100'): # add
                ALUControl = LogicArray('00')
                FlagW = bool(S) ? LogicArray('11') : LogicArray('00')
                NoWrite = Logic(0)
                break
            case LogicArray('0010'): # sub
                ALUControl = LogicArray('01')
                FlagW = bool(S) ? LogicArray('11') : LogicArray('00')
                NoWrite = Logic(0)
                break
            case LogicArray('1100'): # orr
                ALUControl = LogicArray('11')
                FlagW = bool(S) ? LogicArray('10') : LogicArray('00')
                NoWrite = Logic(0)
                break
            case LogicArray('0000'): # and
                ALUControl = LogicArray('10')
                FlagW = bool(S) ? LogicArray('10') : LogicArray('00')
                NoWrite = Logic(0)
                break
            case default:
                ALUControl = LogicArray('00')
                FlagW = LogicArray('00')
                break
    
    NoWrite = (cmd == LogicArray('1010')) & ALUOp
    AddSrc = (cmd == LogicArray('1101')) & ALUOp
    
    return {"FlagW":FlagW, "NoWrite":NoWrite, "ALUControl":ALUControl, "AddSrc":AddSrc}
