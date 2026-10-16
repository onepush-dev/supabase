FROM envoyproxy/envoy:v1.39.1@sha256:57e14a549d7bd43c8d3f6d03e8cfa653e037d4b38e133acd9b54f38c524401b4
COPY envoy.yaml lds.template.yaml cds.template.yaml /etc/envoy/
COPY --chmod=0755 docker-entrypoint.sh /railway-entrypoint.sh
# config files are rendered at start
RUN chmod 0777 /etc/envoy
ENTRYPOINT ["/bin/sh","/railway-entrypoint.sh"]
CMD []
