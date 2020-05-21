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
