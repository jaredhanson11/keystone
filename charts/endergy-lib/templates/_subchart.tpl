{{/*
Call subchart methods. See: https://github.com/helm/helm/issues/4535#issuecomment-416022809
Inputs list[ ., subchart_name, subchart_template ]
*/}}
{{- define "endergy-lib.subchart.call" -}}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 }}
{{- $template := index . 2 }}
{{- include $template (dict "Chart" (dict "Name" $subchart) "Values" (index $dot.Values $subchart) "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end -}}