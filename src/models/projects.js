import db from './db.js';

const getAllProjects = async () => {
    const query = `
        SELECT project_id, name, description, location, date, organization_id
        FROM public.project;
    `;
    const result = await db.query(query);
    return result.rows;
};

const getProjectsByOrganizationId = async (organizationId) => {
    const query = `
        SELECT project_id, organization_id, name, description, location, date
        FROM project
        WHERE organization_id = $1
        ORDER BY date;
    `;
    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);
    return result.rows;
};

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

const getProjectsByCategoryId = async (categoryId) => {
    const query = `
        SELECT p.project_id, p.organization_id, p.name, p.description, p.location, p.date
        FROM project p
        JOIN project_category pc ON p.project_id = pc.project_id
        WHERE pc.category_id = $1
        ORDER BY p.date;
    `;
    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);
    return result.rows;
};

export { getAllProjects, getProjectsByOrganizationId, getProjectDetails, getProjectsByCategoryId };