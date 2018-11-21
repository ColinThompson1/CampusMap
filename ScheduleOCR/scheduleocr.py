from PIL import Image
import pytesseract
import cv2
import os.path
import numpy as np


def execute(path_to_img):
    res = _binary_thresh(_preprocess_img(path_to_img))
    save_path = os.path.join('/tmp', 'processed-img.jpg')
    cv2.imwrite(save_path, res)

    # OCR
    text = pytesseract.image_to_string(Image.open(save_path))

    return _parse_text(text)


def _parse_text(text):
    print(text)
    return text


# Preform transformations on image
def _preprocess_img(img_path):
    img = cv2.imread(img_path)

    # Rescale the image
    return cv2.resize(img, None, fx=3, fy=3, interpolation=cv2.INTER_CUBIC)


# Apply a binary threshold to remove irrelevant pixels and strengthen vital ones
def _binary_thresh(img):
    # Convert to gray
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Apply dilation and erosion to remove some noise
    kernel = np.ones((1, 1), np.uint8)
    img = cv2.dilate(img, kernel, iterations=1)
    img = cv2.erode(img, kernel, iterations=1)

    return cv2.threshold(img, 130, 255, cv2.THRESH_BINARY)[1]



