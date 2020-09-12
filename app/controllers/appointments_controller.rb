class AppointmentsController < ApplicationController
  before_action :validate_user, only: :create

  def create
    doctor = Doctor.where(id: params[:doctor_id]).first
    if doctor
      begin
        time_from = DateTime.strptime(params[:time_from], TIME_FORMAT)
        time_to = DateTime.strptime(params[:time_to], TIME_FORMAT)

        appointment = current_user.appointments.new({
          doctor: doctor,
          time_from: time_from,
          time_to: time_to
        })

        if appointment.save
          render json: {
            appointment: {
              id: appointment.id,
              doctor_id: doctor.id,
              time_from: time_from.strftime(TIME_FORMAT),
              time_to: time_to.strftime(TIME_FORMAT)
            }
          }
        else
          render json: { error: appointment.errors.full_messages.join(', ') }, status: :bad_request
        end
      rescue Date::Error
        render json: { error: "Accepted time format `YYYY-MM-DDTHH:MM:SS+ZZZZ`" }, status: :bad_request
      end
    else
      render json: { error: "Doctor not found" }, status: :not_found
    end
  end

  def index
    appointments = Appointment
    appointments = appointments.where(doctor_id: params[:doctor_id]) if params[:doctor_id]
    appointments = if params[:time_frame] == 'today'
        appointments.where("? >= time_from and time_to >= ?", DateTime.now, DateTime.now)
      elsif params[:time_frame] == 'week'
        appointments.where("? >= time_from and time_to >= ?", DateTime.now.beginning_of_week, DateTime.now.end_of_week)
      else
        appointments
      end

    appointments_response = appointments.select(:id, :doctor_id, :user_id, :time_from, :time_to).map do |a|
      {
        id: a.id,
        doctor_id: a.doctor_id,
        user_id: a.user_id,
        time_from: a[:time_from].strftime(TIME_FORMAT),
        time_to: a[:time_to].strftime(TIME_FORMAT)
      }
    end

    render json: { appointments: appointments_response }
  end
end
