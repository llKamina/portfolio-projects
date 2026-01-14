# ===========================================================

import os
import glob
import re
import csv
import pickle
from bs4 import BeautifulSoup
import arabicstopwords.arabicstopwords as stp

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline



# ===========================================================
# 1. Extract Arabic text from HTML (Windows-1256 decoding)
# ===========================================================
def extract_text_from_html(file_path):
    with open(file_path, "rb") as f:
        raw = f.read()

    # Force Windows-1256 Arabic decoding
    try:
        html = raw.decode("cp1256", errors="ignore")
    except:
        html = raw.decode("windows-1256", errors="ignore")

    soup = BeautifulSoup(html, "html.parser")

    # Extract ALL text
    text = soup.get_text(separator=" ", strip=True)

    # Clean extra spaces
    text = re.sub(r"\s+", " ", text).strip()

    return text


# ===========================================================
# 2. Preprocessing (Arabic safe-cleaning + stopwords)
# ===========================================================
stopwords = stp.stopwords_list()

def preprocess(text):
    # Keep only Arabic letters & digits
    text = re.sub(r"[^\u0600-\u06FF0-9\s]", " ", text)

    # Normalize spaces
    text = re.sub(r"\s+", " ", text).strip()

    # Remove stopwords
    tokens = text.split()
    tokens = [t for t in tokens if t not in stopwords]

    return " ".join(tokens)


# ===========================================================
# 3. Load HTML dataset from a folder
# ===========================================================
def load_data(folder, label):
    texts = []
    labels = []

    files = glob.glob(os.path.join(folder, "*.html"))

    if len(files) == 0:
        print(f" No HTML files found in: {folder}")

    for file in files:
        raw = extract_text_from_html(file)

        if len(raw.split()) < 5:
            print(f" Skipping EMPTY file: {file}")
            continue

        texts.append(raw)
        labels.append(label)

    return texts, labels


# ===========================================================
# 4. Train NB classifier
# ===========================================================
def train_model():

    # CHANGE PATHS TO YOUR FOLDERS
    economy_dir = "Economy/"
    sports_dir  = "Sports/"

    econ_texts, econ_labels = load_data(economy_dir, "Economy")
    sport_texts, sport_labels = load_data(sports_dir, "Sports")

    texts = econ_texts + sport_texts
    labels = econ_labels + sport_labels

    print(f"\n Loaded {len(texts)} training documents.")

    # Preprocess
    texts = [preprocess(t) for t in texts]
    texts = [t for t in texts if len(t) > 5]

    if len(texts) == 0:
        print(" ERROR: No valid text found.")
        return

    # Define model
    model = Pipeline([
        ("tfidf", TfidfVectorizer(max_features=8000, ngram_range=(1,2))),
        ("nb", MultinomialNB())
    ])

    model.fit(texts, labels)

    # Save trained model
    with open("naive_bayes_model.pkl", "wb") as f:
        pickle.dump(model, f)

    print("\n Model saved as naive_bayes_model.pkl\n")



# ===========================================================
# 5. Prediction Function (Used for unseen test files)
# ===========================================================
def predict_folder(base_test_path, output_csv="predictions.csv"):

    with open("naive_bayes_model.pkl", "rb") as f:
        model = pickle.load(f)

    categories = ["Economy", "Sports"]   # two folders to scan

    with open(output_csv, "w", newline="", encoding="utf-8") as output:
        writer = csv.writer(output)
        writer.writerow(["filename", "label"])

        for category in categories:
            folder = os.path.join(base_test_path, category)
            files = glob.glob(os.path.join(folder, "*.html"))

            if len(files) == 0:
                print(f" No HTML files in {folder}")
                continue

            for file in files:
                # Extract text
                text = extract_text_from_html(file)
                text = preprocess(text)

                # Predict
                pred = "UNKNOWN" if len(text.strip()) == 0 else model.predict([text])[0]

                
                fname = os.path.basename(file)
                relative = f"{category}\\{fname}"

                writer.writerow([relative, pred])

    print(f"\n Predictions saved to {output_csv}\n")



# ===========================================================
# 6. MAIN MENU (Runs training or prediction)
# ===========================================================
if __name__ == "__main__":

    train_model()

    predict_folder("Test/")
