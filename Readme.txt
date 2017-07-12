== Author: Francesco Banterle


== Contact e-mail: support@advancedhdrbook.com


== License: This software is distributed under GPL v3 license (see license.txt)


== Year: Fall 2010-2015


== Title: HDR Toolbox for Matlab


== Version: 1.1.0


== How To Install:
1) Unzip the file HDRToolbox.zip in a FOLDER on your PC/MAC;
2) Run Matlab
3) Set the FOLDER as current directory
4) Run the command:      installHDRToolbox
   and wait for the installation process.


== Reference:
Please reference the book in your work or papers if you this toolbox:

@book{Banterle:2011,
 author = {Banterle, Francesco and Artusi, Alessandro and Debattista, Kurt and Chalmers, Alan},
 title = {Advanced High Dynamic Range Imaging: Theory and Practice},
 year = {2011},
 isbn = {9781568817194},
 publisher = {AK Peters (CRC Press)},
 address = {Natick, MA, USA},
} 


== Note on Tone Mapping:
The majority of TMOs return tone mapped images with linear values. This means that gamma encoding
needs to be applied to the output of these TMOs before visualization or before writing tone mapped images
 on the disk; otherwise these images may appear dark.
A few operators (e.g. Mertens et al.'s operator) return gamma encoded values,
so there is no need to apply gamma to them; in this case a message (e.g. a Warning) is displayed
after tone mapping alerting that there is no need of gamma encoding.


== How to Use the Toolbox:
Run the demos to understand how to use I/O function, visualize images, tone Map Images, etc.


==Update Report
07/01/2016: -Improved the toolbox, especially BuildHDR
17/02/2015: -Added iCAM06 (KuangTMO), added Mitsunaga and Nayar method for recovering inverse CRF, added RAW support through DCRAW, bug fixes, and more...
16/07/2014: -Fixed some reported bugs for single input and FattalTMO, thanks to Areias Figueiras Edite and Bin Hu
29/04/2014: -Added a novel framework for HDR video compression and three compression schemes 
19/12/2013: -Many fixes including: ReinhardTMO, DragoTMO, RGBE2Float and many more... 
31/10/2013: -Added different fusion operator/tone mapping operator, improved demos, enhanced the toolbox.

03/10/2013: -Added input/output for HDR videos: these videos need to be encoded as folders with a sequence of HDR files.
	    -Integrated HDRJPEG 2000 into hdrimwrite and hdrimread.

16/09/2013: -Added Grossberg and Nayar sampling through histograms.

05/09/2013: -Added the TMQI Index by H. Yeganeh, Z. Wang. Based on the publication:
	     "Objective Quality Assessment of Tone Mapped Images", Journal of IEEE Transaction on Image Processing, 22 (2), 657-667, 2013
             We thank Hojat Yeganeh for integrating his functions into the Toolbox. Original code can be downloaded at:
	     https://ece.uwaterloo.ca/~z70wang/research/tmqi/

04/09/2013: -Added SIFT LDR images stack alignment based on the VL Feat Library (http://www.vlfeat.org/)
             The library needs to be installed to use this code.

02/09/2013: -Added a Hybrid TMO, BanterleTMO.m, based on ACM SAP 2012 Publications:
	     Francesco Banterle, Alessandro Artusi, Elena Sikudova, Thomas Edward William Bashford-Rogers,
	     Patrick Ledda, Marina Bloj, Alan Chalmers. ACM Symposium on Applied Perception (SAP) - August 2012 

16/07/2013: -Fixed an error in GenerateExposureBracketing.m. Thanks to Cheng-Yu Wu.

24/04/2013: -Fixed BuildHDR.m and aux files. Thanks to Luis Paulo Dos Santos.
	    -Added Alignment folder for aligning LDR images, and added demo_build_radiance_map.m

18/04/2013: -Fixed read_rgbe new line in the header. Thanks to Ronan Boitard.

12/02/2013: -Fixed TpFerwerda and TsFerwerda functions. Thanks to Miguel Melo.

23/10/2012: -Added ExposureHistogramCovering.m for sampling exposures with the histogram
	     using a greedy approach.

18/10/2012: -Added Boschetti et al. 2011 ICIP paper on HDR compression

12/10/2012: -Added Raman and Chaudhuri Eurographics 2009 Short paper on tone mapping (exposure fusion), see RamanTMO.m
            -Added a new demo for performing exposure fusion on stack
             demo_fusion_from_stack.m (this demo applies RamanTMO.m and Mertens.m)
	    -Fixed the interface for MertensTMO.m, now directories can be inserted as input

09/10/2012: -Removed a bug when reading uncompressed .hdr/.pic files.

29/08/2012: -Fixed the EXPOSURE's semantic when opening .hdr/.pic files. Thanks to Matthieu Perreira Da Silva 

06/07/2012: -Partial rewritten of the ChangeMapping.m function and its auxiliary functions
            -Fixed BanterleExpandMap.m to be closer to reference. Fixed a bug in the samples
             clamping, and added a Density Estimation through image splatting (see imSplat.m function).
             Note that this version is not suitable for videos but only for still images.
            -Added a batch function for converting HDR images into LDR images using tone mapping
            -Fixed an issue in Create1DDistribution.m. Thanks to Joel Kronander.

18/06/2012: -Fixed a bug in float2LogLuv.m. Thanks to Vassilios Solachidis

14/06/2012: -Added FalseColor.m function for the visualization of HDR images in false colors 
	    -Added imSameHeight.m utility function for adjusting the height
	    of an image to match the height of a target one

12/06/2012: -Improved TumblinRushmeierTMO.m, added maximum display Luminance parameter
	    -Added clamping to MertensTMO.m

07/06/2012: -Fixed a minor bug in GenerateExposureBracketing.m
	    -Made BuildHDR.m and CombineLDR.m functions more flexible and general,
	    allowing stack to be used as input

28/01/2012: -Fixed a bug in the WardGlobalTMO. Thanks to kirkt from the hdrlabs.com forum.             
            -CompoCon was made Octave compliant (explicit cast to logical values).

27/01/2012: -Removed some case sensitive problems for Octave. Thanks to kirkt from hdrlabs.com forum.

25/01/2012: -Improved read_rgbe.m function; now RLE compressed streams can be opened.
            -Minor improvements in write_rgbe.m function (RLE compression still missing).

17/12/2011: -Fixed PoissonSolver, it now works not only for squared images

	    -Added a first attempt to retinex
18/11/2011: -Fixed some bugs in the LogLuv encoding and added the Adaptive LogLuv encoding

25/10/2011: -Demo images are compressed into RGBE format to reduce download time.

11/10/2011: -Added ReinhardBilTMO.m
	    -Renamed the main util folder due to compability with Linux. Thanks to Shanmuga Raman.

11/09/2011: -Fixed a bug in the MeylanEO.m file

08/03/2011: -Fixed some problems in ExponentialTMO.m. Thanks to Alessandro Artusi.


== Known issues: -In ChangeMapping.m the Spherical mapping is not yet supported for output.


== Other: - Read license.txt
          - bilateralFilter.m is an implementation by Jiawen Chen under MIT License.
          - BanterleExpandMap.m is an implementation of Banterle et al. 2008 (SCCG 2008) for
            images only not videos. It is not an implementation of Banterle et al. 2006 (Graphite) or
            Banterle et al. 2007 (The Visual Computer). If you are not sure about parameters to
            be used please contact the author of the HDR Toolbox at any time.
