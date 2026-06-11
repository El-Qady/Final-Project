# 🧠 MOKHI

### AI-Based Brain Disease Diagnosis & Clinical Decision Support System

---

# Overview

MOKHI is an AI-powered healthcare platform designed to assist doctors and healthcare professionals in diagnosing neurological diseases from both MRI and CT medical images.

The system combines Deep Learning, Clinical Decision Support Systems (CDSS), Explainable AI (XAI), Knowledge Graphs, and a Flutter mobile application to provide fast, reliable, and intelligent diagnostic assistance.

The application enables users to upload medical images, receive AI-powered diagnoses, generate reports, store patient history, and obtain personalized clinical recommendations.

---

# Key Features

## MRI Diagnosis Module

* Brain MRI analysis using Deep Learning.
* MRI validation before diagnosis.
* Multi-class disease classification.
* Explainable AI (XAI) visualization.
* Confidence score generation.
* Automated report generation.
* Patient history management.

### Supported MRI Diseases

* Normal Brain
* Epilepsy
* Stroke
* Glioma Tumor
* Meningioma Tumor
* Pituitary Tumor
* Mild Alzheimer's Disease
* Moderate Alzheimer's Disease
* Very Mild Alzheimer's Disease

---

## CT Diagnosis Module

A newly integrated module focused on Clinical Decision Support.

Unlike MRI diagnosis, which focuses on Ensemble Learning and Explainable AI, the CT module focuses on combining image analysis with medical knowledge and patient symptoms.

### Supported CT Diseases

* Brain Hemorrhage
* Stroke
* Brain Tumor
* Normal Cases

### CT Workflow

1. CT Validation
2. Disease Classification
3. Knowledge Graph Verification
4. Symptom-Based Validation
5. Clinical Recommendation Generation
6. Report Generation

---

# Mobile Application Features

* Dynamic Splash Screen
* Login & Registration
* Home Screen
* Diagnosis Screen
* History Screen
* Find Doctor Screen
* About Us Screen
* Contact Us Screen
* Report Download
* Delete History Records
* Dark Mode
* Light Mode
* Smooth Animations

---

# System Architecture

The system consists of three major layers.

## 1. Mobile Application Layer

Responsible for:

* User Interaction
* Authentication
* Image Upload
* Diagnosis Display
* Report Viewing
* History Management

### Technologies

* Flutter
* Dart

---

## 2. AI Processing Layer

Responsible for:

* Image Validation
* Image Preprocessing
* Feature Extraction
* Disease Classification
* Explainability
* Confidence Calculation

### Technologies

* TensorFlow
* Keras
* Python
* FastAPI

---

## 3. Data Storage Layer

### Firebase

Used for:

* Authentication
* Firestore Database
* User Management

### Supabase

Used for:

* MRI Image Storage
* CT Image Storage
* Patient Media Management

---

# Mobile Development

## Architecture

The application follows the MVVM Architecture pattern.

### Advantages

* Separation of Concerns
* Scalability
* Maintainability
* Clean Code Structure

---

# State Management

## Cubit / Bloc

Used for:

* Authentication
* Diagnosis
* History
* API Communication

## Provider

Used for:

* Theme Management
* Dark Mode
* Light Mode

---

# MRI Deep Learning Pipeline

## Stage 1 — MRI Validation

The uploaded image is first validated using a ResNet50 model.

Purpose:

* Determine whether the image is an MRI image.
* Prevent invalid inputs from entering the classification pipeline.

### Results

* Accuracy: 99.75%
* Precision: 99.59%
* Recall: 99.81%
* ROC-AUC: 1.00

---

## Stage 2 — Disease Classification

The validated MRI image is classified into one of nine neurological categories.

### Models Evaluated

#### DenseNet121

* Accuracy: 96.36%

#### EfficientNetB5

* Accuracy: 97.10%

#### EfficientNetV2-S

* Accuracy: 97.61%

---

# Ensemble Learning

To improve classification performance, a Soft Voting Ensemble was implemented using:

* DenseNet121
* EfficientNetB5
* EfficientNetV2-S

### Ensemble Results

* Accuracy: 98.04%
* Precision: 98%
* Recall: 98%
* F1-Score: 98%

Benefits:

* Higher Robustness
* Reduced Variance
* Better Classification Performance

---

# Explainable AI (XAI)

The MRI module integrates Explainable AI techniques.

Purpose:

* Visualize the region responsible for the prediction.
* Improve transparency.
* Increase physician trust.

Techniques:

* Grad-CAM
* Saliency Maps

Outputs:

* Highlighted Disease Regions
* Visual Explanations

---

# CT Diagnosis Pipeline

The CT module introduces a different diagnostic strategy.

Instead of relying on Ensemble Learning, it combines Deep Learning with a Clinical Decision Support System.

---

## Stage 1 — CT Validation

Model:

* ResNet50

Task:

* CT vs Non-CT Classification

---

## Stage 2 — Disease Classification

Model:

* ResNet50

Classes:

* Hemorrhage
* Stroke
* Tumor
* Normal

---

# Knowledge Graph Integration

The CT diagnosis module integrates a Knowledge Graph.

Purpose:

* Validate AI predictions.
* Link diseases with symptoms.
* Improve diagnostic reliability.
* Generate personalized recommendations.

Examples:

## Stroke

Symptoms:

* Speech Difficulty
* Vision Problems
* Sudden Weakness

## Tumor

Symptoms:

* Persistent Headache
* Seizures
* Vision Changes

## Hemorrhage

Symptoms:

* Severe Headache
* Head Trauma
* Loss of Consciousness

---

# Adaptive Diagnosis System

Future enhancement designed to improve uncertain predictions.

### Confidence ≥ 90%

The system directly displays:

* Disease Prediction
* Confidence Score
* Recommendations

### Confidence < 90%

The system activates an intelligent questionnaire.

The patient's answers are combined with AI predictions to improve diagnostic accuracy before generating the final report.

Benefits:

* Higher Reliability
* Better Clinical Validation
* Reduced Misclassification

---

# Data Collection

## MRI Dataset

Collected from public medical datasets.

Total MRI Images:

* 39,100+

Classes:

* Alzheimer's Disease Stages
* Brain Tumors
* Stroke
* Epilepsy
* Normal

---

## CT Dataset

Collected from:

* Hospitals
* Radiology Centers

Characteristics:

* Real Clinical Cases
* Expert-Verified Labels
* Multiple Disease Categories

---

# Data Preprocessing

The following techniques were applied:

* Image Resizing
* Normalization
* Noise Reduction
* Data Augmentation
* Dataset Balancing

### Augmentation Techniques

* Rotation
* Flipping
* Zooming
* Brightness Adjustment
* Contrast Adjustment

---

# Dataset Split

* Training: 70%
* Validation: 15%
* Testing: 15%

---

# Backend API

The AI services are deployed using FastAPI.

Responsibilities:

* Image Upload
* Model Inference
* Prediction Response
* Confidence Score Generation
* Recommendation Generation

---

# Report Generation

The system automatically generates a medical report containing:

* Patient Information
* Disease Prediction
* Confidence Score
* Recommendations
* Diagnosis Date

Reports can be:

* Viewed
* Downloaded
* Printed

---

# CI/CD Pipeline

Automated deployment is implemented using:

* GitHub Actions
* Shorebird
* Firebase App Distribution

Capabilities:

* Continuous Integration
* Continuous Deployment
* OTA Updates
* Automated Releases

---

# Monitoring & Analytics

## Sentry Integration

Used for:

* Error Tracking
* Crash Reporting
* Performance Monitoring

Benefits:

* Faster Issue Detection
* Improved Stability
* Better User Experience

---

# Project Team

Ahmed Zakaria Hamed

Elsayed Mamdouh Elsayed

Yasmen Darwish Fenter

Esraa Eissawy Abdel Razek

Mariam Ramadan Abdel Sattar

Nourhan Karam Ibrahim

Mariam Ahmed Mubarak

Antonious Malak Telmez

Ehab Galal Abdo Moawad

---

# Supervisors

Dr. Nahla Ahmed Fathy

Dr. Randa Mohamed Ahmed

---

# University

Faculty of Computers & Artificial Intelligence

South Valley National University

Class of 2026

---
## 📥 Application Download


### APK Download



[Download APK](https://www.mediafire.com/file/o9a6pzhko5lheb6/MOKHI.apk/file)

---

# License

This project was developed as a Graduation Project at the Faculty of Computers & Artificial Intelligence, South Valley National University.
