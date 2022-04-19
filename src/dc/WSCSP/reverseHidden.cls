Class dc.WSCSP.reverseHidden Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    &html<
<html>
<head>
<script language="JavaScript" type="text/javascript">
var verbose = true;
var ws;
var lin = "";
var msg = "";
var match =0;
var loop = 0;
var wsserver = "/csp/samples/Web.SocketTest.cls"
var exit = "exit" ;

if ((typeof(WebSocket) == 'undefined') && (typeof(MozWebSocket) != 'undefined')) {
    WebSocket = MozWebSocket;
}

function init() {
    ws = new WebSocket(((window.location.protocol == "https:") ? "wss:" : "ws:") + "//" + window.location.host + wsserver);
    ws.onopen = function(event) {
//
if (verbose) {
        document.getElementById("body").style.visibility = "visible";
        document.getElementById("main").style.visibility = "visible";
    }
        document.getElementById("connected").innerHTML = "Connected to WebSocket server: <b>" + decodeURIComponent(wsserver) + "</b>";
    };

    ws.onmessage = function(event) { 
        msg = event.data ;  
     #call(..saveReply(msg))# ;  
 // alert("0:"+loop+'??'+msg);
        lin = document.getElementById("output").innerHTML ; 
         document.getElementById("output").innerHTML = lin+ "<br>" + msg ;
        match=msg.match(/Welcome/i)==null?0:1 ;
//  alert('1:'+match);      
        if (match>0) {  hash(); } 
        match=msg.match(/Timeout/i)==null?0:1;
 //  alert('2:'+match) ;
       if (match>0) { loop++; }  //   alert("3:"+loop);
       if ((loop>2)&&(exit.length>1)) { ws.send(exit);  exit="" ;}
    };

    ws.onerror = function(event) {
        document.getElementById("connected").innerHTML = "Connection Error - Check that the web server supports web sockets";
    };

    ws.onclose = function(event) {
        document.getElementById("main").style.visibility = "hidden";
        document.getElementById("connected").innerHTML = "Connection Closed";
        exit=#server(..saveReply("exit"))#  ;
        setTimeout(done, 500);
        }
};
function done() {
    var ww = window.open(window.location, '_self'); ww.close(); 
    } ;

function hash() {
    msg=window.location.hash.substr(1);  // remove #
    document.getElementById("msg").value = msg ;
//  alert("5:"+msg+" l="+msg.length);
    if (msg.length>0) send(msg);
} ;
function send(message) { ;
    if (ws) {
        ws.send(message);
    }
    loop = 0;
}
</script>>
    Write !,(..HyperEventHead(0,0)),!
 &html<
</head>
<body id="body" onload="init();" style="visibility:hidden;">
<div id="connected">Not Connected</div>
</p>
<p>
    <div id="main" style="visibility:hidden;">
    Enter Message (Enter 'exit' to quit): <input type="text" id="msg" name="message" value="" size="80" onchange="send(this.value)"/><br/>
    <p>Response from Cache Server ... <div id="output"></div></p>
    </div>
</body>
</html>
>
    Quit $$$OK
}

ClassMethod saveReply(reply As %String) [ WebMethod ]
{
     // server-side method to save reply from WebSocket
     // simply save reply in Gloal ^WSREPLY
     set ^WSREPLY($i(^WSREPLY))=$lb($zdt($h,3),reply)
     Quit
}

}
