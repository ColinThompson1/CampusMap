import boto3, json
import scheduleocr

# Driver to execute scheduleocr on aws lambda

s3 = boto3.client('s3')


def aws_lambda_handler(event, context):
    bucket = event['s3']['bucket']
    key = event['s3']['key']
    download_path = '/tmp/' + key
    s3.download_file(bucket, key, download_path)

    try:
        course_data = scheduleocr.execute(download_path)
        return response(course_data, 200)
    except Exception, e:
        print(e)
        return response({
            'message': 'Error performing OCR on schedule'
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