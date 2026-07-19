# W03 Coaching Session Transcript

## Assignment Summary
This transcript documents a coaching session about the Model-View-Controller pattern in the CSE 340 service network project. The conversation covers models, views, controllers, and error handling with snippets from the project code.

## Session Details
- Estimated duration: 40 minutes
- Topic focus: MVC architecture, routing, EJS views, and error handling
- Project context: A Node.js and Express web application that retrieves data from PostgreSQL and renders dynamic pages

---

## Coaching Session Transcript

**Student:** I’m preparing for my W03 coaching session, and I want to explain how my project uses the Model-View-Controller pattern. My app is organized into separate files for models, views, and controllers, and each part has a clear responsibility.

**AI Coach:** That sounds like a strong understanding already. Let’s start with the model layer. In your application, where do the database queries live?

**Student:** The database logic lives in the model files. For example, in my projects model I have a function that accepts a parameter and uses it in an SQL query. This function retrieves a single project by its ID.

```javascript
const getProjectDetails = async (projectId) => {
    const query = `
        SELECT project_id, organization_id, name, description, location, date
        FROM project
        WHERE project_id = $1;
    `;
    const queryParams = [projectId];
    const result = await db.query(query, queryParams);
    return result.rows.length > 0 ? result.rows[0] : null;
};
```

**AI Coach:** Excellent. That is exactly what a model should do. The function accepts a parameter, places it into the SQL query using `$1`, and returns the matching row. That shows that the model handles the data access logic and keeps the database concern separate from the rest of the app.

**Student:** I also use model functions for related data, such as getting projects by organization or category. That helps keep the controller code focused on request handling rather than SQL details.

---

**AI Coach:** Great. Now let’s talk about the view layer. How does your application insert data into the HTML that users see?

**Student:** The views are written in EJS, and they receive data from the controller through `res.render()`. In my project detail page, I display the project name, description, and a link to the organization that created it.

```ejs
<%- include('partials/header') %>
<h1><%= projectDetails.name %></h1>
<p><%= projectDetails.description %></p>
<p>Organized by: <a href="/organization/<%= organization.organization_id %>"><%= organization.name %></a></p>

<h2>Categories</h2>
<ul>
  <% categories.forEach(category => { %>
    <li><a href="/category/<%= category.category_id %>"><%= category.name %></a></li>
  <% }); %>
</ul>
<%- include('partials/footer') %>
```

**AI Coach:** That is a strong example of view logic. The EJS template inserts dynamic values into the HTML using `<%= ... %>`, and it also uses data from the server to build links. The links include the organization ID and category ID directly in the URL, which is a very practical use of server-side rendering.

**Student:** I also use EJS partials for the shared header and footer, so I can reuse layout markup across multiple pages without duplicating code.

---

**AI Coach:** Now I want to talk about the controller layer. How do your controllers coordinate the request flow?

**Student:** The controllers take the request from Express, call the appropriate model function, and then send a response to the correct view. In my projects controller, I have a route handler that uses a route parameter to identify the specific project.

```javascript
const showProjectDetailsPage = async (req, res, next) => {
    const projectId = req.params.id;
    const projectDetails = await getProjectDetails(projectId);

    if (!projectDetails) {
        const err = new Error('Project Not Found');
        err.status = 404;
        return next(err);
    }

    const organization = await getOrganizationDetails(projectDetails.organization_id);
    const categories = await getCategoriesByProjectId(projectId);
    const title = 'Service Project Details';

    res.render('project', { title, projectDetails, organization, categories });
};
```

**AI Coach:** Perfect. This is a very clear controller example. The function receives the request object, extracts the route parameter from `req.params.id`, and uses it to fetch the right project. That is an important part of MVC because the controller handles the app’s workflow while the model handles data access and the view handles presentation.

**Student:** I also defined the route in my router file so the path `/project/:id` maps to this controller.

```javascript
router.get('/project/:id', showProjectDetailsPage);
```

---

**AI Coach:** Let’s discuss error handling. How do you make sure users see helpful messages when something goes wrong?

**Student:** I handle errors by creating custom error objects and passing them through Express with `next(err)`. I also have dedicated 404 and 500 error pages so the user sees a friendly response instead of a raw stack trace.

```javascript
app.use((req, res, next) => {
    const err = new Error('Page Not Found');
    err.status = 404;
    next(err);
});

app.use((err, req, res, next) => {
    const status = err.status || 500;
    const template = status === 404 ? '404' : '500';
    res.status(status).render(`errors/${template}`, context);
});
```

**AI Coach:** That is a solid strategy. The middleware catches missing routes and other problems, assigns an HTTP status code, and renders the right view. Your 404 page and 500 page make the application more user-friendly and easier to debug.

**Student:** I also created a test route that throws an error so I can verify the 500 page behavior.

```javascript
const testErrorPage = (req, res, next) => {
    const err = new Error('This is a test error');
    err.status = 500;
    next(err);
};
```

**AI Coach:** That is a smart testing approach. It lets you confirm that your error middleware is working correctly and that your status pages render as expected.

---

**Student:** I think I understand the MVC pattern much better now. The model handles database logic, the view renders the page content, the controller coordinates the flow, and the error middleware ensures the app responds gracefully when something goes wrong.

**AI Coach:** That is an excellent summary. You have clearly connected the pieces of your application and explained them in a way that reflects a strong grasp of server-side development.

---

## Closing Reflection
The coaching session showed that the project uses a clear MVC structure:
- Models contain database queries and data access logic.
- Views use EJS to render dynamic HTML and insert server data into links.
- Controllers handle routing logic, request parameters, and response rendering.
- Error handling uses custom status codes and dedicated 404/500 pages to present friendly responses.

This session helped me explain how the pieces of my application work together in a maintainable and organized way.
