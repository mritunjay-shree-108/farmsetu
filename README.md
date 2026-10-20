# FarmSetu: Direct Farmer-to-Consumer E-Commerce Platform

**Team Name:** BroCode  
**Team Leader:** Mritunjay Shree  
**Team Members:** Mritunjay Shree, Ajay Kumar Yadav, Jyotish Kumar, Md. Taushif Iqbal  
**Mentor:** Prof. Sourav Mahapatra

---

## Getting Started Locally

### Prerequisites

- **Node.js**: v18.x or higher
- **PostgreSQL**: v15 or higher with **PostGIS** extension installed
- **pnpm / npm**

---

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone [https://github.com/YOUR_USERNAME/farmsetu.git](https://github.com/YOUR_USERNAME/farmsetu.git)
cd farmsetu
```

### 2. Install Monorepo Dependencies

```bash
    npm install
```

### 3. Database Migration & Seeding

```bash
    psql -U postgres -d farmsetu -f packages/database/migrations/001_initial_schema.sql
```

### 4. Run Development Microservices

```bash
    npm run dev
```
