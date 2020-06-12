{{- define "lib.deploy.envConfigs" -}}
{{- with .Values.config -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "lib.deploy.envSecrets" -}}
{{- with .Values.secret -}}
{{- range $key, $val := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ include "lib.secret.secretName" $ }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
