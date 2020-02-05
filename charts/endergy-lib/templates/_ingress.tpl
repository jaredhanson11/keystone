{{- /*
endergy-libs.hosts generates ingress entrypoints.
.Values
._inputs:
  subdomain: str
  hosts: list (optional)
  svcName: str
  svcPort: str
*/ -}}
{{- define "endergy-lib.hosts" -}}
{{- $_hosts := index (index .Values "endergy-lib") "hosts" }}
{{- $hosts := default $_hosts ._inputs.hosts }}
{{- $inputs := ._inputs -}}
{{- range $hosts }}
- host: "{{ $inputs.subdomain }}.{{ . }}"
  http:
    paths:
      - path: "/"
        backend:
          serviceName: {{ $inputs.svcName| quote }}
          servicePort: {{ $inputs.svcPort }}
{{- end -}}
{{- end -}}