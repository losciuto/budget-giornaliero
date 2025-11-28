from kivymd.app import MDApp
from kivymd.uix.screen import MDScreen
from kivymd.uix.boxlayout import MDBoxLayout
from kivymd.uix.card import MDCard
from kivymd.uix.label import MDLabel
from kivymd.uix.textfield import MDTextField
from kivymd.uix.button import MDRaisedButton, MDIconButton, MDFillRoundFlatIconButton
from kivymd.uix.dialog import MDDialog
from kivymd.uix.pickers import MDDatePicker
from kivy.metrics import dp
from kivy.clock import Clock
from datetime import datetime
import math

class BudgetCalculatorApp(MDApp):
    dialog = None
    target_date = None

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
        
        # Header Layout (Title + Info Button)
        header_layout = MDBoxLayout(orientation='horizontal', size_hint_y=None, height=dp(50))
        
        # Title
        title = MDLabel(
            text="Budget Giornaliero",
            halign="center",
            font_style="H4",
            theme_text_color="Primary",
            size_hint_x=0.9
        )
        
        # Info Button
        info_btn = MDIconButton(
            icon="information",
            theme_text_color="Custom",
            text_color=self.theme_cls.primary_color,
            on_release=self.show_info_dialog,
            size_hint_x=0.1
        )
        
        header_layout.add_widget(title)
        header_layout.add_widget(info_btn)
        
        layout.add_widget(header_layout)

        subtitle = MDLabel(
            text="Gestione spese mensili",
            halign="center",
            font_style="Subtitle1",
            theme_text_color="Secondary",
            size_hint_y=None,
            height=dp(30)
        )
        layout.add_widget(subtitle)
        
        # Card for inputs and results
        card = MDCard(
            orientation='vertical',
            padding=dp(20),
            spacing=dp(15),
            size_hint=(1, None),
            height=dp(420),
            radius=[dp(16), dp(16), dp(16), dp(16)],
            elevation=4
        )
        
        # Date Selection
        date_layout = MDBoxLayout(orientation='vertical', spacing=dp(5), size_hint_y=None, height=dp(80))
        date_label = MDLabel(text="Data Fine Budget", theme_text_color="Secondary", font_style="Caption")
        
        # Initialize default target date (27th of current or next month)
        now = datetime.now()
        if now.day > 27:
             # Next month
            if now.month == 12:
                self.target_date = now.replace(year=now.year + 1, month=1, day=27)
            else:
                self.target_date = now.replace(month=now.month + 1, day=27)
        else:
            self.target_date = now.replace(day=27)

        self.date_btn = MDFillRoundFlatIconButton(
            text=self.target_date.strftime("%d/%m/%Y"),
            icon="calendar",
            pos_hint={'center_x': 0.5},
            size_hint_x=1,
            on_release=self.show_date_picker
        )
        date_layout.add_widget(date_label)
        date_layout.add_widget(self.date_btn)
        
        # Input Field
        self.amount_input = MDTextField(
            hint_text="Importo Disponibile (€)",
            helper_text="Inserisci il tuo budget totale",
            helper_text_mode="on_focus",
            input_filter="float",
            font_size=dp(24),
            mode="rectangle"
        )
        self.amount_input.bind(text=self.update_calculation)
        
        # Info Grid (simulated with BoxLayouts)
        info_layout = MDBoxLayout(orientation='horizontal', spacing=dp(10))
        
        # Date Box
        date_box = MDBoxLayout(orientation='vertical', size_hint_x=0.5)
        date_label_box = MDLabel(text="Data di Oggi", theme_text_color="Secondary", font_style="Caption", halign="center")
        self.date_value = MDLabel(text="--/--/----", font_style="H6", halign="center")
        date_box.add_widget(date_label_box)
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
        card.add_widget(date_layout)
        card.add_widget(self.amount_input)
        card.add_widget(info_layout)
        card.add_widget(result_box)
        
        layout.add_widget(card)
        
        # Spacer
        layout.add_widget(MDLabel())
        
        screen.add_widget(layout)
        
        # Initial Calculation
        self.update_calculation()
        
        return screen

    def show_date_picker(self, instance):
        date_dialog = MDDatePicker(
            year=self.target_date.year,
            month=self.target_date.month,
            day=self.target_date.day
        )
        date_dialog.bind(on_save=self.on_date_save)
        date_dialog.open()

    def on_date_save(self, instance, value, date_range):
        self.target_date = datetime(value.year, value.month, value.day)
        self.date_btn.text = self.target_date.strftime("%d/%m/%Y")
        self.update_calculation()

    def show_info_dialog(self, instance):
        if not self.dialog:
            self.dialog = MDDialog(
                title="Informazioni",
                text="Autore: Massimo Lo Sciuto\nSupporto: Antigravity\nSviluppo: Gemini 3 Pro\nVersione: 1.1.1",
                buttons=[
                    MDRaisedButton(
                        text="CHIUDI",
                        on_release=lambda x: self.dialog.dismiss()
                    ),
                ],
            )
        self.dialog.open()

    def update_calculation(self, *args):
        # Update date first
        now = datetime.now()
        self.date_value.text = now.strftime("%d/%m/%Y")
        
        # Calculate days
        today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        target = self.target_date.replace(hour=0, minute=0, second=0, microsecond=0)
        
        if target < today:
             self.days_remaining = 0
             self.days_value.text = "Scaduto"
        else:
             self.days_remaining = (target - today).days + 1
             self.days_value.text = str(self.days_remaining)

        # Calculate Budget
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
