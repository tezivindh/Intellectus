# Intellectus â€” Demo Materials

This directory contains presentation and demonstration materials for the DevSecOps capstone.

## Live Demo Script (8â€“10 minutes)

### Step 1 â€” Product walkthrough (2 min)
1. Open `http://localhost:3000` in a browser
2. Register a new account â†’ create an organization (e.g., "Acme Corp")
3. Upload a PDF policy document (e.g., an employee handbook)
4. Wait ~15 seconds for the Celery worker to index the document (embedding model downloads on first use)
5. Ask a question: *"How many days of annual leave do employees get?"*
6. Show the grounded answer with **clickable citation** links back to the exact page/section

### Step 2 â€” API & quality gates (1 min)
```bash
curl http://localhost:8000/health
curl http://localhost:8000/ready
```
Show the 200 response with all four backing services green.

### Step 3 â€” Docker multi-stage build (1 min)
```bash
docker compose ps
docker compose exec backend id   # uid=10001 (non-root)
docker compose exec frontend id  # uid=101 (nginx non-root)
```

### Step 4 â€” Make a visible change and push (2 min)
Edit `frontend/src/app/page.tsx` â€” change the hero tagline in `HEADLINE` or the CTA button text.
```bash
git add frontend/src/app/page.tsx
git commit -m "ui: update hero headline for demo presentation"
git push origin main
```
Watch GitHub Actions at `https://github.com/tezivindh/Intellectus/actions`.

### Step 5 â€” CI/CD pipeline (1 min)
Point at the running Actions workflow showing:
- `backend-tests` (pytest 91 tests + ruff + mypy + alembic check)
- `frontend-checks` (npm test + lint + tsc + build)
- `infrastructure-checks` (terraform validate + test + helm lint)
- `secret-scan` (gitleaks)
- `images` (backend + frontend + next built, Trivy scanned, pushed to GHCR with SHA tag)

### Step 6 â€” Kubernetes + Terraform (1 min)
Show:
```bash
kubectl get pods -n Intellectus       # all Running
kubectl get svc,ingress -n Intellectus
helm list -n Intellectus
```
Show AWS Console: VPC `Intellectus-vpc` and EKS cluster `Intellectus` in `ap-south-1`.

### Step 7 â€” Observability (1 min)
```bash
curl http://localhost:8000/metrics | grep Intellectus_http
```
Open Grafana dashboard â€” show HTTP request rate and latency panels with live data.

### Step 8 â€” Security cleanup
```bash
# After evaluation:
cd terraform && terraform destroy -auto-approve
```
Capture the "Destroy complete!" output as evidence.

---

## Key URLs

| Service | URL |
|---------|-----|
| Application | http://localhost:3000 |
| Backend API health | http://localhost:8000/health |
| Backend readiness | http://localhost:8000/ready |
| API docs (debug mode) | http://localhost:8000/api/docs |
| Prometheus metrics | http://localhost:8000/metrics |
| MinIO console | http://localhost:9001 |
| GitHub Actions | https://github.com/tezivindh/Intellectus/actions |
| GHCR packages | https://github.com/tezivindh/Intellectus/pkgs/container |

---

## Architecture Diagram

```
Browser
  â”‚
  â–¼
Nginx (port 3000) â”€â”€â”€â”€â”€â”€â”€â”€ non-root, multi-stage build
  â”‚        â”‚
  â”‚        â–¼
  â”‚     Next.js server (port 3001) â”€â”€ dynamic SSR routes
  â”‚
  â–¼
FastAPI (port 8000) â”€â”€ non-root Wolfi container
  â”‚       â”‚        â”‚
  â”‚       â–¼        â–¼
  â”‚   PostgreSQL  Qdrant (vector search)
  â”‚   (SQLAlchemy/Alembic)
  â”‚
  â”œâ”€â”€ Redis â”€â”€ Celery worker (ingestion, conflict scans)
  â”‚
  â””â”€â”€ MinIO (original file storage)

Prometheus â”€â”€ scrapes /metrics every 15s
Grafana â”€â”€â”€â”€ reads Prometheus, shows HTTP request/latency panels
```

---

## Presentation Checklist

- [ ] Application running (`docker compose up -d` complete)
- [ ] Document uploaded and indexed (worker processed it)
- [ ] Q&A with citations demonstrated
- [ ] `/health` and `/ready` shown live
- [ ] Non-root user verified (`id` in container)
- [ ] Commit pushed, Actions pipeline shown running
- [ ] Trivy scan result explained (see `docs/SECURITY.md`)
- [ ] AWS Terraform plan output shared (`evidence/terraform-mock-plan.txt`)
- [ ] Kubernetes pods shown Running
- [ ] Grafana dashboard with live HTTP metrics
- [ ] Terraform destroy output saved as evidence
