Simple Lua S3 GET/PUT API
=========================

This module supports:
- Downloading something from S3
- Uploading something less than 5GB to S3 (we don't support multipart upload)

That's all.

Connecting to S3
----------------
There are two ways to connect. You can either pass in your AWS keys
directly to the constructor:
```
s3 = require 's3'

local bucket = s3:connect{
  awsId="ABCD",
  awsKey="1234",
  bucket="S3 bucket name here",
}
```

If you're on EC2, you don't have to hardcode your keys! Instead,
provision your instance with an
[IAM role](https://aws.amazon.com/blogs/aws/iam-roles-for-ec2-instances-simplified-secure-access-to-aws-service-apis-from-ec2/)
with the appropriate permissions to access the S3 bucket. Then, you
can simply pass the IAM role name. This class will then fetch
temporary AWS credentials from the
[EC2 Instance Metadata Service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html),
handling expiration and key rotation for you.

```
s3 = require 's3'

local bucket = s3:connect{
  awsRole="IAM Role",
  bucket="S3 bucket name,
}
```

Saving to S3
------------
```
print(b:put("path/to/something", "Content as a string"))
```
Output:
```
{
  resultCode : 200
  headers :
    {
      date : "Tue, 05 Jan 2016 19:07:14 GMT"
      server : "AmazonS3"
      x-amz-id-2 : "ABCD1234"
      connection : "close"
      x-amz-request-id : "ABCD1234"
      content-length : "0"
      etag : "ABCD1234"
    }
  statusLine : "HTTP/1.1 200 OK"
  result : {}
}
```

Retrieving from S3
------------------
```
print(b:get("path/to/something"))
```
Returns `"Content as a string"`.

You can also pass in an `ltn12` sink to stream to a file, for example:
```
f = io.open("/tmp/contents", "w")
print(b:get("path/to/something", ltn12.sink.file(f)))
```
When using the optional `sink` argument, more detailed output is returned:
```
{
  headers :
    {
      content-type : "binary/octet-stream"
      accept-ranges : "bytes"
      x-amz-id-2 : "..."
      date : "Tue, 05 Jan 2016 19:39:08 GMT"
      etag : "..."
      last-modified : "Tue, 05 Jan 2016 19:37:56 GMT"
      connection : "close"
      x-amz-request-id : "..."
      content-length : "19"
      server : "AmazonS3"
    }
  statusLine : "HTTP/1.1 200 OK"
  resultCode : 200
}
```
