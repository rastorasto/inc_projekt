# INC — UART Receiver (VHDL)

A UART receiver (serial to parallel) in VHDL.

- `uart_rx.vhd` — datapath (shift register + counters)
- `uart_rx_fsm.vhd` — 5-state FSM sampling mid-bit
- Hand-drawn FSM diagram + GTKWave screenshot included
- GHDL test harness under `test/`

Coursework for *Návrh číslicových systémů (INC)* at FIT VUT Brno.
