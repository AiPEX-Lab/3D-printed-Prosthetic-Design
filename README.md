# 3D-printed-Prosthetic-Design
This repository contains open-source data and code for 3D-printed prosthetic design research.

# Digital Reconstruction
## Overall Pipeline
All code for 3D reconstruction is in "3D reconstruction code" folder.

Target video → Extract images → Remove background → Reconstruction via Neuralangelo → Post-processing → Final Mesh

## Taking Videos
Taking a good-quality video is an essential part of 3D reconstruction.
You can look at our open-access journal paper for video guidelines [1].

## Execution of the Pipeline
To run the process for any image, run the following command:
```
bash automate.sh video_name.mp4
```

The above command should run the entire pipeline and generate a mesh in the current working directory. Just so you know, this whole process can take about 24 hours.
In the scenario that you are doing anything via ssh, it is best to be able to run the above command with nohup in case your connection times out. To do that, do the following:
```
nohup bash automate.sh video_name.mp4 > logfile.log 2>&1 &
```

If you have a connection reset and you log in to the remote workstation to see the state of your training, run:
```
tail -f -n 1 /path/to/your/logfile.log
```

# Mechanical Prediction of 3D-printed shell

# Citations
Please cite the following papers when using the provided data and code.

[1] Lee, J., Nkama, C., Yusuf, H., Maina, J., Ikuzwe, J., Byiringiro, J., Busogi, M., and Tucker, C. S. (January 23, 2025). "Accessible Digital Reconstruction and Mechanical Prediction of 3D-Printed Prosthetics." ASME. J. Mech. Des. doi: https://doi.org/10.1115/1.4067716

[2] Lee, J, Nkama, C, Yusuf, H, Maina, J, Ikuzwe, J, Byiringiro, J, Busogi, M, & Tucker, C. "Increasing Accessibility of 3D-Printed Customized Prosthetics in Resource-Constrained Communities." Proceedings of the ASME 2024 International Design Engineering Technical Conferences and Computers and Information in Engineering Conference. Volume 3B: 50th Design Automation Conference (DAC). Washington, DC, USA. August 25–28, 2024. V03BT03A024. ASME. https://doi.org/10.1115/DETC2024-143810
