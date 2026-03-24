const { Router } = require('express');
const { getAllUsers, getUsers, createUser, deleteUser, updateUser } = require('../controllers/users.controllers');

const router = Router();

router.get('/users', getAllUsers);

router.get('/users/:id', getUsers);


router.post('/users', createUser);


router.delete('/users/:id', deleteUser);


router.put('/users/:id', updateUser);





module.exports = router;
