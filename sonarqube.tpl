{{- /* Template based on https://docs.sonarqube.org/latest/analysis/generic-issue/ */ -}}
{
  "issues": [
  {{- $t_first := true }}
  {{- range . }}
  {{- $target := .Target }}
    {{- range .Vulnerabilities -}}
    {{- if $t_first -}}
      {{- $t_first = false -}}
    {{ else -}}
      ,
    {{- end }}
    {
      "engineId": "TRIVY",
      "ruleId": "ContainerScanning",
      "severity": {{ if eq .Severity "UNKNOWN" -}}
                    "INFO"
                  {{- else if eq .Severity "LOW" -}}
                    "INFO"
                  {{- else if eq .Severity "MEDIUM" -}}
                    "MINOR"
                  {{- else if eq .Severity "HIGH" -}}
                    "MAJOR"
                  {{- else if eq .Severity "CRITICAL" -}}
                    "CRITICAL"
                  {{-  else -}}
                    "INFO"
                  {{- end }},
      "type": "VULNERABILITY",
      "primaryLocation": {
        "message": "{{ .PkgName }} - {{ .VulnerabilityID }} - {{ .Title }}",
        "filePath": "Dockerfile"
      }
    }
    
    {{- end -}}
  {{- end }}
  ]
}
