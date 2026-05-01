import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core.dart';

abstract class BaseView<T extends BaseCubit<S>, S extends BaseState>
    extends StatelessWidget {
  final bool isSheetView;
  final List<Color>? backgroundColors;

  BaseView({super.key, this.isSheetView = false, this.backgroundColors});

  Widget body(BuildContext context, S state);

  final di = GetIt.instance;

  PreferredSizeWidget? appBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (context) => di<T>()..initState(),
      child: BlocConsumer<T, S>(
        listenWhen: (previous, current) {
          return previous.pageState != current.pageState;
        },
        listener: (context, state) {
          _handleStateChanges(context, state);
        },
        buildWhen: (previous, current) =>
            previous.pageState != current.pageState,
        builder: (context, state) {
          Widget mainContent = isSheetView
              ? body(context, state)
              : CustomScaffold(
                  // backgroundColor: Colors.transparent,
                  appBar: appBar(context),
                  body: body(context, state),
                );
          return Stack(
            children: [
              //background
              // BaseBackgroundWidget(backgroundColors: backgroundColors),
              //main content
              mainContent,
              // Loading overlay
              BlocSelector<T, S, bool>(
                selector: (state) => state.pageState == PageState.loading,
                builder: (context, screenLoading) {
                  return screenLoading
                      ? const Center(child: LoadingView())
                      : const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  static bool isSuccessDialogShown = false;

  onSuccessDialog(
    BuildContext context, {
    String? icon,
    String? title,
    void Function(BuildContext context)? onClickFunction,
  }) async {
    if (isSuccessDialogShown) return;
    isSuccessDialogShown = true;
    try {
      context.successDialog(message: title, icon: icon);
    } finally {
      isSuccessDialogShown = false;
    }
  }

  /// **Required** action for the [isSuccessDialogShown] state.
  /// This is the function for the main button.
  onErrorSnackBar(BuildContext context, {required String title}) {
    context.errorSnackBar(title: title);
  }

  /// Optional callback triggered when [PageState] changes to [success].
  void onSuccess(BuildContext context, S state) {}

  /// Optional callback triggered when [PageState] changes to [init].
  void onInitState(BuildContext context, S state) {}

  void _handleStateChanges(BuildContext context, S state) {
    switch (state.pageState) {
      case PageState.success:
        onSuccess(context, state);
        break;
      case PageState.successWithDialog:
        if (ModalRoute.of(context)?.isCurrent == true) {
          onSuccessDialog(
            context,
            title: state.successMessage,
            icon: state.successIcon,
          );
        }
        break;

      case PageState.errorWithSnackBar:
        if (ModalRoute.of(context)?.isCurrent == true) {
          onErrorSnackBar(context, title: state.failure?.message ?? '');
        }
        break;

      // No action needed for these states in the listener
      case PageState.init:
        onInitState(context, state);
        break;
      case PageState.loading:
      case PageState.failure:
      case PageState.shimmerLoading:
      case PageState.empty:
      case PageState.fetchComplete:
        break;
    }
  }
}
