# Computer-Architecture
 Repository for Computer Architecture course at Olin College of Engineering

# Mini-Project 1
Mini Project 1 features a digital circuit used to drive the iceBlinkPico board through 6 seperate colors, taking 1 second to complete a full loop. Given the iceBlinkPico's 12MHz clock, each color is displayed for 2,000,000 cycles.

This is implemented with a finite-state machine, where each color configuration is a state. A clock cycle counter is used to determine when to switch states.

[LINK TO DEMO VIDEO](https://drive.google.com/file/d/1cO7hveJvfoo27snOOJCG3cbyO854D4y7/view?usp=sharing)

## State Machine Design

| State   | Red | Green | Blue |
|---------|-----|-------|------|
| RED     |  1  |   0   |  0   |
| YELLOW  |  1  |   1   |  0   |
| GREEN   |  0  |   1   |  0   |
| CYAN    |  0  |   1   |  1   |
| BLUE    |  0  |   0   |  1   |
| MAGENTA |  1  |   0   |  1   |

- Each state lasts for `COLOR_INTERVAL = 2,000,000` clock cycles (approximately 0.167s per state at 12MHz).
- The state transitions sequentially in the order listed above.

## cycle_color Module Description

The module includes the following:

Inputs -
- `clk`: System clock @ 12MHz

Outputs -
- `red`, `green`, `blue`: Control signals for the RGB LED

Internal Functionality -
- FSM managing color transitions
- A counter to keep track of number of clock cycles per state

## Usage

1. Press the `RST` switch on the iceBlinkPico's board while holding the `BOOT` switch.
2. Within the OSS CAD Suite environment, navigate to the `mini_project_1` folder and run the following:
```bash
make
make prog
```
3. If you wish to remove the built files afterwards, run:
```bash
make clean
```
 (if you are not on Windows, you'll have to uncomment the correct removal command in the Makefile)



