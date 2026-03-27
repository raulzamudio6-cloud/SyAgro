const modulesService = require('../services/modules.service');

function validateModuleInput(data) {
  const errors = [];
  if (!data.code) errors.push('code is required');
  if (!data.name) errors.push('name is required');
  if (typeof data.is_core !== 'boolean') errors.push('is_core must be boolean');
  return errors;
}

const modulesController = {
  async getAll(req, res) {
    try {
      const modules = await modulesService.getModules();
      res.json({ success: true, data: modules });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async getById(req, res) {
    try {
      const module = await modulesService.getModuleById(req.params.id);
      if (!module) return res.status(404).json({ success: false, error: 'Module not found' });
      res.json({ success: true, data: module });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async create(req, res) {
    try {
      const errors = validateModuleInput(req.body);
      if (errors.length) return res.status(400).json({ success: false, error: errors });
      const id = await modulesService.createModule(req.body);
      res.status(201).json({ success: true, data: { id } });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async update(req, res) {
    try {
      const errors = validateModuleInput(req.body);
      if (errors.length) return res.status(400).json({ success: false, error: errors });
      await modulesService.updateModule(req.params.id, req.body);
      res.json({ success: true });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
  async remove(req, res) {
    try {
      await modulesService.deleteModule(req.params.id);
      res.json({ success: true });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  },
};

module.exports = modulesController;
