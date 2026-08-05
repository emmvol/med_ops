import '../models/story_node.dart';

final Map<String, StoryNode> caseNodes = {

  "START": StoryNode(
    id: "START",
    title: "Ingreso a Urgencias",
    description:
    "Paciente masculino de 22 años encontrado inconsciente tras un operativo en San Pachuca.",
    decisions: [
      "ABC",
      "VITALS",
      "QUESTION_PARAMEDICS",
      "SEARCH_BODY",
      "BACKPACK",
      "OBSERVE",
    ],
  ),

  "PRIMARY": StoryNode(
    id: "PRIMARY",
    title: "Paciente estabilizado",
    description:
    "La vía aérea se encuentra protegida. El paciente continúa inconsciente.",
    decisions: [
      "LAB",
      "GLUCOSE",
      "ECG",
      "CALL_POLICE",
      "BACKPACK",
    ],
  ),

  "VITALS": StoryNode(
    id: "VITALS",
    title: "Valoración clínica",
    description:
    "Midriasis bilateral, TA elevada, FC 132 lpm, temperatura 38.5°C.",
    decisions: [
      "ABC",
      "LAB",
      "GLUCOSE",
    ],
  ),

  "BODY_SEARCH": StoryNode(
    id: "BODY_SEARCH",
    title: "Exploración física",
    description:
    "No existen lesiones importantes. Encuentras una pulsera fluorescente utilizada para ingresar a un rave.",
    decisions: [
      "CALL_POLICE",
      "LAB",
      "BACKPACK",
    ],
  ),

  "PARAMEDICS": StoryNode(
    id: "PARAMEDICS",
    title: "Información prehospitalaria",
    description:
    "Los paramédicos informan que otras tres personas presentaban síntomas diferentes.",
    decisions: [
      "CALL_POLICE",
      "LAB",
    ],
  ),

  "LAB": StoryNode(
    id: "LAB",
    title: "Resultados preliminares",
    description:
    "El tamiz toxicológico detecta cocaína, pero algunos datos clínicos no coinciden.",
    decisions: [
      "CONFIRM",
      "CALL_POLICE",
      "BACKPACK",
    ],
  ),

  "ECG": StoryNode(
    id: "ECG",
    title: "Electrocardiograma",
    description:
    "Taquicardia sinusal sin otras alteraciones relevantes.",
    decisions: [
      "LAB",
      "CONFIRM",
    ],
  ),

  "POLICE": StoryNode(
    id: "POLICE",
    title: "Coordinación policial",
    description:
    "La policía confirma que el paciente podría conocer a los distribuidores.",
    decisions: [
      "CONFIRM",
    ],
  ),

  "BACKPACK": StoryNode(
    id: "BACKPACK",
    title: "Pertenencias",
    description:
    "Dentro de la mochila encuentras un teléfono bloqueado y un ticket de acceso a una fiesta clandestina.",
    decisions: [
      "CALL_POLICE",
      "LAB",
    ],
  ),

  "CONFIRM": StoryNode(
    id: "CONFIRM",
    title: "Informe especializado",
    description:
    "El laboratorio concluye que existen varias sustancias mezcladas y la cocaína no explica todo el cuadro clínico.",
    decisions: [],
  ),

  'POLICE_HQ': StoryNode(
    id: 'POLICE_HQ',
    title: 'Comandancia',
    description:
    'La policía de San Pachuca espera la información obtenida por los hospitales.',
    decisions: [],
  ),

  'CRIME_SCENE': StoryNode(
    id: 'CRIME_SCENE',
    title: 'Escena del crimen',
    description:
    'La calle donde fueron encontrados varios intoxicados permanece acordonada.',
    decisions: [],
  ),

  'RAVE_HOUSE': StoryNode(
    id: 'RAVE_HOUSE',
    title: 'Casa del rave',
    description:
    'La vivienda aún contiene vasos, envoltorios y restos de sustancias.',
    decisions: [],
  ),

  'WAREHOUSE_ENTRY': StoryNode(
    id: 'WAREHOUSE_ENTRY',
    title: 'Almacén',
    description:
    'Un almacén abandonado en la periferia de San Pachuca parece ser el centro de distribución.',
    decisions: [],
  ),

};