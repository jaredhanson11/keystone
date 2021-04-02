{{- /*
libs.hosts generates ingress entrypoints.
.Values
._inputs:
  subdomain: str
  hosts: list (optional)
  svcName: str
  svcPort: str
*/ -}}
{{- define "lib.ingress.hosts" -}}
{{- $hosts := default .Values.lib.hosts .Values.ingress.hosts }}
{{- $fullName := include "lib.common.fullname" . -}}
{{- $svcPort := .Values.service.port -}}
{{- $subdomain := .Values.ingress.subdomain -}}
{{- $rootEnabled := .Values.ingress.rootEnabled -}}
{{- range $hosts }}
- host: "{{ $subdomain }}.{{ . }}"
  http:
    paths:
      - path: "/"
        backend:
          serviceName: {{ $fullName | quote }}
          servicePort: {{ $svcPort }}
{{ if $rootEnabled }}
- host: "{{ . }}"
  http:
    paths:
      - path: "/"
        backend:
          serviceName: {{ $fullName | quote }}
          servicePort: {{ $svcPort }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
*/ -}}
{{- define "lib.ingress" -}}
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: {{ include "lib.common.fullname" . }}
  labels:
    {{- include "lib.common.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  rules:
  {{- include "lib.ingress.hosts" . | indent 4 -}}
{{- end }}
{{- end -}}
