class Item {
  String name;
  int binInto;
  String[] tf, description;

  Item(String line, String desc) {
    name = split(line, ",")[0];
    binInto = int(split(line, ",")[14]); //which bin to draw in the end screen
    description = split(desc, "%"); //for some reason \n doesn't work in text() so I split the description into a String[] of lines
  }

  void setTfArray(String line) {
    tf = subset(split(line, ","), 1, split(line, ",").length-1); //splits the line by commas, and takes everything except the name and the binInto value
  }

  void count(int i) { //for selectQ()
    if (this.tf[i].equals("TRUE")) t++;
    else if (this.tf[i].equals("FALSE")) f++;
    else v++;
  }

  void addItem() { //for removeItems()
    if (this.tf[q].equals(answer)||this.tf[q].equals("VOID")) {
      newI.add(this);
    }
  }
  
  void display() {
    image(binPics[binInto], 230, 400); //draws the bin the item belongs in!
    text(this.name, 380, 50); 
    textSize(14);
    int inc = 0; //spacing purposes
    for (int i = 0; i < this.description.length; i++) {
      text(this.description[i], 380, 80+20*i+30*inc, 400, 120); //textbox with text wrap
      if (this.description[i].length() > 60) { // adjusts where the next line should be drawn based on text wrap
        inc += this.description[i].length()/60;
      }
    }
    textSize(20);
  }
}
