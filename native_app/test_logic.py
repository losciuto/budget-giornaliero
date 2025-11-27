import unittest
from datetime import datetime

class TestBudgetLogic(unittest.TestCase):
    def calculate_days(self, current_date, target_day=27):
        # Logic extracted from main.py
        try:
            target_date = current_date.replace(day=target_day)
        except ValueError:
            return 0 # Invalid date
            
        if current_date.day > target_day:
            return 0
        else:
            return (target_date - current_date).days + 1

    def calculate_budget(self, amount, days):
        if days > 0:
            return amount / days
        return 0

    def test_days_before_target(self):
        # Example: 20th of the month, target 27
        today = datetime(2025, 11, 20)
        days = self.calculate_days(today, target_day=27)
        # 20 to 27 = 8 days
        self.assertEqual(days, 8)

    def test_days_is_target(self):
        # Example: 27th of the month, target 27
        today = datetime(2025, 11, 27)
        days = self.calculate_days(today, target_day=27)
        self.assertEqual(days, 1)

    def test_days_after_target(self):
        # Example: 28th of the month, target 27
        today = datetime(2025, 11, 28)
        days = self.calculate_days(today, target_day=27)
        self.assertEqual(days, 0)
        
    def test_custom_target_day(self):
        # Example: 10th of the month, target 15
        today = datetime(2025, 11, 10)
        days = self.calculate_days(today, target_day=15)
        # 10, 11, 12, 13, 14, 15 = 6 days
        self.assertEqual(days, 6)

    def test_budget_calculation(self):
        amount = 100.0
        days = 4
        budget = self.calculate_budget(amount, days)
        self.assertEqual(budget, 25.0)

    def test_budget_calculation_zero_days(self):
        amount = 100.0
        days = 0
        budget = self.calculate_budget(amount, days)
        self.assertEqual(budget, 0)

if __name__ == '__main__':
    unittest.main()
