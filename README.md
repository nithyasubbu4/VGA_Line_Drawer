# VGA_Line_Drawer
This project implements a dynamic **house-drawing animation** on the **DE1-SoC FPGA** board, using VGA output to render lines and custom modules to manage screen clearing and button input. The shape is drawn line-by-line to form a house structure with a roof, showcasing animation sequencing and hardware state machine control.

---

## Project Overview

- **Objective:** Use VGA output to animate a house being drawn on screen line by line using a finite state machine.
- **Clear Functionality:** Pressing a button triggers a full screen clear using a `screen_clearer` module.
- **Custom Button Input:** Debounced user input using the `input_processing` module to ensure reliable button presses.
- **Pixel Drawing:** Uses a `line_drawer` and `VGA_framebuffer` to draw lines between coordinates.

---

## Key Features

- **FSM-Based Drawing**: Draws a square house and a triangular roof line-by-line.
- **Custom Clear Logic**: `screen_clearer` module allows visual reset of the screen with animated erasure.
- **Debounced Input**: `input_processing` cleans noisy button signals to ensure one-cycle triggers.
- **Coordinate Multiplexing**: Selects between drawing coordinates and clearing coordinates dynamically.
- **Fully Implemented in SystemVerilog**

---

## File Descriptions

| File                  | Description |
|-----------------------|-------------|
| `DE1_SoC_task2.sv`    | Top-level module: orchestrates VGA animation, FSM, and module connections |
| `screen_clearer.sv`   | Module that controls clearing the screen column by column |
| `input_processing.sv` | Debounces a button signal into a one-cycle pulse |
| `line_drawer.sv`      | Draws lines between two given points on VGA |
| `VGA_framebuffer.sv`  | Handles VGA pixel writing and framebuffer logic |

---

## Setup Instructions

1. Clone this repository to your machine.
2. Open the project in **Quartus Prime**.
3. Compile and program the **DE1-SoC** board.
4. Connect the VGA cable to the board to visualize the output.
5. Use:
   - `KEY[3]` to **reset the animation**
   - `KEY[0]` to **trigger a screen clear**
   - `SW[9]` to select the drawing color: `0 = black`, `1 = white`

---

## Hardware Requirements

- DE1-SoC FPGA board
- VGA monitor and cable
- Quartus Prime software (Intel FPGA)
- USB Blaster cable for programming

---

## Skills Demonstrated

- FSM (Finite State Machine) design in hardware
- VGA signal control and coordinate mapping
- Modular hardware design using SystemVerilog
- Custom timing and counter control for animation
- Button debounce and input cleaning
- Dynamic bus control for drawing vs clearing logic

---
