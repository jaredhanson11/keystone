{{- /*
endergy-libs.hosts generates ingress entrypoints.
.Values
._inputs:
  subdomain: str
  hosts: list (optional)
  svcName: str
  svcPort: str
*/ -}}
{{- define "endergy-lib.ingress.hosts" -}}
{{- $hosts := default (index (index .Values "endergy-lib") "hosts") .Values.ingress.hosts }}
{{- $fullName := include "endergy-lib.common.fullname" . -}}
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
{{- define "endergy-lib.ingress" -}}
{{- if .Values.ingress.enabled -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ include "endergy-lib.common.fullname" . }}
  labels:
    {{- include "endergy-lib.common.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  rules:
  {{- include "endergy-lib.ingress.hosts" . | indent 4 -}}
{{- end }}
{{- end -}}