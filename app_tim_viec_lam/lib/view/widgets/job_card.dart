
import 'package:app_tim_viec_lam/data/model/job_model.dart';
import 'package:app_tim_viec_lam/view/Job/job_detail_view.dart';
import 'package:flutter/material.dart';
import 'bookmark_icon.dart';

class JobCard extends StatelessWidget {
  const JobCard({ super.key , required this.model});
  final Job model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailView(jobId: model.id,)));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(10, 10, 35, 0),
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(
                minHeight: 150
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),),
                border: Border.all(
                  color: Color.fromARGB(255, 250, 250, 250),
                  width: 2,),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CardTitle(
                      title: model.title, 
                      size: Size.big),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12,),
                      child: Row(
                        children: [
                          Logo(logoUrl: model.logoUrl,),
                          Expanded(
                             child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 CardTitle(
                                   title: model.enterpriseName,
                                   size: Size.small,
                                   ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0,4,0,0),
                                  child: Wrap(
                                    children: [
                                      CustomTag(label: model.salary),
                                      CustomTag(label: model.workingType),
                                      CustomTag(label: model.area),
                                      CustomTag(label: model.getDate),
                                    ],
                                  ),
                                ),
                              ],),
                           )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
            child: BookMarkIcon(jobId: model.id,))]
      )
    );
  }
}

class CustomTag extends StatelessWidget {
  const CustomTag({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context){
    return Padding(
            padding: const EdgeInsets.fromLTRB(0,0,8,4),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5,1,5,1),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(2.0),),
                border: Border.all(width: 0,)),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 7.5,),
                ),
            ),
          );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key, required this.logoUrl});
  final String logoUrl;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Container(
        padding: EdgeInsets.all(2.5),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: Image(
          image:  (logoUrl == '') ?
            AssetImage('assets/images/enterprise_logo.png') :
            NetworkImage(logoUrl) as ImageProvider,
          fit: BoxFit.cover, 
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Image(
              image: AssetImage('assets/images/enterprise_logo.png'),
              fit: BoxFit.cover,
            );
          },
        )
      ), 
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({super.key, required this.title, required this.size});
  final String title;
  final Size size;

  @override
  Widget build(BuildContext context){
    return Text(
            textAlign: TextAlign.left,
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                  fontSize: size.font,
                  fontWeight: FontWeight.bold,
                ),
            );
  }
}

enum Size {
  big(8.5),
  small(8);

  final double font;

  const Size(this.font);
}