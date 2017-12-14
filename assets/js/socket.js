import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
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


  //--------------->>>>> TWEET channel<<<<<---------------------
   document.getElementById("btn_add_tweet").addEventListener('click',function(){
    var username_ = document.querySelector("#hidden-user").value
    var tweetContent_ = document.querySelector("#in-tweet-text").value
    channel.push("addTweet", {username: username_,tweet: tweetContent_}).receive(
      "ok", (reply) => switchToHome(reply.reply)
     )
})

//--------------->>>>> RETWEET channel<<<<<---------------------
// document.getElementsByName("btn_add_retweet").addEventListener('click',function(){
//   var username_ = document.querySelector("#usr").value
//   var tweetContent_ = document.querySelector("#addTweetText").value
//   channel.push("retweet", {username: username_,tweet: tweetContent_})

// })
 
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

function generateTweetList(user) {
  $("#ctn-tweets").show();
  if(user.tweets.length>0){
    $('#ctn-tweets ul').html("");
    for (var x in user.tweets){
      $('#ctn-tweets ul').append(
        $('<li>').append(
            // $('<a>').attr('href','/user/messages').append(
              $('<span>').append(user.tweets[x])
            // )
          )
      );   
    }
  }
}
function switchToHome(user) {
  $("#ctn-login").hide();
  $("#ctn-landingpage").show();
  $("#div-greet-user").html("Welcome "+user.username)
  $("#hidden-user").val(user.username)
  generateHomepage(user);
  generateTweetList(user)
}

function generateHomepage(user) {
  $("#ctn-homepage").show();
  if(user.homepage.length>0){
    $('#ctn-homepage ul').html("");
    for (var x in user.homepage){
      $('#ctn-homepage ul').append(
        $('<li>').append(

            // $('<a>').attr('href','/user/messages').append(
              $('<input>').attr("type", "radio").attr("name","btn-radio").append(
                $('<span>').append(user.homepage[x])
              )
            )
          // )
      );   
    }
  }
}