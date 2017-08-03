require 'date'

class RetentionPlan

  def initialize()
    @plans ||= {}
    @plans[:standard] = { days: 42 }
    @plans[:gold] = { days: 42, months: 12 }
    @plans[:platinum] = { days: 42, months: 12, years: 7 }
  end

  def add_plan(plan, rules)
    raise "Plan already registered" if @plans.key?(plan)

    raise "Day value must be of type Integer" \
      if (rules.key?(:days) && !rules[:days].is_a?(Integer))

    raise "Month value must be of type Integer" \
      if (rules.key?(:months) && !rules[:months].is_a?(Integer))

    raise "The value of years must be of type Integer" \
      if (rules.key?(:years) && !rules[:years].is_a?(Integer))

    @plans[plan] = rules
  end

  def plans
    @plans
  end

  def status(plan, created_at)
    raise "The snapshot creation date must be in Date format" \
      if !created_at.is_a?(Date)

    if @plans.key?(plan)
      rules = @plans[plan]
      created_at = created_at >> (rules[:years] * 12) if rules.key?(:years)
      created_at = created_at >> rules[:months] if rules.key?(:months)
      created_at += rules[:days] if rules.key?(:days)

      if Date.today <= created_at
        return 'retained'
      end

      return 'deleted'
    end

    raise "Plan not found"
  end
end
