const { json } = require('express');
const pool = require('../db');

const getAllCompanies = async (req, res, next) => {
    try {
        const allCompanies = await pool.query('SELECT * FROM  get_all_companies()');
        res.json(allCompanies.rows);
    } catch (error) {
        next(error);
    }
};


const getCompany = async (req, res, next) => {
    const { id } = req.params;
    try {
        const company = await pool.query('SELECT * FROM get_company_by_id($1)', [id]);
        if (company.rows.length === 0) {
            res.status(404).json({ error: 'Compañía no encontrada' });
        } else {
            res.json(company.rows[0]);
        }
    } catch (error) {
        next(error);
    }
};



const createCompany = async (req, res, next) => {
    const { name, legal_name, city, rfc, phone, email, suscription_plan } = req.body;
    try {
        const result = await pool.query('SELECT * FROM create_company($1, $2, $3, $4, $5, $6, $7)',
            [name, legal_name, city, rfc, phone, email, suscription_plan]);
        res.json(result.rows[0]);
    }
    catch (error) {
        next(error);
    }
};

const deleteCompany = async (req, res, next) => {
    const { id } = req.params;
    try {
        const results = await pool.query('SELECT delete_company($1)', [id]);
        if (results.rowCount === 0) {
            res.status(404).json({ error: 'Compañía no encontrada' });
        } else {
            res.json({ message: 'Compañía eliminada correctamente' });
        }

    } catch (error) {
        next(error);
    }
};



const updateCompany = async (req, res, next) => {
    const { id } = req.params;
    const { name, legal_name, city, rfc, phone, email, suscription_plan } = req.body;

    try {
        const results = await pool.query('SELECT * FROM update_company($1, $2, $3, $4, $5, $6, $7, $8)',
            [id, name, legal_name, city, rfc, phone, email, suscription_plan]);
        if (results.rowCount === 0) {
            res.status(404).json({ error: 'Compañía no encontrada' });
        } else {
            res.json(results.rows[0]);
        }

    } catch (error) {
        next(error);
    }
};
module.exports = {
    getAllCompanies,
    getCompany,
    createCompany,
    deleteCompany,
    updateCompany
};
