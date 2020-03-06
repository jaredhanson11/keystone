{{- define "streamt-app.secretName" -}}
{{- if (not (empty .Values.existingSecret)) -}}
{{ .Values.existingSecret }}  
{{- else -}}
{{ include "lib.common.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "streamt-app.envSecrets" -}}
{{- with .Values.secret -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ include "streamt-app.secretName" $ }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "streamt-app.envConfigs" -}}
{{- with .Values.config -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end -}}
{{- end -}}
{{- end -}}
