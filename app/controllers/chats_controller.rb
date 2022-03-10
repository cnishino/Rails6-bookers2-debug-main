class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]

  def show
    @user = User.find(params[:id]) #チャットする相手は誰か？
    rooms = current_user.user_rooms.pluck(:room_id) #ログイン中のユーザーの部屋情報を全て取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #その中にチャットする相手とのルームがあるか確認

      unless user_rooms.nil? #ユーザールームが無くなかった（つまりあった。）
        #user_roomに紐づくroomsテーブルのレコードをroomに格納
        @room = user_rooms.room #変数@roomにユーザー（自分と相手）と紐づいているroomを代入
      else #ユーザールームが無かった場合
        @room = Room.new #新しくRoomを作る
        @room.save #そして保存
        UserRoom.create(user_id: @user.id, room_id: @room.id) #自分の中間テーブルを作る
        UserRoom.create(user_id: current_user.id, room_id: @room.id) #相手の中間テーブルを作る
      end
      #roomに紐づくchatsテーブルのレコードを@chatsに格納
      @chats = @room.chats
      #form_withでチャットを送信する際に必要な空のインスタンス
      #ここでroom.idを@chatに代入しておかないと、form_withで記述するroom_idに値が渡らない
      @chat = Chat.new(room_id: @room.id)
  end

  def create
    @user = User.find(current_user.id) #チャットする相手は誰か？
    rooms = current_user.user_rooms.pluck(:room_id) #ログイン中のユーザーの部屋情報を全て取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #その中にチャットする相手とのルームがあるか確認

    @room = user_rooms.room
    @chat = Chat.new
    # @chat.user_id = current_user.id
    # @chat.room_id = @room.id
    # @chat.message = '44444'
    @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
#現在のユーザー（わたし）が対象のユーザー（あなた）をフォローしていてかつ、
#対象のユーザー（あなた）が現在のユーザー（わたし）をフォローしていなかった場合、一覧画面へリダイレクトさせる
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
