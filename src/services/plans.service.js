const db = require('../db');

// PLANS SERVICE
const plansService = {
  async getPlans() {
    const { rows } = await db.query('SELECT * FROM get_plans();');
    return rows;
  },
  async getPlanById(id) {
    const { rows } = await db.query('SELECT * FROM get_plan_by_id($1);', [id]);
    return rows[0];
  },
  async createPlan({ name, description, price_monthly, price_yearly, is_active }) {
    const { rows } = await db.query('SELECT create_plan($1, $2, $3, $4, $5) AS id;', [name, description, price_monthly, price_yearly, is_active]);
    return rows[0].id;
  },
  async updatePlan(id, { name, description, price_monthly, price_yearly, is_active }) {
    await db.query('SELECT update_plan($1, $2, $3, $4, $5, $6);', [id, name, description, price_monthly, price_yearly, is_active]);
  },
  async deletePlan(id) {
    await db.query('SELECT delete_plan($1);', [id]);
  },
};

module.exports = plansService;
