# Acoustic-Estimation-of-Volume

This repository complements the project presented in the paper *Liquid Volume Estimation in Glass Containers*. The project investigates a 
non-invasive method for estimating the liquid volume in a glass container by analyzing the sound frequencies emitted when the container is excited. 

The method is described in detail in the associated paper and implemented for two specific container types, which are also described in the paper: 
Type A (milk bottles) and Type B (random bottles).

## MATLAB Scripts:
1. **LiveVolumeEstimation_typeA.m**  
   Real-time volume estimation, Type A containers

2. **LiveVolumeEstimation_typeB.m**  
   Real-time volume estimation, Type B containers

3. **convert_f_to_V_typeA.m**  
   Converts the resonant frequency to liquid volume using the transfer function, Type A containers

4. **convert_f_to_V_typeB.m**  
   Converts the resonant frequency to liquid volume using the transfer function, Type B containers

5. **addToBuffer.m**  
   A helper function for managing circular buffers during real-time processing

6. **ExtractBottleVolumeAndFrequency.m**  
   Analyzes recorded audio files to determine resonant frequencies and their corresponding volumes

7. **BandPass.m**  
   Applies a bandpass filter to isolate relevant frequency ranges in time domain audio signal

8. **FindDominantFrequency.m**  
   Identifies the frequency with the highest amplitude (resonant frequency) from the spectrum

9. **pair_f_and_V_typeA.m**  
   Establishes the transfer function between frequency and volume, Type A containers

10. **pair_f_and_V_typeB.m**  
   Establishes the transfer function between frequency and volume, Type B containers

## Demonstration

   A video demonstrating the proposed real time volume estimation method is available on YouTube: (https://youtu.be/X6KOk0fO4MQ). Additionaly, an example of using milk bottles to play the melody of *Ovčáci, čtveráci* is also available on YouTube: (https://youtube.com/shorts/pi8bOXCfTYk?feature=share).

## Usage

### Real Time Volume Estimation:
1. Run `LiveVolumeEstimation_typeA.m` or `LiveVolumeEstimation_typeB.m` in MATLAB.
2. Tap the container (e.g., with a wooden spoon) to excite sound.
3. The estimated volume will be automatically displayed in real time.

### Extending to New Container Types:
You can also use the provided scripts to estimate liquid volumes of other types of containers. To do this:
- Define a new transfer function (e.g., `pair_f_and_V_newContainer.m`).
- Update the scripts accordingly to include the new container type.

## Notes
- For further details, refer to the paper included in this repository.
