const { json } = require('express');
const pool = require('../db');

const getAllUsers = async (req, res, next) => {
    try {
        const allUsers = await pool.query('SELECT * FROM  users');
        res.json(allUsers.rows);
    } catch (error) {
        next(error);
    }
};


const getUser = async (req, res, next) => {
    const { id } = req.params;
    try {
        const user = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
        if (user.rows.length === 0) {
            res.status(404).json({ error: 'Usuario no encontrado' });
        } else {
            res.json(user.rows[0]);
        }
    } catch (error) {
        next(error);
    }
};



const createUser = async (req, res, next) => {
    const { first_name, last_name, username, email, password_hash, status, is_global_admin } = req.body;
    try {

        const plainPassword = password_hash;
        const saltRounds = 10;
        const passwordHash = await bcrypt.hash(plainPassword, saltRounds);

        console.log(passwordHash);


        const result = await pool.query('INSERT INTO users (first_name, last_name, username, email, password_hash, status, is_global_admin) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
            [first_name, last_name, username, email, passwordHash, status, is_global_admin]);
        res.json(result.rows[0]);
    }
    catch (error) {
        next(error);
    }
};

const deleteUser = async (req, res, next) => {
    const { id } = req.params;
    try {
        const results = await pool.query('DELETE FROM users WHERE id = $1', [id]);
        if (results.rowCount === 0) {
            res.status(404).json({ error: 'Usuario no encontrado' });
        } else {
            res.json({ message: 'Usuario eliminado correctamente' });
        }

    } catch (error) {
        next(error);
    }
};



const updateUser = async (req, res, next) => {
    const { id } = req.params;
    const { first_name, last_name, username, email, password_hash, status, is_global_admin } = req.body;

    try {
        const results = await pool.query('UPDATE users SET first_name = $1, last_name = $2, username = $3, email = $4, password_hash = $5, status = $6, is_global_admin = $7 WHERE id = $8 RETURNING *',
            [first_name, last_name, username, email, password_hash, status, is_global_admin, id]);
        if (results.rowCount === 0) {
            res.status(404).json({ error: 'Usuario no encontrado' });
        } else {
            res.json(results.rows[0]);
        }
    } catch (error) {
        next(error);
    }
};
module.exports = {
    getAllUsers,
    getUser,
    createUser,
    deleteUser,
    updateUser
};

