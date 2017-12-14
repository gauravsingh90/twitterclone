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
      "ok", (reply) => checkForErrors(reply.reply)
     )
  })


  //--------------->>>>> TWEET channel<<<<<---------------------
   document.getElementById("btn_add_tweet").addEventListener('click',function(){
    var username_ = document.querySelector("#hidden-user").value
    var tweetContent_ = document.querySelector("#in-tweet-text").value
    channel.push("addTweet", {username: username_,tweet: tweetContent_}).receive(
      "ok", (reply) => checkForErrors(reply.reply)
     )
})

//--------------->>>>> RETWEET channel<<<<<---------------------
document.getElementById("btn_retweet").addEventListener('click',function(){
  var username_ = document.querySelector("#hidden-user").value
  if($("input[name='btn-radio']:checked").attr("hidval")!=undefined){
    var tweetContent_ = $("input[name='btn-radio']:checked").attr("hidval")
    channel.push("retweet", {username: username_,tweet: tweetContent_}).receive(
      "ok", (reply) => checkForErrors(reply.reply)
     )
  }
  else
    alert("Select a tweet from homepage")
})
 
//--------------->>>>> FOLLOW channel<<<<<----------------------
document.getElementById("btn_follow").addEventListener('click',function(){
  var username_ = document.querySelector("#hidden-user").value
  var to_follow_ = document.querySelector("#in-subscribe-to").value
  channel.push("follow", {username: username_,to_follow: to_follow_}).receive(
    "ok", (reply) => alert(reply.reply)
   )
})

//--------------->>>>> LOGIN channel<<<<<-----------------------
document.getElementById("btn_login").addEventListener('click',function(){
  var username_ = document.querySelector("#usr").value
  var password_= document.querySelector("#password").value
  channel.push("login", {username: username_,password: password_}).receive(
    "ok", (reply) => checkForErrors(reply.reply)
   )
})
//--------------->>>>> LOGOUT channel<<<<<----------------------
document.getElementById("btn_logout").addEventListener('click',function(){
  var username_ = document.querySelector("#hidden-user").value
  // var password_= document.querySelector("#password").value
  channel.push("logout", {username: username_}).receive(
    "ok", (reply) => resetpage()
   )
})

//--------------->>>>> MENTION channel<<<<<-----------------------
document.getElementById("btn_mentions").addEventListener('click',function(){
  var search = document.querySelector("#in-search-term").value
  if(search!=""){
      channel.push("mentions", {username: search}).receive(
      "ok", (reply) => generateResults(reply.reply)
    )
  }else{
    alert("type something in the input box first.")
  }
})


//--------------->>>>> MENTION channel<<<<<-----------------------
document.getElementById("btn_hastags").addEventListener('click',function(){
  var search = document.querySelector("#in-search-term").value
  if(search!=""){
      channel.push("hashtags", {hashtag: "#"+ search}).receive(
      "ok", (reply) => generateResults(reply.reply)
    )
  }else{
    alert("Type something in the search box first.")
  }
})

function resetpage(){
  location.reload()
}
export default socket

function checkForErrors(user){
  if(typeof user === 'string' || user instanceof String)
    alert(user)
  else
    switchToHome(user)
  
}
function generateResults(user){
  $("#ctn-search").show();
  if(typeof user === 'string' || user instanceof String)
  alert(user)
  else{
    if(user.length>0){
      $('#ctn-search ul').html("");
      for (var x in user){
        $('#ctn-search ul').append(
          $('<li>').append(
              // $('<a>').attr('href','/user/messages').append(
                $('<span>').append(user[x])
              // )
            )
        );   
      }
    }
  }
}
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
  $("#btn_logout").show();
  $("#ctn-landingpage").show();
  $("#div-greet-user").html("Welcome "+user.username)
  $("#hidden-user").val(user.username)
  generateHomepage(user);
  generateTweetList(user);
  generateFollowerList(user);
}

function generateHomepage(user) {
  $("#ctn-homepage").show();
  if(user.homepage.length>0){
    $('#ctn-homepage ul').html("");
    for (var x in user.homepage){
      $('#ctn-homepage ul').append(
        $('<li>').append(
            // $('<a>').attr('href','/user/messages').append(
              $('<input>').attr("type", "radio").attr("name","btn-radio").attr("hidval",user.homepage[x])
            ).append(
              user.homepage[x]
          )
      );   
    }
  }
}
function generateFollowerList(user) {
  $("#ctn-followers").show();
  if(user.followers.length>0){
    $('#ctn-followers ul').html("");
    for (var x in user.followers){
      $('#ctn-followers ul').append(
        $('<li>').append(
            // $('<a>').attr('href','/user/messages').append(
              $('<span>').append(user.followers[x])
            // )
          )
      );   
    }
  }
}