HDR Toolbox
===========

HDR Toolbox is a MATLAB/Octave toolbox for processing High Dynamic Range (HDR) content.

Author: Francesco Banterle

License: This software is distributed under GPL v3 license (see license.txt)

Year: Fall 2010-2016

Title: HDR Toolbox for Matlab

Version: 1.1.0

Contact:
========
e-mail: support@advancedhdrbook.com

facebook: https://www.facebook.com/pages/Advanced-High-Dynamic-Range-Imaging-Book/166905003358276


HOW TO INSTALL:
===============
1) Unzip the file HDRToolbox.zip in a FOLDER on your PC/MAC

2) Run Matlab

3) Set the FOLDER as current directory

4) Write the command installHDRToolbox in the Command Window, and wait for the installation process to end.


NOTE ON TONE MAPPING:
=====================
The majority of TMOs return tone mapped images with linear values. This means that gamma encoding
needs to be applied to the output of these TMOs before visualization or before writing tone mapped images
 on the disk; otherwise these images may appear dark.
A few operators (e.g. Mertens et al.'s operator) return gamma encoded values,
so there is no need to apply gamma to them; in this case a message (e.g. a Warning) is displayed
after tone mapping alerting that there is no need of gamma encoding.

NOTE ON EXPANSION OPERATORS (INVERSE/REVERSE TONE MAPPING):
=====================
The majority of EOs require to have as input LDR images in the range [0,1] that are LINEARIZED.
This means that the camera response function (CRF) or the gamma encoding has been removed.
This operation is MANDATORY in order to generate fair comparisons; please do use the gammaRemoval
parameter to remove gamma if you do not have the CRF of the input image. RAW files do not require 
this step because they are already linear.

NOTE ON PULL REQUESTS:
=====================
Please, send your pull requests to the develop branch.

REFERENCE:
==========
Please reference the book in your work or papers if you use this toolbox:

@book{Banterle:2011,

author = {Banterle, Francesco and Artusi, Alessandro and Debattista, Kurt and Chalmers, Alan},

title = {Advanced High Dynamic Range Imaging: Theory and Practice},

year = {2011},

isbn = {9781568817194},

publisher = {AK Peters (CRC Press)},

address = {Natick, MA, USA},

}
