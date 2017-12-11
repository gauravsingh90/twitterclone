defmodule TwittercloneWeb.RoomChannel do
  use Phoenix.Channel
  alias Twi.User

  def join(name, _message, socket) do
    {:ok, %{hi: "join"},socket}
  end
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

  def handle_in("addTweet",message, socket) do
    IO.puts "++++++"
    IO.inspect message
    IO.puts "end"
    # IO.inspect socket
    username_="Gaurav"
    tweet="as as as as asas"
    reply =  GenServer.call(Mainserver,{:find_add_tweet,username_,tweet})
    IO.puts reply
    {:reply, :ok, socket}
  end



  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end