{{- /*
db.sqlalchemyDbUri sets the SQLALCHEMY_DATABASE_URI environment variable (and related envvars).
Requires .Values.dbConnection to be setup with the following inputs:
dbConnection:
  prefix: ""
  passwordSecret:
    secretName: ""
    keyName: ""
  user: ""
  port: ""
  host: ""
  name: ""
*/ -}}
{{- define "lib.db.sqlalchemyDbUri" -}}
{{- if .Values.dbConnection.shouldConnect }}
{{- $prefix := .Values.dbConnection.prefix -}}
{{- $user := .Values.dbConnection.user -}}
{{- $host := .Values.dbConnection.host -}}
{{- $port := toString .Values.dbConnection.port -}}
{{- $name := .Values.dbConnection.name -}}
{{- $sqlalchemyDbUri := printf "%s%s:$(DB_PASSWORD)@%s:%s/%s" $prefix $user $host $port $name -}}
- name: DB_PASSWORD
{{- if (empty .Values.dbConnection.passwordSecret) }}
  value: ""
{{- else }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.dbConnection.passwordSecret.secretName }}
      key: {{ .Values.dbConnection.passwordSecret.keyName }}
{{- end }}
- name: SQLALCHEMY_DATABASE_URI
  value: "{{ $sqlalchemyDbUri }}"
{{- end -}}
{{- end -}}
