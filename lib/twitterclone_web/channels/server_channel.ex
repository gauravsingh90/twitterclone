defmodule TwittercloneWeb.ServerChannel do
  use Phoenix.Channel
  alias Twi.User

  def join("server:main", _message, socket) do
    {:ok, [],socket}
  end
  #--------------->>>>> REGISTER HANDLE IN <<<<<----------------------
  def handle_in("register",%{"username" => username_,"password" => password_}, socket) do
    user = %User{username: username_ |> String.to_atom, password: password_, online: true}
    reply_=GenServer.call(Mainserver, {:register, user})
    IO.inspect reply_
    {:reply, {:ok,%{reply: reply_}}, socket}
  end
  #--------------->>>>> ADD TWEET HANDLE IN <<<<<----------------------
  def handle_in("addTweet",%{"username" => username_,"tweet" => tweet_}, socket) do
    reply_ =  GenServer.call(Mainserver,{:find_add_tweet,username_,tweet_})
    # IO.puts reply
    {:reply, :ok, socket}
  end
  #--------------->>>>> ADD RETWEET HANDLE IN <<<<<----------------------
  def handle_in("retweet",%{"username" => username_,"tweet" => tweet_}, socket) do
    reply_ =  reply = GenServer.call(Mainserver,{:retweet,username_,tweet_})
    {:reply, :ok, socket}
  end
  #--------------->>>>> FOLLOW HANDLE IN <<<<<----------------------
  def handle_in("follow",%{"username" => username_,"to_follow" => to_follow_}, socket) do
    reply_ =  GenServer.call(Mainserver,{:follow_user,username_,to_follow_})
    {:reply, :ok, socket}
  end
  
  #--------------->>>>> LOGIN HANDLE IN <<<<<----------------------
  def handle_in("login",%{"username" => username_,"password" => password_}, socket) do
    reply_ =  GenServer.call(Mainserver,{:login,username_,password_})
    {:reply, :ok, socket}
  end

  #--------------->>>>> LOGOUT HANDLE IN <<<<<----------------------
  def handle_in("logout",%{"username" => username_}, socket) do
    reply_ =  GenServer.call(Mainserver,{:logout,username_})
    {:reply, :ok, socket}
  end
  #--------------->>>>> COMPLETED <<<<<----------------------
  #--------------->>>>> COMPLETED <<<<<----------------------


  def join("server:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end