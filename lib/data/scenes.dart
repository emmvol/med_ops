import '../models/scene.dart';

const scenes = [

  Scene(
    id: "INTRO",
    title: "Ingreso a Urgencias",
    description:
    "Un paciente masculino de aproximadamente 22 años ingresa "
        "al servicio de urgencias.\n\n"
        "Fue encontrado inconsciente en un callejón del centro "
        "de San Pachuca.\n\n"
        "No porta identificación.\n\n"
        "Su estado es crítico.\n\n"
        "El expediente acaba de llegar a sus manos.",
    node: "EXPEDIENTE_1",
  ),

  Scene(
    id: "EXP1_END",
    title: "Un caso que no termina aquí",
    description:
    "El paciente permanece con vida y bajo vigilancia.\n\n"
        "Los resultados iniciales no permiten identificar una única "
        "sustancia responsable.\n\n"
        "Sin embargo, varios elementos comienzan a coincidir con "
        "otros casos de intoxicación.\n\n"
        "La investigación debe continuar.",
    node: "EXPEDIENTE_2",
  ),

  Scene(
    id: "EXP2_END",
    title: "Una dirección",
    description:
    "Las declaraciones, registros y testimonios comienzan a "
        "coincidir en un mismo domicilio.\n\n"
        "La investigación ya tiene un lugar concreto.",
    node: "EXPEDIENTE_3",
  ),

  Scene(
    id: "EXP3_END",
    title: "La segunda ubicación",
    description:
    "La fiesta explica una parte de lo ocurrido.\n\n"
        "No explica todo.\n\n"
        "Los indicios recuperados apuntan hacia otro lugar.",
    node: "EXPEDIENTE_4",
  ),

  Scene(
    id: "EXP4_END",
    title: "El origen",
    description:
    "La evidencia recuperada permite identificar un almacén "
        "relacionado con la distribución.\n\n"
        "La investigación deja de ser una búsqueda de respuestas.\n\n"
        "Ahora comienza un operativo.",
    node: "EXPEDIENTE_5",
  ),
];