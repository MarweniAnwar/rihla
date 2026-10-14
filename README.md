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