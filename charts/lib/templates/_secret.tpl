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

