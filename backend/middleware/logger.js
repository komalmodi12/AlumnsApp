import pino from 'pino';
import pinoHttp from 'pino-http';
import config from '../config/env.js';

const logger = pino({
  level: config.app.logLevel,
  transport: config.app.isDevelopment
    ? {
        target: 'pino-pretty',
        options: {
          colorize: true,
          singleLine: false,
          translateTime: 'HH:MM:ss Z',
          ignore: 'pid,hostname',
        },
      }
    : undefined,
});

export const httpLogger = pinoHttp({
  logger,
  customSuccessMessage: (req, res) => `${req.method} ${req.url} completed with status ${res.statusCode}`,
  customErrorMessage: (req, res, error) => `${req.method} ${req.url} failed with status ${res.statusCode}`,
});

export default logger;
