# motospeedv40-re
Motospeed V40 Mouse Reverse Engineering

## Specifications

- **Manufacturer:** Mototech Technology Group Ltd
- **Optical Sensor:** Avago ADNS-3050 ([Datasheet](https://media.digikey.com/pdf/data%20sheets/avago%20pdfs/adns-3050.pdf))
- **MCU:** Holtek HT82F553 8-bit (No Datasheet)

## Protocol

### Commands

#### Command `0x28`: Init

- Activate DPI triggers: `{0xb2, 0x0d, 0x08, 0x78, 0x32, 0xe6, 0xee}`

#### Command `0x26`: General

- Change LED colors: `{0x95, 0xf5, 0x08, 0x80, 0x95, 0xa6, 0x36}`

    Structure: 24-bit color for each profile, with 4 total profiles.

### Mouse triggers

- Change of DPI's

    - Endpoint: `0x02`
    - Magic bytes: `{0x06, 0x07, 0x01}`

    The fourth byte is for the current DPI mode.

    Example Packet:
    ```
    06 07 01 04
    06 00 00 00
    ```

## DPI Levels

|Byte|DPI Value|
|----|---------|
|01  |      250|
|02  |      500|
|03  |      750|
|04  |     1000|
|05  |     1250|
|06  |     1500|
|07  |     1750|
|08  |     2000|
|09  |     2500|
|0A  |     3000|
|0B  |     3500|
|0C  |     4000|

**NOTE:** To disable the DPI profile, do a bitwise OR with the value and `0x80`, which in practice is the most significant bit. (e.g.:
enabled profile 1 is `0x01` and disabled profile 1 is `0x81`).