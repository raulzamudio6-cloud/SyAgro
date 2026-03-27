const db = require('../db');

// MODULES SERVICE
const modulesService = {
  async getModules() {
    const { rows } = await db.query('SELECT * FROM get_modules();');
    return rows;
  },
  async getModuleById(id) {
    const { rows } = await db.query('SELECT * FROM get_module_by_id($1);', [id]);
    return rows[0];
  },
  async createModule({ code, name, description, is_core }) {
    const { rows } = await db.query('SELECT create_module($1, $2, $3, $4) AS id;', [code, name, description, is_core]);
    return rows[0].id;
  },
  async updateModule(id, { code, name, description, is_core }) {
    await db.query('SELECT update_module($1, $2, $3, $4, $5);', [id, code, name, description, is_core]);
  },
  async deleteModule(id) {
    await db.query('SELECT delete_module($1);', [id]);
  },
};

module.exports = modulesService;
