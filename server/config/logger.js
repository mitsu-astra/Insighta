import pino from "pino";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Create logs directory if it doesn't exist
const logsDir = path.join(__dirname, "../logs");
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

// Configure Pino logger for ELK integration
const logger = pino(
  {
    level: process.env.LOG_LEVEL || "info",
    formatters: {
      level: (label) => ({ level: label }),
    },
    timestamp: pino.stdTimeFunctions.isoTime,
    base: {
      service: "server",
      environment: process.env.NODE_ENV || "development",
    },
  },
  pino.multistream([
    // Write to file for Filebeat to collect
    {
      stream: fs.createWriteStream(path.join(logsDir, "server.json"), {
        flags: "a",
      }),
    },
    // Also write to console for development
    { stream: process.stdout },
  ])
);

// Helper functions for common log patterns
export const logInfo = (message, data = {}) => {
  logger.info({ ...data, msg: message });
};

export const logError = (message, error = null, data = {}) => {
  logger.error({
    ...data,
    msg: message,
    error: error
      ? {
          message: error.message,
          stack: error.stack,
          name: error.name,
        }
      : undefined,
  });
};

export const logWarn = (message, data = {}) => {
  logger.warn({ ...data, msg: message });
};

export const logDebug = (message, data = {}) => {
  logger.debug({ ...data, msg: message });
};

// Request logging middleware
export const requestLogger = (req, res, next) => {
  const start = Date.now();

  res.on("finish", () => {
    const duration = Date.now() - start;
    logger.info({
      msg: "HTTP Request",
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration_ms: duration,
      user_agent: req.get("user-agent"),
      ip: req.ip,
      user_id: req.userId || "anonymous",
    });
  });

  next();
};

// Authentication event logger
export const logAuthEvent = (event, userId, metadata = {}) => {
  logger.info({
    msg: `Auth Event: ${event}`,
    event_type: "authentication",
    event_name: event,
    user_id: userId,
    ...metadata,
  });
};

// Feedback event logger
export const logFeedbackEvent = (event, data = {}) => {
  logger.info({
    msg: `Feedback Event: ${event}`,
    event_type: "feedback",
    event_name: event,
    ...data,
  });
};

// Database event logger
export const logDbEvent = (event, data = {}) => {
  logger.info({
    msg: `Database Event: ${event}`,
    event_type: "database",
    event_name: event,
    ...data,
  });
};

export default logger;
