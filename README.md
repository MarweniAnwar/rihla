# rihla

A new Flutter project.

## Getting Started

## palier2:
Questions de compréhension :
Q1:L'application lève une erreur de dépassement de contrainte (Flex error / largeur non bornée).
Q2:prenom est déclaré final parce que le widget HomeHeader est un StatelessWidget, ce qui signifie qu'il est immuable (son état ne change pas après sa construction).
Q3:cs.primary s'adapte dynamiquement à la couleur principale générée par le système Material 3 à partir de votre seedColor. Si vous modifiez la couleur de base de votre thème dans main.dart, cs.primary changera automatiquement.

Colors.teal est une valeur statique figée (en dur). Elle restera toujours de couleur sarcelle (teal), peu importe les changements apportés à la palette globale ou au thème de l'application.
## palier 3:
Q1:Le DecoratedBox apparaît derrière les autres widgets
 si sa décoration est peinte avant eux. L'ordre des enfants
dans un Stack détermine leur superposition : les premiers sont derrière et les derniers apparaissent devant.
Q2:L'image n'a plus ses coins arrondis et ses bords
deviennent droits. ClipRRect découpe son contenu selon
un rectangle aux coins arrondis.
Q3:right: 130 positionne le texte à 130 pixels du bord
 droit du Stack. Cette valeur permet de placer les textes
 à l'endroit souhaité sur la bannière, par exemple pour
éviter de chevaucher un élément situé à droite.
 La valeur dépend de la taille du Stack et du design souhaité.
 ## palier 4:
 Q1:e Spacer() prend l'espace libre dans la Row entre la note et le prix. L'Expanded autour de la Column lui permet de disposer d'une largeur limitée et de partager correctement cet espace.
 Q2:
 il faut ajouter une ligne dans le fichier qui contient la liste des destinations, probablement lib/data/destinations.dart ou le fichier où la liste est déclarée.
 ## palier 5:
 Q1:
 En mémoire : la variable _categorie est bien mise à jour avec la nouvelle valeur de c.
  À l'écran : rien ne change, l'interface ne se met pas à jour (les cartes ne sont pas filtrées 
et la puce ne se coche pas) car Flutter n'est pas prévenu qu'il doit redessiner l'écran. 
 La fonction build() n'est pas réexécutée.
Q2:Parce que _filtrees dépend directement de l'état _categorie qui peut changer à tout moment 
 (lorsqu'on clique sur une autre puce). En utilisant un getter, la liste des destinations 
est automatiquement recalculée et filtrée à chaque fois que build() est appelé, garantissant 
que l'affichage correspond toujours à la catégorie sélectionnée
Q3:Parce que HeroBanner n'a pas besoin de gérer d'état interne mutable (il ne change pas de lui-même). 
Il reçoit simplement une destination en paramètre d'entrée (propriété) de la part de l'écran parent 
(HomeScreen), qui lui est un StatefulWidget et gère les rafraîchissements globaux.
## tp4 palier 2:
Q1:Oui, le filtre est conservé. Avec la gestion de la navigation par pile (Navigator), l'écran d'accueil (HomeScreen) est placé sous l'écran de détail lors du push et reste conservé en mémoire (en pause). Lorsqu'on revient en arrière avec pop, l'écran supérieur est retiré de la pile et l'on retrouve l'écran d'accueil dans son état exact (le filtre appliqué n'est pas perdu).
Q2:DetailScreen connaît la destination grâce au passage de l'objet par son constructeur (DetailScreen(destination: destination)). Le mécanisme réutilisé du TP 3 est la transmission de paramètres d'un widget parent vers un widget enfant via le constructeur.
Q3:Si l'on retire clipBehavior (comme Clip.antiAlias), l'effet d'encre (ripple effect) de l'animation tactile (InkWell) ne respecte plus les coins arrondis de la carte : l'effet visuel déborde et dépasse carrément des angles arrondis.
## palier 3:
Q1:Action : Elle parcourt tous les champs du formulaire (TextFormField) associés à cette clé et exécute la fonction de validation (validator) définie pour chacun d'eux.

=>Valeur de retour : Elle renvoie un booléen (bool) :*true si tous les champs respectent leurs règles et que leurs validateurs renvoient null.
*false dès qu'au moins un champ échoue à sa validation (le validateur renvoie alors une chaîne de caractères contenant le message d'erreur).
Q2:inputFormatters (Filtrage en amont / Pendant la frappe) : Intervient en temps réel lorsque l'utilisateur tape sur son clavier. Il empêche physiquement la saisie de caractères interdits (par exemple, bloquer les lettres avec FilteringTextInputFormatter.digitsOnly ou limiter la longueur avec LengthLimitingTextInputFormatter(8)).

validator (Validation en aval / À la soumission) : Intervient au moment où l'on clique sur le bouton de confirmation (via validate()). Il vérifie si la valeur finale enregistrée respecte les critères requis (par exemple, s'assurer que le champ n'est pas vide ou qu'il comporte bien le bon nombre de chiffres) et affiche un message d'erreur sous le champ si nécessaire.
Q3:Les contrôleurs de texte (TextEditingController) réservent des ressources et des écouteurs en mémoire pour suivre les modifications de texte en direct. Appeler dispose() dans la méthode du même nom permet de libérer proprement ces ressources dès que le widget est détruit (lors de la fermeture de l'écran), évitant ainsi les fuites de mémoire (memory leaks).
## tp5:palier 0 questions de compréhension
Q1/Si la destination ayant l'identifiant 99 n'existe pas, le serveur renvoie le code 404 Not Found.

Il appartient à la famille des codes 4xx, qui indiquent une erreur liée à la requête du client.
Q2/C'est généralement le serveur qui choisit et génère l'identifiant de la réservation lors de sa création.
Cela permet de garantir l'unicité de l'identifiant et d'éviter les conflits entre plusieurs réservations.
Q3/
GET : sert à récupérer des données. Les paramètres nécessaires sont généralement transmis dans l'URL. Elle n'a normalement pas besoin de corps (Body).
POST : sert à envoyer des données au serveur pour créer une nouvelle ressource. Ces données sont généralement transmises dans le corps de la requête au format JSON
## palier 4:
1.destinationId : Pour éviter la redondance, la destination existant déjà sur le serveur.
2.Content-Type manquant : Le serveur rejette la requête ou renvoie une erreur car il ne sait pas interpréter le format JSON.
3.Test mounted : Pour éviter un crash si l'utilisateur a quitté l'écran pendant l'attente de la réponse réseau.
## tp6
## palier 1
Q1/Si je casse l’application sur feature/favoris, main n’est pas affectée, car la branche isole mes modifications. main reste stable et livrable tant que je n’ai pas fusionné la branche par une Pull Request.
## palier 2
Q1/Un StatelessWidget ne possède aucun état : il ne mémorise rien lui-même. L’état (la liste des favoris) vit dans FavorisModel, en dehors du widget.

Quand l’utilisateur appuie sur le cœur, context.read<FavorisModel>().basculer(...) modifie le modèle, qui appelle notifyListeners(). Grâce à context.watch, le bouton est reconstruit avec la nouvelle valeur. C’est une reconstruction commandée par le modèle, pas un changement d’état interne. Un StatefulWidget n’est nécessaire que si le widget garde lui-même une donnée qui change (avec setState).

Q2/À chaque rechargement depuis json-server (rafraîchissement ou « Réessayer »), Destination.fromJson crée de nouveaux objets. Un Set<Destination> compare les objets par identité : l’ancienne destination favorite et la nouvelle, même si elles ont les mêmes données, seraient considérées comme différentes. Le cœur redeviendrait vide et on pourrait avoir des doublons.

L’id est stable et ne change pas au rechargement. Avec Map<String, Destination>, estFavori retrouve toujours la bonne destination, et ça marche aussi après un rafraîchissement, ce que le test 4 de 2.6 vérifie.
Q3/
Les favoris sont stockés en mémoire vive (RAM), dans la Map de FavorisModel. Un hot restart relance l’application et recrée un nouveau FavorisModel() vide : la mémoire est réinitialisée. Rien n’est enregistré sur le disque. Pour les conserver après la fermeture de l’app, il faudra de la persistance, avec shared_preferences à la séance suivante.
## tp 7
## palier 1:
Q1/
SharedPreferences (et le localStorage sur le Web) ne sait enregistrer que des types simples et primitifs (int, double, bool, String, List<String>), et pas des instances de classes Dart personnalisées comme Destination.

Sérialiser chaque Destination en Map (toJson()) puis en chaîne String JSON (jsonEncode(...)) permet de stocker toute la liste dans setStringList(_cle, textes), puis de la reconstruire fidèlement au chargement via jsonDecode(...) et Destination.fromJson(...).
Q2/
FavorisModel()..charger() utilise l'opérateur cascade (..) de Dart : il crée l'instance FavorisModel, appelle charger() dessus, et renvoie l'instance FavorisModel (et non le Future<void> retourné par charger()). C'est donc bien un FavorisModel qui est fourni à ChangeNotifierProvider.

Avec FavorisModel().charger() (sans ..), l'expression évalue et renvoie le résultat de charger(), c'est-à-dire un Future<void> au lieu d'un FavorisModel : cela provoque une erreur de type à la compilation (Future<void> n'est pas assignable à FavorisModel), et l'application ne démarre pas.
Q3/
charger() est async : la lecture dans SharedPreferences prend un petit temps et se termine après le premier rendu de l'interface (build).

Sans notifyListeners() à la fin de charger(), _favoris est bien rempli en mémoire, mais les widgets qui écoutent FavorisModel (Consumer / context.watch) ne sont pas avertis qu'il faut se redessiner : l'écran peut donc rester affiché comme vide ou avec l'ancien état sans lever d'erreur visible.