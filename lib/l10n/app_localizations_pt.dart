// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Kids Care';

  @override
  String get back => 'Voltar';

  @override
  String get home => 'Início';

  @override
  String get tasks => 'Tarefas';

  @override
  String get map => 'Mapa';

  @override
  String get settings => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get add => 'Adicionar';

  @override
  String get ok => 'OK';

  @override
  String get later => 'Depois';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Cadastrar';

  @override
  String get password => 'Senha';

  @override
  String get email => 'E-mail';

  @override
  String get haveAccount => 'Já tem uma conta? ';

  @override
  String get noAccount => 'Ainda não tem conta? ';

  @override
  String get unknown => 'Desconhecido';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String errorGeneric(String message) {
    return 'Algo deu errado: $message';
  }

  @override
  String unknownError(String message) {
    return 'Erro desconhecido: $message';
  }

  @override
  String get fillAllFields => 'Preencha todos os campos';

  @override
  String get signUpFailed => 'Falha no cadastro';

  @override
  String signUpFailedWithMessage(String message) {
    return 'Falha no cadastro: $message';
  }

  @override
  String get notFoundTitle => 'Ops, nos perdemos!';

  @override
  String get notFoundMessage => 'Esta página não existe.';

  @override
  String get goHome => 'Voltar ao início';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do dispositivo';

  @override
  String get chooseLanguage => 'Escolher idioma';

  @override
  String get welcomeTagline =>
      'Protegendo seu filho a qualquer hora, em qualquer lugar';

  @override
  String get guestModeWarning =>
      'Modo de teste, sem cadastro. Os dados ficam só neste aparelho — anote seu código de vínculo e atualize a conta para não perdê-los.';

  @override
  String get tryAsParent => 'Experimentar como responsável';

  @override
  String get tryAsChild => 'Experimentar como criança';

  @override
  String get loginTagline => 'Crianças seguras, pais tranquilos';

  @override
  String get helloWave => 'Olá! 👋';

  @override
  String get loginSubtitle =>
      'Entre com e-mail (responsável) ou nome de usuário (criança)';

  @override
  String get loginIdentifierHint => 'E-mail (responsável) ou usuário (criança)';

  @override
  String get forgotPasswordTitle => 'Esqueceu a senha?';

  @override
  String get loginNotFound => 'Conta não encontrada';

  @override
  String get loginWrongPassword => 'Senha incorreta';

  @override
  String get loginInvalidCredential => 'E-mail/usuário ou senha incorretos';

  @override
  String loginFailed(String message) {
    return 'Falha ao entrar: $message';
  }

  @override
  String googleLoginFailed(String message) {
    return 'Falha ao entrar com o Google: $message';
  }

  @override
  String get forgotPasswordSubtitle =>
      'Não se preocupe, digite seu e-mail para receber um código de recuperação! 🔑';

  @override
  String get yourEmail => 'Seu e-mail';

  @override
  String get sendRecoveryCode => 'Enviar código';

  @override
  String get strengthWeak => 'Fraca';

  @override
  String get strengthMedium => 'Média';

  @override
  String get strengthGood => 'Boa';

  @override
  String get strengthStrong => 'Forte';

  @override
  String get passwordMismatch => 'As senhas não coincidem';

  @override
  String get setNewPassword => 'Definir nova senha';

  @override
  String get newPasswordHint => 'A nova senha deve ser diferente da anterior';

  @override
  String get newPassword => 'Nova senha';

  @override
  String passwordStrength(String level) {
    return 'Força: $level';
  }

  @override
  String get confirmNewPassword => 'Confirmar nova senha';

  @override
  String get ruleMin8 => 'Pelo menos 8 caracteres';

  @override
  String get ruleUppercase => 'Contém letra maiúscula';

  @override
  String get ruleNumber => 'Contém um número';

  @override
  String get resetPassword => 'Redefinir senha';

  @override
  String get resetSuccessTitle => 'Senha redefinida!';

  @override
  String get resetSuccessMessage =>
      'Sua senha foi alterada. Entre para continuar com o Kids Care!';

  @override
  String get loginNow => 'Entrar agora';

  @override
  String get emailTaken => 'Este e-mail já está em uso';

  @override
  String get createNewAccount => 'Criar nova conta';

  @override
  String get registerSubtitle => 'Comece a jornada de cuidar do seu pequeno 🌟';

  @override
  String get parentFullName => 'Nome completo do responsável';

  @override
  String get passwordConfirmMismatch => 'As senhas não coincidem';

  @override
  String get usernameTaken => 'Este nome de usuário já está em uso';

  @override
  String get createChildAccount => 'Criar conta da criança';

  @override
  String get createChildSubtitle => 'Comece a jornada com seu pequeno';

  @override
  String get usernameLabelCaps => 'NOME DE USUÁRIO';

  @override
  String get childUsernameHint => 'nome ou apelido da criança';

  @override
  String get passwordLabelCaps => 'SENHA';

  @override
  String get confirmPasswordLabelCaps => 'CONFIRMAR SENHA';

  @override
  String get startNow => 'COMEÇAR AGORA →';

  @override
  String get callDad => 'Papai';

  @override
  String get connecting => 'Conectando...';

  @override
  String get micOn => 'Ativar mic';

  @override
  String get micOff => 'Desativar mic';

  @override
  String get speaker => 'Viva-voz';

  @override
  String get video => 'Vídeo';

  @override
  String get endCall => 'Encerrar chamada';

  @override
  String toldParents(String status) {
    return 'Avisei a mamãe e o papai: $status';
  }

  @override
  String get zoneSchool => 'Escola';

  @override
  String get zonePlayground => 'Parquinho';

  @override
  String get zoneHome => 'Casa';

  @override
  String get howAreYouToday => 'Como está o seu dia?';

  @override
  String get pickButtonToTell =>
      'Toque num botão para avisar a mamãe e o papai!';

  @override
  String get statusGoSchool => 'Indo pra escola';

  @override
  String get statusGoPlay => 'Indo brincar';

  @override
  String get statusArrived => 'Cheguei';

  @override
  String get statusBackHome => 'Voltei pra casa';

  @override
  String get callParents => 'LIGAR PARA OS PAIS';

  @override
  String get callParentsHint =>
      'Aperte o botão verde se precisar de ajuda agora!';

  @override
  String get helloCaps => 'OLÁ';

  @override
  String childGreeting(String name) {
    return 'Oi, $name! 👋';
  }

  @override
  String get statusLabelSchool => 'Na escola';

  @override
  String get statusLabelPlaying => 'Brincando';

  @override
  String get statusLabelHome => 'Em casa';

  @override
  String get statusLabelArrived => 'Chegou';

  @override
  String get statusLabelLeft => 'Saiu';

  @override
  String get linkCodeFormatError =>
      'Digite o código de 6 caracteres (ex.: ABC-123)';

  @override
  String get notSignedIn => 'Você não está conectado';

  @override
  String get linkSuccessTitle => 'Vinculado com sucesso!';

  @override
  String get linkSuccessMessage =>
      'As contas foram vinculadas. Começar a usar agora?';

  @override
  String get linkAccountTitle => 'Vincular contas';

  @override
  String get enterLinkCode => 'Digite o código de vínculo';

  @override
  String get enterLinkCodeDescription =>
      'Digite o código de 6 caracteres do responsável ou da criança para vincular as duas contas.';

  @override
  String get linkCodeHint => 'ex.: ABC-123';

  @override
  String get linkCode => 'Código de vínculo';

  @override
  String get linkAction => 'Vincular';

  @override
  String get errLinkOtherParent =>
      'Este código pertence a outra conta de responsável e não pode ser vinculado';

  @override
  String get errLinkNotParent =>
      'Este código não pertence a uma conta de responsável';

  @override
  String get errOwnAccountNotFound => 'Sua conta não foi encontrada';

  @override
  String get errLinkCodeNotFound => 'Código de vínculo não encontrado';

  @override
  String get errOwnCode => 'Este é o seu próprio código';

  @override
  String get errMaxZones => 'No máximo 3 zonas seguras';

  @override
  String get helloParents => 'Olá, pais! 👋';

  @override
  String get whatToDoToday => 'O que você quer fazer hoje?';

  @override
  String get menuNotificationsTitle => 'Avisos do seu filho';

  @override
  String get menuNotificationsDesc =>
      'Onde seu filho está, últimos avisos, chamada de emergência';

  @override
  String get menuMapTitle => 'Mapa e zonas seguras';

  @override
  String get menuMapDesc =>
      'Marque a escola, a casa e os lugares onde seu filho brinca';

  @override
  String get menuTasksTitle => 'Tarefas do seu filho';

  @override
  String get menuTasksDesc => 'Atribua tarefas diárias e veja o que foi feito';

  @override
  String get addSafeZone => 'Adicionar zona segura';

  @override
  String get zoneNameHint => 'Nome da zona (ex.: Escola)';

  @override
  String get zoneLimitReached => 'Limite de 3 zonas atingido';

  @override
  String get childMapTitle => 'Meu mapa';

  @override
  String get mapHintParent =>
      'Mantenha pressionado um ponto no mapa para adicionar uma zona segura.';

  @override
  String get mapHintChild =>
      'Estes são os lugares seguros que a mamãe e o papai escolheram pra você 💛';

  @override
  String get linkCodeLabel => 'Código de vínculo: ';

  @override
  String safeZonesCount(String count, String max) {
    return 'Zonas seguras ($count/$max)';
  }

  @override
  String get noSafeZones => 'Nenhuma zona segura configurada ainda.';

  @override
  String deleteZoneSemantic(String name) {
    return 'Excluir zona $name';
  }

  @override
  String get zoneLimitHint =>
      'Limite de 3 zonas atingido. Exclua uma para adicionar outra.';

  @override
  String get deleteZoneTitle => 'Excluir zona segura?';

  @override
  String deleteZoneMessage(String name) {
    return 'A zona \"$name\" será removida do mapa.';
  }

  @override
  String get recent => 'Recentes';

  @override
  String updatedAtToday(String time) {
    return 'Atualizado às $time hoje';
  }

  @override
  String childIsNear(String name) {
    return '$name está perto de';
  }

  @override
  String get statusSafe => '✅ Seguro';

  @override
  String get emergencyCallChild => 'Chamada de emergência para seu filho';

  @override
  String get voiceCallVia => 'Chamada de voz via ZegoCloud';

  @override
  String get noNotifications => 'Nenhuma notificação ainda';

  @override
  String get childNoStatusYet => 'Seu filho ainda não enviou atualizações';

  @override
  String get accountSecurity => 'Conta e segurança';

  @override
  String get logout => 'Sair';

  @override
  String get logoutSubtitle => 'Sair da conta atual';

  @override
  String get logoutConfirmTitle => 'Sair?';

  @override
  String get logoutGuestWarning =>
      'Esta é uma conta de teste. Se sair, os dados podem ser perdidos. Peça ajuda à mamãe ou ao papai primeiro!';

  @override
  String get logoutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get stay => 'Ficar';

  @override
  String get upgradeAccount => 'Atualizar conta';

  @override
  String get upgradeAccountSubtitle =>
      'Vincule ao Google para não perder seus dados';

  @override
  String get accountUpgraded => 'Conta atualizada!';

  @override
  String get googleAccountInUse =>
      'Esta conta do Google já é usada por outra conta';

  @override
  String get yourLinkCode => 'Seu código de vínculo';

  @override
  String get copy => 'Copiar';

  @override
  String get linkCodeCopied => 'Código copiado';

  @override
  String get linkedAddMore => 'Vinculado — digite um código para vincular mais';

  @override
  String get enterChildCode => 'Digite o código da criança para vincular';

  @override
  String get enterParentCode => 'Digite o código dos pais para vincular';

  @override
  String pendingCount(String count) {
    return 'A fazer ($count)';
  }

  @override
  String doneCount(String count) {
    return 'Feitas ($count)';
  }

  @override
  String get childTasksLoadError =>
      'Ops, não deu pra carregar as tarefas 😢\nTente de novo daqui a pouco!';

  @override
  String get myTasksTitle => 'Minhas tarefas 🌟';

  @override
  String get tapTaskWhenDone => 'Toque na tarefa quando terminar!';

  @override
  String doneOfTotalToday(String done, String total) {
    return '$done/$total tarefas feitas hoje!';
  }

  @override
  String greatJobDone(String title) {
    return '🎉 Muito bem! Você terminou \"$title\"!';
  }

  @override
  String dueShort(String date) {
    return 'Até $date';
  }

  @override
  String doneAt(String time) {
    return 'Feita às $time';
  }

  @override
  String get noTasksYetChild => 'Nenhuma tarefa ainda!';

  @override
  String get parentWillAssign =>
      'A mamãe ou o papai vão te dar tarefas logo 😊';

  @override
  String parentTasksLoadError(String message) {
    return 'Não foi possível carregar as tarefas.\n$message';
  }

  @override
  String get parentTasksTitle => '📋 Tarefas do seu filho';

  @override
  String tasksCompleted(String done, String total) {
    return '$done/$total tarefas concluídas';
  }

  @override
  String get deleteTaskTitle => 'Excluir tarefa?';

  @override
  String deleteTaskMessage(String title) {
    return 'Excluir \"$title\"?';
  }

  @override
  String get taskDone => 'Feita';

  @override
  String get taskPending => 'Pendente';

  @override
  String get addTask => 'Adicionar tarefa';

  @override
  String get addNewTask => '✨ Nova tarefa';

  @override
  String get chooseIcon => 'Escolha um ícone';

  @override
  String get taskNameHint => 'Nome da tarefa (ex.: Fazer a lição)';

  @override
  String get taskDescriptionHint => 'Descrição (opcional)';

  @override
  String dueDateLabel(String date) {
    return 'Prazo: $date';
  }

  @override
  String get pickDueDate => 'Escolher prazo (opcional)';

  @override
  String get assignTask => 'Atribuir tarefa 🚀';

  @override
  String get noTasksYetParent => 'Nenhuma tarefa ainda';

  @override
  String get tapPlusToAssign => 'Toque em + para dar uma tarefa ao seu filho!';

  @override
  String get geofenceChannelName => 'Alertas de zona segura';

  @override
  String get geofenceChannelDesc =>
      'Alertas quando seu filho entra ou sai de uma zona segura';

  @override
  String geofenceLeft(String name, String zone) {
    return '$name acabou de sair de $zone';
  }

  @override
  String geofenceEntered(String name, String zone) {
    return '$name chegou em $zone';
  }
}
