// Liveplot.js -- a p5js scene by Tim Schäfer.
// This is free software, published under the GPLv3 license. No warranties.

// +++ Settings +++
var numDots = 50;   // number of rows of the field
var numPositionsPerDot = 20;      // number of target positions per line, or columns (vertical lines)
var numLines = 18;           // number of plot lines
var numPositionsToDrawForLine = 18;

var doDrawPotentialTargetPoints = false;
var doDrawTargetPoints = false;
var doDrawCurrentPoints = false;
var doDrawVerticalLines = true;
var doDrawMaxDrawXLine = false;

var backGroundColor = 80;
var verticalLinesColor = 160;

// +++ End of settings ++++


var dotPositions = [];
var linesYSpots = [];
var maxXDrawLine;
var interDotDistanceY;
var interDotPositionDistanceX;
var nextLineYSpot;
var someColors = ['#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#ffffff', '#000000' ];

function setup() {
	frameRate(30);
  createCanvas(600, 400);
	interDotDistanceY = (height/numDots);
  interDotPositionDistanceX = (width/numPositionsPerDot);

	for (var i = 0; i < numDots; i++) {
    for (var j = 0; j <= numPositionsPerDot; j++) {
      var currentYPos = i * interDotDistanceY + 0.5 * interDotDistanceY;
      var currentXPos = j * interDotPositionDistanceX + 0.5 * interDotPositionDistanceX;
		    dotPositions.push([currentXPos, currentYPos]);
    }
	}

  maxDrawLineX = dotPositions[numPositionsToDrawForLine-2][0] + 0.5 * interDotPositionDistanceX;

  nextLineYSpot = [];
  for (var k = 0; k < numLines; k++) {
    var currentLineYSpots = [];
    for (var l = 0; l < numPositionsToDrawForLine; l++) {
      currentLineYSpots.push(getRandomInt(0, numDots-1));
    }
    linesYSpots.push(currentLineYSpots);
    nextLineYSpot.push(getRandomInt(0, numDots-1));
  }
}

function draw() {
  background(backGroundColor);
	// move Dots
  var jumpThisFrame = false;
	for (var i = 0; i < dotPositions.length; i++) {
    dotPositions[i][0] -= 2;
		if(dotPositions[i][0] < -interDotPositionDistanceX) {  // reset if it left screen
      var howMuchSmaller = -interDotPositionDistanceX -dotPositions[i][0];
		  dotPositions[i][0] = width - howMuchSmaller;
      jumpThisFrame = true;
		}
	}

  if(jumpThisFrame) {
    // draw new random next points for all lines
    for (var k = 0; k < numLines; k++) {
      linesYSpots[k].shift();
      linesYSpots[k].push(nextLineYSpot[k]);
      nextLineYSpot[k] = (getRandomInt(0, numDots-1));
    }
  }

  // draw maxDrawLineX
  if(doDrawMaxDrawXLine) {
    stroke(color(0, 255, 0));
    line(maxDrawLineX, 0, maxDrawLineX, height);
  }
  stroke(color(0));

	// draw dots
	fill(color(255, 0, 0));
  if (doDrawPotentialTargetPoints) {
	  for (var j = 0; j < dotPositions.length; j++) {
		  ellipse(dotPositions[j][0], dotPositions[j][1], 5);
	  }
  }

  // advance Y spots

  // draw lines
  //  - find the current X positions of all points
  var currentPointXPositions = [];
  stroke(verticalLinesColor);
  for (var l = 0; l <= numPositionsPerDot; l++) {
      currentPointXPositions[l] = dotPositions[l][0];
      // draw vertical lines
      if(doDrawVerticalLines) {
        line(currentPointXPositions[l], 0, currentPointXPositions[l], height);
      }
  }
  stroke(color(0));
  // - sort by X values
  sortWithIndeces(currentPointXPositions);
  // - draw lines between first numPositionsToDrawForLine points


  for (var k = 0; k < numLines; k++) {
    var thisLineYSpots = linesYSpots[k]; // these are only the indices, i.e., row numbers
    //print("Line " + k + " last y spots: " + thisLineYSpots.join(",") + ". Next=" + nextLineYSpot[k]);

    var thisLineYPositionsOfSpots = []; // y coordinates
    for (var l = 0; l < numPositionsToDrawForLine; l++) {
      thisLineYPositionsOfSpots[l] = thisLineYSpots[l] * interDotDistanceY + 0.5 * interDotDistanceY;
    }
    //print("Line " + k + " y positions: " + thisLineYPositionsOfSpots.join(","));

    var colorNoAlpha = color(someColors[k]);
    var newAlpha = 160;
    var colorAlpha = color(red(colorNoAlpha), green(colorNoAlpha), blue(colorNoAlpha), newAlpha);
    stroke(colorAlpha);
    strokeWeight(4);
    line(0, thisLineYPositionsOfSpots[0], currentPointXPositions[0], thisLineYPositionsOfSpots[0]);
    for (var l = 0; l <= numPositionsToDrawForLine; l++) {

      line(currentPointXPositions[l], thisLineYPositionsOfSpots[l], currentPointXPositions[l+1], thisLineYPositionsOfSpots[l+1]);
    }
    // Draw line towards next point: compute y position at x position maxDrawLineX
    var nextY = nextLineYSpot[k] * interDotDistanceY + 0.5 * interDotDistanceY;
    var lastY = thisLineYPositionsOfSpots[numPositionsToDrawForLine-1];
    var lastX = currentPointXPositions[numPositionsToDrawForLine-1];
    var nextX = currentPointXPositions[numPositionsToDrawForLine];
    var yDiff = nextY - lastY;
    var xDiff = nextX - lastX;
    var ascent = yDiff / xDiff;
    var xDiffToMaxDrawLineX = maxDrawLineX - lastX;
    var yAtmaxDrawLineX = lastY + (ascent * xDiffToMaxDrawLineX);
    line(currentPointXPositions[numPositionsToDrawForLine-1], lastY, maxDrawLineX, yAtmaxDrawLineX);
    strokeWeight(1);
    //print("Line " + k + ": ascent=" + ascent +", nextY=" + nextY +", lastY=" +lastY + ". lastX=" + lastX + " ,nextX=" + nextX + ". xDiff=" + xDiff + " (interDotPositionDistanceX=" + interDotPositionDistanceX + "), yDiff=" + yDiff);

    if(doDrawCurrentPoints) {
      fill(color(255,127,80));    // draw current dot in orange (stroke with current line's color)
      ellipse(lastX, lastY, 10);
    }
    if(doDrawTargetPoints) {
      fill(color(255, 255, 0));   // draw next target in yellow (stroke with current line's color)
      ellipse(nextX, nextY, 10);
    }
  }
}

function sortWithIndeces(toSort) {
  for (var i = 0; i < toSort.length; i++) {
    toSort[i] = [toSort[i], i];
  }
  toSort.sort(function(left, right) {
    return left[0] < right[0] ? -1 : 1;
  });
  toSort.sortIndices = [];
  for (var j = 0; j < toSort.length; j++) {
    toSort.sortIndices.push(toSort[j][1]);
    toSort[j] = toSort[j][0];
  }
  return toSort;
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
