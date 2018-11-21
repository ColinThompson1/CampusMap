import boto3, json, uuid
import scheduleocr

s3 = boto3.client('s3')


def aws_lambda_handler(event, context):
    bucket = event['s3']['bucket']
    key = event['s3']['key']
    download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
    s3.download_file(bucket, key, download_path)

    try:
        course_data = scheduleocr.execute(download_path)
        return response(course_data, 200)
    except scheduleocr.OCRError, e:
        return response({
            'message': e.message
        }, 500)


def response(message, status_code):
    return {
        'statusCode': str(status_code),
        'body': json.dumps(message),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
    }