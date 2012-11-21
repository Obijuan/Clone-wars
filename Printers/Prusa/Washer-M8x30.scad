//-- M8x30 Washer for the Prusa-Mendel 3D Printer
//-- (c) 2011 Juan Gonzalez-Gomez (Obijuan)
//-- GPL License

//-- Internal diameter
id=8.3;

//-- outer diameter
od=30;

//-- Thickness
th=2;

difference() {
  cylinder(r=od/2, h=th,$fn=50,center=true);
  cylinder(r=id/2, h=20, $fn=50,center=true);
}