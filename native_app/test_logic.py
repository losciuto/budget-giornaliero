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
            # Calculate for next month
            if current_date.month == 12:
                next_month = 1
                next_year = current_date.year + 1
            else:
                next_month = current_date.month + 1
                next_year = current_date.year
            
            try:
                target_date = current_date.replace(year=next_year, month=next_month, day=target_day)
            except ValueError:
                # Handle cases like Feb 30th -> skip to last day of month or handle as error
                # For simplicity in this context, let's assume valid target days or handle appropriately
                # If target day is invalid for next month (e.g. 31st in Feb), 
                # a robust solution might clamp to the last day. 
                # But keeping it simple as per original logic structure:
                return 0 
                
            return (target_date - current_date).days + 1
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
        # Should calculate until 27th of NEXT month
        today = datetime(2025, 11, 28)
        # Nov 28 to Dec 27
        # Nov has 30 days. 28, 29, 30 (3 days) + 27 days in Dec = 30 days
        days = self.calculate_days(today, target_day=27)
        self.assertEqual(days, 30)

    def test_year_rollover(self):
        # Example: Dec 28th, target 27
        today = datetime(2025, 12, 28)
        # Dec 28 to Jan 27 (2026)
        # Dec has 31 days. 28, 29, 30, 31 (4 days) + 27 days in Jan = 31 days
        days = self.calculate_days(today, target_day=27)
        self.assertEqual(days, 31)
        
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
