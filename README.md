# Data Platform Case Study

This repository contains a take-home assignment designed to evaluate data engineering, analytics, and backend fundamentals for the Data Platform team.

The assignment focuses on integrating data from multiple source databases, building an analytics-ready data warehouse, deriving business insights, and exposing curated data via APIs.

## Context
Our business manages user onboarding, customer profiles, and financial transactions. To support decision-making, we want to understand user behavior across onboarding and transactions.

You are given 3 datasets in CSV format, each representing a table in a different Postgres database:

## Table Definitions

### Database A → `users` table (`users.csv`)
- `user_id` - unique identifier for each user
- `name`
- `email`
- `phone`
- `created_at`

### Database B → `onboarding` table (`onboarding.csv`)
- `onboarding_id` - unique identifier for each onboarding record
- `user_id` - identifier that matches with `users.user_id` in Database A
- `role` (e.g., merchant, customer, agent, admin)
- `status` (e.g., pending, kyc_done, rejected, completed)
- `onboarding_date`

### Database C → `transactions` table (`transactions.csv`)
- `transaction_id` - unique identifier for each transaction
- `user_id` - identifier that matches with `users.user_id` in Database A
- `amount`
- `transaction_date`

---

## Assignment Scope & Expectations

Design and implement an end-to-end, dockerized data analytics system that integrates user, onboarding, and transaction data from multiple databases into a centralized data warehouse and expose data through APIs.

Your solution should:
- Propose and implement a scalable data integration and management approach with a single source of truth by choosing any data warehouse of your choice.
- Produce analytics covering:
  - Daily KYC completions and week-over-week growth
  - Top 5 users per day by transaction amount and their contribution percentage
  - Transaction statistics (average, median, min, max)
  - Comparison of transaction behavior for KYC-completed vs pending users, with a focus on merchants
- Expose curated analytics data via APIs for downstream consumers(writing unit tests for APIs is a huge plus)
- Provide a fully dockerized local setup, SQL/transformations, a short analytical report, and clear setup documentation.

---

## Notes
- These datasets are synthetic but reflect realistic distributions.
- There are no enforced foreign key constraints across databases. Instead, `user_id` serves as a business key to logically link records.

---

## CSV Files(Under data directory)
- `users.csv` (Database A – user profile data)
- `onboarding.csv` (Database B – user onboarding info)
- `transactions.csv` (Database C – transaction logs)
