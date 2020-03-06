{{- define "streamt-vidpub.nginx-conf" -}}
worker_processes auto;
rtmp_auto_push on;
events {}
http {
  server {
    listen 80;
    location /healthz {
      return 200 Ok;
    }
  }
}
rtmp {
    server {
        listen 1935;
        listen [::]:1935 ipv6only=on;

        application live {
            ## General
            live on;

            # Access
            allow publish all; # anyone can publish (if they have a stream key)
            deny play all;

            # Events
            on_publish {{ .Values.rtmpPublishUrl }};
        }

        application published {
            ## General
            live on;
            deny publish all;
            deny play all;
            allow publish 127.0.0.1;

            ## Record
            record all;
            record_path {{ .Values.rtmpRecordLocation }}; 
            record_unique on;
            record_lock on; # allows s3 publish job to know if file is currently still being recorded
            record_interval {{ .Values.rtmpRecordInterval }};

            # Events
            on_publish_done {{ .Values.rtmpPublishDoneUrl }};
      }
    }
}
{{- end -}}
