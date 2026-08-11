import '../models/evaluation.dart';
import '../models/evaluation_question.dart';

final Map<String, Evaluation> campaignEvaluations = {

  // ============================================================
  // INTEGRACIÓN 1 → POLICÍA
  // ============================================================

  "EVAL_EXP1_INTEGRATION": Evaluation(
    id: "EVAL_EXP1_INTEGRATION",
    expediente: 1,
    title: "Evaluación de integración I",
    subtitle:
    "Integra los hallazgos clínicos, toxicológicos y médico-legales "
        "del paciente índice.",
    type: EvaluationType.integration,

    requiredCorrect: 3,

    unlockFlagOnPass: "policeUnlocked",

    questions: [

      EvaluationQuestion(
        question:
        "¿Cuál es la prioridad inicial ante un paciente inconsciente "
            "con deterioro potencialmente tóxico?",
        options: [
          "Solicitar únicamente estudios toxicológicos",
          "Realizar valoración primaria ABC",
          "Interrogar a los familiares",
          "Buscar primero evidencia criminalística",
        ],
        correctIndex: 1,
        correctMessage:
        "La estabilización inicial mediante ABC tiene prioridad.",
        incorrectMessage:
        "La investigación no debe desplazar la estabilización inicial.",
        trustOnSuccess: 6,
        trustOnFail: 8,
        moneyPenalty: 50,
      ),

      EvaluationQuestion(
        question:
        "¿Qué hallazgo permite relacionar inicialmente al paciente "
            "con un evento colectivo?",
        options: [
          "La hipertensión aislada",
          "La pulsera fluorescente",
          "La taquicardia sinusal",
          "La hipertermia",
        ],
        correctIndex: 1,
        correctMessage:
        "La pulsera constituye un indicio que relaciona al paciente "
            "con el evento.",
        incorrectMessage:
        "Los signos clínicos establecen un cuadro, pero no identifican "
            "por sí mismos el evento.",
        evidenceOnSuccess: "Pulsera fluorescente",
        trustOnSuccess: 6,
        trustOnFail: 5,
        moneyPenalty: 50,
      ),

      EvaluationQuestion(
        question:
        "¿Qué utilidad tiene el tamiz toxicológico en este contexto?",
        options: [
          "Establecer por sí solo la causa de muerte",
          "Identificar sustancias potencialmente relacionadas con el cuadro",
          "Sustituir la valoración clínica",
          "Determinar automáticamente al responsable",
        ],
        correctIndex: 1,
        correctMessage:
        "El tamiz orienta la investigación y debe interpretarse "
            "junto con los hallazgos clínicos.",
        incorrectMessage:
        "Un tamiz toxicológico no determina por sí mismo causalidad "
            "ni responsabilidad.",
        trustOnSuccess: 7,
        trustOnFail: 8,
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "¿Qué hallazgo justifica ampliar la investigación a otros casos?",
        options: [
          "La presencia de un solo síntoma",
          "La coincidencia de intoxicaciones con manifestaciones relacionadas",
          "La ausencia de identificación",
          "El resultado del ECG aislado",
        ],
        correctIndex: 1,
        correctMessage:
        "La aparición de casos relacionados permite plantear una exposición común.",
        incorrectMessage:
        "Un hallazgo aislado no permite establecer un patrón epidemiológico.",
        trustOnSuccess: 7,
        trustOnFail: 6,
        moneyPenalty: 50,
      ),
    ],
  ),

  // ============================================================
  // INTEGRACIÓN 2 → CASA DEL RAVE
  // ============================================================

  "EVAL_EXP2_INTEGRATION": Evaluation(
    id: "EVAL_EXP2_INTEGRATION",
    expediente: 2,
    title: "Evaluación de integración II",
    subtitle:
    "Determina si la información reunida permite establecer "
        "un domicilio relacionado con el evento.",
    type: EvaluationType.integration,

    requiredCorrect: 3,

    unlockFlagOnPass: "raveHouseUnlocked",

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué elemento permite vincular directamente al paciente "
            "con una ubicación?",
        options: [
          "La glucosa",
          "La localización del teléfono",
          "El ECG",
          "La temperatura",
        ],
        correctIndex: 1,
        correctMessage:
        "La localización del teléfono aporta una referencia espacial.",
        incorrectMessage:
        "Los datos clínicos no permiten establecer por sí mismos "
            "la ubicación del evento.",
        evidenceOnSuccess: "Localización del teléfono",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "¿Por qué es importante comparar diferentes testimonios?",
        options: [
          "Para sustituir la evidencia física",
          "Para identificar coincidencias y contradicciones",
          "Para evitar documentar los hallazgos",
          "Para determinar automáticamente culpabilidad",
        ],
        correctIndex: 1,
        correctMessage:
        "La correlación de testimonios permite valorar la consistencia "
            "de la reconstrucción.",
        incorrectMessage:
        "Los testimonios deben analizarse junto con el resto de la evidencia.",
        moneyPenalty: 50,
      ),

      EvaluationQuestion(
        question:
        "¿Qué combinación fortalece la identificación del domicilio?",
        options: [
          "Un único testimonio",
          "Testimonio, teléfono y declaración del organizador",
          "Únicamente los síntomas",
          "Únicamente el resultado toxicológico",
        ],
        correctIndex: 1,
        correctMessage:
        "La convergencia de distintas fuentes fortalece la hipótesis.",
        incorrectMessage:
        "Una única fuente proporciona menor capacidad de corroboración.",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es la finalidad de correlacionar la información policial?",
        options: [
          "Determinar culpabilidad de inmediato",
          "Establecer una línea de investigación sustentada",
          "Sustituir la investigación médico-legal",
          "Evitar entrevistar testigos",
        ],
        correctIndex: 1,
        correctMessage:
        "La correlación permite establecer una línea de investigación.",
        incorrectMessage:
        "La correlación orienta la investigación, pero no sustituye "
            "el proceso de determinación de responsabilidades.",
        moneyPenalty: 50,
      ),
    ],
  ),

  // ============================================================
  // INTEGRACIÓN 3 → ESCENA
  // ============================================================

  "EVAL_EXP3_INTEGRATION": Evaluation(
    id: "EVAL_EXP3_INTEGRATION",
    expediente: 3,
    title: "Evaluación de integración III",
    subtitle:
    "Reconstruye lo ocurrido en el domicilio y determina "
        "si existe una segunda ubicación relevante.",
    type: EvaluationType.integration,

    requiredCorrect: 3,

    unlockFlagOnPass: "crimeSceneUnlocked",

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué debe hacerse antes de manipular evidencia en una escena?",
        options: [
          "Mover los objetos para examinarlos mejor",
          "Documentar las condiciones generales",
          "Desechar objetos irrelevantes",
          "Entregar la evidencia a cualquier investigador",
        ],
        correctIndex: 1,
        correctMessage:
        "La documentación previa permite conservar la referencia espacial.",
        incorrectMessage:
        "La manipulación prematura puede alterar la interpretación de la escena.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué permite establecer una reconstrucción de los hechos?",
        options: [
          "Únicamente quién es culpable",
          "La relación temporal y espacial entre los indicios",
          "La identidad genética de todos los asistentes",
          "La causa definitiva de muerte",
        ],
        correctIndex: 1,
        correctMessage:
        "La reconstrucción relaciona los hallazgos dentro de una secuencia.",
        incorrectMessage:
        "Una reconstrucción no establece automáticamente culpabilidad.",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "Si los indicios sugieren que la intoxicación continuó después "
            "de la fiesta, ¿qué debe hacerse?",
        options: [
          "Cerrar el expediente",
          "Investigar una segunda ubicación",
          "Ignorar los nuevos indicios",
          "Modificar los testimonios",
        ],
        correctIndex: 1,
        correctMessage:
        "La hipótesis debe ampliarse hacia la nueva ubicación.",
        incorrectMessage:
        "Los indicios contradictorios deben investigarse, no ignorarse.",
        moneyPenalty: 50,
      ),

      EvaluationQuestion(
        question:
        "¿Qué elemento tiene mayor valor para conectar el domicilio "
            "con la siguiente ubicación?",
        options: [
          "La decoración del inmueble",
          "La evidencia relacionada con la distribución",
          "La edad de los asistentes",
          "Los signos vitales de los pacientes",
        ],
        correctIndex: 1,
        correctMessage:
        "La evidencia de distribución permite establecer una conexión logística.",
        incorrectMessage:
        "Los elementos generales del domicilio no necesariamente establecen una ruta.",
        moneyPenalty: 75,
      ),
    ],
  ),

  // ============================================================
  // INTEGRACIÓN 4 → ALMACÉN
  // ============================================================

  "EVAL_EXP4_INTEGRATION": Evaluation(
    id: "EVAL_EXP4_INTEGRATION",
    expediente: 4,
    title: "Evaluación de integración IV",
    subtitle:
    "Integra la escena, la autopsia y la evidencia toxicológica.",
    type: EvaluationType.integration,

    requiredCorrect: 3,

    unlockFlagOnPass: "warehouseUnlocked",

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué aporta la autopsia médico-legal al caso?",
        options: [
          "Únicamente una descripción anatómica",
          "Información sobre causa y mecanismo de muerte",
          "La identidad automática del responsable",
          "La ubicación del almacén",
        ],
        correctIndex: 1,
        correctMessage:
        "La autopsia aporta elementos para establecer causa y mecanismo de muerte.",
        incorrectMessage:
        "La autopsia no identifica automáticamente a un responsable.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Por qué deben correlacionarse los hallazgos postmortem "
            "con la toxicología?",
        options: [
          "Para sustituir la autopsia",
          "Para valorar la relación entre sustancias y hallazgos",
          "Para evitar documentar el cadáver",
          "Para establecer culpabilidad automáticamente",
        ],
        correctIndex: 1,
        correctMessage:
        "La interpretación médico-legal requiere integrar múltiples fuentes.",
        incorrectMessage:
        "Ningún resultado aislado debe interpretarse fuera de contexto.",
        moneyPenalty: 75,
      ),

      EvaluationQuestion(
        question:
        "¿Qué permite establecer la evidencia de la escena?",
        options: [
          "Únicamente la identidad del cadáver",
          "La relación entre personas, objetos y actividades",
          "El diagnóstico clínico",
          "El tratamiento administrado",
        ],
        correctIndex: 1,
        correctMessage:
        "La escena aporta información contextual y reconstructiva.",
        incorrectMessage:
        "La evidencia de escena no sustituye los estudios clínicos.",
        moneyPenalty: 50,
      ),

      EvaluationQuestion(
        question:
        "¿Qué resultado justificaría investigar un almacén?",
        options: [
          "Una coincidencia entre evidencia de distribución y una ubicación",
          "Una alteración aislada del ECG",
          "Una glucosa normal",
          "Una declaración sin corroboración",
        ],
        correctIndex: 0,
        correctMessage:
        "La evidencia logística puede orientar hacia un punto de distribución.",
        incorrectMessage:
        "Los hallazgos clínicos aislados no permiten localizar una instalación.",
        moneyPenalty: 75,
      ),
    ],
  ),
};

final Map<String, Evaluation> finalEvaluations = {

  // ============================================================
  // FINAL EXPEDIENTE 1
  // ============================================================

  "EVAL_FINAL_EXP1": Evaluation(
    id: "EVAL_FINAL_EXP1",
    expediente: 1,
    title: "Evaluación final • Paciente índice",
    subtitle:
    "Determina si la atención clínica y la interpretación inicial "
        "del caso fueron adecuadas.",
    type: EvaluationType.finalCase,
    requiredCorrect: 4,
    trustReward: 10,

    questions: [

      EvaluationQuestion(
        question:
        "Ante el deterioro inicial, ¿qué debe priorizarse?",
        options: [
          "Investigación policial",
          "Estabilización ABC",
          "Interrogatorio",
          "Análisis de evidencia",
        ],
        correctIndex: 1,
        correctMessage: "La estabilización del paciente es prioritaria.",
        incorrectMessage: "La investigación no sustituye la atención urgente.",
        trustOnSuccess: 8,
        trustOnFail: 10,
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué estudio ayuda a identificar sustancias relacionadas con el cuadro?",
        options: [
          "ECG",
          "Tamiz toxicológico",
          "Radiografía",
          "Glucosa",
        ],
        correctIndex: 1,
        correctMessage: "El tamiz orienta la etiología tóxica.",
        incorrectMessage: "El estudio seleccionado no permite identificar sustancias.",
        trustOnSuccess: 7,
        trustOnFail: 7,
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe evitarse al interpretar un resultado toxicológico?",
        options: [
          "Correlacionarlo con clínica",
          "Considerar el contexto",
          "Atribuir causalidad únicamente por la presencia de una sustancia",
          "Solicitar confirmación",
        ],
        correctIndex: 2,
        correctMessage:
        "La presencia de una sustancia no demuestra por sí sola causalidad.",
        incorrectMessage:
        "Un resultado positivo debe interpretarse en contexto.",
        trustOnSuccess: 8,
        trustOnFail: 8,
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué permite ampliar el caso hacia otros pacientes?",
        options: [
          "La identificación de un patrón común",
          "Un único síntoma",
          "Una alteración aislada",
          "Una sospecha sin evidencia",
        ],
        correctIndex: 0,
        correctMessage: "El patrón común permite ampliar razonablemente la investigación.",
        incorrectMessage: "Una sospecha aislada no basta.",
        trustOnSuccess: 8,
        trustOnFail: 8,
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué documento resulta fundamental para integrar los hallazgos?",
        options: [
          "Una nota informal",
          "El expediente médico-legal documentado",
          "Una conversación verbal",
          "Un mensaje personal",
        ],
        correctIndex: 1,
        correctMessage: "La documentación formal permite conservar la trazabilidad.",
        incorrectMessage: "La información relevante debe documentarse formalmente.",
        trustOnSuccess: 8,
        trustOnFail: 8,
        moneyPenalty: 100,
      ),
    ],
  ),

  // ============================================================
  // FINAL EXPEDIENTE 2
  // ============================================================

  "EVAL_FINAL_EXP2": Evaluation(
    id: "EVAL_FINAL_EXP2",
    expediente: 2,
    title: "Evaluación final • Investigación policial",
    subtitle:
    "Evalúa la capacidad para integrar testimonios, registros "
        "y evidencia clínica.",
    type: EvaluationType.finalCase,
    requiredCorrect: 4,
    trustReward: 10,

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué fortalece una hipótesis investigativa?",
        options: [
          "Una sola declaración",
          "La convergencia de diferentes fuentes",
          "Una sospecha",
          "Un rumor",
        ],
        correctIndex: 1,
        correctMessage: "La corroboración entre fuentes fortalece la hipótesis.",
        incorrectMessage: "Una sola fuente tiene menor capacidad de corroboración.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es el papel de la policía en este punto?",
        options: [
          "Sustituir al médico",
          "Apoyar la investigación y preservar la evidencia",
          "Determinar el diagnóstico",
          "Interpretar resultados clínicos",
        ],
        correctIndex: 1,
        correctMessage: "La investigación requiere colaboración interdisciplinaria.",
        incorrectMessage: "Cada disciplina conserva sus competencias específicas.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué valor tiene rastrear el teléfono?",
        options: [
          "Determinar culpabilidad",
          "Establecer una referencia espacial",
          "Determinar causa de muerte",
          "Identificar automáticamente una sustancia",
        ],
        correctIndex: 1,
        correctMessage: "La localización proporciona una línea espacial de investigación.",
        incorrectMessage: "Una localización no demuestra responsabilidad.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe hacerse ante testimonios contradictorios?",
        options: [
          "Elegir el que resulte más conveniente",
          "Corroborarlos con otras evidencias",
          "Eliminar ambos",
          "Modificar el expediente",
        ],
        correctIndex: 1,
        correctMessage: "Las contradicciones deben verificarse mediante otras fuentes.",
        incorrectMessage: "No es válido seleccionar arbitrariamente una versión.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Cuándo debe ampliarse una investigación?",
        options: [
          "Cuando aparecen elementos objetivos que justifican nuevas líneas",
          "Siempre",
          "Nunca",
          "Únicamente cuando existe una confesión",
        ],
        correctIndex: 0,
        correctMessage: "La ampliación debe estar sustentada por nuevos elementos.",
        incorrectMessage: "La investigación debe mantenerse sustentada en evidencia.",
        moneyPenalty: 100,
      ),
    ],
  ),

  // ============================================================
  // FINAL EXPEDIENTE 3
  // ============================================================

  "EVAL_FINAL_EXP3": Evaluation(
    id: "EVAL_FINAL_EXP3",
    expediente: 3,
    title: "Evaluación final • Casa del Rave",
    subtitle:
    "Evalúa la reconstrucción de la escena y la cadena de indicios.",
    type: EvaluationType.finalCase,
    requiredCorrect: 4,
    trustReward: 12,

    questions: [

      EvaluationQuestion(
        question:
        "¿Cuál es la primera acción antes de una búsqueda dirigida?",
        options: [
          "Manipular objetos",
          "Documentar la escena",
          "Desechar materiales",
          "Mover muebles",
        ],
        correctIndex: 1,
        correctMessage: "La documentación precede a la manipulación.",
        incorrectMessage: "Manipular antes de documentar puede alterar la escena.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué permite relacionar los indicios?",
        options: [
          "La reconstrucción de la secuencia de hechos",
          "La intuición",
          "La sospecha",
          "La presión policial",
        ],
        correctIndex: 0,
        correctMessage: "La reconstrucción permite contextualizar los indicios.",
        incorrectMessage: "La interpretación debe basarse en evidencia.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe hacerse con evidencia potencialmente relevante?",
        options: [
          "Manipularla libremente",
          "Documentarla y asegurarla adecuadamente",
          "Desecharla",
          "Entregarla sin registro",
        ],
        correctIndex: 1,
        correctMessage: "La evidencia debe conservar su integridad y trazabilidad.",
        incorrectMessage: "La evidencia debe manejarse con control y documentación.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Qué indicaría una segunda ubicación?",
        options: [
          "Evidencia que no puede explicarse por el domicilio inicial",
          "Una glucosa normal",
          "Un ECG normal",
          "Un testimonio sin relación",
        ],
        correctIndex: 0,
        correctMessage: "Los indicios incompatibles con la primera escena justifican ampliar la búsqueda.",
        incorrectMessage: "Los hallazgos deben guardar relación con la hipótesis investigativa.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es el objetivo principal de la reconstrucción?",
        options: [
          "Crear una historia conveniente",
          "Explicar la secuencia de acontecimientos a partir de evidencia",
          "Encontrar un culpable",
          "Cerrar rápidamente el expediente",
        ],
        correctIndex: 1,
        correctMessage: "La reconstrucción debe derivarse de los indicios disponibles.",
        incorrectMessage: "No debe construirse una narrativa sin sustento.",
        moneyPenalty: 125,
      ),
    ],
  ),

  // ============================================================
  // FINAL EXPEDIENTE 4
  // ============================================================

  "EVAL_FINAL_EXP4": Evaluation(
    id: "EVAL_FINAL_EXP4",
    expediente: 4,
    title: "Evaluación final • Reconstrucción médico-legal",
    subtitle:
    "Integra los hallazgos clínicos, toxicológicos, postmortem y criminalísticos.",
    type: EvaluationType.finalCase,
    requiredCorrect: 4,
    trustReward: 15,

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué establece principalmente la autopsia médico-legal?",
        options: [
          "Causa y mecanismo de muerte",
          "Responsabilidad penal",
          "Identidad del distribuidor",
          "Ubicación del almacén",
        ],
        correctIndex: 0,
        correctMessage: "La autopsia aporta elementos sobre causa y mecanismo de muerte.",
        incorrectMessage: "La autopsia no establece responsabilidad penal.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe hacerse con los hallazgos toxicológicos?",
        options: [
          "Interpretarlos aisladamente",
          "Correlacionarlos con clínica y hallazgos postmortem",
          "Ignorarlos",
          "Usarlos como prueba única de responsabilidad",
        ],
        correctIndex: 1,
        correctMessage: "La interpretación debe ser integral.",
        incorrectMessage: "Los resultados aislados pueden conducir a conclusiones erróneas.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué permite la integración médico-legal?",
        options: [
          "Relacionar diferentes fuentes de evidencia",
          "Sustituir todas las pruebas",
          "Determinar automáticamente al responsable",
          "Evitar una investigación criminalística",
        ],
        correctIndex: 0,
        correctMessage: "La integración permite construir una interpretación sustentada.",
        incorrectMessage: "La integración no elimina la necesidad de otras investigaciones.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué hallazgo podría orientar hacia un punto de distribución?",
        options: [
          "Registros logísticos relacionados con sustancias",
          "Un síntoma aislado",
          "Un ECG",
          "Una glucosa",
        ],
        correctIndex: 0,
        correctMessage: "La evidencia logística puede orientar hacia una instalación.",
        incorrectMessage: "Los hallazgos clínicos no localizan por sí mismos un punto de distribución.",
        moneyPenalty: 100,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es el principio fundamental al emitir conclusiones médico-legales?",
        options: [
          "Concluir más allá de la evidencia",
          "Limitar las conclusiones a lo sustentado",
          "Favorecer una hipótesis",
          "Omitir hallazgos negativos",
        ],
        correctIndex: 1,
        correctMessage: "Las conclusiones deben corresponder al alcance de la evidencia.",
        incorrectMessage: "Una conclusión médico-legal debe mantenerse dentro de sus límites probatorios.",
        moneyPenalty: 150,
      ),
    ],
  ),

  // ============================================================
  // FINAL EXPEDIENTE 5
  // ============================================================

  "EVAL_FINAL_EXP5": Evaluation(
    id: "EVAL_FINAL_EXP5",
    expediente: 5,
    title: "Evaluación final • Red Quimera",
    subtitle:
    "Resolver el caso completo utilizando toda la evidencia reunida.",
    type: EvaluationType.finalCase,
    requiredCorrect: 4,
    trustReward: 20,

    questions: [

      EvaluationQuestion(
        question:
        "¿Qué permite relacionar los diferentes expedientes?",
        options: [
          "Una cadena común de evidencia",
          "Una sola declaración",
          "Una sospecha",
          "Una coincidencia aislada",
        ],
        correctIndex: 0,
        correctMessage: "La evidencia acumulada permite establecer relaciones entre casos.",
        incorrectMessage: "Una única fuente no permite integrar toda la investigación.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Qué representa finalmente 'Quimera'?",
        options: [
          "Únicamente una sustancia",
          "Una estructura organizada de distribución",
          "Un diagnóstico",
          "Un hospital",
        ],
        correctIndex: 1,
        correctMessage: "La investigación permite identificar una estructura organizada.",
        incorrectMessage: "El caso supera la interpretación de Quimera como simple sustancia.",
        moneyPenalty: 125,
      ),

      EvaluationQuestion(
        question:
        "¿Qué debe ocurrir con la evidencia final?",
        options: [
          "Ser asegurada y documentada",
          "Ser destruida",
          "Ser utilizada personalmente",
          "Ser entregada sin registro",
        ],
        correctIndex: 0,
        correctMessage: "La evidencia debe conservar su integridad y trazabilidad.",
        incorrectMessage: "La evidencia requiere un manejo formal.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Qué factor puede modificar la valoración global de la campaña?",
        options: [
          "Únicamente el dinero",
          "La reputación y las decisiones tomadas",
          "Únicamente el AP restante",
          "La cantidad de pacientes",
        ],
        correctIndex: 1,
        correctMessage:
        "Las decisiones éticas y la reputación acumulada tendrán consecuencias.",
        incorrectMessage:
        "El resultado final debe considerar también el comportamiento durante la campaña.",
        moneyPenalty: 150,
      ),

      EvaluationQuestion(
        question:
        "¿Cuál es la mejor conclusión ante una cadena de evidencia compleja?",
        options: [
          "Concluir únicamente lo sustentado por el conjunto de evidencias",
          "Elegir la explicación más conveniente",
          "Ignorar evidencia contradictoria",
          "Atribuir responsabilidad automáticamente",
        ],
        correctIndex: 0,
        correctMessage:
        "La conclusión debe corresponder al conjunto de evidencia disponible.",
        incorrectMessage:
        "La investigación no debe exceder lo que puede demostrarse.",
        moneyPenalty: 200,
      ),
    ],
  ),
};