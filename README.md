# Peer-graded Assignment: Getting and Cleaning Data Course Project

The presented data is a subset from the "Human Activity Recognition Using Smartphones Dataset
Version 1.0" Detailed information of the source dataset can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

From the description of the original dataset:
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

## Course Project Analysis
The target of this analysis is to subset the data on the mean and standard deviation of each experiment and to present the result in a "tidy formatted" way. Exec run_analysis.R does the following for you:

1. read all measurements (train & test data)
2. merge the two subsets
3. select all columns representing the mean or standard deviation of a measured value
4. enrich the data by adding two columns (1. observed subject, 2. performed activity)
5. replace the foreign key for the observed activity with the corresponding label
6. from 5. create a new dataset with averaged values for each measurement grouped by subject and activity
7. save the new dataset to "averaged_data.txt" in the current working directory


### Prerequisite
Following libraries are necessary to run the analysis:

* data.table
* dplyr