use <RepRapLogo.scad>
use <reprapleonText.scad> // "leon"
use <CLONEWARSText.scad>  // "clone wars"
use <reprapText.scad>     // "reprap"

cardMarginPer = 0.5;
cardMarginH = 0.5;
cardWidth = 87 + cardMarginPer;
cardLength = 55.5 + cardMarginPer;
cardHight  = 1*0.76 + cardMarginH;

wall = 1.6;

cardHolderW = wall + cardWidth;
cardHolderL = wall + cardLength;
cardHolderH = wall + cardHight;

holderL = 15;

module card ( w, l, h )
{
	cube ( [w, l, h] );
}

module myText (text = "clone wars")
{
	translate ( [3,cardHolderL/2,wall] )
	{
		if (text=="leon") // Leon
		{
			scale ( [0.45, 0.45, 0.3])
				rotate ([0,0,-90])
				{
					poly_path2992(2);
					poly_path2994(2);
					poly_path2996(2);
					poly_path2998(2);
					poly_path3000(2);
					poly_path3002(2);
					poly_path3004(2);
					poly_path3006(2);
					poly_path3008(2);
					poly_path3010(2);
					poly_path2990(2);
					poly_path3012(2);
					poly_path3014(2);
				}
		}
		
		if ( text == "clone wars" )
		{
			#scale ( [0.60, 0.60, 0.3])
				rotate ([0,0,-90])
				{
				
					poly_path3241(2);
					poly_path3243(2);
					poly_path3245(2);
					poly_path3247(2);
					poly_path3249(2);
					poly_path3251(2);
					poly_path3253(2);
					poly_path3255(2);
					poly_path3239(2);
				}
		}
		else // RepRap
		{
			scale ( [0.45, 0.45, 0.3])
				rotate ([0,0,-90])
				{
					poly_path3168(2);
					poly_path3162(2);
					poly_path3170(2);
					poly_path3172(2);
					poly_path3174(2);
					poly_path3176(2);
					poly_path3178(2);
					poly_path3180(2);
					poly_path3182(2);
					poly_path3184(2);
					poly_path3186(2);
					poly_path3160(2);
					poly_path3188(2);
					poly_path3190(2);
					poly_path3166(2);
					poly_path3164(2);
				}
		}
	}
}

module d1CardStrap (text="clone wars")
{
	difference ()
	{
			translate ( [cardHolderW, 0, 0] )
			{
				card ( holderL, cardHolderL, wall );
				myText (text = "clone wars");
				
			}
			//	cutting angles of strap
			translate ( [cardHolderW+holderL, 0, 0] )
			{
				rotate ([0,0,180])
				{
					cylinder ( r=holderL+wall, h=10, $fn=3, center=true );
				}
			}
			translate ( [cardHolderW+holderL, cardHolderL, 0] )
			{
				rotate ([0,0,180])
				{
					cylinder ( r=holderL+wall, h=10, $fn=3, center=true );
				}
			}
		
			// Strap hole
			translate ( [(cardHolderW+(holderL/2)+0.7), cardHolderL/2-5, -1] )
			{
				card (3, 10, 10);
				translate ([1.5,0,-1])
					cylinder ( r=1.5, h=10, $fn=10 );
				translate ([1.5,10,-1])
					cylinder ( r=1.5, h=10, $fn=10 );
				translate ([1.5,5,-5])
					cylinder ( r=3, h=10, , $fn=20 );
			}
	}	
}	

module topStops ()
{
	translate ( [ 20, 0, cardHolderH ] )
	{
		union ()
		{
			card ( cardHolderW - 40, 2*wall,  wall );
			// Round the ends
			translate ( [0, wall, 0] )
				cylinder ( r=wall, h=wall, $fn=10 );
			translate ( [cardHolderW - 40, wall, 0] )
				cylinder ( r=wall, h=wall, $fn=10 );
		}
	}
	translate ( [ 20, cardHolderL-(2*wall), cardHolderH] )
	{
		union ()
		{
			card ( cardHolderW - 40, 2*wall,  wall );
			// Round the ends
			translate ( [0, wall, 0] )
				cylinder ( r=wall, h=wall, $fn=10 );
			translate ( [cardHolderW-40, wall, 0] )
				cylinder ( r=wall, h=wall, $fn=10 );
		}
	}
}

module d1CardHolder ()
{
	union() {
		difference ()
		{
			union (){
				difference ()
				{
					card (cardHolderW, cardHolderL, cardHolderH);
					translate ([wall,wall,wall])
						card (cardHolderW, cardHolderL-2*wall, cardHolderH);
	
					translate ([cardHolderL/3, cardHolderW/1.56, -2])
					{
						rotate ([0,0,270])
							scale ([0.6,0.6,1])
							repraplogo(20);
					}
				}
			}
			// Card extraction
			translate ([0, (cardHolderL)/2, 0])
				cylinder (  h=10, r = 8, center=true);	
	
		}
	
	    // Top overhang
		topStops();
		d1CardStrap(text="reprap");
	}
}

d1CardHolder();
translate ([wall, wall, wall])
{
	*#card ( 86, 54, 0.8 );
}
