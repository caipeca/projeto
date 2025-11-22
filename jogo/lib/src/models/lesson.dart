import 'dart:convert';

class LessonContentBlock {
  final String type; // text,title,list,image,diagram,example,animation
  final dynamic value;
  LessonContentBlock({required this.type, required this.value});

  factory LessonContentBlock.fromJson(Map<String, dynamic> j) {
    return LessonContentBlock(type: j['type'] as String, value: j['value']);
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final List<String> quizSteps;
  final List<LessonContentBlock> content;
  bool unlocked;
  bool completed;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.quizSteps,
    required this.content,
    this.unlocked = false,
    this.completed = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> j) {
    return Lesson(
      id: j['id'] ?? '',
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      quizSteps: (j['quizSteps'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      content: (j['content'] as List<dynamic>? ?? []).map((c) => LessonContentBlock.fromJson(c as Map<String,dynamic>)).toList(),
      unlocked: j['unlocked'] ?? false,
      completed: j['completed'] ?? false,
    );
  }

  static List<Lesson> fromJsonList(String jsonStr) {
    final arr = json.decode(jsonStr) as List<dynamic>;
    return arr.map((e) => Lesson.fromJson(e as Map<String,dynamic>)).toList();
  }
}


class DemoLesson {
  static List<Lesson> sample() {
    return [
      Lesson(
        id: "l1",
        title: "Introdução às Redes",
        description: "Conceitos básicos de redes",
        unlocked: true,
        quizSteps: [
          "Enviar pacote",
          "Roteamento",
          "Entrega ao destino"
        ],
        content: [
          LessonContentBlock(type: "title", value: "O que é uma rede?"),

          LessonContentBlock(type: "text", value:
          "Uma rede é um conjunto de dispositivos que trocam dados entre si. "
              "Ela permite comunicação, acesso à internet, partilha de arquivos e muito mais."
          ),

          LessonContentBlock(type: "image", value: "assets/images/network.png"),

          LessonContentBlock(type: "example", value: {
            "title": "Exemplo prático:",
            "description":
            "Quando envias uma mensagem no WhatsApp, teu smartphone envia dados "
                "até o servidor e depois até o telemóvel do destinatário. Esse percurso acontece via rede."
          }),

          LessonContentBlock(type: "diagram", value:
          """
[ Teu Telemóvel ]
         |
         |  Wi-Fi/4G
         |
[ Roteador ] --- [ Internet ] --- [ Servidor WhatsApp ]
    """),

          LessonContentBlock(type: "list", value: [
            "Permite comunicação",
            "Acesso remoto",
            "Transferência de dados",
            "Ligação entre redes do mundo inteiro"
          ]),
        ],
      ),


      Lesson(
        id: "l2",
        title: "Modelo OSI",
        description: "7 camadas da comunicação",
        quizSteps: [
          "Aplicação",
          "Transporte",
          "Rede",
          "Enlace",
          "Física"
        ],
        content: [
          LessonContentBlock(type: "title", value: "O Modelo OSI"),

          LessonContentBlock(type: "text", value:
          "O modelo OSI é uma forma de compreender como a comunicação ocorre entre sistemas."
          ),

          LessonContentBlock(type: "image", value: "assets/images/osi_layers.png"),

          LessonContentBlock(type: "diagram", value:
          """
 +----------------------+
 | 7 - Aplicação        |
 | 6 - Apresentação     |
 | 5 - Sessão           |
 | 4 - Transporte       |
 | 3 - Rede             |
 | 2 - Enlace           |
 | 1 - Física           |
 +----------------------+
    """),

          LessonContentBlock(type: "example", value: {
            "title": "Exemplo prático:",
            "description":
            "Quando carregas uma página web, a camada de aplicação envia o pedido HTTP. "
                "O TCP (camada 4) garante a entrega. A camada física envia os bits pelo cabo ou Wi-Fi."
          }),
        ],
      ),


      Lesson(
        id: "l3",
        title: "TCP vs UDP",
        description: "Conexão e envio de dados",
        quizSteps: [
          "Handshake 3-way",
          "Troca de dados",
          "Encerramento da conexão"
        ],
        content: [
          LessonContentBlock(type: "title", value: "TCP"),

          LessonContentBlock(type: "text", value:
          "TCP garante que os dados cheguem sem erros e na ordem correta. "
              "Por isso é usado em e-mail, login, downloads e websites."
          ),

          LessonContentBlock(type: "image", value: "assets/images/tcp_handshake.png"),

          LessonContentBlock(type: "diagram", value:
          """
Cliente ---- SYN ----> Servidor  
Cliente <--- SYN/ACK --- Servidor  
Cliente ---- ACK ----> Servidor  
    (Conexão estabelecida)
    """),

          LessonContentBlock(type: "title", value: "UDP"),

          LessonContentBlock(type: "text", value:
          "UDP é mais rápido, mas não garante entrega. "
              "Ideal para jogos, chamadas e streaming."
          ),

          LessonContentBlock(type: "example", value: {
            "title": "Exemplo prático:",
            "description":
            "Numa chamada de vídeo, perder 1 ou 2 pacotes não faz mal — é melhor manter a fluidez "
                "do que ficar à espera de retransmissões."
          }),
        ],
      ),


    ];
  }
}
