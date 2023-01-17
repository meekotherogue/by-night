addEventListener("keydown", (event) => {
  if (event.keyCode == 37) {
    const left = document.getElementById("imageDetailLeftArrow");
    left.click();
  } else if (event.keyCode == 39) {
    const right = document.getElementById("imageDetailRightArrow");
    right.click();
  } else if (event.keyCode == 27) {
    const escape = document.getElementById("imageDetailEscape");
    escape.click();
  }
});
