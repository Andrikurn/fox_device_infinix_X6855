## OrangeFox device tree for Infinix Note 50 Pro 4G (_X6855_)

## Device picture

<p align="left" width="100%">
<img width="33%" src="https://fdn2.gsmarena.com/vv/pics/infinix/infinix-note50-pro-2.jpg"> 
</p>

## Device specifications

Device                  | Infinix Note 50 Pro 4G
-----------------------:|:-----------------------------------------
SoC                     | Mediatek Helio G100 Ultimate (6 nm)
CPU                     | Octa-core (2x2.2 GHz Cortex-A76 & 6x2.0 GHz Cortex-A55)
GPU                     | Mali-G57 MC2
Memory                  | 8/12 GB RAM
Storage                 | 256 GB (UFS 2.2)
MicroSD                 | None
Shipped Android Version | 15.0
Battery                 | Non-removable 5200 mAh
Display                 | 1080 x 2436 pixels (~393 ppi density), 6.78 inches
Camera                  | 50 MP (wide); 8 MP (front, ultrawide)

## Features

- [ ] ADB
- [ ] Decryption
- [ ] Display
- [ ] Fasbootd
- [ ] Flashing
- [ ] MTP
- [ ] Sideload
- [ ] USB OTG
- [ ] Vibrator
- [ ] MicroSD

## Building

Sync OrangeFox 14.1 Manifest:

```
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./orangefox_sync.sh --branch 14.1 --path "~/YOUR/PATH/HERE"
```

Clone the device tree:

```
cd ~/YOUR/PATH/HERE
git clone https://github.com/Andrikurn/fox_device_infinix_X6855.git -b fox_14.1 ./device/infinix/X6855
```

Build:

```
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch fox_X6855-ap2a-eng && mka adbd vendorbootimage
```
