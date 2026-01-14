# 📰 Text Classification Using Naive Bayes  
### Arabic News Classification — Economy vs Sports

This project implements an end-to-end **Arabic text classification system** using a **Naive Bayes classifier**.  
The model is trained to distinguish between two categories of Arabic news articles:

- **Economy**
- **Sports**

The system covers data extraction from HTML files, text preprocessing, TF-IDF feature extraction, model training, and automated predictions on unseen test files.

---

## 📌 Project Overview

The goal of this project is to build a **lightweight, efficient, and accurate text classifier** specifically designed for Arabic content.  
Key components include:

- Extracting Arabic text from **Windows-1256 encoded HTML files**
- Cleaning and preprocessing text using Arabic-specific rules
- Removing stopwords using an Arabic stopword list
- Converting text into TF-IDF features
- Training a **Multinomial Naive Bayes** classifier
- Generating predictions for unseen test files and storing them in CSV format

---

## 🗂 Dataset

The dataset consists of two folders:

- **Economy/**
- **Sports/**

Each folder contains multiple **Arabic HTML files**, each representing a single article.

Additionally, a set of **unseen test files** is used for final evaluation.

---

## 🧹 Preprocessing Pipeline

✔ Extract text from HTML using **BeautifulSoup**  
✔ Decode Windows-1256 / cp1256 encoded files  
✔ Keep only Arabic characters and digits  
✔ Remove punctuation & symbols  
✔ Remove Arabic stopwords  
✔ Normalize spacing  
✔ Tokenize and rejoin cleaned tokens

Example preprocessing snippet:

```python
def preprocess(text):
    text = re.sub(r"[^\u0600-\u06FF0-9\s]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    tokens = [t for t in text.split() if t not in stopwords]
    return " ".join(tokens)
```

---

## 🤖 Model Architecture

The model uses a simple but powerful machine learning pipeline:

```python
Pipeline([
    ("tfidf", TfidfVectorizer(max_features=8000, ngram_range=(1, 2))),
    ("nb", MultinomialNB())
])
```

Why Naive Bayes?

- **Excellent for text classification**

- **Fast and lightweight**

- **Works well with TF-IDF**

- **Performs strongly on Arabic tokenized text**

---

## 🚀 Training the Model

Training is initiated using:

```python
train_model()
```

This function:

- **Loads HTML files from the Economy and Sports folders**

- **Extracts & preprocesses the text**

- **Trains the Naive Bayes classifier**

- **Saves the trained model as:**

```python
naive_bayes_model.pkl
```

---

## 🔍 Prediction on Unseen Files

To generate predictions for new unseen test files:

```python
predict_folder("path/to/Test", "predictions.csv")
```

The script:

- **Loads the saved model**

- **Reads all .html files in test folders**

- **Extracts & preprocesses text**

- **Predicts either Economy or Sports**

- **Saves results as:**

```css
filename, label
Economy\file1.html, Economy
Sports\file7.html, Sports
```

---

## 📁 Project Structure

```bash
project/
│
├── Economy/                   # Training HTML files
├── Sports/                    # Training HTML files
├── Test/                      # Unseen evaluation files
│
├── naive_bayes_model.pkl      # Saved model
├── predictions.csv            # Output predictions
│
└── main.py / Project405.py    # Full pipeline (training + prediction)
```

---

## 🛠️ Technologies Used

- **Python**

- **BeautifulSoup4**

- **arabicstopwords**

- **scikit-learn (TF-IDF + Naive Bayes + Pipeline)**

- **Regular Expressions (Regex)**

- **CSV handling & file processing**

---

## 🏁 Expected Accuracy

Naive Bayes + TF-IDF commonly achieves:

    - **75% – 90% accuracy depending on dataset quality**

    - **Higher accuracy when training set is clean and well-balanced**

---
