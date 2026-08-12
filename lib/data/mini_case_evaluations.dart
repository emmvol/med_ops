import '../models/evaluation.dart';
import '../models/evaluation_question.dart';

final Map<String, Evaluation> miniCaseEvaluations = {

  // ============================================================
  // INTOXICACIÓN POR ALCOHOL
  // ============================================================

  "MINI_CASE_ALCOHOL": Evaluation(
    id: "MINI_CASE_ALCOHOL",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por alcohol",
    subtitle:
    "Valora al paciente y selecciona la conducta inicial.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseAlcoholComplete",

    questions: [

      EvaluationQuestion(
        question:
        "Paciente con ingesta importante de alcohol, somnolencia, "
            "lenguaje incoherente y vómito. ¿Cuál es la prioridad inicial?",
        options: [
          "Inducir el vómito",
          "Valorar y proteger la vía aérea",
          "Dar más alcohol para evitar abstinencia",
          "Dar de alta inmediatamente",
        ],
        correctIndex: 1,
        correctMessage:
        "La disminución del estado de conciencia aumenta el riesgo "
            "de compromiso de la vía aérea.",
        incorrectMessage:
        "La prioridad es valorar el estado de conciencia y proteger "
            "la vía aérea si está comprometida.",
        trustOnSuccess: 8,
        trustOnFail: 10,
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué complicación debe vigilarse especialmente en un paciente "
            "con intoxicación etílica grave?",
        options: [
          "Broncoaspiración",
          "Otitis media",
          "Dermatitis",
          "Conjuntivitis",
        ],
        correctIndex: 0,
        correctMessage:
        "La depresión del estado de conciencia favorece la broncoaspiración.",
        incorrectMessage:
        "El deterioro de la conciencia aumenta principalmente el riesgo "
            "de pérdida de reflejos protectores y broncoaspiración.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe formar parte de la valoración inicial?",
        options: [
          "Solo el nivel de alcohol",
          "Signos vitales, estado neurológico y glucemia",
          "Solo una radiografía",
          "Únicamente una prueba toxicológica",
        ],
        correctIndex: 1,
        correctMessage:
        "La valoración debe identificar alteraciones metabólicas y "
            "compromiso neurológico o hemodinámico.",
        incorrectMessage:
        "La concentración de alcohol no sustituye la valoración clínica.",
        moneyPenalty: 75,
      ),
    ],
  ),

  // ============================================================
  // INTOXICACIÓN POR COCAÍNA
  // ============================================================

  "MINI_CASE_COCAINE": Evaluation(
    id: "MINI_CASE_COCAINE",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por cocaína",
    subtitle:
    "Identifica las prioridades ante un síndrome simpaticomimético.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseCocaineComplete",

    questions: [

      EvaluationQuestion(
        question:
        "Paciente con consumo reciente de cocaína, agitación, "
            "diaforesis, midriasis, taquicardia e hipertensión. "
            "¿Qué síndrome debe sospecharse?",
        options: [
          "Síndrome simpaticomimético",
          "Síndrome anticolinérgico exclusivamente",
          "Síndrome opioide",
          "Síndrome serotoninérgico confirmado",
        ],
        correctIndex: 0,
        correctMessage:
        "La combinación de midriasis, diaforesis, taquicardia, "
            "hipertensión y agitación es compatible con un toxíndrome "
            "simpaticomimético.",
        incorrectMessage:
        "Los hallazgos corresponden principalmente a activación "
            "simpática excesiva.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es una prioridad ante este cuadro?",
        options: [
          "Reducir la estimulación y controlar la agitación",
          "Dejar al paciente sin vigilancia",
          "Inducir el vómito",
          "Administrar estimulantes",
        ],
        correctIndex: 0,
        correctMessage:
        "La reducción de estímulos, monitorización y control de la "
            "agitación son medidas iniciales importantes.",
        incorrectMessage:
        "El paciente requiere vigilancia y manejo de la hiperactividad "
            "simpática.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué complicación cardiovascular debe considerarse?",
        options: [
          "Síndrome coronario agudo",
          "Otitis externa",
          "Rinitis alérgica",
          "Insuficiencia venosa crónica",
        ],
        correctIndex: 0,
        correctMessage:
        "La cocaína puede producir vasoconstricción y complicaciones "
            "cardiovasculares, incluido síndrome coronario agudo.",
        incorrectMessage:
        "La toxicidad por cocaína puede producir complicaciones "
            "cardiovasculares graves.",
        moneyPenalty: 125,
      ),
    ],
  ),

  // ============================================================
  // INTOXICACIÓN POR MARIHUANA
  // ============================================================

  "MINI_CASE_CANNABIS": Evaluation(
    id: "MINI_CASE_CANNABIS",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por cannabis",
    subtitle:
    "Valora los efectos clínicos y determina la conducta inicial.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseCannabisComplete",

    questions: [

      EvaluationQuestion(
        question:
        "Paciente después de consumir cannabis presenta ansiedad, "
            "alteración de la percepción y taquicardia. ¿Cuál es la conducta inicial?",
        options: [
          "Ambiente tranquilo y vigilancia clínica",
          "Inducir el vómito",
          "Administrar estimulantes",
          "Realizar cirugía inmediata",
        ],
        correctIndex: 0,
        correctMessage:
        "En ausencia de complicaciones graves, el manejo suele ser "
            "principalmente de soporte y reducción de estímulos.",
        incorrectMessage:
        "La mayoría de los cuadros requieren medidas de soporte y vigilancia.",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe descartarse ante alteración importante del estado mental?",
        options: [
          "Otras intoxicaciones o causas médicas",
          "Únicamente hambre",
          "Solo deshidratación",
          "Ninguna causa adicional",
        ],
        correctIndex: 0,
        correctMessage:
        "La alteración del estado mental requiere valorar diagnósticos "
            "alternativos y posibles sustancias concomitantes.",
        incorrectMessage:
        "No debe atribuirse automáticamente todo cambio neurológico al cannabis.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué principio debe guiar el manejo?",
        options: [
          "Tratamiento sintomático y vigilancia",
          "Antibióticos en todos los casos",
          "Inducir el vómito",
          "Ignorar los signos vitales",
        ],
        correctIndex: 0,
        correctMessage:
        "El manejo es principalmente sintomático, con vigilancia de posibles complicaciones.",
        incorrectMessage:
        "El tratamiento debe adaptarse a la gravedad y manifestaciones clínicas.",
        moneyPenalty: 75,
      ),
    ],
  ),

  // ============================================================
  // INTOXICACIÓN POR ALUCINÓGENOS
  // ============================================================

  "MINI_CASE_HALLUCINOGENS": Evaluation(
    id: "MINI_CASE_HALLUCINOGENS",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por alucinógenos",
    subtitle:
    "Evalúa la alteración perceptiva y el riesgo conductual.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseHallucinogensComplete",

    questions: [

      EvaluationQuestion(
        question:
        "Paciente con alucinaciones visuales, ansiedad, midriasis y "
            "alteración de la percepción después de consumir una sustancia. "
            "¿Cuál es la prioridad?",
        options: [
          "Proporcionar un ambiente seguro y reducir estímulos",
          "Dejarlo solo",
          "Inducir el vómito",
          "Estimularlo físicamente",
        ],
        correctIndex: 0,
        correctMessage:
        "La seguridad del paciente y la reducción de estímulos son "
            "prioritarias ante una alteración perceptiva.",
        incorrectMessage:
        "Debe reducirse el riesgo de lesión y la estimulación ambiental.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe vigilarse durante la evolución?",
        options: [
          "Estado mental y signos vitales",
          "Únicamente la temperatura",
          "Solo la pupila",
          "Únicamente la glucosa",
        ],
        correctIndex: 0,
        correctMessage:
        "La evolución neurológica y hemodinámica permite detectar complicaciones.",
        incorrectMessage:
        "La vigilancia debe ser integral y continua.",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "Ante agitación intensa con riesgo para el paciente o terceros, "
            "¿qué principio debe seguirse?",
        options: [
          "Controlar el ambiente y tratar la agitación de forma adecuada",
          "Dejar que continúe sin vigilancia",
          "Provocarlo para que responda",
          "Permitir que abandone el hospital",
        ],
        correctIndex: 0,
        correctMessage:
        "La prioridad es mantener la seguridad y controlar la agitación.",
        incorrectMessage:
        "La agitación grave requiere intervención y vigilancia.",
        moneyPenalty: 125,
      ),
    ],
  ),

  // ============================================================
  // INTOXICACIÓN POR OPIOIDES
  // ============================================================

  "MINI_CASE_OPIOIDS": Evaluation(
    id: "MINI_CASE_OPIOIDS",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por opioides",
    subtitle:
    "Reconoce el toxíndrome y prioriza la intervención.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseOpioidsComplete",

    questions: [

      EvaluationQuestion(
        question:
        "Paciente inconsciente después de consumir una sustancia. "
            "Presenta miosis puntiforme y respiración lenta. "
            "¿Qué toxíndrome debe sospecharse?",
        options: [
          "Opioide",
          "Simpaticomimético",
          "Anticolinérgico",
          "Alucinógeno",
        ],
        correctIndex: 0,
        correctMessage:
        "La combinación de depresión de conciencia, miosis y depresión "
            "respiratoria es característica de intoxicación por opioides.",
        incorrectMessage:
        "La miosis y la depresión respiratoria orientan a un toxíndrome opioide.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es la prioridad inmediata?",
        options: [
          "Asegurar ventilación y vía aérea",
          "Esperar el resultado toxicológico",
          "Dar líquidos por vía oral",
          "Inducir el vómito",
        ],
        correctIndex: 0,
        correctMessage:
        "La depresión respiratoria constituye una amenaza vital inmediata.",
        incorrectMessage:
        "La prioridad es corregir el compromiso respiratorio.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Qué antídoto puede utilizarse ante intoxicación por opioides "
            "con depresión respiratoria?",
        options: [
          "Naloxona",
          "Atropina",
          "Flumazenil",
          "Adrenalina",
        ],
        correctIndex: 0,
        correctMessage:
        "La naloxona antagoniza los receptores opioides y puede revertir "
            "la depresión respiratoria.",
        incorrectMessage:
        "El antagonista utilizado en intoxicación por opioides es la naloxona.",
        moneyPenalty: 125,
      ),
    ],
  ),

  "EVAL_INTERROGATION": Evaluation(
    id: "EVAL_INTERROGATION",
    expediente: 4,
    title: "Interrogatorio del paciente índice",
    subtitle: "Selecciona hasta 3 preguntas (de 5) para interrogar al paciente despierto.",
    type: EvaluationType.integration,
    questions: [
      EvaluationQuestion(
        question: "¿Dónde estuviste la noche del evento?",
        options: ["Casa", "Rave", "Trabajo", "No recuerda"],
        correctIndex: 1,
        correctMessage: "El paciente recuerda haber estado en la rave.",
        incorrectMessage: "La respuesta no concuerda con evidencias.",
        trustOnSuccess: 4,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "¿Viste a alguien inyectarse o administrar sustancias?",
        options: ["Sí, alguien lo hizo", "No vi nada", "No recuerda", "No hubo inyección"],
        correctIndex: 0,
        correctMessage: "Identificación de posible administrador.",
        incorrectMessage: "No se obtuvo información útil.",
        trustOnSuccess: 4,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "¿Recuerdas haber discutido con alguien sobre una \"mezcla\"?",
        options: ["Sí", "No", "No recuerda", "Preferir no decir"],
        correctIndex: 0,
        correctMessage: "Sospecha de distribución coordinada.",
        incorrectMessage: "No aporta información útil.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "¿Dónde estuvo el grupo Omega la última vez que los viste?",
        options: ["En una puerta oculta", "En un auto", "En una casa", "No lo sé"],
        correctIndex: 0,
        correctMessage: "El paciente recuerda la puerta oculta.",
        incorrectMessage: "No localizamos la ubicación.",
        trustOnSuccess: 4,
        trustOnFail: 3,
      ),
      EvaluationQuestion(
        question: "¿Con quién mantuviste contacto esa noche?",
        options: ["Amigos locales", "Mi pareja", "Desconocidos", "No lo recuerdo"],
        correctIndex: 2,
        correctMessage: "Nombres y descripciones parciales.",
        incorrectMessage: "Respuesta no concluyente.",
        trustOnSuccess: 2,
        trustOnFail: 1,
      ),
    ],
    requiredCorrect: 2,
    maxQuestionsToAsk: 3,
    trustReward: 5,
    moneyReward: 0,
    unlockFlagOnPass: "omegaQuestionnaireUnlocked",
  ),

  // MINI_CASE_BENZOS
  "MINI_CASE_BENZOS": Evaluation(
    id: "MINI_CASE_BENZOS",
    expediente: 2,
    title: "Minicaso clínico • Benzodiacepinas",
    subtitle: "Evaluación sobre depresión del SNC y manejo del síndrome de abstinencia/intoxicación.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCaseBenzosComplete",

    questions: [
      EvaluationQuestion(
        question: "Paciente somnoliento con respiración lenta tras consumo de fármacos; ¿qué antídoto es específico para benzodiacepinas?",
        options: ["Flumazenil", "Naloxona", "Atropina", "Fisostigmina"],
        correctIndex: 0,
        correctMessage: "El flumazenil antagoniza receptores benzodiacepínicos en sobredosis selectas.",
        incorrectMessage: "Naloxona es para opioides; flumazenil para benzodiacepinas.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "¿Qué riesgo existe al administrar flumazenil en pacientes crónicos de benzodiacepinas?",
        options: ["Crisis convulsivas", "Hiperglucemia", "Arritmias crónicas", "Anemia aguda"],
        correctIndex: 0,
        correctMessage: "El flumazenil puede precipitar convulsiones en pacientes dependientes.",
        incorrectMessage: "Convulsiones son la complicación principal a vigilar.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "Manejo general de una intoxicación por benzodiacepinas grave:",
        options: ["Soporte ventilatorio y considerar flumazenil con precaución", "Dar glucosa oral", "Administrar antibióticos", "Aplicar diálisis de rutina"],
        correctIndex: 0,
        correctMessage: "Soporte de las funciones vitales es la base; flumazenil solo en casos seleccionados.",
        incorrectMessage: "El soporte ventilatorio y cuidados intensivos son primordiales.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
    ],
  ),

  // MINI_CASE_POLY
  "MINI_CASE_POLY": Evaluation(
    id: "MINI_CASE_POLY",
    expediente: 2,
    title: "Minicaso clínico • Intoxicación por polisustancias",
    subtitle: "Interpretación y manejo ante intoxicación por mezclas.",
    type: EvaluationType.miniCase,
    requiredCorrect: 3,
    retryOnFail: true,

    unlockFlagOnPass: "miniCasePolyComplete",

    questions: [
      EvaluationQuestion(
        question: "Ante un paciente con signos mixtos (miosis + taquicardia + agitación) ¿qué debes considerar?",
        options: ["Polisustancias y mezcla de toxíndromes", "Solo una monointoxicación", "Infección viral", "Hipotermia accidental"],
        correctIndex: 0,
        correctMessage: "La combinación de signos sugiere exposición a varias sustancias.",
        incorrectMessage: "Considera poliuso y mezcla de toxíndromes.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "¿Qué medida es prioritaria en polisustancias con compromiso respiratorio?",
        options: ["Asegurar vía aérea y soporte ventilatorio", "Esperar tox screen", "Administrar estimulantes", "Dar de alta"],
        correctIndex: 0,
        correctMessage: "Prioriza soporte ventilatorio y ABCs.",
        incorrectMessage: "El soporte vital no debe retrasarse por pruebas.",
        trustOnSuccess: 3,
        trustOnFail: 2,
      ),
      EvaluationQuestion(
        question: "La interpretación de pruebas toxicológicas en polisustancias:",
        options: ["Requiere correlación clínica", "Siempre determina causalidad", "Es irrelevante", "No se realiza nunca"],
        correctIndex: 0,
        correctMessage: "Las pruebas orientan pero deben integrarse a la clínica.",
        incorrectMessage: "No atribuir causalidad sin contexto clínico.",
        trustOnSuccess: 2,
        trustOnFail: 1,
      ),
    ],
  ),

  // ============================================================
// RESOLUCIÓN FINAL: OPERACIÓN OMEGA
// ============================================================
  "EVAL_OMEGA_FINAL": Evaluation(
    id: "EVAL_OMEGA_FINAL",
    expediente: 5,
    title: "Resolución Final: Operación Omega",
    subtitle: "La red Quimera ha sido acorralada. Basado en la evidencia del almacén, toma la decisión final.",
    type: EvaluationType.integration,
    requiredCorrect: 2,
    questions: [
      EvaluationQuestion(
        question: "Según la discrepancia en los planos y la bitácora del servidor ('tras el metal rojo'), ¿dónde se oculta el núcleo del Equipo Omega?",
        options: [
          "En el muelle de carga norte (Tras los contenedores)",
          "Han escapado por los túneles de ventilación",
          "Tras la puerta de mantenimiento reforzada en este almacén",
          "En una oficina corporativa en el centro de la ciudad"
        ],
        correctIndex: 2, // La puerta oculta
        correctMessage: "¡Correcto! La puerta de mantenimiento roja ocultaba el acceso al búnker.",
        incorrectMessage: "Error. Mientras registras la zona equivocada, los líderes de Quimera escapan por una salida oculta.",
      ),
      EvaluationQuestion(
        question: "El tiempo se agota. ¿Cómo procederá el equipo con la entrada al búnker?",
        options: [
          "Entrar de inmediato por nuestra cuenta (Riesgo alto)",
          "Asegurar el perímetro y esperar al equipo táctico SWAT (Seguro)",
        ],
        correctIndex: 1, // Specialists
        correctMessage: "El equipo SWAT realiza una entrada limpia y asegura a los objetivos.",
        incorrectMessage: "La entrada precipitada resulta en un tiroteo caótico y pérdida de evidencia.",
      ),
    ],
    // Estos flags son los que usará el Finalizer después
    unlockFlagOnPass: "omegaQuestionnaireCompleted",
  ),
};