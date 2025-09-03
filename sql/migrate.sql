DO $$
DECLARE
  json_data jsonb;
BEGIN
  -- Load JSON file từ S3 vào biến json_data
  SELECT convert_from(
    aws_s3.object_get(
      aws_commons.create_s3_uri('your-bucket', 'jsonfile.json', 'ap-southeast-1')
    ),
    'UTF8'
  )::jsonb INTO json_data;

  -- Tạo table nếu chưa có
  CREATE TABLE IF NOT EXISTS urls (
    id SERIAL PRIMARY KEY,
    url_main TEXT NOT NULL,
    url TEXT NOT NULL,
    url_name TEXT
  );

  -- Insert dữ liệu từ JSON vào bảng
  INSERT INTO urls (url_main, url, url_name)
  SELECT
    value->>'url_main',
    value->>k AS url,
    value->>(k || '_name') AS url_name
  FROM jsonb_array_elements(json_data) arr(value),
       LATERAL (
         VALUES ('url_1'), ('url_2'), ('url_3'), ('url_4'), ('url_5')
       ) AS urls(k);

END $$;
