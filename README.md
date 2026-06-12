# Event System

A full-stack event registration and waitlist management system built with Ruby on Rails 8.

## Features

- **Authentication** — Sign up, login, email confirmation via Devise
- **Authorization** — Role-based access control (Admin, Organizer, Attendee) via Pundit
- **Events** — Create, edit, cancel events with unique title enforcement
- **Registration** — Register for events with capacity enforcement
- **Waitlist** — Auto-promotion when a registered user cancels, with position updates
- **Notifications** — In-app and email notifications for registrations, waitlist updates, cancellations
- **Admin Dashboard** — Manage users, view all registrations and waitlist entries
- **Background Jobs** — Sidekiq + Redis for async job processing
- **Pagination** — Kaminari for all listing pages

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1.3 |
| Database | PostgreSQL |
| Authentication | Devise |
| Authorization | Pundit |
| Background Jobs | Sidekiq + Redis |
| Email | Action Mailer (Gmail SMTP) |
| Frontend | Bootstrap 5 |
| Containerization | Docker + Docker Compose |

## Roles

| Role | Permissions |
|---|---|
| Admin | Full access — manage users, view dashboard, cancel any event |
| Organizer | Create and manage their own events |
| Attendee | Browse events, register, join waitlist |

## Getting Started

### Local Development

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Set up environment variables** — create a `.env` file:
   ```
   GMAIL_USERNAME=your@gmail.com
   GMAIL_PASSWORD=your_app_password
   RAILS_MASTER_KEY=your_master_key
   ```

3. **Set up the database:**
   ```bash
   bin/rails db:create db:migrate db:seed
   ```

4. **Start Redis and Sidekiq:**
   ```bash
   redis-server
   bundle exec sidekiq
   ```

5. **Start the server:**
   ```bash
   bin/rails server
   ```

Visit `http://localhost:3000` and log in with `admin@admin.com` / `password123`.

### Docker

```bash
docker compose up --build
```

Visit `http://localhost:3000`.

## Code Quality

```bash
bundle exec rubocop      # linting
bundle exec brakeman     # security scan
```

Overcommit runs RuboCop and Brakeman automatically on every `git commit`.
