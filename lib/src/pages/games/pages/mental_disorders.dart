import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/pages/games/components/custom_container.dart';

class MentalDisorders extends StatelessWidget {
  final User? user;
  const MentalDisorders({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return customContainer(Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Text("Information About Mental Diorders",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            )),
                      ])),
                  const SizedBox(height: 15),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Text("1. Autism Spectrum Disorder (ASD)",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        const Divider(),
                        const SizedBox(height: 15),
                        Text(
                            "        Autism Spectrum Disorder (ASD) is a developmental condition that affects communication, social interaction, and behavior. It is characterized by symptoms that can include difficulties with verbal and nonverbal communication, struggles with social interaction, and repetitive behaviors. ASD can have significant effects on the quality of life of both individuals with ASD and their families and caregivers. It can impact academic and career success, daily living activities, and mental health, among other aspects.\n\n"
                            "        Early diagnosis and intervention can improve outcomes and increase opportunities for success and independence for individuals with ASD. Access to resources and support is also essential in improving quality of life for individuals with ASD and their families. Families and caregivers may experience financial and emotional strain related to managing challenging behaviors and providing ongoing care, and it is important to provide them with the necessary resources and support to alleviate these challenges. With early"
                            " diagnosis, intervention, and access to resources, individuals with ASD can thrive and achieve their full potential.\n",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                      ])),
                  const SizedBox(height: 15),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Text("2. Dyslexia",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        const Divider(),
                        const SizedBox(height: 15),
                        Text(
                            "        Dyslexia is a learning disorder that affects language processing and reading ability. Those with dyslexia may find it challenging to recognize words, decode text, and comprehend written language. Consequently, their academic and career success can be affected, as well as their daily activities that require reading comprehension.\n\n"
                            "        The impact of dyslexia is not limited to the individual. It can also affect the quality of life of their families and caregivers. For instance, families and caregivers may face financial and emotional strain as they manage the condition and seek access to resources.\n\n"
                            "        However, early diagnosis and intervention can improve outcomes, offering more opportunities for success and independence to those with dyslexia. Access to resources and support is also crucial in enhancing the quality of life of individuals with dyslexia and their families. With early diagnosis, intervention, and support, people with dyslexia can achieve their full potential and lead successful lives.\n",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                      ])),
                  const SizedBox(height: 15),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Text("For more information on Mental Disorders",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        const Divider(),
                        const SizedBox(height: 15),
                        Text(
                            "Contact SAMSHA's National Helpline Number 1-800-662-4357\n"
                            "Or visit https://www.nimh.nih.gov/health/topics\n to learn more about health disorders.\n",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            )),
                      ])),
                ])))));
  }
}
