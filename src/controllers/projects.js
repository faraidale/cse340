import { getAllProjects, getProjectDetails, getProjectsByOrganizationId } from '../models/projects.js';
import { getOrganizationDetails } from '../models/organizations.js';
import { getCategoriesByProjectId } from '../models/categories.js';

const showProjectsPage = async (req, res) => {
    const projects = await getAllProjects();
    const title = 'Service Projects';
    res.render('projects', { title, projects });
};

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

export { showProjectsPage, showProjectDetailsPage };