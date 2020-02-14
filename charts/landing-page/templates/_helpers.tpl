{{- define "landing-page.client.labels" -}}
{{ dict "type" "client" | toYaml }}
{{ include "lib.common.labels" . }}
{{- end -}}

{{- define "landing-page.client.selectorLabels" -}}
{{ dict "type" "client" | toYaml }}
{{ include "lib.common.selectorLabels" . }}
{{- end -}}

{{- define "landing-page.server.labels" -}}
{{ dict "type" "server" | toYaml }}
{{ include "lib.common.labels" . }}
{{- end -}}

{{- define "landing-page.server.selectorLabels" -}}
{{ dict "type" "server" | toYaml }}
{{ include "lib.common.selectorLabels" . }}
{{- end -}}

{{- define "landing-page.server.mailPassword" -}}
{{ if .Values.server.mailPassword }}
  {{- .Values.server.mailPassword -}}
{{ else }}
  {{ fail "server.mailPassword is not set" }}
{{ end }}
{{- end -}}

{{- define "landing-page.server.sqlConnectionUri" -}}
{{ if .Values.server.sqlConnectionUri }}
  {{- .Values.server.sqlConnectionUri -}}
{{ else }}
  {{ fail "server.sqlConnectionUri is not set" }}
{{ end }}
{{- end -}}
