const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const db = require('./config');
const app = express();
const port = db.port;

const companiesRoutes = require('./routes/companies.routes');
const userRoutes = require('./routes/users.routes');
const modulesRoutes = require('./routes/modules.routes');
const plansRoutes = require('./routes/plans.routes');


// ✅ Configura CORS (PON ESTO ANTES DE TUS ROUTAS)
app.use(cors({
    origin: [
        'https://sy-agro-client.vercel.app',  // Tu frontend en Vercel (PRODUCCIÓN)
        'http://localhost:3000',              // Tu frontend local (Confirmado en puerto 3000)
        /^https:\/\/sy-agro-client-git-master-.*\.vercel\.app$/ // RegExp para permitir ramas de Vercel
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'], // ✅ Incluye OPTIONS
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'] // ✅ Headers que usas
}));

app.use(morgan('dev'));

app.use(express.json());

app.use(companiesRoutes);
app.use(userRoutes);
app.use('/modules', modulesRoutes);
app.use('/plans', plansRoutes);
app.use((err, req, res, next) => {
    return res.json({
        message: err.message
    });
});
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
