import json
import base64
import uuid
import scheduleocr
import os
import pytesseract

# Driver to execute scheduleocr on aws lambda

SAVE_DIR = '/tmp/images/'
LIB_DIR = '/tmp/lib/'

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PATH_TO_TESS = SCRIPT_DIR + '/tesseract'
PATH_TO_TESS_DATA = SCRIPT_DIR  # (parent directory of your "tessdata" directory)


def aws_lambda_handler(event, context):

    if not ('body' in event and event['body']):
        return _error('Missing base64 image', 400)

    selected_uuid = str(uuid.uuid4())
    img_path = SAVE_DIR + selected_uuid + '.png'

    if not os.path.exists(SAVE_DIR):
        os.makedirs(SAVE_DIR)
    img_data = base64.urlsafe_b64decode(event['body'].encode("ascii"))
    with open(img_path, 'wb+') as f:
        f.write(img_data)

    try:
        pytesseract.pytesseract.tesseract_cmd = PATH_TO_TESS
        os.environ["TESSDATA_PREFIX"] = PATH_TO_TESS_DATA
        course_data = scheduleocr.execute(img_path)
        return _response(course_data, 200)
    except Exception, e:
        print(e)
        return _error('Error performing OCR on schedule', 500)


def _response(message, status_code):
    return {
        'isBase64Encoded': False,
        'statusCode': status_code,
        'body': json.dumps(message),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
    }


def _error(message, status_code):
    print(message)
    return _response({
        'error': message
    }, status_code)

