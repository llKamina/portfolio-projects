# ============================================================
# Fast ResNet18 CIFAR-10 Classifier 
# ============================================================

import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import transforms, models
from torchvision.datasets import CIFAR10
from torch.utils.data import DataLoader

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score,
    f1_score, confusion_matrix
)
from sklearn.preprocessing import label_binarize
from sklearn.metrics import precision_recall_curve

# ---------------------------
# Fast transforms 
# ---------------------------
transform_train = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomCrop(32, padding=4),
    transforms.ToTensor(),
    transforms.Normalize((0.4914, 0.4822, 0.4465),
                         (0.2023, 0.1994, 0.2010))
])

transform_test = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.4914, 0.4822, 0.4465),
                         (0.2023, 0.1994, 0.2010))
])

# ---------------------------
# Dataset
# ---------------------------
train_dataset = CIFAR10(root="./data", train=True, download=False, transform=transform_train)
test_dataset  = CIFAR10(root="./data", train=False, download=False, transform=transform_test)

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
test_loader  = DataLoader(test_dataset, batch_size=32, shuffle=False)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("Device:", device)

# ---------------------------
# EDA — Class Distribution
# ---------------------------
labels = np.array(train_dataset.targets)

plt.figure(figsize=(8, 5))
plt.hist(labels, bins=10, rwidth=0.8)
plt.title("CIFAR-10 Class Distribution")
plt.xlabel("Class ID")
plt.ylabel("Count")
plt.show()

# ---------------------------
# Build ResNet18 for CIFAR-10 (32 × 32)
# ---------------------------
model = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)

# Change the first conv layer to handle 32×32
model.conv1 = nn.Conv2d(3, 64, kernel_size=3, stride=1, padding=1, bias=False)
model.maxpool = nn.Identity()  # Remove pooling

# Replace final layer
model.fc = nn.Linear(model.fc.in_features, 10)

model = model.to(device)

# ---------------------------
# Loss, Optimizer, Scheduler
# ---------------------------
criterion = nn.CrossEntropyLoss()
optimizer = optim.AdamW(model.parameters(), lr=1e-4)
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.5)

# ---------------------------
# Evaluate function
# ---------------------------
def evaluate(loader):
    model.eval()
    preds, labels = [], []

    with torch.no_grad():
        for X, y in loader:
            X, y = X.to(device), y.to(device)
            outputs = model(X)
            predictions = torch.argmax(outputs, dim=1)
            preds.extend(predictions.cpu().numpy())
            labels.extend(y.cpu().numpy())

    acc = accuracy_score(labels, preds)
    prec = precision_score(labels, preds, average='weighted', zero_division=0)
    rec = recall_score(labels, preds, average='weighted', zero_division=0)
    f1 = f1_score(labels, preds, average='weighted', zero_division=0)

    return acc, prec, rec, f1, preds, labels

# ---------------------------
# Training Loop
# ---------------------------
num_epochs = 10
train_losses, val_accuracies = [], []

for epoch in range(num_epochs):
    model.train()
    total_loss = 0

    for X, y in train_loader:
        X, y = X.to(device), y.to(device)

        optimizer.zero_grad()
        outputs = model(X)
        loss = criterion(outputs, y)
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

    avg_loss = total_loss / len(train_loader)
    train_losses.append(avg_loss)

    acc, prec, rec, f1, _, _ = evaluate(test_loader)
    val_accuracies.append(acc)

    scheduler.step()

    print(f"Epoch {epoch+1}/{num_epochs} | Loss: {avg_loss:.4f} | Acc: {acc:.4f}")

# ---------------------------
# Final Results
# ---------------------------
test_acc, test_prec, test_rec, test_f1, preds, labels = evaluate(test_loader)

print("\n=== FINAL TEST PERFORMANCE ===")
print("Accuracy:", test_acc)
print("Precision:", test_prec)
print("Recall:", test_rec)
print("F1 Score:", test_f1)

# ---------------------------
# Confusion Matrix
# ---------------------------
cm = confusion_matrix(labels, preds)

plt.figure(figsize=(9,7))
sns.heatmap(cm, annot=True, fmt='d', cmap="Blues")
plt.title("Confusion Matrix – CIFAR-10")
plt.xlabel("Predicted")
plt.ylabel("True")
plt.show()

# ---------------------------
# Training Curves
# ---------------------------
plt.figure(figsize=(12,5))

plt.subplot(1,2,1)
plt.plot(train_losses)
plt.title("Training Loss Curve")

plt.subplot(1,2,2)
plt.plot(val_accuracies)
plt.title("Validation Accuracy Curve")

plt.show()