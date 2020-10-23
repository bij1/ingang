class MainController < ApplicationController
  before_action :set_user_room, only: [:join, :users]

  def index
  end

  def join
    @running = bbb_server.is_meeting_running?(@room.meeting)
    if not @running and @user.moderator
      meeting = bbb_server.create_meeting(@room.name,
                                          @room.meeting,
                                          { :attendeePW => @room.attendee_pw,
                                            :moderatorPW => @room.moderator_pw })
      @running = meeting[:returncode]
    end

    if @running
      @url = bbb_server.join_meeting_url(@room.meeting,
                                         @user.name,
                                         @user.moderator ? @room.moderator_pw : @room.attendee_pw,
                                         { :userID => @user.id })
      redirect_to @url
    end
  end

  def users
    require 'csv'

    if @user.moderator and bbb_server.is_meeting_running?(@room.meeting)
      csv_data = CSV.generate do |csv|
        bbb_server.get_meeting_info(@room.meeting, @room.moderator_pw)[:attendees].each do |attendee|
          if User.exists?(attendee[:userID]) and voter = User.find(attendee[:userID]) and not voter.proxy
            if voter.vote
              csv << [voter.id, voter.email, voter.name]
            end
            User.where(email: voter.email, vote: true, proxy: true).each do |proxy|
              csv << [proxy.id, proxy.email, "gemachtigde voor #{proxy.name}"]
            end
          end
        end
      end
    end

    respond_to do |format|
      format.csv { send_data csv_data, filename: "#{@room.name} #{Time.zone.now}.csv" }
    end
  end

  private
    def set_user_room
      @user = User.find_by token: params[:token]
      @room = Room.find(@user.room_id)
    end

end
