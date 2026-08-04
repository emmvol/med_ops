import '../models/story_node.dart';

final Map<String, StoryNode> caseNodes = {

  "START": StoryNode(

    id: "START",

    title: "Ingreso a Urgencias",

    description:
    "Paciente masculino de 22 años inconsciente. No existe diagnóstico confirmado.",

    decisions: [

      "ABC",

      "LAB",

      "BACKPACK",

    ],

  ),

  "PRIMARY": StoryNode(

    id: "PRIMARY",

    title: "Paciente estabilizado",

    description:
    "La vía aérea está permeable y los signos vitales mejoran ligeramente.",

    decisions: [

      "LAB",

      "BACKPACK",

    ],

  ),

  "LAB": StoryNode(

    id: "LAB",

    title: "Resultados de laboratorio",

    description:
    "Se detectan metabolitos compatibles con cocaína.",

    decisions: [

      "CONFIRM",

      "BACKPACK",

    ],

  ),

  "BACKPACK": StoryNode(

    id: "BACKPACK",

    title: "Pertenencias",

    description:
    "Encuentras un teléfono bloqueado y un ticket con una dirección.",

    decisions: [

      "LAB",

      "ABC",

    ],

  ),

  "CONFIRM": StoryNode(

    id: "CONFIRM",

    title: "Análisis confirmado",

    description:
    "La sustancia contiene adulterantes desconocidos.",

    decisions: [

      "BACKPACK",

    ],

  ),

};