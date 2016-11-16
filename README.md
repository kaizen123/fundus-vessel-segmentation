Vessel segmentation from fundus images
======================================
* Contains matlab algorithms for blood vessel segmentation from fundus images.
* Three methods based on 
	- Scale space theory
		Apply gaussian filters to simulate different 'scales' of viewing
		and combining edges which appear across different scales.

	- matched filter response 
		Approximating the blood vessel profile by a gaussian function.

	- Motion blurring (A new method for vessel segmentation)
		Averaging an image using motion blurring and subtracting the averaged image from the original image.

Running
-------
* Run the vesselSegmentatioGUI.fig file using Matlab Guide. This provides a GUI with a few simple functions. 

* NOTE: The gui has hardcoded parameters for the functions. So you might need to change these to get it working with fundus images other than the supplied one.