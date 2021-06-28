{
    "Version": "2012-10-17",
    "Id":"DocsBucketPolicy",
    "Statement": [
        {
            "Sid": "Delegate access",
            "Effect":"Allow",
            "Principal":"*",
            "Action":[
                "s3:GetObject"
            ],
            "Resource":[
                "BUCKET_NAME/*"
            ]
        }
    ]
}
