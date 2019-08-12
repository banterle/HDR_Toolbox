HDR Toolbox
===========

HDR Toolbox is a MATLAB/Octave toolbox for processing High Dynamic Range (HDR) content.

Author: Francesco Banterle

License: This software is distributed under GPL v3 license (see license.txt)

Year: Fall 2010-2018

Title: HDR Toolbox for Matlab

Version: 1.1.0

REFERENCE:
==========
When you use the HDR Toolbox for your research, please DO NOT reference the URL of this website as many people wrongly do.
Please reference the book in your work/papers:

@book{Banterle:2017,
 
 author = {Banterle, Francesco and Artusi, Alessandro and Debattista, Kurt and Chalmers, Alan},
 
 title = {Advanced High Dynamic Range Imaging (2nd Edition)},
 
 year = {2017},
 
 month={July},
 
 isbn = {9781498706940},
 
 publisher = {AK Peters (CRC Press)},
 
 address = {Natick, MA, USA},
 
} 

HOW TO INSTALL:
===============
1) Unzip the file HDRToolbox.zip in a FOLDER on your PC/MAC

2) Run Matlab

3) Set the FOLDER as current directory

4) Write the command installHDRToolbox in the Command Window, and wait for the installation process to end.

NOTE ON EXPANSION OPERATORS (INVERSE/REVERSE TONE MAPPING):
=====================
The majority of EOs require to have as input LDR/SDR images that are NORMALZIED (i.e., in the range [0,1])
and LINEARIZED. To be LINEARIZED means that the camera response function (CRF) or the gamma encoding has been removed.
This operation is MANDATORY in order to generate FAIR comparisons.

NOTE1: Please DO use the gammaRemoval parameter to remove gamma encoding if you do not have the CRF of the input image. Note
that this is an approximation.

NOTE2: RAW files do not require this step because they are already linear. Therefore, for ONLY these
images set gammaRemoval = 1.0.

NOTE ON TONE MAPPING:
=====================
The majority of TMOs return tone mapped images with linear values (i.e., withouth a CRF or gamma encoding). 
This means that gamma encoding needs to be applied to the output of these TMOs before visualization or before 
writing tone mapped images on the disk; otherwise these images will appear dark.
A few operators (e.g., Mertens et al.'s operator) return gamma encoded values,
so there is no need to apply gamma to them; in this case a message (e.g., a Warning) is displayed
after tone mapping alerting that there is no need of gamma encoding.

NOTE ON PULL REQUESTS:
=====================
Please, send your pull requests to the develop branch. Requests sent to the Master branch will be ignored.

Contact:
========
e-mail: support@advancedhdrbook.com

facebook: https://www.facebook.com/pages/Advanced-High-Dynamic-Range-Imaging-Book/166905003358276
