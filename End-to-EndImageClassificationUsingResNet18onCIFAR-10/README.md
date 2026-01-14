# 🧠 End-to-End Image Classification using ResNet18 on CIFAR-10

This project implements a complete **deep learning pipeline** for image classification using a **customized ResNet18 model** trained on the CIFAR-10 dataset. It covers data preprocessing, model modification, training, evaluation, and visualization of results.

---

## 📌 Project Overview

The goal of this project is to build an efficient image classifier using **ResNet18**, originally trained on ImageNet, and adapt it for the **32×32 CIFAR-10 images**.  
The pipeline includes:

- Data augmentation
- Transfer learning with a modified ResNet18
- Training with AdamW optimizer + StepLR scheduler
- Full evaluation (accuracy, precision, recall, F1-score)
- Confusion matrix visualization
- Training/validation curves

---

## 🗂 Dataset — CIFAR-10

CIFAR-10 contains **60,000 images** across **10 classes**:

✈ airplane  
🚗 automobile  
🐦 bird  
🐱 cat  
🦌 deer  
🐶 dog  
🐸 frog  
🐴 horse  
🚢 ship  
🚚 truck  

Each image is **32×32 pixels** and **RGB**.

---

## 🔧 Technologies & Libraries Used

- **Python**
- **PyTorch**
- **Torchvision**
- **NumPy**
- **Matplotlib**
- **Seaborn**
- **Scikit-learn**

---

## 🚀 Model Architecture

This project uses **ResNet18**, modified to fit CIFAR-10:

### ✔ Updated first convolution layer
Adapted from ImageNet (224×224) to CIFAR-10 (32×32):

```python
model.conv1 = nn.Conv2d(3, 64, kernel_size=3, stride=1, padding=1, bias=False)
```

### ✔ Removed max-pooling layer
Improves feature extraction for small images:

```python
model.maxpool = nn.Identity()
```

### ✔ Replaced the final fully connected layer

```python
model.fc = nn.Linear(model.fc.in_features, 10)
```

### 🔁 Training Pipeline
- **Optimizer: AdamW (lr = 1e-4)**

- **Loss function: CrossEntropyLoss**

- **Scheduler: StepLR (step_size=5, gamma=0.5)**

- **Epochs: 10**

- **Batch size: 32**

- **Data Augmentation:**

    - **Random Horizontal Flip**

    - **Random Crop**

    - **Normalization**

### 📊 Evaluation Metrics
During evaluation, the following metrics are computed:

- **Accuracy**

- **Precision (weighted)**

- **Recall (weighted)**

- **F1-score (weighted)**

A confusion matrix is also generated to visualize classification errors.

### 📈 Visualizations
### ✔ Class Distribution
Histogram of CIFAR-10 training labels.

### ✔ Training Curves
- **Loss per epoch**

- **Validation accuracy curve**

### ✔ Confusion Matrix
Heatmap displaying predictions vs. true labels.

### 🏁 Final Performance (Example Output)
Performance depends on hardware and randomness, but ResNet18 typically achieves:

- **Accuracy: ~90%**

- **Precision: ~90%**

- **Recall: ~90%**

- **F1-score: ~90%**

This shows that the model successfully learns all CIFAR-10 classes with high accuracy.

### 📁 Project Structure
Project405.py         # Full training/evaluation pipeline

/data                 # CIFAR-10 dataset (auto-downloaded)

### ▶ How to Run
Install dependencies:

pip install torch torchvision matplotlib seaborn scikit-learn

Run the script:

python Project405.py