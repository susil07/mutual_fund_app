import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/scheme_model.dart';
import '../../data/scheme_list_repository.dart';

// Events
abstract class SchemeListEvent extends Equatable {
  const SchemeListEvent();
  @override
  List<Object?> get props => [];
}

class FetchSchemes extends SchemeListEvent {}

class SearchSchemes extends SchemeListEvent {
  final String query;
  const SearchSchemes(this.query);
  @override
  List<Object?> get props => [query];
}

class LoadMoreSchemes extends SchemeListEvent {}

// States
abstract class SchemeListState extends Equatable {
  const SchemeListState();
  @override
  List<Object?> get props => [];
}

class SchemeListInitial extends SchemeListState {}
class SchemeListLoading extends SchemeListState {}

class SchemeListLoaded extends SchemeListState {
  final List<SchemeModel> schemes;
  final bool hasReachedMax;
  final bool isPaginating;
  
  const SchemeListLoaded({
    required this.schemes,
    this.hasReachedMax = false,
    this.isPaginating = false,
  });

  SchemeListLoaded copyWith({
    List<SchemeModel>? schemes,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return SchemeListLoaded(
      schemes: schemes ?? this.schemes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [schemes, hasReachedMax, isPaginating];
}

class SchemeListError extends SchemeListState {
  final String message;
  const SchemeListError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SchemeListBloc extends Bloc<SchemeListEvent, SchemeListState> {
  final SchemeListRepository _repository;
  
  List<SchemeModel> _allSchemes = [];
  List<SchemeModel> _filteredSchemes = [];
  String _currentQuery = '';
  
  static const int _pageSize = 20;

  SchemeListBloc({required SchemeListRepository repository}) 
      : _repository = repository,
        super(SchemeListInitial()) {
    on<FetchSchemes>(_onFetchSchemes);
    on<SearchSchemes>(
      _onSearchSchemes,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<LoadMoreSchemes>(_onLoadMoreSchemes);
  }

  Future<void> _onFetchSchemes(FetchSchemes event, Emitter<SchemeListState> emit) async {
    emit(SchemeListLoading());
    try {
      _allSchemes = await _repository.fetchSchemes();
      _filteredSchemes = List.from(_allSchemes);
      
      final initialData = _filteredSchemes.take(_pageSize).toList();
      emit(SchemeListLoaded(
        schemes: initialData,
        hasReachedMax: _filteredSchemes.length <= _pageSize,
      ));
    } catch (e) {
      emit(SchemeListError(e.toString()));
    }
  }

  void _onSearchSchemes(SearchSchemes event, Emitter<SchemeListState> emit) {
    _currentQuery = event.query;
    
    if (_currentQuery.isEmpty) {
      _filteredSchemes = List.from(_allSchemes);
    } else {
      _filteredSchemes = _allSchemes
          .where((scheme) =>
              scheme.schemeName.toLowerCase().contains(_currentQuery.toLowerCase()))
          .toList();
    }
    
    final initialData = _filteredSchemes.take(_pageSize).toList();
    emit(SchemeListLoaded(
      schemes: initialData,
      hasReachedMax: _filteredSchemes.length <= _pageSize,
    ));
  }

  void _onLoadMoreSchemes(LoadMoreSchemes event, Emitter<SchemeListState> emit) {
    final currentState = state;
    if (currentState is SchemeListLoaded && !currentState.hasReachedMax && !currentState.isPaginating) {
      emit(currentState.copyWith(isPaginating: true));
      
      final currentLength = currentState.schemes.length;
      final nextData = _filteredSchemes.skip(currentLength).take(_pageSize).toList();
      
      final updatedSchemes = List<SchemeModel>.from(currentState.schemes)..addAll(nextData);
      
      emit(SchemeListLoaded(
        schemes: updatedSchemes,
        hasReachedMax: updatedSchemes.length >= _filteredSchemes.length,
        isPaginating: false,
      ));
    }
  }
}
