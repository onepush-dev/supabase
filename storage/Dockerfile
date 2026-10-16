FROM supabase/storage-api:v1.74.0@sha256:f1546fac6d1c7e345428ac904bfaa7be7cecd50a1f549fe1cf38c628a7b15c85
COPY mint-keys.js /railway/mint-keys.js
COPY --chmod=0755 node-entrypoint.sh /railway/entrypoint.sh
ENTRYPOINT ["/railway/entrypoint.sh"]
CMD ["node","dist/start/server.js"]
