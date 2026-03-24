const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const db = require('./config');
const app = express();
const port = db.port;
const companiesRoutes = require('./routes/companies.routes');
const userRoutes = require('./routes/users.routes');

app.use(cors());
app.use(morgan('dev'));

app.use(express.json());

app.use(companiesRoutes);
app.use(userRoutes);
app.use((err, req, res, next) => {
    return res.json({
        message: err.message
    });
});
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});


