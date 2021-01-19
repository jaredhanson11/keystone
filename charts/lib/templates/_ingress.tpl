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
{{- range $hosts }}
- host: "{{ $subdomain }}.{{ . }}"
  http:
    paths:
      - path: "/"
        backend:
          serviceName: {{ $fullName | quote }}
          servicePort: {{ $svcPort }}
{{- end -}}
{{- end -}}

{{- /*
*/ -}}
{{- define "lib.ingress" -}}
{{- if .Values.ingress.enabled -}}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ include "lib.common.fullname" . }}
  labels:
    {{- include "lib.common.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  rules:
  {{- include "lib.ingress.hosts" . | indent 4 -}}
{{- end }}
{{- end -}}
