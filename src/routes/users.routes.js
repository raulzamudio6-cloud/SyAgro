const { Router } = require('express');
const { getAllUsers, getUser, createUser, deleteUser, updateUser } = require('../controllers/users.controllers');

const router = Router();

router.get('/users', getAllUsers);
router.get('/users/:id', getUser);
router.post('/users', createUser);
router.put('/users/:id', updateUser);
router.delete('/users/:id', deleteUser);





module.exports = router;
