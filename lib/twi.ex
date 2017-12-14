defmodule Twi do
  use GenServer
  alias Twi.User
  alias Twi.Server
 
  def start_link(args, args2, args3) do
    GenServer.start_link(Twi, %Server{users: [], hashtags: %{}}, name: Mainserver)
  end

  ### --- CALL BACK FUNCTION RECEIVED FROM THE CLIENT ON SERVER MODULE --- ##
  ## handle call for register
  def handle_call({:register, %User{username: username}=user},_from, %Server{users: users} = server) do
    username_ =
    case Enum.member?(users,username) do
      false -> GenServer.start_link(Client,user, name: username)
      # reply_= "User Account : #{username |> to_string} created" 
      reply_=user
        [username]
      true -> 
        # reply_="!!! User Account : #{username |> to_string} already exits. Try changing username."
        reply_=user
        []
    end
  {:reply, reply_, %Server{server | users: (users ++ username_)}}
  end
   # 
   # 
   # 
   # 
   # 7 HASHTAGS
  def handle_cast({:add_hashtags,newHashtag,tweet}, %Server{hashtags: existingHashtags} = server) do
  #  IO.puts("Reached Hashtag main")
  newMap_= case Map.has_key?(existingHashtags,newHashtag) do
       false -> 
        Map.put_new(existingHashtags,newHashtag,[tweet])

      true -> 
        temp = Map.get(existingHashtags,newHashtag)
        temp_=temp++[tweet]
        Map.put(existingHashtags,newHashtag,temp_)
        
    end
  {:noreply, %Server{server| hashtags: newMap_}}
  end
 

  def handle_call({:login,username,password}, _from, state) do
    reply_ =case Process.whereis(:"#{username}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
         GenServer.call(:"#{username}",{:login_client,password})  
    end
    {:reply,reply_,state}
  end

  def handle_call({:logout,username}, _from, state) do
    reply_ = case Process.whereis(:"#{username}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
        GenServer.call(:"#{username}",:logout_client)  
    end
    {:reply,reply_,state}
  end

  def handle_call({:find_add_tweet,username,tweet}, _from, state) do
    reply_ =
    case Process.whereis(:"#{username}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
       GenServer.call(:"#{username}",{:add_tweet,tweet})  
    end
    {:reply,reply_,state}
  end

  def handle_call({:follow_user,username,to_follow},_from,state) do
    reply_ = case Process.whereis(:"#{to_follow}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
        GenServer.call(:"#{to_follow}",{:client_follow, username})
    end
    {:reply,reply_,state}
  end

  def handle_call({:retweet,username,tweet},_from,state) do
    reply_ = case Process.whereis(:"#{username}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
        GenServer.cast(:"#{username}",{:send_retweet, tweet})
    end
    {:reply,reply_,state}
  end
 
  # ________________________________________________
  # CLIENT QUERY COMMANDS
  # ________________________________________________

  def handle_call({:fetch_mention,username}, _from, state) do
    reply_ = case Process.whereis(:"#{username}") do
      nil ->
        "Please enter the correct UserName. Username not found in database"
      _ ->
        GenServer.call(:"#{username}",:get_mention)  
    end
    {:reply,reply_,state}
  end

  def handle_call({:fetch_hashtags,hashtag}, _from,  %Server{hashtags: existingHashtags} = server) do
    reply_ = case Map.has_key?(existingHashtags,hashtag) do
      false -> 
       "No matching hashtags found."
     true -> 
       Map.get(existingHashtags,hashtag)
   end
   {:reply,reply_,server}
  end

  def handle_call({:fetch_userHomepage,username}, _from, server) do
    reply_ = case Process.whereis(:"#{username}") do
      nil ->
        IO.puts "Please enter the correct UserName. Username not found in database"
      _ ->
       GenServer.call(:"#{username}",:get_userHomepage)  
    end
    {:reply,reply_,server}
  end
end
