# peaksCNN
This Matlab code follows the idea from the paper (in citaion) with some modifications, for training and using deep learning CNN (convolutional neural network) model to classify LC-MS features as true (high quality) and false (low quality).

## Use pretrained model for peak classification (use function "peaksEVA.m" or a GUI app "peakfilter.mlapp")
Example usage: type the following one-line code in matlab

    peaksEVA('example_pos.mzXML', 'example_peaks_pos.csv', [5,6], 'net64')

Required inputs:
1) input .mzXML file
2) input peaklist file generated from peakpicking (XCMS,mzMINE,ElMaven)
3) specify column numbers for m/z and rt in the peaklist file.
4) name of the pretrained model
Two pretrained models included in this repo:  "net64.mat" and "net48.mat". (difference: image compression to 64X64 or 48X48)

Output:
 1) A subfolder with a time stamp will be generated, containing a "true" and a "false" folder. 
 2) EICs of all the peaks will be plotted and classified into these two subfolders.
 3) A copy of the peaklist file will be created under the same folder, a new column "ispeak" will be added to the peaklist.

## Train your own model. (use script peaksCNN )
1) download the training set from link below
https://pubs.acs.org/doi/suppl/10.1021/acs.analchem.1c01309/suppl_file/ac1c01309_si_001.zip
2) Do some modifications (optional, see below) and run peaksCNN.m.
<br /> a) modify the training data set as desired, or add new images to the training data set, which could come from the classification results from your own data
<br /> b) change the architecture of the CNN models by adding/removing layers 
<br /> c) change the splits of training & validation sets
<br /> d) change the training options
3) save the CNNmodel 'net' from workspace 
    
    save('mymodel.mat', 'net')

## Citation 
Anal. Chem. 2021, 93, 36, 12181–12186 "EVA: Evaluation of Metabolic Feature Fidelity Using a Deep Learning Model Trained With Over 25000 Extracted Ion Chromatograms"
