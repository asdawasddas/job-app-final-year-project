import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.go,
              maxLines: 1,
              autofocus: true,
              controller: controller,
              decoration:  InputDecoration(
                labelStyle: TextStyle(color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: Align(
                  widthFactor: 0,
                  heightFactor: 1.0,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        controller.text ='';
                      });
                    },
                    icon: Icon(Icons.close,))),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))), 
                labelText: widget.label),
              onTapOutside: (event) => {
                FocusScope.of(context).unfocus()
              },
            ),
          ),
          IconButton(
            color: Colors.red,
            onPressed: (){}, 
            icon: Icon(Icons.search))]
      ),
    );
  }
}