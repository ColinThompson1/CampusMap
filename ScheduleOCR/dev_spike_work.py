import cv2
import sys
import os.path
import numpy as np

def preprocess_img(img_path):

    img = cv2.imread(img_path)

    # Rescale the image
    img = cv2.resize(img, None, fx=3, fy=3, interpolation=cv2.INTER_CUBIC)

    return img

def apply_threshold(img, type):
    threshold = {
        1: binary_thresh(img),
        2: adaptive_thresh(img),
        3: highlight_lines(img)
    }
    return threshold.get(type, "Invalid threshold")

def binary_thresh(img):

    # Convert to gray
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Apply dilation and erosion to remove some noise
    kernel = np.ones((1, 1), np.uint8)
    img = cv2.dilate(img, kernel, iterations=1)
    img = cv2.erode(img, kernel, iterations=1)

    return cv2.threshold(img, 130, 255, cv2.THRESH_BINARY)[1]

def adaptive_thresh(img):

    # Convert to gray
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Apply dilation and erosion to remove some noise
    kernel = np.ones((1, 1), np.uint8)
    img = cv2.dilate(img, kernel, iterations=1)
    img = cv2.erode(img, kernel, iterations=1)

    return cv2.adaptiveThreshold(img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 41, 3)


def highlight_lines(img):

    # Convert to HSV to have only one channel
    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    # # Column lines should be (0,0,230). I gave it a bit more room with room for expansion (you'll get more noise though)
    lower_bound = (0, 0, 229)
    upper_bound = (0, 0, 231)

    mask = cv2.inRange(hsv_img, lower_bound, upper_bound)
    return cv2.bitwise_and(img, img, mask=mask)

def find_edge_coords(img):
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    imgColor = cv2.cvtColor(img, cv2.COLOR_GRAY2RGB)
    edges = cv2.Canny(img,50,150,apertureSize = 3)
    lines = cv2.HoughLines(edges, 1, np.pi/180, 250)

    for line in lines:
        print(len(line))
        for rho, theta in line:
        # rho, theta = line[0]


            # Convert to cartesian coords
            x = rho * np.cos(theta)
            y = rho * np.sin(theta)

            if x > 0:

                # print (x,y)
                # cv2.line(imgColor, (x, y), (x, y), (0, 255, 0), 2)

                a = np.cos(theta)
                b = np.sin(theta)
                x0 = a*rho
                y0 = b*rho
                x1 = int(x0 + 100000*(-b))
                y1 = int(y0 + 100000*(a))
                x2 = int(x0 - 100000*(-b))
                y2 = int(y0 - 100000*(a))

                cv2.line(imgColor,(x1,y1),(x2,y2),(0,255,0),2)

    return imgColor


def main():

    # Verify image exists
    if not os.path.exists(sys.argv[1]):
        print('No image found')
        sys.exit()


    # Extract the file name without the file extension
    file_name = os.path.basename(sys.argv[1]).split('.')[0].split()[0]

    # Process the image
    img = apply_threshold(preprocess_img(sys.argv[1]), float(sys.argv[2]))
    img_line = find_edge_coords(img)

    # Create a directory for outputs
    output_path = os.path.join('./output', file_name)
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    # Save the filtered image in the output directory
    save_path = os.path.join(output_path, file_name + ".jpg")
    save_path_line = os.path.join(output_path, file_name + "-line.jpg")
    cv2.imwrite(save_path, img)

    cv2.imwrite(save_path_line, img_line)


if len(sys.argv) == 3:
    main()
else:
    print('Invalid arguments. usage: python process_schedule_image <imagePath> <methodType>')


# /import cv2
# import sys
# import os.path
# import numpy as np
#
# def main():
#     #Process for lines and split into cells
#
#     #for each cell image process and run ocr
#
#     #profit??
#
#     res = find_edge_coords(highlight_lines(preprocess_img(sys.argv[1])))
#
#     save_path = os.path.join('./output', 'result' + ".jpg")
#     cv2.imwrite(save_path, res)
#
# def preprocess_img(img_path):
#
#     img = cv2.imread(img_path)
#
#     # Rescale the image
#     img = cv2.resize(img, None, fx=3, fy=3, interpolation=cv2.INTER_CUBIC)
#
#     return img
#
# def highlight_lines(img):
#
#     # Convert to HSV to have only one channel
#     hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
#
#     # # Column lines should be (0,0,230). I gave it a bit more room with room for expansion (you'll get more noise though)
#     lower_bound = (0, 0, 229)
#     upper_bound = (0, 0, 231)
#
#     mask = cv2.inRange(hsv_img, lower_bound, upper_bound)
#     andOperation = cv2.bitwise_and(img, img, mask=mask)
#
#     return cv2.dilate(andOperation, np.ones((4,4),np.uint8), iterations=1)
#
# def find_edge_coords(img):
#     img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#     imgColor = cv2.cvtColor(img, cv2.COLOR_GRAY2RGB)
#     # edges = cv2.Canny(img,50,150,apertureSize = 3)
#     lines = cv2.HoughLines(img, 1, np.pi/180, 250)
#
#     for line in lines:
#         print(len(line))
#         for rho, theta in line:
#             # rho, theta = line[0]
#
#
#             # Convert to cartesian coords
#             x = rho * np.cos(theta)
#             y = rho * np.sin(theta)
#
#             if x > 0:
#
#                 # print (x,y)
#                 # cv2.line(imgColor, (x, y), (x, y), (0, 255, 0), 2)
#
#                 a = np.cos(theta)
#                 b = np.sin(theta)
#                 x0 = a*rho
#                 y0 = b*rho
#                 x1 = int(x0 + 100000*(-b))
#                 y1 = int(y0 + 100000*(a))
#                 x2 = int(x0 - 100000*(-b))
#                 y2 = int(y0 - 100000*(a))
#
#                 cv2.line(imgColor,(x1,y1),(x2,y2),(0,255,0),2)
#
#     return imgColor
#
#
# # def find_edge_coords(img):
# #     img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
# #     imgColor = cv2.cvtColor(img, cv2.COLOR_GRAY2RGB)
# #     # edges = cv2.Canny(img,50,150,apertureSize = 3)
# #     lines = cv2.HoughLinesP(img, 1, np.pi/180, 100, 100, 40)
# #
# #     for line in lines:
# #         for x1,y1,x2,y2 in line:
# #             cv2.line(imgColor,(x1,y1),(x2,y2),(0,255,0),2)
# #
# #     return imgColor
#
#
# main()