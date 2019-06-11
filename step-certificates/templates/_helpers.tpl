{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "step-ca.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "step-ca.fullname" -}}
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
{{- define "step-ca.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "step-ca.labels" -}}
helm.sh/chart: {{ include "step-ca.chart" . }}
app.kubernetes.io/name: {{ include "step-ca.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create CA URL
*/}}
{{- define "step-ca.url" -}}
{{- if .Values.ca.url -}}
{{- .Values.ca.url -}}
{{- else -}}
{{- printf "https://%s.%s.svc.cluster.local" (include "step-ca.fullname" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Create CA DNS
*/}}
{{- define "step-ca.dns" -}}
{{- if .Values.ca.dns -}}
{{- .Values.ca.dns -}}
{{- else -}}
{{- printf "%s.%s.svc.cluster.local,127.0.0.1" (include "step-ca.fullname" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
