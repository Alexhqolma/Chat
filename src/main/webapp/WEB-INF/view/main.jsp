<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>
<head>
    <title>Chat</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
    <style>
        .chatbox {
            display: none;
        }
        .changename {
            display: none;
            margin-bottom: 10px;
        }
        .changename input{
            display: block;
            width: 400px;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
            float: left;
            margin-right: 10px;
        }
        .start input{
            display: block;
            width: 400px;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
            float: left;
            margin-right: 10px;
        }
        .chatbox textarea{
            display: block;
            width: 535px;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
            float: left;
            margin-right: 10px;
            margin-bottom:20px;
        }
        .messages {
            background-color: #a6bbd0;
            width: 534px;
            padding: 20px;
            border-radius: 10px;
        }
        .messages .msg {
            background-color: #fff;
            border-radius: 10px;
            margin-top: 10px;
            overflow: hidden;
        }
        .messages .msg .from {
            background-color: #473084;
            line-height: 30px;
            text-align: center;
            color: white;
        }
        .messages .msg .text {
            padding: 10px;
        }
    </style>
    <script>
        let chatUnit = {
            init() {
                this.startbox = document.querySelector(".start");
                this.changenamebox = document.querySelector(".changename");
                this.chatbox = document.querySelector(".chatbox");
                this.startBtn = this.startbox.querySelector("button");
                this.nameInput = this.startbox.querySelector("input");
                this.nameBtn = this.changenamebox.querySelector("button");
                this.newnameInput = this.changenamebox.querySelector("input");
                this.msgTextArea = this.chatbox.querySelector("textarea");
                this.chatMessageContainer = this.chatbox.querySelector(".messages");
                this.bindEvents();
            },

            bindEvents() {
                this.startBtn.addEventListener("click", e => this.openSocket());
                this.msgTextArea.addEventListener("keyup", e => {
                    if (e.ctrlKey && e.keyCode === 13) {
                        e.preventDefault();
                        this.send();
                    }
                });
                this.nameBtn.addEventListener("click", e => this.changeName());
            },

            send() {
                this.sendMessage({
                    name: this.name,
                    text: this.msgTextArea.value
                });
            },

            onMessage(msg) {
                let msgBlock = document.createElement("div");
                msgBlock.className = "msg";
                let fromBlock = document.createElement("div");
                fromBlock.className = "from";
                fromBlock.innerText = msg.name;
                let textBlock = document.createElement("div");
                textBlock.className = "text";
                textBlock.innerText = msg.text;
                msgBlock.appendChild(fromBlock);
                msgBlock.appendChild(textBlock);
                this.chatMessageContainer.prepend(msgBlock);
            },

            sendMessage(msg) {
                this.onMessage({name: "I am", text: msg.text});
                this.msgTextArea.value = "";
                this.ws.send(JSON.stringify(msg));
            },

            openSocket() {
                this.ws = new WebSocket("ws://localhost:8080/chat");
                this.ws.onopen = () => this.onOpenSock();
                this.ws.onmessage = (e) => this.onMessage(JSON.parse(e.data));
                this.ws.onclose = () => this.onClose();
                this.name = this.nameInput.value;
                this.startbox.style.display = "none";
                this.chatbox.style.display = "block";
                this.changenamebox.style.display = "block";
            },

            changeName() {
                this.name = this.newnameInput.value;
            }
        };

        window.addEventListener("load", e => chatUnit.init());
    </script>
</head>
<body>
<h1>ChatBox</h1>
<div class="start">
    <input type="text" class="username from-control" placeholder="Enter name">
    <button id="start" class="btn btn-success">Choose Name</button>
</div>
<div class="changename">
    <input type="text" class="usernewname from-control" placeholder="Change name">
    <button id="newname" class="btn btn-success">Change name</button>
</div>
<div class="chatbox">
    <textarea class="msg"></textarea>
    <div class="messages"></div>
</div>
</body>
</html>
