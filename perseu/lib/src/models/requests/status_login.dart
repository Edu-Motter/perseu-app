enum StatusLogin {
  athleteWithTeam,
  athleteWithPendingTeam,
  athleteWithoutTeam,
  coachWithTeam,
  coachWithoutTeam,
  unknown
}

class StatusLoginString {
  static StatusLogin getStatusLogin(String statusString) {
    switch (statusString) {
      case 'atleta_com_time':
        return StatusLogin.athleteWithTeam;
      case 'atleta_com_time_pendente':
        return StatusLogin.athleteWithPendingTeam;
      case 'atleta_sem_time':
        return StatusLogin.athleteWithoutTeam;
      case 'treinador_com_equipe':
        return StatusLogin.coachWithTeam;
      case 'treinador_sem_equipe':
        return StatusLogin.coachWithoutTeam;
      default:
        return StatusLogin.unknown;
    }
  }
}

extension StatusLoginExtension on StatusLogin {

  String get toJson {
    switch (this) {
      case StatusLogin.athleteWithTeam:
        return 'atleta_com_time';
      case StatusLogin.athleteWithPendingTeam:
        return 'atleta_com_time_pendente';
      case StatusLogin.athleteWithoutTeam:
        return 'atleta_sem_time';
      case StatusLogin.coachWithTeam:
        return 'treinador_com_equipe';
      case StatusLogin.coachWithoutTeam:
        return 'treinador_sem_equipe';
      default:
        return 'desconhecido';
    }
  }

  StatusLogin getStatus(String statusString) {
    switch (statusString) {
      case 'atleta_com_time':
        return StatusLogin.athleteWithTeam;
      case 'atleta_com_time_pendente':
        return StatusLogin.athleteWithPendingTeam;
      case 'atleta_sem_time':
        return StatusLogin.athleteWithoutTeam;
      case 'treinador_com_equipe':
        return StatusLogin.coachWithTeam;
      case 'treinador_sem_equipe':
        return StatusLogin.coachWithoutTeam;
      default:
        return StatusLogin.unknown;
    }
  }
}
