FROM supabase/studio:2026.09.07-sha-7996410@sha256:94a2a9d2906e8b4109e55159a62e241c3044709a492913ea8edd34b14973d288
COPY mint-keys.js /railway/mint-keys.js
COPY --chmod=0755 node-entrypoint.sh /railway/entrypoint.sh
ENTRYPOINT ["/railway/entrypoint.sh"]
CMD ["node","apps/studio/server.js"]
