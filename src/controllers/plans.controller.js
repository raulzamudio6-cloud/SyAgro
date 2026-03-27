const plansService = require('../services/plans.service');

function validatePlanInput(data) {
  const errors = [];
  if (!data.name) errors.push('name is required');
  if (typeof data.price_monthly !== 'number') errors.push('price_monthly must be a number');
  if (typeof data.price_yearly !== 'number') errors.push('price_yearly must be a number');
  if (typeof data.is_active !== 'boolean') errors.push('is_active must be boolean');
  return errors;
}

const plansController = {
  async getAll(req, res) {
    try {
      const plans = await plansService.getPlans();
      res.json({ success: true, data: plans });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async getById(req, res) {
    try {
      const plan = await plansService.getPlanById(req.params.id);
      if (!plan) return res.status(404).json({ success: false, error: 'Plan not found' });
      res.json({ success: true, data: plan });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async create(req, res) {
    try {
      const errors = validatePlanInput(req.body);
      if (errors.length) return res.status(400).json({ success: false, error: errors });
      const id = await plansService.createPlan(req.body);
      res.status(201).json({ success: true, data: { id } });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async update(req, res) {
    try {
      const errors = validatePlanInput(req.body);
      if (errors.length) return res.status(400).json({ success: false, error: errors });
      await plansService.updatePlan(req.params.id, req.body);
      res.json({ success: true });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async remove(req, res) {
    try {
      await plansService.deletePlan(req.params.id);
      res.json({ success: true });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
};

module.exports = plansController;
