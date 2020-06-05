{{- define "flask-app.secretName" -}}
{{- if (not (empty .Values.existingSecret)) -}}
{{ .Values.existingSecret }}  
{{- else -}}
{{ include "lib.common.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "flask-app.envSecrets" -}}
{{- with .Values.secret -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ include "flask-app.secretName" $ }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "flask-app.envConfigs" -}}
{{- with .Values.config -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

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
    secretName: {{ include "flask-app.secretName" $ }}
    items:
      - key: {{ $key }}
        path: {{ $key }}
{{- end -}}
{{- end -}}
