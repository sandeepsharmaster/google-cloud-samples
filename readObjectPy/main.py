
import sys
from flask import escape
import functions_framework
import sys
from google.cloud import storage


def hello_gcs(event, context):

    print('Event ID: {}'.format(context.event_id))
    print('Event type: {}'.format(context.event_type))
    print('Bucket: {}'.format(event['bucket']))
    print('File: {}'.format(event['name']))
    print('Metageneration: {}'.format(event['metageneration']))
    print('Created: {}'.format(event['timeCreated']))
    print('Updated: {}'.format(event['updated']))

    file_cont = download_blob(bucket_name=event['bucket'], source_blob_name=event['name']
        #destination_file_name="./file-1.txt"
    )
    #detect_logos_uri("https://storage.cloud.google.com/poc-input-bucket-sandy/vodafone.jpg")
    try:
        print("Calling Image API ")
        logo = detect_logos_uri('gs://poc-input-bucket-sandy/' + str(event['name']))
    except:
        print("An exception occurred block 2")

    upload_blob_from_memory("poc-output-bucket-sandy", file_cont, event['name'] + '_' + logo)

def download_blob(bucket_name, source_blob_name):

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)


    blob = bucket.blob(source_blob_name)

    file_cont = blob.download_as_string()
    print(
        "Downloaded storage object {} from bucket {} to local file {}.".format(
            source_blob_name, bucket_name, file_cont
        )
    )
    return file_cont
    

def detect_logos_uri(uri):
    """Detects logos in the file located in Google Cloud Storage or on the Web.
    """
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.Image()
    image.source.image_uri = uri

    response = client.logo_detection(image=image)
    logos = response.logo_annotations
    print('Logos:')
    first_logo = ''
    for logo in logos:
        first_logo = logo.description
        print(logo.description)

    if response.error.message:
        raise Exception(
            '{}\nFor more info on error messages, check: '
            'https://cloud.google.com/apis/design/errors'.format(
                response.error.message))
    return first_logo

def upload_blob_from_memory(bucket_name, contents, destination_blob_name):

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_string(contents)

    print(
        f"{destination_blob_name} with contents {contents} uploaded to {bucket_name}."
    )

if __name__ == "__main__":
    download_blob(
        bucket_name=sys.argv[1],
        source_blob_name=sys.argv[2],
        destination_file_name=sys.argv[3],
    )