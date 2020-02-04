{{- /*
endergy-libs.hosts generates ingress entrypoints.
input:
  dict(
    subdomain: str
    hosts: list (optional)
    svcName: str
    svcPort: str
  )
*/ -}}
{{- define "endergy-lib.hosts" -}}
{{- $subdomain := .subdomain }}
{{- $hosts := default (list "endergy.info" "endergy.co") .hosts }} 
{{- $svcName := .svcName }}
{{- $svcPort := .svcPort }}
{{- range $hosts }}
- host: "{{ $subdomain }}.{{ . }}"
  http:
    paths:
      - path: "/"
        backend:
          serviceName: {{ $svcName | quote }}
          servicePort: {{ $svcPort }}
{{- end -}}
{{- end -}}