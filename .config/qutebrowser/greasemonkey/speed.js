// ==UserScript==
// @name         Speed up media
// @description  change media playbackRate 
// @author       xade
// ==/UserScript==
VAR_SPEED = 6
setInterval(() => {
  document.querySelector("video, audio").playbackRate = VAR_SPEED;
}, 40)
