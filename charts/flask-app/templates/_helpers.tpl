{{- define "flask-app.secretVolumeMounts" -}}
{{- range $key, $path := .Values.mountedSecrets }}
- name: {{ substr 0 10 (sha1sum $key) }} # uses sha to force alphanumberic
  mountPath: {{ $path }}
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "flask-app.secretVolumes" -}}
{{- range $key, $path := .Values.mountedSecrets }}
- name: {{ substr 0 10 (sha1sum $key) }}  # uses sha to force alphanumberic
  secret:
    secretName: {{ include "lib.secret.secretName" $ }}
    items:
      - key: {{ $key }}
        path: {{ $key }}
{{- end -}}
{{- end -}}
