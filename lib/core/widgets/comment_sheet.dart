import 'package:flutter/material.dart';

class CommentSheet extends StatefulWidget {
  final String username;
  final Function(int) onCommentAdded;

  const CommentSheet({
    super.key, 
    required this.username, 
    required this.onCommentAdded,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();
  Map<String, dynamic>? replyingTo;
  String replyHint = 'Ajouter un commentaire...';
  int commentCount = 0;
  
  // Liste de commentaires fictifs pour la démonstration
  late List<Map<String, dynamic>> demoComments;

  @override
  void initState() {
    super.initState();
    demoComments = [
      {
        'id': '1',
        'author': 'Alice',
        'text': 'J\'adore ton top 3 !',
        'time': '2h',
        'likes': 3,
        'replies': []
      },
      {
        'id': '2',
        'author': 'Bob',
        'text': 'Je ne connais pas le deuxième titre, tu recommandes ?',
        'time': '1h',
        'likes': 1,
        'replies': [
          {
            'id': '3',
            'author': widget.username,
            'text': 'Absolument, c\'est un de mes préférés !',
            'time': '45min',
            'likes': 2
          }
        ]
      }
    ];
    
    // Compter le nombre total de commentaires (incluant les réponses)
    commentCount = countAllComments();
  }
  
  // Compte le nombre total de commentaires incluant les réponses
  int countAllComments() {
    int count = demoComments.length;
    for (var comment in demoComments) {
      if (comment['replies'] != null) {
        count += (comment['replies'] as List).length;
      }
    }
    return count;
  }

  void setReplyingTo(Map<String, dynamic>? comment) {
    setState(() {
      replyingTo = comment;
      if (comment != null) {
        replyHint = 'Répondre à ${comment['author']}...';
      } else {
        replyHint = 'Ajouter un commentaire...';
      }
    });
  }

  void addNewComment() {
    if (commentController.text.trim().isEmpty) return;
    
    setState(() {
      final newComment = {
        'id': DateTime.now().toString(),
        'author': 'Vous',
        'text': commentController.text,
        'time': 'à l\'instant',
        'likes': 0,
        'replies': []
      };
      
      if (replyingTo != null) {
        // Ajouter une réponse à un commentaire existant
        bool commentFound = false;
        
        // Chercher le commentaire parent et y ajouter la réponse
        for (var comment in demoComments) {
          // Vérifier si c'est le commentaire principal auquel on répond
          if (comment['id'] == replyingTo!['id']) {
            if (comment['replies'] == null) comment['replies'] = [];
            comment['replies'].add(newComment);
            commentFound = true;
            break;
          }
          
          // Vérifier si on répond à une réponse existante
          // Dans ce cas, ajouter au même niveau dans la liste des réponses du commentaire parent
          if (comment['replies'] != null && comment['replies'].isNotEmpty) {
            for (var reply in comment['replies']) {
              if (reply['id'] == replyingTo!['id']) {
                comment['replies'].add(newComment);
                commentFound = true;
                break;
              }
            }
            if (commentFound) break;
          }
        }
        
        // Si le commentaire n'a pas été trouvé (cas rare), ajouter comme commentaire principal
        if (!commentFound) {
          demoComments.insert(0, newComment);
        }
      } else {
        // Ajouter un nouveau commentaire principal
        demoComments.insert(0, newComment);
      }
      
      // Réinitialiser
      commentController.clear();
      setReplyingTo(null);
      
      // Mettre à jour le nombre total de commentaires
      commentCount = countAllComments();
      
      // Notifier la mise à jour du nombre de commentaires
      widget.onCommentAdded(commentCount);
    });
    
    // Notification pour confirmer l'ajout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commentaire ajouté'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Barre de poignée pour fermer
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Titre avec compteur
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Commentaires ($commentCount)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (replyingTo != null)
                  TextButton.icon(
                    icon: const Icon(Icons.close, size: 16, color: Colors.white70),
                    label: const Text(
                      'Annuler la réponse',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    onPressed: () => setReplyingTo(null),
                  ),
              ],
            ),
          ),
          
          const Divider(color: Colors.grey),
          
          // Liste des commentaires
          Expanded(
            child: demoComments.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun commentaire pour le moment.\nSoyez le premier à commenter !',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: demoComments.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final comment = demoComments[index];                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Commentaire principal
                          _buildCommentItem(
                            context, 
                            comment, 
                            onReply: () => setReplyingTo(comment)
                          ),
                          
                          // Réponses (si présentes)
                          if (comment['replies'] != null && comment['replies'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: Column(
                                children: [
                                  for (var reply in comment['replies'])
                                    _buildCommentItem(
                                      context, 
                                      reply, 
                                      isReply: true,
                                      onReply: () => setReplyingTo(reply)
                                    ),
                                ],
                              ),
                            ),
                          // Enlevé la ligne de séparation (Divider) entre les commentaires
                        ],
                      );
                    },
                  ),
          ),
            // Champ de texte pour ajouter un commentaire
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Alignement centré verticalement
              children: [
                // Avatar de l'utilisateur
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=5',
                  ),
                ),
                const SizedBox(width: 8),
                
                // Champ de commentaire
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: replyHint,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                
                // Bouton d'envoi
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: addNewComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
    // Construit un élément de commentaire individuel
  Widget _buildCommentItem(BuildContext context, Map<String, dynamic> comment, {bool isReply = false, VoidCallback? onReply}) {
    // Vérifier si ce commentaire est déjà liké
    bool isLiked = comment['isLiked'] ?? false;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: isReply ? 14 : 18,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=${comment['author']}',
            ),
          ),
          const SizedBox(width: 8),
          
          // Contenu du commentaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auteur et temps
                Row(
                  children: [                    Text(
                      comment['author'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Taille uniforme pour tous les auteurs
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12, // Taille uniforme pour tous les horodatages
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                  // Texte du commentaire
                Text(
                  comment['text'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Taille uniforme pour tous les commentaires
                  ),
                ),
                const SizedBox(height: 4),
                
                // Interactions (like, répondre)
                Row(
                  children: [
                    // Bouton like avec état
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (!isLiked) {
                            comment['likes'] = (comment['likes'] ?? 0) + 1;
                            comment['isLiked'] = true;
                          } else {
                            comment['likes'] = (comment['likes'] ?? 1) - 1;
                            comment['isLiked'] = false;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment['likes'] ?? 0}',
                            style: TextStyle(
                              color: isLiked ? Colors.red : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Bouton répondre (maintenant disponible sur tous les commentaires)
                    if (onReply != null)
                      InkWell(
                        onTap: onReply,
                        child: const Text(
                          'Répondre',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
