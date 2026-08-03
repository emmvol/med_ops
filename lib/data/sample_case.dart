import '../models/story_node.dart';
import '../models/decision.dart';

final Map<String, StoryNode> caseNodes = {

  "START": StoryNode(

    id: "START",

    title: "Paciente encontrado",

    description:
    "Varón de 22 años encontrado inconsciente en un callejón.",

    decisions: [

      Decision(

        id: "LAB",

        title: "Solicitar laboratorio",

        description: "Enviar muestras.",

        moneyCost: 300,

        trustChange: 15,

        result: "Se encontraron metabolitos de cocaína.",

        evidence: "Laboratorio positivo",

        nextNode: "LAB",

      ),

      Decision(

        id: "QUESTION",

        title: "Interrogar acompañante",

        description: "Buscar antecedentes.",

        moneyCost: 0,

        trustChange: 10,

        result: "Obtienes un alias.",

        evidence: "Alias: El Mono",

        nextNode: "WITNESS",

      ),

      Decision(

        id: "TRATMENT",

        title: "Administrar tratamiento",

        description: "Intentar estabilizar.",

        moneyCost: 500,

        trustChange: 20,

        result: "Paciente parcialmente estable.",

        nextNode: "TREATMENT",

      ),

    ],

  ),

  "LAB": StoryNode(

    id: "LAB",

    title: "Resultados",

    description:
    "El laboratorio confirma cocaína.",

    decisions: [

      Decision(

        id: "ANALYSIS",

        title: "Solicitar análisis confirmatorio",

        description: "",

        moneyCost: 400,

        trustChange: 10,

        result: "Confirma alta pureza.",

        nextNode: "CONFIRM",

      ),

      Decision(

        id: "SEARCH",

        title: "Buscar proveedor",

        description: "",

        moneyCost: 300,

        trustChange: 15,

        result: "Encuentran una dirección.",

        nextNode: "HOUSE",

      ),

    ],

  ),

};