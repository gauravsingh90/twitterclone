defmodule TwittercloneWeb.RoomChannel do
  use Phoenix.Channel
  alias Twi.User

  def join(name, _message, socket) do
    {:ok, %{hi: "join"},socket}
  end
  #--------------->>>>> REGISTER HANDLE IN <<<<<----------------------
  def handle_in("register",message, socket) do
    IO.puts "++++++"
    # IO.inspect message
    # IO.inspect socket
    username_="Gaurav"
    password_="as"

    user = %User{username: username_ |> String.to_atom, password: password_, online: true}
    # GenServer.cast(pid, {:register, user})
    # user = %User{ username: "amit" |> String.to_atom, password: "amitisawesome"}
    
    GenServer.cast(Mainserver, {:register, user})
    {:reply, :ok, socket}
  end
  #--------------->>>>> ADD TWEET HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"payload" => tweet}, socket) do
    IO.puts "++++++"
    IO.inspect tweet
    IO.puts "end"
    # IO.inspect socket
    username_="Gaurav"
    # tweet="as as as as asas"
    reply =  GenServer.call(Mainserver,{:find_add_tweet,username_,tweet})
    IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> ADD RETWEET HANDLE IN <<<<<----------------------
  def handle_in("ReaddTweet",%{"payload" => tweet}, socket) do
    IO.inspect tweet
    IO.inspect username
    username_="Gaurav"
    # tweet="as as as as asas"
    reply =  reply = GenServer.call(pid,{:retweet,username,tweet})
    IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> FOLLOW HANDLE IN <<<<<----------------------
  def handle_in("follow",%{"payload" => tweet}, socket) do
    IO.inspect tweet
    # IO.inspect socket
    username_="Gaurav"
    # tweet="as as as as asas"
    reply =  GenServer.call(pid,{:follow_user,username,to_follow})
    IO.puts reply
    {:reply, :ok, socket}
  end
  
  #--------------->>>>> LOGIN HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"payload" => tweet}, socket) do
    IO.puts "++++++"
    IO.inspect tweet
    IO.puts "end"
    # IO.inspect socket
    username_="Gaurav"
    # tweet="as as as as asas"
    reply =  reply = GenServer.call(pid,{:login,username,password})
    IO.puts reply
    {:reply, :ok, socket}
  end

  #--------------->>>>> LOGOUT HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"payload" => tweet}, socket) do
    IO.puts "++++++"
    IO.inspect tweet
    IO.puts "end"
    # IO.inspect socket
    username_="Gaurav"
    # tweet="as as as as asas"
    reply =  GenServer.call(pid,{:logout,username})
    IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> COMPLETED <<<<<----------------------
  #--------------->>>>> COMPLETED <<<<<----------------------


  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end