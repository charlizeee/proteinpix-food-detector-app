# ProteinPix

ProteinPix is a **mobile application** built with Flutter that uses a custom-trained **YOLOv11-based semantic segmentation model** to recognize and segment Filipino dishes from photos. The app estimates protein content and allows users to interact with editable segmentation results in real time.

---

## Features

- Real-time food recognition and semantic segmentation of 20 Filipino dishes  
- Protein estimation based on detected food items  
- Editable segmentation results to improve accuracy  
- On-device inference using TensorFlow Lite for fast performance (~1.2s per image)  
- Intuitive Flutter UI for seamless user experience  

---

## Technology Stack

- **Flutter:** Mobile app development framework  
- **PyTorch:** Model training and fine-tuning  
- **YOLOv11:** Custom semantic segmentation model architecture  
- **TensorFlow Lite:** Model conversion and on-device inference  
- **CVAT:** Data annotation and labeling tool  
- **Python:** Data preprocessing and model pipeline scripts  

---
