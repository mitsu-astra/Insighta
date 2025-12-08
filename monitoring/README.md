# CRM Sentiment Analysis - Monitoring Setup

This folder contains the Docker Compose configuration for Grafana and Prometheus monitoring.

## Quick Start

### Prerequisites

- Docker Desktop installed and running
- Backend server running on port 4000

### Start Monitoring Stack

```bash
cd monitoring
docker-compose up -d
```

### Access Dashboards

| Service    | URL                   | Credentials                    |
| ---------- | --------------------- | ------------------------------ |
| Grafana    | http://172.24.48.1:3001 | team.808.test@gmail.com / team@808 |
| Prometheus | http://172.24.48.1:9090 | -                              |
| Redis      | 172.24.48.1:6379        | -                              |

## Services

### Prometheus (Port 9090)

- Scrapes metrics from the backend at `/metrics`
- Collects Node.js runtime metrics
- Custom CRM metrics:
  - `http_requests_total` - Total HTTP requests
  - `http_request_duration_seconds` - Request latency
  - `active_users_total` - Registered users count
  - `verified_users_total` - Verified users count
  - `feedback_submitted_total` - Feedback submissions

### Grafana (Port 3001)

- Pre-configured with Prometheus datasource
- Auto-provisioned dashboard: "CRM Sentiment Analysis - Live Metrics"
- Default login: team.808.test@gmail.com / team@808
- Anonymous viewer access enabled

### Redis (Port 6379)

- Used by feedback processing queue (BullMQ)
- Persisted data in Docker volume

## Creating Grafana Dashboard

### Auto-Provisioned Dashboard (Default)

The "CRM Sentiment Analysis - Live Metrics" dashboard is automatically created on startup and displays:

- Total HTTP Requests count
- Total Users registered
- Users currently online
- Total Feedback submissions
- Request rate trend (5m average)
- Request latency (p95)
- Feedback breakdown by sentiment
- Memory usage over time

### Manual Dashboard Creation

If you want to create a custom dashboard:

1. Login to Grafana at http://172.24.48.1:3001
2. Go to Dashboards → New → New Dashboard
3. Add a panel and select Prometheus as data source
4. Use queries like:
   - `rate(http_requests_total[5m])` - Request rate
   - `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))` - P95 latency
   - `active_users_total` - Total users
   - `nodejs_heap_size_used_bytes` - Memory usage

## Example Prometheus Queries

```promql
# Request rate per minute
rate(http_requests_total[1m])

# Average response time
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])

# Error rate
rate(http_requests_total{code=~"5.."}[5m]) / rate(http_requests_total[5m])

# Memory usage in MB
nodejs_heap_size_used_bytes / 1024 / 1024

# Active event loop lag
nodejs_eventloop_lag_seconds
```

## Stop Monitoring

```bash
docker-compose down
```

To remove all data volumes:

```bash
docker-compose down -v
```

## Troubleshooting

### Backend not showing in Prometheus

1. Ensure backend is running: `npm run dev` in server folder
2. Check metrics endpoint: http://172.24.48.1:4000/metrics
3. On Windows, `host.docker.internal` should resolve to host machine

### Grafana can't connect to Prometheus

1. Both containers must be on the same Docker network
2. Check if Prometheus is running: http://172.24.48.1:9090
3. Verify datasource configuration in Grafana

## Environment Variables

You can customize the setup in `docker-compose.yml`:

```yaml
environment:
  - GF_SECURITY_ADMIN_PASSWORD=your_secure_password
  - GF_USERS_ALLOW_SIGN_UP=false
```
