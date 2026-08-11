import '../models/scene.dart';
import '../models/story_node.dart';

const campaignEndings = [

  Scene(
    id: "QUIMERA_COMPLETE",
    title: "Operación Quimera • Caso cerrado",
    description:
    "La investigación ha terminado.\n\n"
        "Los casos que parecían independientes fueron relacionados "
        "mediante evidencia clínica, toxicológica, criminalística "
        "y médico-legal.\n\n"
        "La red de distribución fue identificada y la evidencia "
        "fundamental quedó asegurada.\n\n"
        "Sin embargo, una pregunta permanece abierta:\n\n"
        "¿Quién creó realmente la mezcla conocida como Quimera?",
    node: "CAMPAIGN_COMPLETE",
  ),

  Scene(
    id: "ENDING_ESCAPE",
    title: "Operación Quimera • La red escapa",
    description:
    "No se localizó la red a tiempo o las investigaciones no fueron contundentes. "
        "La distribución continúa y los responsables evaden la captura.",
    node: "ENDING_ESCAPE_NODE",
  ),

  Scene(
    id: "ENDING_BAD",
    title: "Operación Quimera • Fracaso operativo",
    description:
    "La entrada fue improvisada y la operación fracasó, con consecuencias graves. "
        "El paciente no sobrevivió o la red siguió operando a pesar del intento.",
    node: "ENDING_BAD_NODE",
  ),

  Scene(
    id: "ENDING_MEDIUM",
    title: "Operación Quimera • Éxito parcial",
    description:
    "Se logró desarticular parte de la red y detener a algunos implicados. "
        "Sin embargo, no se pudieron asegurar todos los responsables ni toda la evidencia.",
    node: "ENDING_MEDIUM_NODE",
  ),

  Scene(
    id: "ENDING_BEST",
    title: "Operación Quimera • Operación exitosa",
    description:
    "La operación fue planificada y ejecutada con equipo especializado. "
        "Se detuvo a la red en el acto y la evidencia quedó asegurada. El paciente sobrevivió.",
    node: "ENDING_BEST_NODE",
  ),

];

final Map<String, StoryNode> endingNodes = {

  "CAMPAIGN_COMPLETE": StoryNode(
    id: "CAMPAIGN_COMPLETE",
    expediente: 5,
    title: "Operación Quimera • Investigación concluida",
    description:
    "La cadena de intoxicaciones ha sido reconstruida. "
        "La evidencia médico-legal queda integrada al expediente.",
  ),

  "ENDING_ESCAPE_NODE": StoryNode(
    id: "ENDING_ESCAPE_NODE",
    expediente: 5,
    title: "La red escapa",
    description:
    "Pese a esfuerzos, la red continúa operando. Reflexiona sobre la información pendiente y las decisiones clave.",
  ),

  "ENDING_BAD_NODE": StoryNode(
    id: "ENDING_BAD_NODE",
    expediente: 5,
    title: "Fracaso operativo",
    description:
    "La actuación precipitada y riesgo táctico llevaron a un resultado adverso. Revisa la gestión del riesgo y el manejo del paciente.",
  ),

  "ENDING_MEDIUM_NODE": StoryNode(
    id: "ENDING_MEDIUM_NODE",
    expediente: 5,
    title: "Éxito parcial",
    description:
    "Buenos hallazgos parciales y detenciones, pero falta consolidar la evidencia para condenas duraderas.",
  ),

  "ENDING_BEST_NODE": StoryNode(
    id: "ENDING_BEST_NODE",
    expediente: 5,
    title: "Operación exitosa",
    description:
    "La operación culminó con detenciones y la integridad del paciente preservada. Felicitaciones.",
  ),

};