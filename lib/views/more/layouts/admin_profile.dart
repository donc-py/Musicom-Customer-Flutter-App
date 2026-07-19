import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/auth_controller/password_change_controller.dart';
import 'package:readypos_flutter/controllers/auth_controller/profile_update_controller.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/more/components/moreAppBar.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.isTabletLandsCape
              ? 125.h
              : 120.h - MediaQuery.of(context).padding.top,
        ),
        child: MoreAppBar(
          title: S.of(context).adminProfile,
          isTrailing: false,
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _PersonalInfo(),
            _Password(),
          ],
        ),
      ),
    );
  }
}

class _Password extends ConsumerStatefulWidget {
  const _Password();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PasswordState();
}

class __PasswordState extends ConsumerState<_Password> {
  final _passowordFormKey = GlobalKey<FormBuilderState>();
  bool isCurrentPassVisible = false;
  bool isNewPassVisible = false;
  bool isConfirmPassVisible = false;

  Row textFieldHeader({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Icon(
            Icons.star,
            color: Colors.red,
            size: 8.w,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : AppColor.whiteColor,
      child: FormBuilder(
        key: _passowordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).password.toUpperCase(),
              style: AppTextStyle.title.copyWith(
                letterSpacing: 3.0,
                fontSize: 14.sp,
              ),
            ),
            Gap(24.h),
            textFieldHeader(text: 'Password Attuale'),
            Gap(8.h),
            FormBuilderTextField(
              name: "current_password",
              obscureText: !isCurrentPassVisible,
              style: isLargeScreen
                  ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                  : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "Inserisci la password attuale",
                hintStyle: isLargeScreen
                    ? AppTextStyle.normalBody.copyWith(
                        fontSize: 12.sp,
                        color: AppColor.borderColor,
                      )
                    : AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.borderColor,
                      ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isCurrentPassVisible = !isCurrentPassVisible;
                    });
                  },
                  icon: Icon(
                    isCurrentPassVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "La password attuale è obbligatoria"),
              ]),
            ),
            Gap(24.h),
            textFieldHeader(text: 'Nuova Password'),
            Gap(8.h),
            FormBuilderTextField(
              name: "password",
              obscureText: !isNewPassVisible,
              style: isLargeScreen
                  ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                  : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "Inserisci la nuova password",
                hintStyle: isLargeScreen
                    ? AppTextStyle.normalBody.copyWith(
                        fontSize: 12.sp,
                        color: AppColor.borderColor,
                      )
                    : AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.borderColor,
                      ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isNewPassVisible = !isNewPassVisible;
                    });
                  },
                  icon: Icon(
                    isNewPassVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "La nuova password è obbligatoria"),
              ]),
            ),
            Gap(24.h),
            textFieldHeader(text: 'Conferma Password'),
            Gap(8.h),
            FormBuilderTextField(
              name: "password_confirmation",
              obscureText: !isConfirmPassVisible,
              style: isLargeScreen
                  ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                  : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "Conferma la nuova password",
                hintStyle: isLargeScreen
                    ? AppTextStyle.normalBody.copyWith(
                        fontSize: 12.sp,
                        color: AppColor.borderColor,
                      )
                    : AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.borderColor,
                      ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isConfirmPassVisible = !isConfirmPassVisible;
                    });
                  },
                  icon: Icon(
                    isConfirmPassVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "La conferma password è obbligatoria"),
                (val) {
                  if (val !=
                      _passowordFormKey.currentState!.value['password']) {
                    return 'Le password non coincidono';
                  }
                  return null;
                },
              ]),
            ),
            Gap(24.h),
            Consumer(builder: (context, ref, _) {
              final isLoading = ref.watch(passwordChangeControllerProvider);
              return SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () {
                          if (_passowordFormKey.currentState!
                              .saveAndValidate()) {
                            final formData = {
                              ..._passowordFormKey.currentState!.value
                            };
                            ref
                                .read(
                                    passwordChangeControllerProvider.notifier)
                                .passwordChange(formData)
                                .then((value) {
                              if (value) {
                                _passowordFormKey.currentState!.reset();
                                GlobalFunction.showCustomSnackbar(
                                    message:
                                        "Password modificata con successo",
                                    isSuccess: true);
                              }
                            });
                          }
                        },
                        text: 'Aggiornamento',
                      ),
              );
            }),
            Gap(15.h),
          ],
        ),
      ),
    );
  }
}

class _PersonalInfo extends StatefulWidget {
  const _PersonalInfo();

  @override
  State<_PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<_PersonalInfo> {
  final _personalFormKey = GlobalKey<FormBuilderState>();
  XFile? _image;

  pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row textFieldHeader({required String text, bool isRequired = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        isRequired
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.w,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppConstants.authBox).listenable(),
      builder: (context, authBox, _) {
        return Container(
          margin: EdgeInsets.only(top: 12.h),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          color: AdaptiveTheme.of(context).mode.isDark
              ? AppColor.darkBackgroundColor
              : AppColor.whiteColor,
          child: FormBuilder(
            key: _personalFormKey,
            initialValue: {
              "name": authBox.get(AppConstants.userData)['name'],
              "email": authBox.get(AppConstants.userData)['email'],
              "phone": authBox.get(AppConstants.userData)['phone'],
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informazioni Personali',
                  style: AppTextStyle.title.copyWith(
                    letterSpacing: 3.0,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(24.h),
                textFieldHeader(text: 'Nome'),
                Gap(8.h),
                FormBuilderTextField(
                  name: "name",
                  style: isLargeScreen
                      ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                      : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Inserisci il nome",
                    hintStyle: isLargeScreen
                        ? AppTextStyle.normalBody.copyWith(
                            fontSize: 12.sp,
                            color: AppColor.borderColor,
                          )
                        : AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Il nome è obbligatorio"),
                  ]),
                ),
                Gap(24.h),
                textFieldHeader(text: 'E-mail'),
                Gap(8.h),
                FormBuilderTextField(
                  name: "email",
                  style: isLargeScreen
                      ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                      : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Inserisci l'email",
                    hintStyle: isLargeScreen
                        ? AppTextStyle.normalBody.copyWith(
                            fontSize: 12.sp,
                            color: AppColor.borderColor,
                          )
                        : AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "L'email è obbligatoria"),
                    FormBuilderValidators.email(
                        errorText: "Email non valida"),
                  ]),
                ),
                Gap(24.h),
                textFieldHeader(text: 'Telefono'),
                Gap(8.h),
                FormBuilderTextField(
                  name: "phone",
                  keyboardType: TextInputType.number,
                  style: isLargeScreen
                      ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                      : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Inserisci il numero di telefono",
                    hintStyle: isLargeScreen
                        ? AppTextStyle.normalBody.copyWith(
                            fontSize: 12.sp,
                            color: AppColor.borderColor,
                          )
                        : AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText:
                            "Il numero di telefono è obbligatorio"),
                    FormBuilderValidators.maxLength(12,
                        errorText: "Numero di telefono non valido"),
                    FormBuilderValidators.minLength(10,
                        errorText: "Numero di telefono non valido"),
                  ]),
                ),
                Gap(24.h),
                Gap(24.h),
                Consumer(builder: (context, ref, _) {
                  final isLoading =
                      ref.watch(profileUpdateControllerProvider);
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: () {
                              if (_personalFormKey.currentState!
                                  .saveAndValidate()) {
                                final formData = {
                                  ..._personalFormKey.currentState!.value
                                };
                                if (_image != null) {
                                  formData["image"] = _image!.path;
                                }
                                ref
                                    .read(profileUpdateControllerProvider
                                        .notifier)
                                    .profileUpdate(formData)
                                    .then((value) {
                                  if (value) {
                                    _personalFormKey.currentState!.reset();
                                    _image = null;
                                    GlobalFunction.showCustomSnackbar(
                                        message:
                                            "Profilo aggiornato con successo",
                                        isSuccess: true);
                                  }
                                });
                              }
                            },
                            text: 'Aggiornamento',
                          ),
                        );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}