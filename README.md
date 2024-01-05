FFT Visualizer with Guitar Input
=====================================

Objective:
----------
Implement a Fourier Transform on an FPGA to visualize the frequency spectrum of a guitar's output. The objective is to display the played notes in real-time, leveraging FPGA efficiency for accurate and optimized processing.

Our Solution:
-------------
Integral to our system is a dedicated circuitry component that scales down the guitar signal to match the input range of the Analog-to-Digital Converter (ADC). This crucial step ensures precise and accurate digital conversion of the incoming analog signal, optimizing the dynamic range and enabling the FPGA to effectively capture and process the guitar's nuanced frequency components.

For the visualization aspect of this project, we employed a unique solution using 3D-printed chevrons attached to servos. These servos dynamically adjust the position of the chevrons based on the magnitude of specific frequencies detected through the Fourier Transform. As a result, users can visually interpret the varying amplitudes of different frequency components in the guitar's output.

The Fourier Transform functionality core is implemented through a dedicated FFT (Fast Fourier Transform) module instantiated on the FPGA. The code facilitating seamless communication between the FPGA and the FFT module is developed to ensure efficient and accurate frequency analysis. This module serves as the backbone of the frequency visualization system, delivering the necessary computational power to process incoming audio signals.

Additionally, to convert the computed magnitudes into actionable visual feedback, we integrated a Pulse Width Modulation (PWM) module. This module generates a PWM signal proportional to the magnitude of the detected frequency, allowing for a dynamic representation of the intensity of each note. By combining these elements – the 3D-printed chevrons controlled by servos, the FFT module for frequency analysis, and the PWM module for visual output – our solution provides a comprehensive and engaging means of visualizing the guitar's frequency spectrum in real-time.

Media:
------


Credits:
-------
**Kurt Querengesser**

Author of PWM code and Circuitry

[![Kurt Querengesser](https://media-exp1.licdn.com/dms/image/C5603AQGrgBTkykBlKQ/profile-displayphoto-shrink_200_200/0/1631942127837?e=1658361600&v=beta&t=vpEAgsTLOk_cjnBG9KAYYulb9IDrupyVI58InTzyYOE)](https://www.linkedin.com/in/kurt-querengesser/)



**Garnett Goodacre**

Author of FFT Code

[![Garnett Goodacre](https://media.licdn.com/dms/image/C5603AQFDvJeW3hdyWw/profile-displayphoto-shrink_800_800/0/1585168724073?e=1709769600&v=beta&t=it44ts5j02tkVfCLBlJQiF6Z_ANbabj0iYbrIEzTz00)](https://www.linkedin.com/in/garnett-goodacre-6b4708b9/)
