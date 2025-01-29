import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals_mvi_example/core/base_view_model.dart';

mixin ViewModelMixin<T extends StatefulWidget,
    V extends BaseViewModel<BaseState, BaseEvent, BaseEffect>> on State<T> {
  late final V viewModel;
  late final StreamSubscription<BaseEffect?> _effectSubscription;

  BaseState get state => viewModel.state.value;

  @protected
  V createViewModel();

  @protected
  void onEffect(covariant BaseEffect? effect);

  @override
  void initState() {
    super.initState();
    viewModel = createViewModel();
    _effectSubscription = viewModel.effects.listen(onEffect);
  }

  @override
  void dispose() {
    viewModel.dispose();
    _effectSubscription.cancel();
    super.dispose();
  }

  void addEvent(BaseEvent event) {
    viewModel.addEvent(event);
  }
}
