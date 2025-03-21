part of 'project_bloc.dart';

sealed class ProjectState extends Equatable {
  final Project? currentProject;
  final List<Project>? projects;
  const ProjectState({this.currentProject, this.projects});

  @override
  List<Object?> get props => [currentProject];
}

final class ProjectInitial extends ProjectState {}

final class GetProjectsSuccess extends ProjectState {
  const GetProjectsSuccess(
      {required super.projects, required super.currentProject});
}

final class ProjectsLoading extends ProjectState {
  const ProjectsLoading(
      {required super.projects, required super.currentProject});
}

final class ProjectsChanged extends ProjectState {
  const ProjectsChanged(
      {required super.projects, required super.currentProject});
}

final class CurrentProjectChanged extends ProjectState {
  const CurrentProjectChanged(
      {required super.currentProject, required super.projects});
}

final class FaildToLoadProject extends ProjectState {
  const FaildToLoadProject(
      {required super.projects, required super.currentProject});
}
