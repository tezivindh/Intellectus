{{- define "Intellectus.name" -}}{{ .Release.Name }}{{- end -}}
{{- define "Intellectus.labels" -}}
app.kubernetes.io/name: Intellectus
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "Intellectus.security" -}}
allowPrivilegeEscalation: false
capabilities:
  drop: [ALL]
runAsNonRoot: true
seccompProfile:
  type: RuntimeDefault
{{- end -}}
{{- define "Intellectus.wait" -}}
- name: wait-for-migrations
  image: "{{ .Values.images.backend.repository }}:{{ .Values.images.backend.tag }}"
  imagePullPolicy: {{ .Values.images.backend.pullPolicy }}
  command: [python, scripts/wait_for_migrations.py]
  envFrom:
    - configMapRef: { name: {{ include "Intellectus.name" . }}-config }
    - secretRef: { name: {{ .Values.secretName }} }
  securityContext:
    {{- include "Intellectus.security" . | nindent 4 }}
{{- end -}}
