from kivymd.app import MDApp
from kivymd.uix.screen import MDScreen
from kivymd.uix.boxlayout import MDBoxLayout
from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel
from kivymd.uix.textfield import MDTextField
from kivymd.uix.button import MDRaisedButton
from kivy.metrics import dp
from kivy.clock import Clock
from datetime import datetime
import math

class BudgetCalculatorApp(MDApp):
    def build(self):
        self.theme_cls.theme_style = "Dark"
        self.theme_cls.primary_palette = "Blue"
        
        screen = MDScreen()
        
        # Main Layout
        layout = MDBoxLayout(
            orientation='vertical',
            padding=dp(20),
            spacing=dp(20),
            pos_hint={'center_x': 0.5, 'center_y': 0.5},
            size_hint_x=None,
            width=dp(350)
        )
        
        # Title
        title = MDLabel(
            text="Budget Giornaliero",
            halign="center",
            font_style="H4",
            theme_text_color="Primary",
            size_hint_y=None,
            height=dp(50)
        )
        subtitle = MDLabel(
            text="Fino al 27 del mese",
            halign="center",
            font_style="Subtitle1",
            theme_text_color="Secondary",
            size_hint_y=None,
            height=dp(30)
        )
        
        layout.add_widget(title)
        layout.add_widget(subtitle)
        
        # Card for inputs and results
        card = MDCard(
            orientation='vertical',
            padding=dp(20),
            spacing=dp(20),
            size_hint=(1, None),
            height=dp(350),
            radius=[dp(16), dp(16), dp(16), dp(16)],
            elevation=4
        )
        
        # Input Field
        self.amount_input = MDTextField(
            hint_text="Importo Disponibile (€)",
            helper_text="Inserisci il tuo budget totale",
            helper_text_mode="on_focus",
            input_filter="float",
            font_size=dp(24),
            mode="rectangle"
        )
        self.amount_input.bind(text=self.calculate_budget)
        
        # Info Grid (simulated with BoxLayouts)
        info_layout = MDBoxLayout(orientation='horizontal', spacing=dp(10))
        
        # Date Box
        date_box = MDBoxLayout(orientation='vertical', size_hint_x=0.5)
        date_label = MDLabel(text="Data di Oggi", theme_text_color="Secondary", font_style="Caption", halign="center")
        self.date_value = MDLabel(text="--/--/----", font_style="H6", halign="center")
        date_box.add_widget(date_label)
        date_box.add_widget(self.date_value)
        
        # Days Box
        days_box = MDBoxLayout(orientation='vertical', size_hint_x=0.5)
        days_label = MDLabel(text="Giorni Mancanti", theme_text_color="Secondary", font_style="Caption", halign="center")
        self.days_value = MDLabel(text="--", font_style="H6", halign="center", theme_text_color="Custom", text_color=self.theme_cls.primary_color)
        days_box.add_widget(days_label)
        days_box.add_widget(self.days_value)
        
        info_layout.add_widget(date_box)
        info_layout.add_widget(days_box)
        
        # Result Section
        result_box = MDBoxLayout(orientation='vertical', padding=[0, dp(20), 0, 0])
        result_label = MDLabel(text="Puoi spendere al giorno:", halign="center", theme_text_color="Secondary")
        self.result_value = MDLabel(
            text="€ 0.00",
            halign="center",
            font_style="H3",
            theme_text_color="Custom",
            text_color=self.theme_cls.primary_color
        )
        result_box.add_widget(result_label)
        result_box.add_widget(self.result_value)
        
        # Add widgets to card
        card.add_widget(self.amount_input)
        card.add_widget(info_layout)
        card.add_widget(result_box)
        
        layout.add_widget(card)
        
        # Spacer
        layout.add_widget(MDLabel())
        
        screen.add_widget(layout)
        
        # Initial Calculation
        self.update_date()
        self.calculate_budget()
        
        return screen

    def update_date(self):
        now = datetime.now()
        self.date_value.text = now.strftime("%d/%m/%Y")
        
        # Calculate days
        today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        target_date = today.replace(day=27)
        
        # If today is past the 27th, target is next month? 
        # Requirement says "current month". If passed, it's 0 or negative.
        # Let's stick to the same logic as the web app:
        # If today > 27th, period ended.
        
        if today.day > 27:
            self.days_remaining = 0
            self.days_value.text = "Terminato"
        else:
            # Inclusive calculation: (27 - today) + 1
            # Example: Today 27. (27-27) = 0. +1 = 1 day.
            self.days_remaining = (target_date - today).days + 1
            self.days_value.text = str(self.days_remaining)

    def calculate_budget(self, instance=None, value=None):
        try:
            amount_text = self.amount_input.text
            if not amount_text:
                self.result_value.text = "€ 0.00"
                return
                
            amount = float(amount_text.replace(',', '.'))
            
            if self.days_remaining > 0:
                daily = amount / self.days_remaining
                self.result_value.text = f"€ {daily:.2f}"
            else:
                self.result_value.text = "€ 0.00"
        except ValueError:
            self.result_value.text = "€ 0.00"

if __name__ == '__main__':
    BudgetCalculatorApp().run()
