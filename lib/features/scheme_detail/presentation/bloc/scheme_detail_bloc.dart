import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/scheme_detail_model.dart';
import '../../data/scheme_detail_repository.dart';

// Events
abstract class SchemeDetailEvent extends Equatable {
  const SchemeDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchSchemeDetail extends SchemeDetailEvent {
  final int schemeCode;
  const FetchSchemeDetail(this.schemeCode);
  @override
  List<Object?> get props => [schemeCode];
}

// States
abstract class SchemeDetailState extends Equatable {
  const SchemeDetailState();
  @override
  List<Object?> get props => [];
}

class SchemeDetailInitial extends SchemeDetailState {}
class SchemeDetailLoading extends SchemeDetailState {}
class SchemeDetailLoaded extends SchemeDetailState {
  final SchemeDetailModel detail;
  const SchemeDetailLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}
class SchemeDetailError extends SchemeDetailState {
  final String message;
  const SchemeDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SchemeDetailBloc extends Bloc<SchemeDetailEvent, SchemeDetailState> {
  final SchemeDetailRepository _repository;

  SchemeDetailBloc({required SchemeDetailRepository repository}) 
      : _repository = repository,
        super(SchemeDetailInitial()) {
    on<FetchSchemeDetail>(_onFetchSchemeDetail);
  }

  Future<void> _onFetchSchemeDetail(FetchSchemeDetail event, Emitter<SchemeDetailState> emit) async {
    emit(SchemeDetailLoading());
    try {
      final detail = await _repository.fetchSchemeDetails(event.schemeCode);
      emit(SchemeDetailLoaded(detail));
    } catch (e) {
      emit(SchemeDetailError(e.toString()));
    }
  }
}
