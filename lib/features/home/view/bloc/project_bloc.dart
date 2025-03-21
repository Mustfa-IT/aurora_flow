import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_app/features/home/domain/entities/project.dart';
import 'package:task_app/features/home/domain/repository/project_repo.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository;
  ProjectBloc(
    this._projectRepository,
  ) : super(ProjectInitial()) {
    // Register the projects update
    registerProjcetsUpdate();
    on<ProjectEvent>((event, emit) {});
    on<RequestProjectsEvent>(onRequestProjects);
    on<ChangeCurrentProjectEvent>(onChangeCurrentProject);
    on<ProjectsChangedEvent>(onProjectsChanged);
  }

  Future<void> onRequestProjects(
    RequestProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectsLoading(projects: null, currentProject: state.currentProject));
    var projects = await _projectRepository.getProjects();
    if (projects == null) {
      emit(ProjectInitial());
    } else {
      emit(GetProjectsSuccess(
          projects: projects, currentProject: state.currentProject));
    }
  }

  Future<void> onChangeCurrentProject(
    ChangeCurrentProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    if (state.projects != null) {
      var searchInList = state.projects!.firstWhere((p) => p.id == event.id);
      // ignore: unnecessary_null_comparison
      if (searchInList != null) {
        emit(CurrentProjectChanged(
            currentProject: searchInList, projects: state.projects));
        return;
      }

      var project = await _projectRepository.getProject(event.id);
      if (project != null) {
        emit(CurrentProjectChanged(
            currentProject: project, projects: state.projects));
        return;
      }
      print("Faild To Load Project");
      emit(FaildToLoadProject(currentProject: null, projects: state.projects));
    }
  }

  Future<void> onProjectsChanged(
    ProjectsChangedEvent event,
    Emitter<ProjectState> emit,
  ) async {
    add(RequestProjectsEvent());
  }

  void registerProjcetsUpdate() async {
    await _projectRepository.onProjectsUpdates(
      () {
        print("Some changes happend");
        add(ProjectsChangedEvent());
      },
    );
  }
}
