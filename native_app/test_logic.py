import unittest
from datetime import datetime

class TestBudgetLogic(unittest.TestCase):
    def calculate_days(self, current_date):
        # Logic extracted from main.py
        target_date = current_date.replace(day=27)
        
        if current_date.day > 27:
            return 0
        else:
            return (target_date - current_date).days + 1

    def calculate_budget(self, amount, days):
        if days > 0:
            return amount / days
        return 0

    def test_days_before_27(self):
        # Example: 20th of the month
        today = datetime(2025, 11, 20)
        days = self.calculate_days(today)
        # 20, 21, 22, 23, 24, 25, 26, 27 = 8 days
        # Formula: (27 - 20) + 1 = 8
        self.assertEqual(days, 8)

    def test_days_is_27(self):
        # Example: 27th of the month
        today = datetime(2025, 11, 27)
        days = self.calculate_days(today)
        # 27 = 1 day
        # Formula: (27 - 27) + 1 = 1
        self.assertEqual(days, 1)

    def test_days_after_27(self):
        # Example: 28th of the month
        today = datetime(2025, 11, 28)
        days = self.calculate_days(today)
        self.assertEqual(days, 0)

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
