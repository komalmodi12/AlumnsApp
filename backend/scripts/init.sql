-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);

-- Insert sample data
INSERT INTO users (name, email, password) VALUES
  ('Test User', 'user@example.com', 'password'),
  ('Admin User', 'admin@example.com', 'admin123')
ON CONFLICT (email) DO NOTHING;

INSERT INTO posts (user_id, title, body) VALUES
  (1, 'First Post', 'This is the body of the first post'),
  (1, 'Second Post', 'This is the body of the second post'),
  (2, 'Admin Post', 'Admin user post content here')
ON CONFLICT DO NOTHING;
