{{/* vim: set filetype=mustache: */}}

{{- define "additional-scrape-configs.yaml" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- if eq .Values.level "cluster" -}}
  {{- range $path, $bytes := .Files.Glob "additionals/c-scrape_*.yaml" -}}
    {{- $tpl := tpl ($bytes | toString) $root }}
    {{- if $tpl }}
    {{- $_ := set $yamls $tpl "" -}}
    {{- end }}
  {{- end -}}
{{- end -}}
{{- range $path, $bytes := .Files.Glob "additionals/w-scrape_*.yaml" -}}
  {{- $tpl := tpl ($bytes | toString) $root }}
  {{- if $tpl }}
  {{- $_ := set $yamls $tpl "" -}}
  {{- end }}
{{- end -}}
{{- if .Values.additionalScrapeConfigs -}}
  {{- $_ := set $yamls (.Values.additionalScrapeConfigs | toYaml) "" -}}
{{- end -}}
{{- if $yamls -}}
  {{- keys $yamls | join "\n" | quote -}}
{{- end -}}
{{- end -}}


{{- define "additional-alertmanager-configs.yaml" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- if eq .Values.level "cluster" -}}
  {{- range $path, $bytes := .Files.Glob "additionals/c-altermanager_*.yaml" -}}
    {{- $tpl := tpl ($bytes | toString) $root }}
    {{- if $tpl }}
    {{- $_ := set $yamls $tpl "" -}}
    {{- end }}
  {{- end -}}
{{- end -}}
{{- range $path, $bytes := .Files.Glob "additionals/w-altermanager_*.yaml" -}}
  {{- $tpl := tpl ($bytes | toString) $root }}
  {{- if $tpl }}
  {{- $_ := set $yamls $tpl "" -}}
  {{- end }}
{{- end -}}
{{- if .Values.additionalAlertManagerConfigs -}}
  {{- $_ := set $yamls (.Values.additionalAlertManagerConfigs | toYaml) "" -}}
{{- end -}}
{{- if $yamls -}}
  {{- keys $yamls | join "\n" | quote -}}
{{- end -}}
{{- end -}}

{{- define "namespace.selector" -}}
{{- if and .selector .selector.matchLabels -}}
matchLabels:
{{ toYaml .selector.matchLabels | indent 2 }}
{{- end }}
matchExpressions:
{{- if .projectName }}
- key: "field.cattle.io/projectId"
  operator: "In"
  values: [ "{{ .projectName }}" ]
{{- end }}
{{- if and .selector .selector.matchExpressions }}
{{ toYaml .selector.matchExpressions }}
{{- end -}}
{{- end -}}

{{- define "serviceMonitor.namespace.selector" -}}
{{- $rootContext := dict -}}
{{- $_ := set $rootContext "projectName" .Values.global.projectName -}}
{{- $_ := set $rootContext "selector" .Values.serviceMonitorNamespaceSelector -}}
serviceMonitorNamespaceSelector:
{{ include "namespace.selector" $rootContext | indent 2 }}
{{- end -}}


{{/* vim: set filetype=mustache: */}}

{{- define "app.version" -}}
{{- $name := .Chart.Name -}}
{{- $version := .Chart.Version | replace "+" "_" -}}
{{- printf "%s-%s" $name $version -}}
{{- end -}}


{{- define "app.fullname" -}}
{{- $name := .Chart.Name -}}
{{- printf "%s-%s" $name .Release.Name -}}
{{- end -}}


{{- define "app.nginx.fullname" -}}
{{- $name := .Chart.Name -}}
{{- printf "%s-%s-nginx" $name .Release.Name -}}
{{- end -}}


{{- define "rbac_api_version" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" -}}
{{- "rbac.authorization.k8s.io/v1" -}}
{{- else if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1beta1" -}}
{{- "rbac.authorization.k8s.io/v1beta1" -}}
{{- else -}}
{{- "rbac.authorization.k8s.io/v1alpha1" -}}
{{- end -}}
{{- end -}}

{{/*
Windows cluster will add default taint for linux nodes,
add below linux tolerations to workloads could be scheduled to those linux nodes
*/}}
{{- define "linux-node-tolerations" -}}
- key: "cattle.io/os"
  value: "linux"
  effect: "NoSchedule"
  operator: "Equal"
{{- end -}}

{{- define "linux-node-selector" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
beta.kubernetes.io/os: linux
{{- else -}}
kubernetes.io/os: linux
{{- end -}}
{{- end -}}

{{- define "release_namespace" -}}
{{- default "harvester-monitoring" .Values.namespaceOverride -}}
{{- end -}}
