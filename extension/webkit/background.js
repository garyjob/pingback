// Copyright (c) 2010 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A generic onclick callback function.
function doPingBack(info, tab) {
  console.log("item " + info.menuItemId + " was clicked");
  console.log("info: " + JSON.stringify(info));
  console.log("tab: " + JSON.stringify(tab));
  linkedTo = info.linkUrl;
  link = info.pageUrl;
  console.log(link+" > "+linkedTo);

  var params = "link="+link+"&linkedTo="+linkedTo;
  var xhr = new XMLHttpRequest();
  xhr.open("POST", 
  	"http://ping.disconnect.me/", true);

  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) {
      alert(xhr.responseText);
    }
  }
  xhr.send(params);  
}

// Create one test item for each context type.
var contexts = ["link"];

for (var i = 0; i < contexts.length; i++) {
  var context = contexts[i];
  var title = "Do PingBack";
  var id = chrome.contextMenus.create({"title": title, "contexts":[context],
                                       "onclick": doPingBack});
  console.log("'" + context + "' item:" + id);
}

