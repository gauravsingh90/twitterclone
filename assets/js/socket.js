// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

//--------------->>>>> REGISTER channel<<<<<---------------------
// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("server:main", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })



  //--------------->>>>> REGISTER channel<<<<<---------------------
  $("#btn_register").click(function(){
    var username_ = document.querySelector("#usr").value
    var password_= document.querySelector("#password").value
    channel.push("register", {username: username_,password: password_}).receive(
      "ok", (reply) => switchToHome(reply.reply)
     )
  })


  function switchToHome(user) {
    $("#ctn-login").hide();
    $("#ctn-homepage").show();
    $("#div-greet-user").html("Welcome "+user.username)
    $("#hidden-user").value(user.username)
    user.homepage


  }
  

  //--------------->>>>> TWEET channel<<<<<---------------------
   document.getElementById("btn_add_tweet").addEventListener('click',function(){
    var username_ = document.querySelector("#usr").value
    var tweetContent_ = document.querySelector("#addTweetText").value
    channel.push("addTweet", {username: username_,tweet: tweetContent_})
})

//--------------->>>>> RETWEET channel<<<<<---------------------
document.getElementById("btn_add_retweet").addEventListener('click',function(){
  var username_ = document.querySelector("#usr").value
  var tweetContent_ = document.querySelector("#addTweetText").value
  channel.push("retweet", {username: username_,tweet: tweetContent_})

})
 
//--------------->>>>> FOLLOW channel<<<<<----------------------
document.getElementById("btn_follow").addEventListener('click',function(){
  var username_ = document.querySelector("#usr").value
  var to_follow_ = document.querySelector("#addTweetText").value
  channel.push("follow", {username: username_,to_follow: to_follow_})

})

//--------------->>>>> LOGIN channel<<<<<-----------------------
document.getElementById("btn_login").addEventListener('click',function(){
  var username_ = document.querySelector("#usr").value
  var password_= document.querySelector("#password").value
  channel.push("login", {username: username_,password: password_})
})
//--------------->>>>> LOGOUT channel<<<<<----------------------
document.getElementById("btn_logout").addEventListener('click',function(){
  var username_ = document.querySelector("#usr").value
  // var password_= document.querySelector("#password").value
  channel.push("logout", {username: username_})
})
export default socket
