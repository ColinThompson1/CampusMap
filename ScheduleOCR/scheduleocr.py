from PIL import Image
import pytesseract
import cv2
import os.path
import numpy as np
import re
import json

debug = True


def execute(path_to_img):
    res = _binary_thresh(_preprocess_img(path_to_img))
    save_path = os.path.join('/tmp', 'processed-img.jpg')
    cv2.imwrite(save_path, res)

    # OCR
    text = pytesseract.image_to_string(Image.open(save_path))

    return _parse_text(text)


def _parse_text(text):
    course = {}
    sched = {}
    if debug:
        print("Input:")
        print(text)
    for line in text.splitlines():
        m = re.match(r"(?P<CourseCode>\w{3,4})\s?(?P<CourseNum>\d{3}\w?)\s?[-|~]\s?(?P<Section>\w{2,3})", line)
        if m:
            if debug: print(m.groups())
            courseCode = str(m.group("CourseCode"))
            courseNum = str(m.group("CourseNum"))
            courseSec = str(m.group("Section"))
            if courseSec.find("8") == 0 and len(courseSec) > 2 :
                x = courseSec.find("8")
                courseSec = "B" + courseSec[x+1:]
            if courseSec.find("O") > -1:
                x = courseSec.find("O")
                courseSec = courseSec[:x] + "0" + courseSec[x+1:]
            key = courseCode + courseNum + "-"+ courseSec
            course[key] = {
                "CourseCode" : courseCode,
                "CourseNum" : courseNum,
                "Section" : courseSec
            }
            sched.update(course)
    if debug:
        print("Classes found:")
        print(json.dumps(sched))
    return sched


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



