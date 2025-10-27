# 🚗 Road Fighter Game — FPGA Implementation (COL215 Lab 8)

## 🎯 Overview
This project implements a **car racing arcade game** called *Road Fighter* on the **Basys3 FPGA board**, using **Verilog HDL**.  
The objective is to integrate **VGA display control**, **sprite animation**, and **finite-state machine (FSM)** logic for interactive gameplay.

> Developed as part of **COL215: Digital Logic and System Design (IIT Delhi)**, Semester I, 2025-26.

---

## ⚙️ System Design
The project consists of three main parts, each building upon the previous stage.

### 🧩 Part I — Displaying Images via VGA
- Configures VGA for 640×480 resolution using `VGA_driver.v`.
- Displays background and car sprites from ROMs initialized with COE files:
  - `bg_rom` → background (`bg1_testing.coe`, 12-bit, depth 38400)
  - `main_car_rom` → main car (`main_car_testing.coe`, 12-bit, depth 224)
- Removes the pink background from the red car using transparency logic:
  ```verilog
  if (main_car_color == 12'b101000001010)  // pink
      vgaRGB = bg_color;
  else
      vgaRGB = main_car_color;
  ```
- Verified through simulation (HSYNC and VSYNC timing) and synthesized for Basys3.

---

### 🎮 Part II — Car Movement and Collision Detection
Implements interactive **car movement** and **collision detection** using push buttons.

#### Inputs
| Button | Function |
|---------|-----------|
| `BTNL` | Move car left |
| `BTNR` | Move car right |
| `BTNC` | Restart game (reset FSM) |

#### FSM States
| State | Description |
|--------|-------------|
| `START` | Game initialization |
| `IDLE` | Car stationary within road bounds |
| `RIGHT_CAR` | Moving right |
| `LEFT_CAR` | Moving left |
| `COLLIDE` | Collision detected — Game Over |

#### Collision Logic
Road boundaries (in VGA coordinates):
```
Left  boundary: x = 244
Right boundary: x = 318
Collision if:
car_x < 244 OR car_x + 14 > 318
```

FSM transitions are based on push-button input and collision flags.

---

### 🏎️ Part III — Rival Car (Bonus)
Adds a **rival car** that appears at the top and moves downward continuously.

#### Features
- Random horizontal position between 44 and 104 pixels (using 8-bit **LFSR**).
- Vertical movement synchronized with VGA frame refresh.
- Collision detection between player and rival cars using bounding box overlap.
- Re-spawn from top after leaving the bottom or on no-collision.

#### LFSR Logic
Implements pseudo-random number generation:
```verilog
always @(posedge clk or posedge reset) begin
    if (reset)
        rand_val <= SEED;
    else
        rand_val <= {rand_val[6:0], rand_val[7] ^ rand_val[5] ^ rand_val[4] ^ rand_val[3]};
end
```
- Seed = bitwise XOR of 8 LSBs from Kerberos ID(s).
- Output range scaled to (44–104) for rival car’s X-coordinate.

---

## 🧠 Design Modules
| Module | Description |
|---------|-------------|
| `VGA_driver.v` | VGA signal generation (HSYNC, VSYNC, pixel clock) |
| `Display_sprite.v` | Top-level module handling image display |
| `bg_rom` / `main_car_rom` / `rival_car_rom` | Sprite ROMs initialized from COE files |
| `car_fsm.v` | Controls player car movement and collision |
| `lfsr_random.v` | Generates pseudo-random numbers |
| `debounce.v` | Cleans push-button signals |
| `top.v` | Integrates all modules |

---

## 🧪 Simulation and Testing
- Simulated using **Vivado simulator** and **EDAPLAYGROUND**.
- Verified VGA sync pulse intervals and FSM transitions.
- Tested hardware implementation on **Basys3** with external VGA monitor.

---

## 🧰 Implementation Details
- **Resolution:** 640×480  
- **Color depth:** 12-bit RGB (4 bits per color)  
- **ROM type:** Single-port distributed memory  
- **Clock frequency:** 25 MHz pixel clock  
- **FSM:** Moore-type with synchronous reset  

---

## 🧾 File List
| File | Purpose |
|------|----------|
| `VGA_driver.v` | VGA timing generator |
| `Display_sprite.v` | Top module for VGA display |
| `bg_rom.v` | Background image ROM |
| `main_car_rom.v` | Player car sprite ROM |
| `rival_car_rom.v` | Rival car sprite ROM |
| `car_fsm.v` | FSM for car movement |
| `lfsr_random.v` | 8-bit pseudo-random generator |
| `debounce.v` | Button debouncing |
| `top.v` | Integration module |
| `basys3.xdc` | Pin constraints for VGA and buttons |

---

## 💡 How to Run
1. Open **Vivado** → Create a new project → Add all `.v` source files.  
2. Add constraint file `basys3.xdc`.  
3. Generate and initialize ROMs using `.coe` files.  
4. Run **Synthesis** → **Implementation** → **Generate Bitstream**.  
5. Load the `.bit` file to **Basys3 board**.  
6. Connect VGA output → Observe the game on monitor.  

---

## 🧱 Bonus Design Features
- Smooth pixel-based movement for animation.
- Transparent overlay rendering for sprites.
- Modular FSM with debounced input.
- Frame-synchronized rival car descent.

---

## 👨‍💻 Author
**Name:** Aryan Patel  
**Course:** COL215 – Digital Logic and System Design  
**Institution:** Indian Institute of Technology, Delhi  
