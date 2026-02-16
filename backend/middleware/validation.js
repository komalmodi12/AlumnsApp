import Joi from 'joi';
import logger from './logger.js';

export const validateRequest = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(
      {
        body: req.body,
        query: req.query,
        params: req.params,
      },
      { abortEarly: false }
    );

    if (error) {
      const details = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message,
      }));
      
      logger.warn({ validationErrors: details }, 'Validation failed');
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: details,
      });
    }

    req.validated = value;
    next();
  };
};

// Common validation schemas
export const loginSchema = Joi.object({
  body: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().min(6).required(),
  }),
});

export const paginationSchema = Joi.object({
  query: Joi.object({
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(10),
  }),
});
