
## HELPERS FOR SYSTEM TESTS
module SystemTestHelper

   ## Chosen Js Plugin selector
   def select_chosen_option(dropdown_selector, option_text)
      select_element = find(dropdown_selector)
      select_element.click
      within '.chosen-results' do
         find('li', text: option_text).click
      end
      assert_selector "#{dropdown_selector} .chosen-single", text: option_text
   end

   ## Simulate selecting a date from the Flatpickr calendar   
   # def select_flatpickr_date(form_date_field, day_to_pick)

   #    ## Click on the input field created by flatpickr to pop calendar
   #    find(form_date_field, visible: false).sibling('input').click

   #    ## Grab all the dates of the month from the calendar
   #    date_widget_from = find('.flatpickr-calendar .flatpickr-days', visible: true)
   #    columns = date_widget_from.all('.flatpickr-day')

   #    # Find and click the date in the calendar
   #    date_column = columns.find { |column| column.text == day_to_pick }
   #    date_column.click if date_column

   #    # columns.each do |column|
   #    #    # Perform actions on each column
   #    #    if column.text == day_to_pick
   #    #       column.click
   #    #       break
   #    #    end
   #    # end
   # end

   ## Simulate selecting a date from the Flatpickr calendar   
   ## System Test Usuage
   ## select_flatpickr_date('#your_form_date_field_id', '15', 'December', 2023)

   def select_flatpickr_date(form_date_field, day_to_pick)
      # Click on the input field created by flatpickr to pop the calendar
      find(form_date_field, visible: false).sibling('input').click
   
      # Calculate the next month
      next_month = (Date.today.month % 12) + 1
      next_month_name = Date::MONTHNAMES[next_month]

      # Navigate to the next month
      find('.flatpickr-next-month').click
      find('.flatpickr-next-month').click
   
      # Grab all the dates of the month from the calendar
      date_widget_from = find('.flatpickr-calendar .flatpickr-days', visible: true)
      columns = date_widget_from.all('.flatpickr-day')
   
      # Find and click the date in the calendar
      date_column = columns.find { |column| column.text == day_to_pick }
      date_column.click if date_column
   end
 
end

