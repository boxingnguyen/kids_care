// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'FamHub';

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
      'Modo de teste, sem cadastro. Vincule um e-mail nas Configurações para não perder seus dados ao sair da conta ou trocar de aparelho.';

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
      'Sua senha foi alterada. Entre para continuar com o FamHub!';

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
  String get noNotifications => 'Nenhuma atualização ainda';

  @override
  String get childNoStatusYet =>
      'Status, compartilhamentos de localização e tarefas concluídas da criança aparecem aqui';

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

  @override
  String get searchPlaceHint => 'Buscar escola, casa, parque…';

  @override
  String get searchNoResults => 'Nenhum lugar encontrado';

  @override
  String get searchFailed => 'Falha na busca, tente novamente';

  @override
  String get locationPermissionDenied =>
      'Sem permissão de localização, o mapa não pode abrir na sua posição.';

  @override
  String get locationServiceDisabled =>
      'Os serviços de localização estão desligados.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get myLocation => 'Minha localização';

  @override
  String get linkChildToAssign =>
      'Nenhum filho vinculado ainda. Peça ao seu filho para inserir o código de vínculo para atribuir tarefas.';

  @override
  String get assignTo => 'Atribuir a';

  @override
  String get linkEmailTitle => 'Vincular e-mail';

  @override
  String get linkEmailSubtitle =>
      'Adicione um e-mail para manter seus dados e entrar de novo em outro celular ou após reinstalar.';

  @override
  String get linkEmailAction => 'Vincular e enviar e-mail de verificação';

  @override
  String get passwordTooShort => 'A senha precisa ter pelo menos 6 caracteres';

  @override
  String get invalidEmail => 'E-mail inválido';

  @override
  String get tooManyRequests =>
      'Muitas tentativas, tente novamente em alguns minutos.';

  @override
  String get verifyEmailTitle => 'Verifique seu e-mail';

  @override
  String verifyEmailMessage(String email) {
    return 'Enviamos um link de verificação para $email. Abra o e-mail, toque no link e volte ao app.';
  }

  @override
  String get verifyEmailCheck => 'Já verifiquei';

  @override
  String get verifyEmailResend => 'Reenviar e-mail';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get verifyEmailSent => 'E-mail de verificação reenviado';

  @override
  String get verifyEmailNotYet =>
      'Seu e-mail ainda não foi verificado. Toque no link do e-mail.';

  @override
  String get emailLinkedLoggedOut =>
      'E-mail vinculado. Da próxima vez, entre com este e-mail para recuperar seus dados.';

  @override
  String get logoutGuestLinkTitle => 'Seus dados serão perdidos';

  @override
  String get logoutGuestLinkMessage =>
      'Você está usando uma conta de convidado. Se sair, todos os dados e vínculos serão perdidos para sempre. Vincule um e-mail para mantê-los.';

  @override
  String get logoutAnyway => 'Sair mesmo assim';

  @override
  String get setNameTitle => 'Qual é o seu nome?';

  @override
  String get setNameParentHint => 'Ex.: Mãe Ana';

  @override
  String get setNameChildHint => 'Ex.: Bia';

  @override
  String get save => 'Salvar';

  @override
  String get regenerateLinkCode => 'Novo código';

  @override
  String get regenerateLinkCodeConfirm =>
      'O código antigo deixará de funcionar. Contas já vinculadas continuam vinculadas.';

  @override
  String get linkCodeRegenerated => 'Novo código de vínculo criado';

  @override
  String get confirmPasswordHint => 'Confirme a senha';

  @override
  String get sendLinkRequest => 'Enviar pedido de vínculo';

  @override
  String get linkRequestSent =>
      'Pedido enviado. Aguarde a outra pessoa aceitar!';

  @override
  String linkRequestFromParent(String name) {
    return '$name (responsável) quer se vincular a você';
  }

  @override
  String linkRequestFromChild(String name) {
    return '$name (filho) quer se vincular a você';
  }

  @override
  String get linkRequestHint =>
      'Aceite para sincronizar zonas seguras, tarefas e notificações.';

  @override
  String get accept => 'Aceitar';

  @override
  String get reject => 'Recusar';

  @override
  String linkRequestAccepted(String name) {
    return 'Vinculado a $name';
  }

  @override
  String get pendingRequestsTitle => 'Aguardando aceite';

  @override
  String pendingRequestCode(String code) {
    return 'Código $code';
  }

  @override
  String get cancelRequest => 'Cancelar pedido';

  @override
  String get linkedAccountsTitle => 'Contas vinculadas';

  @override
  String get unlink => 'Desvincular';

  @override
  String unlinkConfirmTitle(String name) {
    return 'Desvincular de $name?';
  }

  @override
  String get unlinkConfirmMessageParent =>
      'Seu filho não verá mais suas zonas seguras e tarefas, e você não receberá mais as notificações dele. É possível vincular de novo com um código.';

  @override
  String get unlinkConfirmMessageChild =>
      'Seus pais não serão mais avisados quando você chegar ou sair das zonas seguras. Pergunte a eles antes!';

  @override
  String get unlinked => 'Desvinculado';

  @override
  String get errRequestPending => 'Pedido já enviado, aguardando aceite';

  @override
  String get errAlreadyLinked => 'Essas contas já estão vinculadas';

  @override
  String get errRequestGone =>
      'Este pedido não é mais válido, ou a criança já tem 3 responsáveis vinculados.';

  @override
  String get errChildHasParent =>
      'Já vinculado a outro responsável. Desvincule primeiro.';

  @override
  String get zonesNeedChild =>
      'Vincule-se ao seu filho primeiro para criar as zonas seguras dele.';

  @override
  String get errMaxGuardians =>
      'Esta criança já tem 3 responsáveis vinculados. Desvincule um primeiro.';

  @override
  String eventShareStarted(String name) {
    return '$name está compartilhando a localização ao vivo';
  }

  @override
  String eventShareStopped(String name) {
    return '$name parou de compartilhar a localização';
  }

  @override
  String eventTodoCreated(String name, String title) {
    return '$name adicionou uma tarefa: $title';
  }

  @override
  String eventTodoDone(String name, String title) {
    return '$name concluiu: $title';
  }

  @override
  String get locationRequestTitle => 'Compartilhar localização';

  @override
  String locationRequestBody(String name) {
    return '$name quer ver onde você está';
  }

  @override
  String get locationRequestHint =>
      'Toque em \"Compartilhar localização ao vivo\" abaixo';

  @override
  String locationRequestSent(String name) {
    return 'Pedido enviado para $name compartilhar a localização';
  }

  @override
  String locationRequestPending(String time) {
    return 'Pedido às $time, aguardando resposta';
  }

  @override
  String get liveShareNotifTitle => 'Compartilhando localização';

  @override
  String get liveShareNotifText => 'Seus pais podem ver onde você está';

  @override
  String get noLocationYet =>
      'Ainda sem localização — peça para a criança compartilhar';

  @override
  String liveSharingRemaining(String minutes) {
    return 'Ao vivo · faltam $minutes min';
  }

  @override
  String lastSeenAt(String time) {
    return 'Última localização às $time';
  }

  @override
  String childLocationTitle(String name) {
    return '$name está aqui';
  }

  @override
  String askChildLocation(String name) {
    return 'Pedir localização a $name';
  }

  @override
  String get askAgain => 'Pedir de novo';

  @override
  String get liveBadge => 'AO VIVO';

  @override
  String get noChildLinkedTitle =>
      'Vincule-se à criança para ver a localização e receber avisos';

  @override
  String get linkWithChild => 'Vincular à criança';

  @override
  String get notLinkedYetHint =>
      'Ainda não vinculado aos pais — vincule em Configurações';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get locationServiceOff =>
      'A localização está desativada. Ative e tente de novo.';

  @override
  String get locationPermissionNeeded =>
      'É preciso permitir a localização para compartilhar com os pais.';

  @override
  String get locationPermissionSettings =>
      'A permissão de localização está desativada. Abra as Configurações para permitir.';

  @override
  String get locationNoFix =>
      'Não foi possível obter a localização. Tente de novo em um local aberto.';

  @override
  String minutesRemaining(String minutes) {
    return 'Faltam $minutes minutos';
  }

  @override
  String get liveShareHint => 'Seus pais verão onde você está por 60 minutos';

  @override
  String get startLiveShare => 'Compartilhar localização ao vivo';

  @override
  String get stopLiveShare => 'Parar de compartilhar';

  @override
  String get addTodo => 'Adicionar tarefa';

  @override
  String get addTodoTitle => 'O que você quer fazer? ✨';

  @override
  String get addTodoHint => 'ex.: Regar as plantas';

  @override
  String get childCanAddTodo =>
      'Toque em \"Adicionar tarefa\" para criar uma, ou espere seus pais 😊';

  @override
  String get assignTab => 'Atribuir';

  @override
  String get notesTab => 'Recados';

  @override
  String get notesTitle => 'Recados para os pais 💌';

  @override
  String get notesSubtitle => 'O que você quer que seus pais façam?';

  @override
  String notesWaiting(String count) {
    return '$count recados aguardando os pais';
  }

  @override
  String notesDoneCount(String count) {
    return 'Feito ($count)';
  }

  @override
  String get writeNote => 'Escrever recado';

  @override
  String get addNoteTitle => 'O que você quer dizer aos seus pais? 💌';

  @override
  String get addNoteHint => 'ex.: Comprar lápis de cor';

  @override
  String get sendNote => 'Enviar aos pais';

  @override
  String get deleteNoteTitle => 'Apagar recado?';

  @override
  String noteDoneBy(String name, String time) {
    return 'Feito por $name às $time';
  }

  @override
  String get noteWaiting => 'Aguardando os pais…';

  @override
  String get noNotesYet => 'Nenhum recado ainda';

  @override
  String get noNotesHint =>
      'Toque em \"Escrever recado\" para pedir algo aos pais 😊';

  @override
  String get parentNotesTitle => 'Pedidos do seu filho';

  @override
  String get parentNotesAllDone =>
      'Todos os recados da criança foram feitos 🎉';

  @override
  String parentNotesWaiting(String count) {
    return '$count pedidos da criança — toque para marcar como feito';
  }

  @override
  String get parentNotesEmpty => 'Nenhum recado da criança ainda';

  @override
  String get parentNotesEmptyHint =>
      'Quando a criança pedir algo, aparecerá aqui';

  @override
  String eventNoteCreated(String name, String title) {
    return '$name pede: $title';
  }

  @override
  String noteDoneNotif(String name, String title) {
    return '$name fez: $title';
  }

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountSubtitle =>
      'Remova sua conta e seus dados permanentemente';

  @override
  String get deleteAccountConfirmTitle => 'Excluir sua conta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Sua conta, localização, zonas seguras, tarefas, recados e vínculos serão excluídos permanentemente. Isso não pode ser desfeito.';

  @override
  String get deleteAccountAskParent => 'Pergunte antes à mamãe ou ao papai!';

  @override
  String get deleteAccountAction => 'Excluir permanentemente';

  @override
  String get deleteAccountFailed =>
      'Não foi possível excluir sua conta. Verifique a conexão e tente novamente.';

  @override
  String get accountDeleted => 'Sua conta foi excluída';

  @override
  String get locationDisclosureTitle => 'O FamHub usa sua localização';

  @override
  String get locationDisclosureBody =>
      'O FamHub coleta sua localização para avisar os pais vinculados quando você chega a uma zona segura ou sai dela, mesmo quando o app está fechado ou não está em uso.\n\nSua localização também é enviada quando você toca em um botão de status ou compartilha a localização em tempo real. Só os pais vinculados a você podem vê-la.';

  @override
  String get locationDisclosureContinue => 'Continuar';

  @override
  String get locationDisclosureNotNow => 'Agora não';

  @override
  String get checkInLocationHint =>
      'Ao tocar em um botão, sua localização também é enviada aos seus pais';
}
