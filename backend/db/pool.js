import pg from 'pg';
import config from '../config/env.js';
import logger from '../middleware/logger.js';

const { Pool } = pg;

const pool = new Pool({
  host: config.database.host,
  port: config.database.port,
  database: config.database.database,
  user: config.database.user,
  password: config.database.password,
  max: config.database.max,
  idleTimeoutMillis: config.database.idleTimeoutMillis,
  connectionTimeoutMillis: config.database.connectionTimeoutMillis,
});

pool.on('error', (err) => {
  logger.error(err, 'Unexpected pool error');
});

pool.on('connect', () => {
  logger.info('Database pool connection established');
});

export const query = async (text, params) => {
  const start = Date.now();
  try {
    const result = await pool.query(text, params);
    const duration = Date.now() - start;
    logger.debug({ text, duration }, 'Database query');
    return result;
  } catch (err) {
    logger.error({ err, text }, 'Database query error');
    throw err;
  }
};

export const getClient = async () => {
  return await pool.connect();
};

export const closePool = async () => {
  await pool.end();
  logger.info('Database pool closed');
};

export default pool;
