import sys
import os
import scheduleocr
import json

# Driver to execute scheduleocr locally


def run():
    if not len(sys.argv) == 2:
        print('Usage: python process_schedule_image <imagePath>')
        sys.exit()

    # Verify image exists
    if not os.path.exists(sys.argv[1]):
        print('No image found')
        sys.exit()

    print(json.dumps(scheduleocr.execute(sys.argv[1])))


run()
