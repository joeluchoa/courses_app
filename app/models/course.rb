require 'ostruct'

class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :attendances, dependent: :destroy

  validates :address, presence: true
  validate :start_time_must_be_before_end_time
  validate :time_fields_must_be_present_if_enabled

  # This method prepares a full 7-day schedule for the form.
  def weekly_schedule_for_form
    schedule_hash = (self.weekly_schedule || []).index_by { |d| d["day"] }

    Date::DAYNAMES.map do |day_name|
      if schedule_hash[day_name]
        # Existing schedule for this day
        OpenStruct.new(schedule_hash[day_name].merge(enabled: true))
      else
        # No schedule for this day, create a blank one
        OpenStruct.new(day: day_name, start_time: '', end_time: '', enabled: false)
      end
    end
  end

  # This method processes the form data before saving.
  def weekly_schedule_attributes=(attributes)
    self.weekly_schedule = []
    attributes.each do |_, item_attrs|
      # Only save the schedule if the 'enabled' checkbox was checked
      if item_attrs["enabled"] == "1"
        self.weekly_schedule << item_attrs.except("enabled")
      end
    end
  end

  def start_time_must_be_before_end_time
    # Ensure the schedule is not nil before iterating.
    return unless weekly_schedule.present?

    weekly_schedule.each do |schedule|
      start_time_str = schedule["start_time"]
      end_time_str = schedule["end_time"]

      # Skip validation for this entry if either time is not set.
      # Presence of these can be handled by other validations if needed.
      next if start_time_str.blank? || end_time_str.blank?

      # Compare the parsed time values.
      if Time.parse(start_time_str) >= Time.parse(end_time_str)
        # Add a user-friendly error to the object's base.
        errors.add(:base, "For #{schedule['day']}, the start time must be before the end time.")
      end
    end
  end

  def time_fields_must_be_present_if_enabled
    # The weekly_schedule array only contains enabled rows, so we just
    # need to check if any of them have blank time fields.
    return unless weekly_schedule.present?

    weekly_schedule.each do |schedule|
      if schedule["start_time"].blank? || schedule["end_time"].blank?
        # Add a specific, user-friendly error message.
        errors.add(:base, "For #{schedule['day']}, start and end times are required.")
      end
    end
  end

end
