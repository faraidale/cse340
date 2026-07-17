# W02 Coaching Session Transcript

## Assignment Summary
This transcript documents a coaching session about database retrieval and server-side rendering for the CSE 340 service network project. The conversation covers relational database structure, Node.js data access logic, Express routing, and EJS template rendering with snippets from the project code.

## Session Details
- Estimated duration: 35 minutes
- Topic focus: Database retrieval, routing, and client-side rendering
- Project context: A Node.js/Express web app that retrieves data from PostgreSQL and renders pages using EJS

---

## Coaching Session Transcript

**Student:** I’m preparing for my W02 coaching session, and I want to explain how my project retrieves and displays data from a database. I built a small Express app that connects to PostgreSQL and renders pages for organizations, projects, and categories.

**AI Coach:** That sounds like a strong foundation. Let’s start with the database design. In your project, you created several tables. Can you explain the purpose of those tables and how they relate to each other?

**Student:** Yes. I created a relational database structure in my SQL setup file with separate tables for organizations, projects, categories, and a junction table called project_category.

```sql
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, category_id),
    FOREIGN KEY (project_id) REFERENCES project (project_id),
    FOREIGN KEY (category_id) REFERENCES category (category_id)
);
```

**AI Coach:** Excellent. That shows a good understanding of relational design. The organization table stores information about partner organizations, the project table stores project details, and the category table stores types of projects. The project_category table is the relationship table that connects projects to categories, which is a classic many-to-many relationship.

**Student:** Exactly. A single project can belong to multiple categories, and a single category can be assigned to multiple projects. The junction table makes that possible by linking the two tables through foreign keys.

**AI Coach:** Perfect. That is the right idea. Your database design is organized and clearly separates entities while preserving relationships between them.

---

**AI Coach:** Let’s move to the server-side data access logic. How does your Node.js code retrieve data from the database?

**Student:** The application uses model files to isolate the database queries from the route handlers. For example, my projects model defines a function that selects all projects from the project table.

```javascript
import db from './db.js';

const getAllProjects = async () => {
    const query = `
        SELECT project_id, name, description
        FROM public.project;
    `;
    const result = await db.query(query);
    return result.rows;
};

export { getAllProjects };
```

**AI Coach:** Good. That snippet shows the full flow of data retrieval. The function imports the database connection object, constructs a SQL query, sends it to the database using `db.query(query)`, and then returns the rows from the result. That is a clean pattern because the model handles the database logic while the route keeps the HTTP logic separate.

**Student:** I also have a shared database module that creates the PostgreSQL pool and exposes the query interface.

```javascript
import { Pool } from 'pg';

const pool = new Pool({
    connectionString: process.env.DB_URL,
    ssl: { rejectUnauthorized: false }
});

const testConnection = async () => {
    try {
        const result = await db.query('SELECT NOW() as current_time');
        console.log('Database connection successful:', result.rows[0].current_time);
        return true;
    } catch (error) {
        console.error('Database connection failed:', error.message);
        throw error;
    }
};
```

**AI Coach:** Exactly. The database module manages the connection pool, and your model functions use it to execute queries. That is a strong software design because it keeps the database access logic organized and reusable.

---

**AI Coach:** Now let’s talk about Express server logic and routing. How does your server receive a request and decide what to do with it?

**Student:** In my server.js file, I use Express route handlers to map URLs to specific actions. For example, the `/projects` route calls the model function, retrieves the data, and then passes it to the EJS view.

```javascript
import express from 'express';
import { getAllProjects } from './src/models/projects.js';

const app = express();

app.get('/projects', async (req, res) => {
    const projects = await getAllProjects();
    const title = 'Service Projects';
    res.render('projects', { title, projects });
});
```

**AI Coach:** That is a very good example of route handling. The `app.get('/projects', ...)` method registers a route for the `/projects` URL path. When the browser requests that path, the callback runs, gets the data from the model, and uses `res.render()` to send a response to the client. The route handler is responsible for coordinating the request flow.

**Student:** I also configure the view engine and static assets in the server.

```javascript
app.set('view engine', 'ejs');
app.use(express.static('public'));
```

**AI Coach:** Right. Setting the view engine to EJS tells Express how to render dynamic templates, and serving the public folder makes CSS and images available to the browser. That makes the server more complete and easier to maintain.

---

**AI Coach:** Finally, let’s discuss client-side rendering with EJS templates. How does the data get from the server into the page the user sees?

**Student:** The route passes the data into the EJS template when it calls `res.render()`. Then the template uses that data to generate HTML dynamically. In my projects view, I loop through the list of projects and display each one.

```ejs
<%- include('partials/header') %>
<h1><%= title %></h1>
<ul>
  <% projects.forEach(project => { %>
    <li><strong><%= project.name %></strong> - <%= project.description %></li>
  <% }); %>
</ul>
<%- include('partials/footer') %>
```

**AI Coach:** Excellent. This is exactly the right explanation. The route sends an object containing the `title` and `projects` variables, and the EJS template accesses them with embedded JavaScript expressions. The `<% ... %>` syntax runs logic such as the `forEach` loop, while `<%= ... %>` inserts values into the HTML output. That is the core of server-side rendering with EJS.

**Student:** So the full flow is: the route receives the request, the model queries the database, the route passes the result to the EJS template, and the template renders the page for the user. That shows how the whole app works together.

**AI Coach:** Yes, and that is a strong understanding of the architecture. Your project demonstrates the connection between database design, server logic, data access, and template rendering in a very coherent way.

---

## Closing Reflection
The coaching session showed that my project uses a clear flow of data:
- The database stores structured information in tables and relationships.
- The Node.js model functions retrieve that data using SQL queries.
- The Express route handlers coordinate the request and send the data to the view.
- The EJS templates render the data into HTML for the browser.

This session helped me understand how each part of the project contributes to the full web application experience.
