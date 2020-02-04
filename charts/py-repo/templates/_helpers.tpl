{{/*
Expand the name of the chart.
*/}}
{{- define "py-repo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "py-repo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "py-repo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "py-repo.labels" -}}
helm.sh/chart: {{ include "py-repo.chart" . }}
{{ include "py-repo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "py-repo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "py-repo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "py-repo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "py-repo.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Call subchart methods. See: https://github.com/helm/helm/issues/4535#issuecomment-416022809
*/}}
{{- define "py-repo.call-nested" -}}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 }}
{{- $template := index . 2 }}
{{- include $template (dict "Chart" (dict "Name" $subchart) "Values" (index $dot.Values $subchart) "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end -}}

{{/*
Get DB connection url.
*/}}
{{- define "py-repo.dbUrl" -}}
{{- $user := .Values.global.postgresql.postgresqlUsername -}}
{{- $password := .Values.global.postgresql.postgresqlPassword -}}
{{- $db := .Values.global.postgresql.postgresqlDatabase -}}
{{- $host := include "py-repo.call-nested" (list . "postgresql" "postgresql.fullname") -}}
{{- $port := include "py-repo.call-nested" (list . "postgresql" "postgresql.port") -}}
postgres://{{ $user }}:{{ $password }}@{{ $host }}:{{ $port }}/{{ $db }}
{{- end -}}
