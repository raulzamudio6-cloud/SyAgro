const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const db = require('./config');
const app = express();
const port = db.port;
const companiesRoutes = require('./routes/companies.routes');
const userRoutes = require('./routes/users.routes');

app.use(cors({origin: [`http://localhost:${port}`, 'https://syagro-client.vercel.app', 'https://sy-agro-client.vercel.app/']}));


// ✅ Configura CORS (PON ESTO ANTES DE TUS ROUTAS)
app.use(cors({
  origin: [
    'https://sy-agro-client.vercel.app',  // Tu frontend en Vercel (PRODUCCIÓN)
    'http://localhost:${3000}}',               // Tu frontend local (DESARROLLO)
    'https://sy-agro-client-git-master-*.vercel.app' // Dominios de preview de Vercel (opcional)
  ],
  credentials: true, // Permite enviar cookies/autenticación si las usas
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

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


