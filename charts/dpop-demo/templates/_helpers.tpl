{{- define "dpop-demo.labels" -}}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{/* Seletor de um componente: include "dpop-demo.selector" (dict "ctx" $ "component" "api") */}}
{{- define "dpop-demo.selector" -}}
app.kubernetes.io/name: {{ .ctx.Chart.Name }}-{{ .component }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- end }}

{{- define "dpop-demo.securityContext" -}}
allowPrivilegeEscalation: false
runAsNonRoot: true
capabilities:
  drop: ["ALL"]
seccompProfile:
  type: RuntimeDefault
{{- end }}
