(function(e,t){
  var n=e.document;
  setTimeout(function(){
    function a(e){
      if(e.data==="destroy_bookmarklet"){
        var r=n.getElementById(t);
        if(r){
          n.body.removeChild(r);
          r=null
        }
      }
    }
    var t="KUANSIM_bookmarklet_iframe",r=n.getElementById(t);
    if(r){
      return
    }
    var i="http://localhost:3000/bookmarks/save&",s=n.createElement("iframe");
    s.id=t;
    s.src=i+"url="+encodeURIComponent(e.location.href)+"&title="+encodeURIComponent(n.title)+"&note="+encodeURIComponent(""+(e.getSelection?e.getSelection():n.getSelection?n.getSelection():n.selection.createRange().text));
    s.style.position="fixed";
    s.style.top="0";
    s.style.left="0";
    s.style.height="100%25";
    s.style.width="100%25";
    s.style.zIndex="16777270";
    s.style.border="none";
    s.style.visibility="hidden";
    s.onload=function(){
      this.style.visibility="visible"
    };
    n.body.appendChild(s);
    var o=e.addEventListener?"addEventListener":"attachEvent";
    var u=o=="attachEvent"?"onmessage":"message";
    e[o](u,a,false)},1)
})(window);

a=function(){return window.top!==window.self?window.parent.postMessage("destroy_bookmarklet","*"):(window.open("","_self",""),window.close())}



javascript:(function(e,t){var n=e.document;setTimeout(function(){function a(e){if(e.data==="destroy_bookmarklet"){var r=n.getElementById(t);if(r){n.body.removeChild(r);r=null}}}var t="KUANSIM_bookmarklet_iframe",r=n.getElementById(t);if(r){return}var i="http://kuansim.herokuapp.com/bookmarks/save?source=bookmarklet&",s=n.createElement("iframe");s.id=t;s.src=i+"url="+encodeURIComponent(e.location.href)+"&title="+encodeURIComponent(n.title)+"&note="+encodeURIComponent(""+(e.getSelection?e.getSelection():n.getSelection?n.getSelection():n.selection.createRange().text));s.style.position="fixed";s.style.top="0";s.style.left="0";s.style.height="100%25";s.style.width="100%25";s.style.zIndex="16777270";s.style.border="none";s.style.visibility="hidden";s.onload=function(){this.style.visibility="visible"};n.body.appendChild(s);var o=e.addEventListener?"addEventListener":"attachEvent";var u=o=="attachEvent"?"onmessage":"message";e[o](u,a,false)},1)})(window)