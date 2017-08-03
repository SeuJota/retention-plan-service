require 'date'
require 'retention_plan'

describe "RetentionPlan:" do
  context "Checking the existence of plans:" do
    it "Is there an Standard?" do
      retention_plan = RetentionPlan.new
      expect(retention_plan.plans.key?(:standard)).to eq(true)
    end

    it "Is there an Gold?" do
      retention_plan = RetentionPlan.new
      expect(retention_plan.plans.key?(:gold)).to eq(true)
    end

    it "Is there an Platinum?" do
      retention_plan = RetentionPlan.new
      expect(retention_plan.plans.key?(:platinum)).to eq(true)
    end

    it "Is there no emerald?" do
      retention_plan = RetentionPlan.new
      expect(retention_plan.plans.key?(:emerald)).to eq(false)
    end
  end

  context "Custom Plans:" do
    it "Can I include a new plan?" do
      retention_plan = RetentionPlan.new
      rules = {days: 10, months: 10, years: 20}
      retention_plan.add_plan(:emerald, rules)
      expect(retention_plan.plans.size).to eq(4)
    end

    it "Can I include a plan that has already been created?" do
      retention_plan = RetentionPlan.new
      rules = {days: 10, months: 10, years: 20}
      expect{ retention_plan.add_plan(:gold, rules) }.to \
        raise_error(RuntimeError, "Plan already registered")
    end

    it "Can the plan rules be different from integer values?" do
      retention_plan = RetentionPlan.new
      rules = {days: "10", months: "10 meses", years: 20}
      expect{ retention_plan.add_plan(:emerald, rules) }.to raise_error(RuntimeError)
    end
  end

  context "Snapshots stay" do
    it "Standard plan, created the day before" do
      retention_plan = RetentionPlan.new
      created_at = Date.today - 1
      expect(retention_plan.status(:standard, created_at)).to eq('retained')
    end

    it "Gold plan, created the day before" do
      retention_plan = RetentionPlan.new
      created_at = Date.today - 1
      expect(retention_plan.status(:gold, created_at)).to eq('retained')
    end

    it "Platinum plan, created the day before" do
      retention_plan = RetentionPlan.new
      created_at = Date.today - 1
      expect(retention_plan.status(:platinum, created_at)).to eq('retained')
    end

    it "Custom plan, created the day before" do
      retention_plan = RetentionPlan.new
      created_at = Date.today - 1
      expect{ retention_plan.status(:emerald, created_at) }.to \
        raise_error(RuntimeError, "Plan not found")
    end

    it "Standard plan, created more than 42 days" do
      retention_plan = RetentionPlan.new
      created_at = Date.today - 43
      expect(retention_plan.status(:standard, created_at)).to eq('deleted')
    end

    it "Gold plan, created more than 12 months and 42 days" do
      retention_plan = RetentionPlan.new
      created_at = Date.today << 12
      created_at -= 43
      expect(retention_plan.status(:gold, created_at)).to eq('deleted')
    end

    it "Platinum created more than 7 years, 12 months and 42 days" do
      retention_plan = RetentionPlan.new
      created_at = Date.today << (7 * 12)
      created_at = created_at << 12
      created_at -= 43
      expect(retention_plan.status(:platinum, created_at)).to eq('deleted')
    end

    it "Customized plan within the period of stay" do
      retention_plan = RetentionPlan.new
      rules = {days: 1, months: 1, years: 1}
      retention_plan.add_plan(:emerald, rules)
      created_at = Date.today <<  12
      expect(retention_plan.status(:emerald, created_at)).to eq('retained')
    end

    it "Customized plan out of stay" do
      retention_plan = RetentionPlan.new
      rules = {days: 1, months: 1, years: 1}
      retention_plan.add_plan(:emerald, rules)
      created_at = Date.today << 12
      created_at = created_at << 1
      created_at -= 2
      expect(retention_plan.status(:emerald, created_at)).to eq('deleted')
    end

    it "When the is not provided the beginning of the stay" do
      retention_plan = RetentionPlan.new
      expect{ retention_plan.status(:platinum, "") }.to \
        raise_error(RuntimeError, "The snapshot creation date must be in Date format")
    end

  end

end
