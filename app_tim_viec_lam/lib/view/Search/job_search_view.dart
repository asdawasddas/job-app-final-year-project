// ignore_for_file: prefer_const_constructors

import 'package:app_tim_viec_lam/data/model/job_search_model.dart';
import 'package:app_tim_viec_lam/view/widgets/expand_btn.dart';
import 'package:app_tim_viec_lam/view/widgets/job_card.dart';
import 'package:app_tim_viec_lam/viewmodel/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constans.dart';
import '../../utils/enums.dart';
import '../../utils/validators.dart';
import '../widgets/button.dart';
import '../widgets/dropdown_btn.dart';
import '../widgets/text_field.dart';

List<String> Positions = List.from(['Tất cả'])..addAll(Constants.positions as Iterable<String>);
List<String> WorkingTypes = List.from(['Tất cả'])..addAll(Constants.workingTypes as Iterable<String>);

class JobSearchView extends StatefulWidget {
  const JobSearchView({super.key, this.seartchTxt = ''});
  final String seartchTxt;
  @override
  State<JobSearchView> createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<JobSearchView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController searchCtr = TextEditingController();
  TextEditingController salaryCtr = TextEditingController();
  TextEditingController experienceCtr = TextEditingController();
  List occupationsCtrl = [];
  List areasCtrl = [];
  String workingType = 'Tất cả';
  String position = 'Tất cả';
  String sort = 'Liên quan nhất';

  var positions = Positions.map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();


  var workingTypes = WorkingTypes.map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();

  var sorts = ['Liên quan nhất', 'Mới nhất'].map((value) => 
    DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();

  bool isInAreas(String area) {
    if (areasCtrl.contains(area)) {
      return true;
    } else {
      return false;
    }
  }

  bool isInOcupations(String occupation) {
    if (occupationsCtrl.contains(occupation)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    searchCtr.text = widget.seartchTxt;
    Provider.of<JobProvider>(context, listen: false).search(JobSearchModel.fromJson({'title': widget.seartchTxt}));
    super.initState();
  }

  @override
  void dispose() {
    searchCtr.dispose();
    // Provider.of<JobProvider>(context, listen: false).reset();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    var searchList = jobProvider.searchList;
    return Form(
      key: formKey,
      child: SafeArea(
        child: GestureDetector(
          // onTap: () {
          //    FocusScopeNode currentScope = FocusScope.of(context);
          //   if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   }
          // },
          child: Scaffold(
            endDrawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.84,
              child: Drawer(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Lọc tìm kiếm'),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ExpansionTile(
                            collapsedShape: Border.all(width: 1,color: Colors.grey),
                            shape: Border.all(
                              width: 1.5,
                              color: Colors.blue
                            ),
                            leading: Icon(Icons.location_city, color: Colors.green,),
                            title: Text(
                              'Khu vực làm việc',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10
                              ),),
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200
                                ),
                                constraints: const BoxConstraints(
                                  maxHeight: 400
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 7,
                                      children: Constants.areas.map((area) {
                                        bool check = isInAreas(area);
                                        return ActionChip(
                                          shape: StadiumBorder(side: check ? BorderSide(width: 1.5, color: Colors.green.shade400) : BorderSide(width: 1.5, color: Colors.grey.shade300)),
                                          label: SizedBox(
                                            width: 110,
                                            child: Text(area, style: TextStyle(fontSize: 6.5), )),
                                          onPressed: () {
                                            if (check) {
                                              areasCtrl.removeWhere((item) => item == area);
                                            } else {
                                              areasCtrl.add(area);
                                            }
                                            setState(() {});
                                          },
                                        );
                                      }
                                      ).toList()
                                      ,
                                    ),
                                  ),
                                ),
                              ),
                              CustomButton(label: 'Đặt lại', type: ButtonType.cancel, onPressFunction: () { setState(() {
                                areasCtrl = [];
                              }); },)
                            ],
                          ),
                        ),
                        ExpansionTile(
                          collapsedShape: Border.all(width: 1,color: Colors.grey),
                          shape: Border.all(
                            width: 1.5,
                            color: Colors.blue
                          ),
                          leading: Icon(Icons.location_city, color: Colors.green,),
                          title: Text(
                            'Ngành nghề (tối đa 5)',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10
                            ),
                          ),
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 350
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 7,
                                    children: Constants.occupations.map((occupation) {
                                      bool check = isInOcupations(occupation);
                                      return ActionChip(
                                        shape: StadiumBorder(side: check ? BorderSide(width: 1.5, color: Colors.green.shade400) : BorderSide(width: 1.5, color: Colors.grey.shade300)),
                                        label: Text(occupation, style: TextStyle(fontSize: 6.5),),
                                        onPressed: () {
                                          if (check) {
                                            occupationsCtrl.removeWhere((item) => item == occupation);
                                            setState(() {});
                                          } else {
                                            if (occupationsCtrl.length < 5) {
                                              occupationsCtrl.add(occupation);
                                              setState(() {});
                                            }
                                          }
                                        },
                                      );
                                    }
                                    ).toList()
                                    ,
                                  ),
                                ),
                              ),
                            ),
                            CustomButton(label: 'Đặt lại', type: ButtonType.cancel, onPressFunction: () { setState(() {
                              occupationsCtrl = [];
                            }); },)
                          ],
                        ),
                        CustomTextField(controller: salaryCtr, label: 'Lương mong muốn',validator: Validator.salaryValidator, icon: Icons.monetization_on, isNumKeyboard: true, hintText: 'Đơn vị: triệu đồng',),
                        
                        CustomDropdownBtn( label: 'Vị trí', value: position, values: positions, icon: Icons.person,
                          onChangeF: (value) {
                                setState(() {
                                  position = value.toString();
                                });
                          }, 
                        ),
                        CustomDropdownBtn( label: 'Hình thức làm việc', value: workingType, values: workingTypes, icon: Icons.punch_clock_rounded,
                          onChangeF: (value) {
                                setState(() {
                                  workingType = value.toString();
                                });
                              }, 
                        ),
                        CustomTextField(controller: experienceCtr, label: 'Kinh nghiệm',validator: Validator.expValidator, icon: Icons.hourglass_full_rounded, isNumKeyboard: true, hintText: 'Kinh nghiệm',),
                        CustomDropdownBtn( label: 'Sắp xếp', value: sort, values: sorts, icon: Icons.sort,
                          onChangeF: (value) {
                                setState(() {
                                  sort = value.toString();
                                });
                              }, 
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ExpandButton(
                                label: 'Đặt lại',
                                type: ButtonType.cancel,
                                onPressFunction: () {
                                  salaryCtr.text = '';
                                  experienceCtr.text = '';
                                  occupationsCtrl = [];
                                  areasCtrl = [];
                                  workingType = 'Tất cả';
                                  position = 'Tất cả';
                                  sort = 'Liên quan nhất';
                                  setState(() {});
                                },
                              )
                            ),
                            Expanded(
                              child: ExpandButton(
                                label: 'Áp dụng',
                                type: ButtonType.confirm,
                                onPressFunction: () {
                                  if (formKey.currentState!.validate()) {
                                    jobProvider.search(JobSearchModel.fromJson({
                                      'title' : searchCtr.text,
                                      'workingType' : workingType,
                                      'occupations' : occupationsCtrl,
                                      'areas' : areasCtrl,
                                      'position' : position,
                                      'experience' : experienceCtr.text,
                                      'salary' : salaryCtr.text,
                                      'sort' : sort
                                  }));
                                    Navigator.pop(context);
                                  }
                                },
                              )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
            appBar: null,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    leading: null,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.blue,
                    toolbarHeight: kToolbarHeight + 20,
                    pinned: true,
                    centerTitle: false,
                    floating: true,
                    actions: null,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20,)
                            ),
                            Expanded(
                              child: GestureDetector(
                                // onTap: () {
                                //   final FocusScopeNode currentScope = FocusScope.of(context);
                                //   if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                                //     FocusManager.instance.primaryFocus?.unfocus();
                                //   }
                                // },
                                child: TextField(
                                style: TextStyle(fontSize: 12),
                                maxLines: 1,
                                controller: searchCtr,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Tìm kiếm việc làm',
                                  hintStyle: TextStyle(
                                    fontSize: 12
                                  ),
                                  suffixIcon: TextButton(
                                    child: Text('Tìm', style: TextStyle(color: Colors.red.shade700),),
                                    onPressed: () {
                                      jobProvider.search(JobSearchModel.fromJson(
                                        {
                                          'title' : searchCtr.text,
                                          'workingType' : workingType,
                                          'occupations' : occupationsCtrl,
                                          'areas' : areasCtrl,
                                          'position' : position,
                                          'experience' : experienceCtr.text,
                                          'salary' : salaryCtr.text,
                                          'sort' : sort
                                        }
                                      ));
                                    },
                                  ),
                                  focusedBorder:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    // borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                  ),
                                ),
                                onSubmitted: (data) {
                                },
                                onTapOutside: (value) {
                                  // FocusScope.of(context).unfocus();
                                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                },
                                ),
                              ),
                            ),
                            VerticalDivider(color: Colors.blue,)
                          ]
                        ),
                    ],),
                  ),
              ],
              body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child: (searchList.isEmpty ) ? 
                  const EmptyList() :
                  ListView.builder(
                    itemCount: searchList.length + 1,
                    itemBuilder: (context, index) {
                      return (index != searchList.length) ? JobCard(model: searchList[index]) : const EndOfList();
                    }
                  ),
              ),
            ),
            )
          ),
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget{
  const EmptyList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('Không tìm thấy kết quả', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)));
  }
}

class EndOfList extends StatelessWidget{
  const EndOfList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Text('Đã đến cuối danh sách', textAlign: TextAlign.center , style: TextStyle(fontSize: 12)));
  }
}