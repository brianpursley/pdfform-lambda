# pdfform-lambda

This project demonstrates creating a serverless application for populating fillable PDFs.

## Technologies Used

* Node.js
* AWS Lambda
* AWS API Gateway
* AWS CloudWatch
* Terraform

## Deploying

```
td -chdir=tf apply
```
or
```
cd tf
tf apply
```

## Usage

### Listing the fields of a fillable PDF:

```
curl --request POST \
    --url https://11hnc9oxr8.execute-api.us-east-2.amazonaws.com/test/listFields \
    --header 'content-type: application/json' \
    --data '{"pdf": "https://www.irs.gov/pub/irs-pdf/fw9.pdf"}'
```

Response:
```
{"f1_1":[{"type":"string"}],"f1_2":[{"type":"string"}],"f1_9":[{"type":"string"}],"f1_10":[{"type":"string"}],"c1_1":[{"type":"boolean"},{"type":"boolean"},{"type":"boolean"},{"type":"boolean"},{"type":"boolean"},{"type":"boolean"},{"type":"boolean"}],"f1_3":[{"type":"string"}],"f1_4":[{"type":"string"}],"f1_5":[{"type":"string"}],"f1_6":[{"type":"string"}],"f1_7":[{"type":"string"}],"f1_8":[{"type":"string"}],"f1_11":[{"type":"string"}],"f1_12":[{"type":"string"}],"f1_13":[{"type":"string"}],"f1_14":[{"type":"string"}],"f1_15":[{"type":"string"}]}
```

### Transforming a fillable PDF using field values:

```
curl --request POST \
    --url https://11hnc9oxr8.execute-api.us-east-2.amazonaws.com/test/transform \
    --header 'content-type: application/json' \
    --data '{
        "pdf": "https://www.irs.gov/pub/irs-pdf/fw9.pdf",
        "fields": {
            "f1_1": ["FirstName LastName"],
            "f1_2": ["CompanyName"],
            "c1_1": [1,0,0,0,0,0,0],
            "f1_7": ["123 Fake Street"],
            "f1_8": ["Cincinnati, OH 45241"],
            "f1_14": ["12"],
            "f1_15": ["3456789"]
        }
    }' \
    --output /tmp/output.pdf
```

The filled PDF will be written to **/tmp/output.pdf**