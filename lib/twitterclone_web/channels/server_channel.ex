defmodule TwittercloneWeb.ServerChannel do
  use Phoenix.Channel
  alias Twi.User

  def join("server:main", _message, socket) do
    {:ok, %{hi: "join"},socket}
  end
  #--------------->>>>> REGISTER HANDLE IN <<<<<----------------------
  def handle_in("register",%{"username" => username_,"password" => password_}, socket) do
    user = %User{username: username_ |> String.to_atom, password: password_, online: true}
    GenServer.cast(Mainserver, {:register, user})
    {:reply, :ok, socket}
  end
  #--------------->>>>> ADD TWEET HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"username" => username_,"tweet" => tweet_}, socket) do
    reply =  GenServer.call(Mainserver,{:find_add_tweet,username_,tweet_})
    # IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> ADD RETWEET HANDLE IN <<<<<----------------------
  def handle_in("retweet",%{"username" => username_,"tweet" => tweet_}, socket) do

    reply =  reply = GenServer.call(username_,{:retweet,username_,tweet_})
    {:reply, :ok, socket}
  end
  #--------------->>>>> FOLLOW HANDLE IN <<<<<----------------------
  def handle_in("follow",%{"username" => username_,"tweet" => tweet_}, socket) do
    # IO.inspect tweet
    # IO.inspect socket
    username_="Gaurav"
    # tweet="as as as as asas"
    # reply =  GenServer.call(pid,{:follow_user,username_,to_follow})
    # IO.puts reply
    {:reply, :ok, socket}
  end
  
  #--------------->>>>> LOGIN HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"username" => username_,"password" => password_}, socket) do
    # IO.puts "++++++"
    # IO.inspect tweet
    # IO.puts "end"
    # # IO.inspect socket
    # username_="Gaurav"
    # tweet="as as as as asas"
    # reply =  reply = GenServer.call(pid,{:login,username_,password_})
    # IO.puts reply
    {:reply, :ok, socket}
  end

  #--------------->>>>> LOGOUT HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"payload" => tweet}, socket) do
    # IO.puts "++++++"
    # IO.inspect tweet
    # IO.puts "end"
    # # IO.inspect socket
    # username_="Gaurav"
    # # tweet="as as as as asas"
    # # reply =  GenServer.call(pid,{:logout,username})
    # IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> COMPLETED <<<<<----------------------
  #--------------->>>>> COMPLETED <<<<<----------------------


  def join("server:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end