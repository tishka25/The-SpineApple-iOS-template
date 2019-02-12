var scrollTexts = [];
var scrollImages = [];
var backgroundColor = null;


function setup(){
    createCanvas(windowWidth, windowHeight);
    angleMode(DEGREES);
    rectMode(CENTER);
    backgroundColor = color(20,100,200);
    for(var i=0;i<4;i++){
        scrollTexts.push(new Scroller("The SpineApple is THE BEST" , "TEXT" , {x:random(0,width),y:random(0,height)} ));
    }
    for(var i =0;i<5;i++){
        scrollImages.push(new Scroller(createImg("./resources/logo.png").hide(), "IMAGE" , {x:random(0,width),y:random(0,height)} ));
    }
}

function draw(){
    background(backgroundColor);
    for(scrollText of scrollTexts){
        scrollText.update();
    }
    for(scrollImage of scrollImages){
        scrollImage.update();
    }
}



class Scroller{
    constructor(obj , type , starting){
        this.obj = obj;
        this.type = type;
        this.angle = 0;
        this.x = starting.x;
        this.y = starting.y;
        this.rotationSpeed = 1;
        this.speedX = 1;
        this.speedY = 1;
    }

    begin(){
    }
    update(){
        this.angle += this.rotationSpeed;
        
        push();
        textSize(18);
        translate(this.x , this.y);
        rotate(this.angle);
        fill(random(0,255) , random(0,255), random(0,255));
        if(this.type == "TEXT")
            text(this.obj , -150 ,0);
        else if(this.type == "IMAGE"){
            image(this.obj , 0, 0 , 50 , 50);
        }
            
        pop();

        if(this.x<0 || this.x>=width){
            this.speedX*= -1;
            this.rotationSpeed *= -1;
        }else if(this.y<0 || this.y>height){
            this.speedY*= -1;
            this.rotationSpeed *= -1;
        }
        
        if(dist(mouseX , mouseY , this.x , this.y) <= 20 && mouseIsPressed){
            this.x = mouseX;
            this.y = mouseY;
        }else{
            this.x += this.speedX;
            this.y += this.speedY;
        }

    }
}
