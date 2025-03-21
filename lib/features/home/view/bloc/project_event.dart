part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class RequestProjectsEvent extends ProjectEvent {}

class RequestProjectEvent extends ProjectEvent {
  final String id;
  const RequestProjectEvent({required this.id});
}

class ChangeCurrentProjectEvent extends ProjectEvent {
  final String id;
  const ChangeCurrentProjectEvent({required this.id});
}

class ProjectsChangedEvent extends ProjectEvent {
  const ProjectsChangedEvent();
}
