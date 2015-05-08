// custom transformation: scale header's title
// From https://www.polymer-project.org/0.5/components/core-scroll-header-panel/demo.html
var titleStyle = document.querySelector('#site-header .title').style;
addEventListener('core-header-transform', function(e) {
  var d = e.detail;
  var m = d.height - d.condensedHeight;
  var scale = Math.max(0.75, (m - d.y) / (m / 0.25)  + 0.75);
  titleStyle.transform = titleStyle.webkitTransform =
    'scale(' + scale + ') translateZ(0)';
});
