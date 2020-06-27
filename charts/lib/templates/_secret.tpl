{{- define "lib.secret.secretName" -}}
{{- if (not (empty .Values.existingSecret)) -}}
{{ .Values.existingSecret }}  
{{- else -}}
{{ include "lib.common.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "lib.secret.defaultSecret" -}}
{{- if not .Values.existingSecret -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "lib.secret.secretName" . }}
type: Opaque
data:
{{ range $key, $val := .Values.secret }}
  {{ $key }}: {{ required "Missing value." $val | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "lib.secret.secretVolumeMounts" -}}
{{- range $key, $path := .Values.mountedSecrets }}
- name: {{ substr 0 10 (sha1sum $key) }} # uses sha to force alphanumberic
  mountPath: {{ $path }}
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "lib.secret.secretVolumes" -}}
{{- range $key, $path := .Values.mountedSecrets }}
- name: {{ substr 0 10 (sha1sum $key) }}  # uses sha to force alphanumberic
  secret:
    secretName: {{ include "lib.secret.secretName" $ }}
    items:
      - key: {{ $key }}
        path: {{ $key }}
{{- end -}}
{{- end -}}

