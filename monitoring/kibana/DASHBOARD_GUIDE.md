# Kibana Dashboard Setup Guide

## Available Dashboards

### 1. CRM Analytics Dashboard

**Purpose**: Real-time monitoring of application performance and user activities

**Key Visualizations**:

- Total request count (24h window)
- HTTP status code distribution
- Authentication event timeline
- Error rate trends
- Feedback sentiment analysis
- User activity patterns
- API response time histogram
- Recent error logs table

**Recommended Use**: Daily operations monitoring

### 2. Security & Audit Dashboard

**Focus Areas**:

- Failed login attempts
- Admin actions audit trail
- Unusual activity patterns
- Geographic access patterns

### 3. Performance Monitoring Dashboard

**Metrics**:

- API endpoint latency (p50, p95, p99)
- Database query performance
- Queue processing times
- Memory/CPU usage correlation

## How to Import Dashboards

### Method 1: Kibana UI Import

1. Open Kibana at `http://localhost:5601`
2. Navigate to **Stack Management** → **Saved Objects**
3. Click **Import**
4. Select the dashboard JSON file
5. Confirm import settings

### Method 2: API Import

```bash
curl -X POST "http://localhost:5601/api/saved_objects/_import" \
  -H "kbn-xsrf: true" \
  --form file=@crm-analytics-dashboard.json
```

### Method 3: PowerShell Import

```powershell
$headers = @{ "kbn-xsrf" = "true" }
$file = "monitoring\kibana\dashboards\crm-analytics-dashboard.json"
Invoke-RestMethod -Uri "http://localhost:5601/api/saved_objects/_import" `
  -Method Post -Headers $headers -InFile $file
```

## Create Custom Index Patterns

After starting ELK stack, create these index patterns:

### Main Logs Index

```
Name: crm-logs-*
Time field: @timestamp
```

### Error Logs Index

```
Name: crm-errors-*
Time field: @timestamp
```

### Authentication Logs Index

```
Name: crm-auth-*
Time field: @timestamp
```

### Feedback Logs Index

```
Name: crm-feedback-*
Time field: @timestamp
```

## Useful Kibana Queries

### Find All Errors in Last Hour

```
log_level:error AND @timestamp:[now-1h TO now]
```

### Track Specific User Activity

```
user_id:"USER_ID_HERE"
```

### Monitor Failed Login Attempts

```
event_name:login AND log_level:error
```

### Sentiment Analysis Results

```
service:worker AND sentiment_label:*
```

### Slow API Endpoints (>2 seconds)

```
duration_ms:>2000
```

### Database Connection Issues

```
log_message:*database* AND log_level:error
```

## Dashboard Refresh Intervals

**Real-time monitoring**: 10s
**Operations dashboard**: 30s
**Historical analysis**: 5m or manual
**Audit reports**: Manual refresh

## Alert Rules (To Configure)

1. **High Error Rate**

   - Threshold: >10 errors/minute
   - Action: Email notification

2. **Slow API Performance**

   - Threshold: p95 latency >3s
   - Action: Slack notification

3. **Failed Login Spike**

   - Threshold: >5 failed attempts in 5 minutes
   - Action: Security alert

4. **Service Down**
   - Threshold: No logs for 5 minutes
   - Action: PagerDuty alert

## Best Practices

1. **Index Lifecycle Management**

   - Delete logs older than 30 days automatically
   - Archive important logs to S3/Azure Blob

2. **Dashboard Performance**

   - Limit time range for heavy queries
   - Use sampling for large datasets
   - Cache aggregation results

3. **Security**

   - Enable Kibana authentication in production
   - Restrict access by role (admin, viewer, analyst)
   - Audit dashboard access logs

4. **Maintenance**
   - Monitor Elasticsearch cluster health
   - Optimize index mappings
   - Regular backup of Kibana objects
