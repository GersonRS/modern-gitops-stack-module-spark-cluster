{{/* Create chart name and version to be used by the chart label */}}
{{- define "modern-gitops-stack-module-spark-cluster.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{ end -}}

{{/* Define selectors to be used (to be also used as templates) */}}
{{- define "modern-gitops-stack-module-spark-cluster.selector" }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ end -}}

{{/* Define common labels */}}
{{- define "modern-gitops-stack-module-spark-cluster.labels" -}}
{{ include "modern-gitops-stack-module-spark-cluster.selector" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ end -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "modern-gitops-stack-module-spark-cluster.chart" . }}
{{- end -}}
{{/* End labels */}}
