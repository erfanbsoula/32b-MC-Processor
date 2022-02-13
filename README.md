# 32b-MC-Processor
32-bit Multi Cycle Processor (Computer Architecture Course)

## Instruction Set
* ### Data Processing
  | inst [31:30] | inst [29:24] | inst [23] | inst [22:20] | inst [19:16] | inst [15:12] | inst [11:0] |
  | :----------: | :----------: | :-------: | :----------: | :----------: | :----------: | :---------: |
  |      C       |    000000    |     I     |     opc      | #Register-A  | #Register-D  |     Op2     |

  * R-Type
    |   I   | Op2 [11:4] |  Op2 [3:0]  |
    | :---: | :--------: | :---------: |
    |   0   | don't care | #Register-B |

  * Immediate
    |   I   | Op2 [11:0] |
    | :---: | :--------: |
    |   1   | immediate  |

  |  opc  | Function | Description                |
  | :---: | :------: | :------------------------- |
  |  000  |   add    | Rd = Ra + Op2              |
  |  001  |   sub    | Rd = Ra - Op2              |
  |  010  |   rsb    | Rd = Ra - Op2              |
  |  011  |   and    | Rd = Ra & Op2              |
  |  100  |   not    | Rd = -Op2 (2's Comp.)      |
  |  101  |   tst    | set conditions on Ra & Op2 |
  |  110  |   cmp    | set conditions on Ra - Op2 |
  |  111  |   mov    | Rd = Op2                   |

* ### Data Transfer
  | inst [31:30] | inst [29:21] | inst [20] | inst [19:16] | inst [15:12] | inst [11:0] |
  | :----------: | :----------: | :-------: | :----------: | :----------: | :---------: |
  |      C       |  010000000   |     L     | #Register-A  | #Register-D  |   Offset    |

  |   L   | Function |     Description     |
  | :---: | :------: | :-----------------: |
  |   0   |   load   | Rd = Mem[Ra+Offset] |
  |   1   |  store   | Mem[Ra+Offset] = Rd |

* ### Branch Instruction
  | inst [31:30] | inst [29:27] | inst [26] | inst [25:0] |
  | :----------: | :----------: | :-------: | :---------: |
  |      C       |     101      |     L     |   Offset    |

  |   L   |  Function  | Description                             |
  | :---: | :--------: | :-------------------------------------- |
  |   0   |   branch   | jump to Offset+PC                       |
  |   1   | b and link | jump to Offset+PC, R15 = return address |

### Flags
The processor has 4 flags that get set with Data-Processing instructions according to the following table.

|     Flag     |  DP Instructions   |
| :----------: | :----------------: |
|   Z (zero)   |        all         |
|  C (carry)   | add, sub, rsb, cmp |
| N (ngative)  |        all         |
| V (overflow) | add, sub, rsb, cmp |

### Conditions
Every instruction has a C field (condition) that controls the execution of that instruction according to the following table.

|   C   |       Name        | Description                                                 |
| :---: | :---------------: | :---------------------------------------------------------- |
|  00   |    EQ (equal)     | Z set                                                       |
|  01   | GT (greater than) | Z clear, and either N set and V set, or N clear and V clear |
|  10   |  LT (less than)   | N set and V clear, or N clear and V set                     |
|  11   |    AL (always)    | always                                                      |