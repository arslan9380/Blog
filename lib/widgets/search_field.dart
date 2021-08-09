import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final bool enable;
  final bool textAlignCenter;
  final int maxLines;
  final focusNode;
  final bool showDropDown;
  final Function onChange;

  InputField(
      {this.focusNode,
      this.hint,
      this.icon,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscure = false,
      this.enable = true,
      this.textAlignCenter = false,
      this.maxLines,
      this.showDropDown = false,
      this.onChange});

  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<InputField> {
  bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.065,
      child: TextField(
        focusNode: widget.focusNode ?? null,
        maxLines: widget.maxLines == null ? 1 : widget.maxLines,
        enabled: widget.enable,
        controller: widget.controller,
        textAlign:
            widget.textAlignCenter == true ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
        onChanged: widget.onChange,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscure ? obscure : widget.obscure,
        textAlignVertical: TextAlignVertical.bottom,
        // expands: true,
        decoration: InputDecoration(
            // isCollapsed: true,
            // isDense: true,
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            filled: false,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 1.0, color: Colors.deepOrange[400]),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 1.0, color: Colors.deepOrange[400]),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 1.0, color: Colors.deepOrange[400]),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 1.0, color: Colors.deepOrange[400]),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 1.0, color: Colors.deepOrange[400]),
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.width * 0.5,
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            prefixIcon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            widget.icon,
                            color: IconTheme.of(context).color,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            // suffixIconConstraints: BoxConstraints(
            //   maxHeight: MediaQuery.of(context).size.width * 0.09,
            //   maxWidth: MediaQuery.of(context).size.width * 0.09,
            // ),
            suffixIcon: !widget.obscure && widget.showDropDown == false
                ? null
                : widget.showDropDown == true
                    ? Icon(
                        Icons.arrow_drop_down,
                        color: IconTheme.of(context).color,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        child: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                          color: IconTheme.of(context).color,
                        ),
                      )),
      ),
    );
  }
}
