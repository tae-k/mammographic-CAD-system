*****************
*** IMPORTANT *** 
*****************

You are reading the "README.txt" file of Evaluation code Version 1.0. This folder contains several files and subfolders that will be used to evaluate your algorithm of Project 1. There are several things you should do: 

1. We updated the "Project1List.xlsx". Please replace the old one with the new version. The main difference is that the new version of list gives diagnoses for both breasts of each subject. In Project 1, given a pair of mammograms (left and right), you need to give the diagnoses and masks for both breasts. We will treat all the images independently when computing the diagnostic accuracy and Dice overlap. You will still have the prior knowledge that only one side of the breasts has a mass for each subject with disease.

2. You should edit the evaluation code to make it work well with your own algorithm.
Note: There are two MATLAB files you can edit: "script_EvaluationProj1.m" and "runProject1.m". However, for each MATLAB file, not all lines are allowed to be edited. In "script_EvaluationProj1.m", please edit the line that calls function "runProject1". In "runProject1.m", please edit the lines following the instruction.

% You may add more inputs to run_Project1();

3. Since you don't have "real" testing data, you may use your training data as "fake" testing data to run the evaluation code. To do this, you should: 
* copy the "*.png" files of training SCANs and MASKs to "MammoTesting" folder.

4. After editing the evaluation code, you should send a compressed *ROOT FOLDER* (.zip file) to TAs. The compressed *ROOT FOLDER* should contain: 
* script_EvaluationProj1.m (may be edited)
* runProject1.m (may be edited)
* Your_algorithm.m (If you use other languages, your code should be callable for MATLAB.)
* Others (e.g. pretrained model)

5. What will TAs do when evaluating your code?
* TAs will copy real testing data to corresponding folders (e.g. Mammograms for testing),
* replace the "fake" testing lists (i.e. Project1ListTesting.xlsx) with "real" testing lists,
* and run "script_EvaluationProj1.m". Then your code will be assessed based on the displayed metrics. 
* So, please double check that your code is fully automatic, and works well with the evaluation code.

6. Changes might be made on the evaluation code if we found errors or bugs. So, make sure that you are working on the latest version of evaluation code.




****************
*** CONTENTS ***
**************** 

1. script_EvaluationProj1.m: script for evaluating Project 1.

2. runProject1.m: MATLAB function to call your algorithm. 

3. Project1List.xlsx:updated version of the TRAINING subjects' ID and their diagnosis. Please replace the old one with this version.

4. Project1ListTesting.xlsx: table of subjects' ID and their diagnosis for both breasts of testing data. 
Note: To make evaluation code runnable in your machine, the content of "Project1ListTesting.xlsx" is made to be the list of TRAINING subjects. However, after you send us the final code, TAs will replace the content with the IDs and diagnosis of TESTING subjects. 

5. (Empty folder) MammoTesting: to make the evaluation code runnable on your machine, you  may copy the "*.png" files of TRAINING scans and masks to this folder.

6. README.txt
