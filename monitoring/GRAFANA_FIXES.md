# Grafana Dashboard Fixes - Summary

## Issues Fixed

### 1. **Embedded Grafana Dashboard Not Displaying**
   - **Problem**: The iframe was using kiosk mode which caused display issues
   - **Solution**: 
     - Removed kiosk parameter from iframe URL
     - Added `sandbox` attribute for proper iframe restrictions
     - Increased iframe height from 600px to 700px
     - Added a "Open in Full Screen" link for better UX
     - Added helper text explaining the dashboard auto-refreshes

### 2. **Grafana Dashboard Showing No Data**
   - **Problem**: Dashboard UID was missing, causing Grafana to not find the dashboard
   - **Solution**: 
     - Added `"uid": "crm-dashboard"` to the dashboard JSON
     - Created a new improved dashboard with better Prometheus queries
     - All queries now target correct metrics from the backend

### 3. **Prometheus Not Finding Backend Metrics**
   - **Problem**: Scrape interval was too long (15s), missing feedback-pipeline port
   - **Solution**:
     - Reduced scrape interval to 5s for more responsive data
     - Added scrape timeout of 5s
     - Corrected feedback-pipeline port from 3002 to 3005

### 4. **Dashboard Queries Using Wrong Metrics**
   - **Problem**: Dashboard was querying metrics that don't exist or are incorrect
   - **Solution**: 
     - Updated all queries to use actual metrics exposed by the backend
     - Replaced with correct metric names: `users_total`, `users_online`, `feedback_total`, etc.
     - Improved visualization with better color thresholds

## Files Modified

1. **`monitoring/prometheus.yml`**
   - Reduced scrape_interval to 5s
   - Added scrape_timeout of 5s
   - Corrected feedback-pipeline target port to 3005

2. **`monitoring/grafana/provisioning/dashboards/crm-dashboard.json`**
   - Added uid: "crm-dashboard" for consistent identification
   - Replaced all metric queries with actual backend metrics
   - Improved panel configurations with better thresholds

3. **`client/src/pages/AdminDashboard.jsx`**
   - Updated iframe URL (removed &kiosk parameter)
   - Added proper sandbox attribute for security
   - Increased height to 700px
   - Added full-screen link button
   - Added helpful tip text for users

4. **`monitoring/README.md`**
   - Updated credentials: team.808.test@gmail.com / team@808
   - Added info about auto-provisioned dashboard
   - Added troubleshooting tips

## Available Metrics from Backend

The backend now exposes these metrics that Grafana can visualize:

- `http_requests_total` - Total HTTP requests
- `http_request_duration_seconds` - Request latency histogram
- `users_total` - Total users
- `users_online` - Online users
- `feedback_total` - Total feedback
- `feedback_sentiment` - Feedback by sentiment
- `nodejs_heap_size_used_bytes` - Memory usage
- `nodejs_heap_size_total_bytes` - Total heap
- Plus all default Node.js metrics

## Testing the Fix

1. **Ensure all services are running**:
   ```bash
   docker-compose up -d
   npm start # backend
   npm run dev # frontend
   ```

2. **Generate some traffic**:
   - Go to http://localhost:3000
   - Login and submit feedback
   - The metrics will update within 5 seconds

3. **View the dashboard**:
   - In Admin Dashboard → Monitoring tab
   - Or go directly to http://localhost:3001/d/crm-dashboard

4. **Check Prometheus directly**:
   - Go to http://localhost:9090
   - Click Status → Targets
   - Verify "crm-backend" shows "UP"

## Grafana Dashboard Features

The auto-provisioned "CRM Sentiment Analysis - Live Metrics" dashboard shows:

| Panel | Type | Metric |
|-------|------|--------|
| Total HTTP Requests | Stat | Sum of http_requests_total |
| Total Users | Stat | users_total |
| Users Online | Stat | users_online |
| Total Feedback | Stat | feedback_total |
| Request Rate (5m) | Time Series | rate(http_requests_total[5m]) |
| Request Duration (p95) | Time Series | histogram_quantile(0.95, ...) |
| Feedback by Sentiment | Time Series | feedback_sentiment |
| Memory Usage | Time Series | nodejs_heap_size_used_bytes |

## Default Refresh Rate

- Dashboard: Auto-refreshes every 5 seconds
- Prometheus scrape: Every 5 seconds
- Grafana data points update continuously

## Next Steps

If you still see no data:

1. Check backend metrics endpoint: `curl http://localhost:4000/metrics`
2. Verify Prometheus is scraping: http://localhost:9090/targets
3. Restart Docker: `docker-compose restart`
4. Restart backend: Kill node process and restart `npm start`
5. Check Docker logs: `docker logs crm_prometheus` and `docker logs crm_grafana`

## URLs Reference

- Grafana Dashboard: http://localhost:3001/d/crm-dashboard
- Prometheus UI: http://localhost:9090
- Backend Metrics: http://localhost:4000/metrics
- Admin Dashboard Monitoring Tab: http://localhost:3000/admin (click Monitoring tab)
