import express from 'express';
import 'express-async-errors';
import cors from 'cors';
import helmet from 'helmet';
import config from './config/env.js';
import { httpLogger } from './middleware/logger.js';
import { errorHandler, notFound } from './middleware/errorHandler.js';
import { authMiddleware, generateToken } from './middleware/auth.js';
import { validateRequest, loginSchema, paginationSchema } from './middleware/validation.js';
import { query } from './db/pool.js';
import logger from './middleware/logger.js';

const app = express();

// Security middleware
app.use(helmet());
app.use(cors(config.cors));

// Request parsing
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ limit: '10kb', extended: true }));

// Logging
app.use(httpLogger);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    success: true,
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Readiness check for Kubernetes/ECS
app.get('/ready', async (req, res) => {
  try {
    await query('SELECT 1');
    res.json({
      success: true,
      status: 'ready',
      timestamp: new Date().toISOString(),
    });
  } catch (err) {
    logger.error(err, 'Readiness check failed');
    res.status(503).json({
      success: false,
      status: 'not ready',
      error: 'Database connection failed',
    });
  }
});

// Login endpoint
app.post('/login', validateRequest(loginSchema), async (req, res) => {
  const { email, password } = req.validated.body;

  try {
    // Query user from database
    const result = await query(
      'SELECT id, name, email FROM users WHERE email = $1 AND password = $2',
      [email, password]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    const user = result.rows[0];
    const token = generateToken({
      sub: user.id,
      email: user.email,
      iat: Math.floor(Date.now() / 1000),
    });

    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
        },
      },
    });
  } catch (err) {
    logger.error(err, 'Login error');
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
});

// Get user profile
app.get('/profile', authMiddleware, async (req, res) => {
  try {
    const result = await query(
      'SELECT id, name, email FROM users WHERE id = $1',
      [req.user.sub]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    logger.error(err, 'Profile fetch error');
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
});

// List posts (paginated)
app.get('/posts', validateRequest(paginationSchema), async (req, res) => {
  const { page, limit } = req.validated.query;
  const offset = (page - 1) * limit;

  try {
    const countResult = await query('SELECT COUNT(*) as count FROM posts');
    const total = parseInt(countResult.rows[0].count, 10);

    const postsResult = await query(
      'SELECT id, title, body, created_at FROM posts ORDER BY created_at DESC LIMIT $1 OFFSET $2',
      [limit, offset]
    );

    res.json({
      success: true,
      data: postsResult.rows,
      meta: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (err) {
    logger.error(err, 'Posts fetch error');
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
});

// Error handling middleware
app.use(notFound);
app.use(errorHandler);

// Start server
const port = config.app.port;
app.listen(port, () => {
  logger.info(
    {
      port,
      nodeEnv: config.app.nodeEnv,
      isDevelopment: config.app.isDevelopment,
    },
    `Server listening on port ${port}`
  );
});

export default app;
