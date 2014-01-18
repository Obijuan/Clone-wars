module repraplogo(h=7)
{
	difference ()
	{
		union(){
			scale ([0.5,0.5,0.5])
				linear_extrude(height=h)
				import("C:/Users/malparti/Documents/GitHub/Clone-wars/logos/clone-wars/repraplogo.dxf");

		}
	}
}