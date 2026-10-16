FROM supabase/edge-runtime:v1.76.2@sha256:edd22bef4477b900d5c300e287ce9b18bff9b81a0291bee14ee0b7c7b71a2899
COPY functions /home/deno/functions
ENTRYPOINT ["edge-runtime"]
CMD ["start","--user-worker-request-idle-timeout","150000","--main-service","/home/deno/functions/main"]
