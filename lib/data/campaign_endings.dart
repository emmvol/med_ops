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

};