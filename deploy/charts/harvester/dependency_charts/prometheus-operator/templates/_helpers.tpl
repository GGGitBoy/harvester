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



{{- define "deployment_api_version" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1" -}}
{{- "apps/v1" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta2" -}}
{{- "apps/v1beta2" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta1" -}}
{{- "apps/v1beta1" -}}
{{- else -}}
{{- "extensions/v1beta1" -}}
{{- end -}}
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
