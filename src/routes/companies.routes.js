const { Router } = require('express');
const { getAllCompanies, getCompany, createCompany, deleteCompany, updateCompany } = require('../controllers/companies.controllers');

const router = Router();

router.get('/companies', getAllCompanies);
router.get('/companies/:id', getCompany);
router.post('/companies', createCompany);
router.put('/companies/:id', updateCompany);
router.delete('/companies/:id', deleteCompany);





module.exports = router;
