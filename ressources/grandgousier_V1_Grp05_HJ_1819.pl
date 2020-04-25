%╔════════════════════════════════════════════════════════════════╗
%║                     Entêtes et librairies                      ║
%╚════════════════════════════════════════════════════════════════╝
	:- discontiguous(nez/2).
	:- discontiguous(description/2).
	:- discontiguous(bouche/2).
	:- discontiguous(nom/2).
	:- discontiguous(categorie/2).
	:- discontiguous(appellation/2).
	:- discontiguous(prix/2).
	:- discontiguous(regle_rep/4).
	:- discontiguous(accord/2).
	:- use_module(library(lists)).
%╔════════════════════════════════════════════════════════════════╗
%║             PRODUIRE_REPONSE(L_Mots,L_Lignes_reponse) :        ║
%║                                                                ║
%║  Input : une liste de mots L_Mots representant la question     ║
%║          de l'utilisateur                                      ║
%║  Output : une liste de liste de lignes correspondant a la      ║
%║                 reponse fournie par le bot                     ║
%╚════════════════════════════════════════════════════════════════╝

	produire_reponse([fin],[L1]) :-
	   L1 = [merci, de, m, '\'', avoir, consulte], !.    

	produire_reponse(L,Rep) :-

	   mclef(M,_), member(M,L),
	   clause(regle_rep(M,_,Pattern,Rep),Body),
	   match_pattern(Pattern,L),
	   call(Body), !.

	produire_reponse(_,[L1]) :-
	   L1 = [je, ne , connais, pas, la, reponse, a, cette, question, ',', desole, '.'].

%╔════════════════════════════════════════════════════════════════╗
%║                 Gestion des données entrées                    ║
%╚════════════════════════════════════════════════════════════════╝
	% ┌───────────────────────────────────────────────────────────┐
	% │ pattern matching							          	  │
	% └───────────────────────────────────────────────────────────┘
		match_pattern(Pattern,Lmots) :-
		   tous_noms_uniformes(Lmots,L_mots_unif),
		   sublist(Pattern,L_mots_unif).

		sublist(SL,L) :- prefix(SL,L), !.
		sublist(SL,[_|T]) :- sublist(SL,T).

	% ┌───────────────────────────────────────────────────────────┐
	% │ Uniformiser les noms de vins, régions et appellations     │
	% └───────────────────────────────────────────────────────────┘

		tous_noms_uniformes(Lmots,L_mots_unif):-
			nom_vins_uniforme(Lmots,Lmots1),	
			nom_app_uniforme(Lmots1,Lmots2),
		    nom_cat_uniforme(Lmots2,Lmots3),
		    nom_met_uniforme(Lmots3, L_mots_unif).

		nom_cat_uniforme(Lmots, L_mots_unif):-
			L1 = Lmots,
			replace_mots([bordeaux], bordeaux,L1,L2),
			replace_mots([cotes, du, rhone],rhoneLanguedoc,L2,L3),
			replace_mots([languedoc],rhoneLanguedoc,L3,L4),
			replace_mots([beaujolais], beaujolais,L4,L5),
			replace_mots([val, de, loire],valLoire,L5,L6),
			replace_mots([vin, blanc],blancs,L6,L7),
			L_mots_unif = L7.

		nom_met_uniforme(Lmots, L_mots_unif):-
			L1 = Lmots,
			replace_mots([viande, rouge], viandeRouge,L1,L2),
			replace_mots([viande, blanche],viandeBlanche,L2,L3),
			replace_mots([plat, sucre],sucreDessert,L3,L4),
			replace_mots([fromage], fromage,L4,L5),
			replace_mots([poisson],poissonEntree,L5,L6),
			replace_mots([entree],poissonEntree,L6,L7),
			replace_mots([dessert],sucreDessert,L7,L8),
		    replace_mots([volaille],viandeBlanche,L8,L9),
		    replace_mots([poulet],viandeBlanche,L9,L10),
		    replace_mots([chapon],viandeBlanche,L10,L11),
		    replace_mots([boeuf],viandeRouge,L11,L12),
		    replace_mots([canard],viandeRouge,L12,L13),
		    replace_mots([agneau],viandeRouge,L13,L14),
		    replace_mots([porc],viandeBlanche,L14,L15),
		    replace_mots([veau],viandeBlanche,L15,L16),
		    replace_mots([lapin],viandeBlanche,L16,L17),
		    replace_mots([mouton],viandeRouge,L17,L18),
		    replace_mots([gibier],viandeRouge,L18,L19),
		    replace_mots([sanglier],viandeRouge,L19,L20),
		    replace_mots([dinde],viandeBlanche,L20,L21),
		    replace_mots([biche],viandeRouge,L21,L22),
		    replace_mots([saumon],poissonEntree,L22,L23),
		    replace_mots([truite],poissonEntree,L23,L24),
		    replace_mots([thon],poissonEntree,L24,L25),
		    replace_mots([hareng],poissonEntree,L25,L26),
		    replace_mots([raie],poissonEntree,L26,L27),
		    replace_mots([bar],poissonEntree,L27,L28),
		    replace_mots([sole],poissonEntree,L28,L29),
		    replace_mots([rouget],poissonEntree,L29,L30),
		    replace_mots([merlan],poissonEntree,L30,L31),
		    replace_mots([perche],poissonEntree,L31,L32),
		    replace_mots([lotte],poissonEntree,L32,L33),
		    replace_mots([fruits, de, mer],poissonEntree,L33,L34),
			L_mots_unif = L34.

		nom_app_uniforme(Lmots,L_mots_unif) :-
		    L1 = Lmots,
		    
			replace_mots([bordeaux],bordeaux,L1,L2),
		    replace_mots([bordeaux,superieur],bordeaux_sup,L2,L3),
		    replace_mots([blaye,cotes,de,bordeaux],bord_blaye,L3,L4),
		    replace_mots([cotes,de,bordeaux,castillon],bord_castillon,L4,L5),
		    replace_mots([graves],graves,L5,L6),
		    replace_mots([madiran],madiran,L6,L7),
		    replace_mots([bordeaux],bordeaux,L7,L8),
		    replace_mots([bordeaux,superieur],bordeaux_sup,L8,L9),
		    replace_mots([cotes,de,bordeaux,claye],blaye,L9,L10),
		    replace_mots([cotes,de,bordeaux,castillon],castillon,L10,L11),
		    replace_mots([graves],graves,L11,L12),
		    replace_mots([madiran],madiran,L12,L13),
		    replace_mots([medoc],medoc,L13,L14),
		    replace_mots([saint,emilion],stEmilion,L14,L15),
		    replace_mots([lalande,de,pomerol],pomerol,L15,L16),
		    replace_mots([saint,estephe],stEstephe,L16,L17),
		    replace_mots([pauillac],pauillac,L17,L18),
		    replace_mots([saint,julien],stJulien,L18,L19),
		    replace_mots([pomerol],pomerol,L19,L20),
		    replace_mots([pays,'d\'oc'],paysOc,L20,L21),
		    replace_mots([cotes,du,rhone,villages],rhoneVillages,L21,L22),
		    replace_mots([cotes,du,roussillon,villages],roussillonVillages,L22,L23),
		    replace_mots([lirac],lirac,L23,L24),
		    replace_mots([beaumes,de,venise],beaumeVenise,L24,L25),
		    replace_mots([vacqueyras],vacqueyras,L25,L26),
		    replace_mots([saint,joseph],stJoseph,L26,L27),
		    replace_mots([gigondas],gigondas,L27,L28),
		    replace_mots([chateauneuf,du,pape],cndp,L28,L29),
		    replace_mots([hermitage],hermitage,L29,L30),
		    replace_mots([coteaux,bourguignons],coteauxBourguignons,L30,L31),
		    replace_mots([hautes,cotes,de,nuits],coteNuits,L31,L32),
		    replace_mots([savigny,les,beaune],savignyBeaunes,L32,L33),
		    replace_mots([aloxe,corton],aloxeCorton,L33,L34),
		    replace_mots([nuits,saint,georges],nuitsStGeorges,L34,L35),
		    replace_mots([chambolle,musigny],chambolleMusigny,L35,L36),
		    replace_mots([chiroubles],chiroubles,L36,L37),
		    replace_mots([fleurie],fleurie,L37,L38),
		    replace_mots([moulin,a,vent],moulinVent,L38,L39),
		    replace_mots([chinon],chinon,L39,L40),
		    replace_mots([sancerre],sancerre,L40,L41),
		    replace_mots([cotes,de,duras],cotesDuras,L41,L42),

			L_mots_unif=L42.

		nom_vins_uniforme(Lmots,L_mots_unif) :-
		   L1 = Lmots,
		   replace_mots([beaumes,de,venise,2015],beaumes_de_venise_2015,L1,L2),
			 replace_mots([les,chaboeufs,2013],les_chaboeufs_2013,L2,L3),
			 replace_mots([ch,moulin,de,mallet,2014],bordeaux_2014,L3,L4),
			 replace_mots([ch,la,fleur,baudron,2014],bordeaux_superieur_2014,L4,L5),
			 replace_mots([ch,bois,vert,cuvee,elegance,2014],cotes_de_bordeaux_blaye_2014,L5,L6),
			 replace_mots([ch,paret,2012],cotes_de_bordeaux_castillion_2012,L6,L7),
			 replace_mots([ch,menota,cuvee,montgarede,2014],graves_2014,L7,L8),
			 replace_mots([madiran,vieilles,vignes,2006],madiran_vieilles_vignes_2006,L8,L9),
			 replace_mots([ch,du,moulin,neuf,cuvee,prestige,2014],medoc_2014,L9,L10),
			 replace_mots([ch,milon,la,grave,cuvee,particuliere,2012],lussac_saint_emilion_2012,L10,L11),
			 replace_mots([ch,roc,de,binet,2010],montagne_saint_emilion_2010,L11,L12),
			 replace_mots([ch,ruat,petit,poujeaux,2010],moulis_en_medoc_2010,L12,L13),
			 replace_mots([ch,les,polyanthas,2010],saint_emilion_2010,L13,L14),
			 replace_mots([ch,la,menotte,2012],lalande_de_pomerol_2012,L14,L15),
			 replace_mots([la,fleur,de,pomys,2012],saint_estephe_2012,L15,L16),
			 replace_mots([florilege,pauillac,2011],florilege_pauillac_2011,L16,L17),
			 replace_mots([florilege,saint,julien,2010],florilege_saint_julien_2010,L17,L18),
			 replace_mots([florilege,pomerol,2012],florilege_pomerol_2012,L18,L19),
			 replace_mots([syrah,2015,2012],vin_de_pays_d_oc_2015,L19,L20),
			 replace_mots([cotes,du,rhone,villages,2014],cuvee_pierre_et_charlotte_2014,L20,L21),
			 replace_mots([tautavel,2014],cotes_du_roussilion_villages_2014,L21,L22),
			 replace_mots([lirac,2015],lirac_2015,L22,L23),
			 replace_mots([cairanne,2014],cairanne_2014,L23,L24),
			 replace_mots([vacqueyras,2014],vacqueyras_2014,L24,L25),
			 replace_mots([saint,joseph,2014],saint_jospeh_2014,L25,L26),
			 replace_mots([gigondas,2014],gigondas_2014,L26,L27),
			 replace_mots([chateauneuf,du,ppe,rouge,2013],chateauneuf_2013,L27,L28),
			 replace_mots([hermitage,rouge,2007],hermitage_rouge_2007,L28,L29),
			 replace_mots([coteaux,bourguignons,2014],coteaux_bourguignons_2014,L29,L30),
			 replace_mots([bourgogne,pinot,noir,2014],bourgogne_pinot_noir_2014,L30,L31),
			 replace_mots([hautes,cotes,de,nuits,2014],hautes_cotes_de_nuits_2014,L31,L32),
			 replace_mots([savigny,les,beaune,2014],savigny_les_beaunes_2014,L32,L33),
			 replace_mots([savigny,les,beaune,premier,cru,2014],aux_serpentieres_2014,L33,L34),
			 replace_mots([aloxe,corton,2014],aloxe_corton_2014,L34,L35),
			 replace_mots([nuits,saint,georges,premier,cru,2013],les_chaboeufs_2013,L35,L36),
			 replace_mots([chambolle,musigny,premier,cru,2012],les_noirots_2012,L36,L37),
			 replace_mots([fleurie,2015],fleurie_2015,L37,L38),
			 replace_mots([moulin,a,vent,2014],moulin_a_vent_2014,L38,L39),
			 replace_mots([chinon,vieilles,vignes,2014],chinon_vieilles_vignes_2014,L39,L40),
			 replace_mots([sancerre,rouge,2015],sancerre_rouge_2015,L40,L41),
			 replace_mots([les,guignards,2015],aoc_cotes_de_duras_2015,L41,L42),
			 replace_mots([chardonnay,exception,2016],vin_de_pays_d_oc_2016,L42,L43),
			 replace_mots([savigny,les,beaune,'1er',cru,2014],aux_serpentieres_2014,L43,L44),
			 replace_mots([nuits,saint,georges,'1er',cru,2013],les_chaboeufs_2013,L44,L45),
			 replace_mots([chambolle,musigny,'1er',cru,2012],les_noirots_2012,L45,L46),

		   L_mots_unif = L46.
		   
		replace_mots(L,X,In,Out) :-
		   append(L,Suf,In), !, Out = [X|Suf].
		replace_mots(_,_,[],[]) :- !.
		replace_mots(L,X,[H|In],[H|Out]) :-
		   replace_mots(L,X,In,Out).

%╔════════════════════════════════════════════════════════════════╗
%║                       Base de données                          ║
%╚════════════════════════════════════════════════════════════════╝
	% ┌───────────────────────────────────────────────────────────┐
	% │ Description des vins 								      │
	% └───────────────────────────────────────────────────────────┘

		nom(bordeaux_2014,'Ch.moulin de Mallet 2014 - Bordeaux').
		bouche(bordeaux_2014,
		[	['en bouche, il presente un bel eventail aromatique et '],
			['des tannins fins', '.']
		]).
		nez(bordeaux_2014,
		[	['il est tendrement parfume de fruits rouges (cerises, mures)','.']
		]).
		description(bordeaux_2014,
		[	['joli vin, classique, polyvalent','.']
		]).
		categorie(bordeaux_2014,bordeaux).
		prix(bordeaux_2014, 6.85).
		appellation(bordeaux_2014,bordeaux).
		accord(bordeaux_2014,viandeBlanche).

		%...............................................................
		nom(bordeaux_superieur_2014,'Ch.la Fleur Baudron 2014 - Bordeaux Superieur').
		bouche(bordeaux_superieur_2014,
		[	['bouche tres plaisante, riche, et de beaux tannins associes a un boise bien integre','.']
		]).
		nez(bordeaux_superieur_2014,
		[	['il presente des aromes de fruits compotes et d\'epices fines associees a une nuance florale (violette)','.']
		]).
		description(bordeaux_superieur_2014,
		[	['magnifique terroir a l\'arriere de Lussac-Saint-Emilion reposant sur des sols'],
			['graveleux et argilo-calcaires','.']
		]).
		categorie(bordeaux_superieur_2014,bordeaux).
		prix(bordeaux_superieur_2014, 7.48).
		appellation(bordeaux_superieur_2014,bordeaux_sup).
		accord(bordeaux_superieur_2014,viandeBlanche).

		%...............................................................
		nom(cotes_de_bordeaux_blaye_2014,'Ch.Bois Vert "Cuvee Elegance" 2014 - Cotes de Bordeaux-Blaye').
		bouche(cotes_de_bordeaux_blaye_2014,
		[	['en bouche les saveurs sont genereuses, tres plaisantes avec cette rondeur caracteristique'],
			['du merlot','.']
		]).
		nez(cotes_de_bordeaux_blaye_2014,
		[	['il presente une jolie note boisee qui s\'integre avec elegance aux aromes dominants de violette'],
			['et de cassis, associes a une nuance empyreumatique','.']
		]).
		description(cotes_de_bordeaux_blaye_2014,
		[	['appellation de la region de Bordeaux, appreciee et reputee'],
			['particulierement en Belgique, pour la souplesse et la qualite de ses vins','.']
		]).
		categorie(cotes_de_bordeaux_blaye_2014,bordeaux).
		prix(cotes_de_bordeaux_blaye_2014, 8.11).
		appellation(cotes_de_bordeaux_blaye_2014,blaye).
		accord(cotes_de_bordeaux_blaye_2014,sucreDessert).

		%...............................................................
		nom(cotes_de_bordeaux_castillion_2012,'Ch.Paret 2012 - Cotes de bordeaux-Castillon').
		bouche(cotes_de_bordeaux_castillion_2012,
		[	['bouche alliant matiere et densite, avec une grande maturite, de belles'],
			['notes de fruits noirs, de chocolat et une touche de sous-bois (aiguilles de pin)','.']
		]).
		nez(cotes_de_bordeaux_castillion_2012,
		[	['nez profond, annonce un vin riche, concentre','.']
		]).
		description(cotes_de_bordeaux_castillion_2012,
		[	['propriete situee dans l\'excellente zone des coteaux de'],
			['l appellation qui jouxte celle de Saint-Emilion, de nature argilo-calcaire (St-Genes)','.']
		]).
		categorie(cotes_de_bordeaux_castillion_2012,bordeaux).
		prix(cotes_de_bordeaux_castillion_2012, 8.68).
		appellation(cotes_de_bordeaux_castillion_2012,castillon).
		accord(cotes_de_bordeaux_castillion_2012,viandeRouge).

		%...............................................................
		nom(graves_2014,'Ch.Menota "Cuvee Montgarede"2014 - Graves').
		bouche(graves_2014,
		[	['texture en bouche ronde et veloutee aux tannins soyeux, l\'ensemble'],
			['est dense, d\'un remarquable equilibre, Finale cacaotee aux saveurs genereuses','.']
		]).
		nez(graves_2014,
		[	['son nez presente fruits noirs et d\'epices associees a des nuances empyreumatiques','.']
		]).
		description(graves_2014,
		[	['propriete situee au sud de Pessac-Leognan en bordure'],
			['de la Garonne ayant beneficie d\'un bon amoncellement de graves garonnaises','.']
		]).
		categorie(graves_2014,bordeaux).
		prix(graves_2014, 9.46).
		appellation(graves_2014,graves).
		accord(graves_2014,viandeRouge).

		%...............................................................

		nom(madiran_vieilles_vignes_2006,'Madiran Vieilles Vignes 2006').
		bouche(madiran_vieilles_vignes_2006,
		[	['bouche aux notes de fruits noirs, et une touche typique de cacao','.']
		]).
		nez(madiran_vieilles_vignes_2006,
		[	['au nez, un vin charpente, riche en tannins, certes puissant, mais pas austere','.']
		]).
		description(madiran_vieilles_vignes_2006,
		[	['le temps a permis a ce cru de s\'epanouir et d\'offrir aujourd\'hui'],
			['une merveilleuse palette d\'aromes et de saveurs','.']
		]).
		categorie(madiran_vieilles_vignes_2006,bordeaux).
		prix(madiran_vieilles_vignes_2006, 9.92).
		appellation(madiran_vieilles_vignes_2006,madiran).
		accord(madiran_vieilles_vignes_2006,viandeRouge).

		%...............................................................
		nom(medoc_2014,'Ch.du Moulin Neuf "Cuvee Prestige" 2014 - Medoc').
		bouche(medoc_2014,
		[	['vin de belle maturite, avec des tannins murs. Joli boise, bien integre','.'] 
		]).
		nez(medoc_2014,
		[	['au nez, la dominante cabernet se fait sentir des l\'ouverture avec des notes'],
			['de fruits noirs confitures (myrtilles, mures) associes a des notes'],
			['fumees et chocolatees','.']
		]).
		description(medoc_2014,
		[	['petite propriete de 2,5 Ha au nord de l\'AOC Medoc'],
			['terroir graveleux sur fond argilo-ferrugineux. Belle cuvee qui'],
			['temoigne de la reussite des cabernets dans le Medoc en 2014','.']
		]).
		categorie(medoc_2014,bordeaux).
		prix(medoc_2014, 10.3).
		appellation(medoc_2014,medoc).
		accord(medoc_2014,sucreDessert).

		%...............................................................

		nom(lussac_saint_emilion_2012,'Ch.Milon La Grave "Cuvee Particuliere" 2012 - Lussac-Saint-Emilion').
		bouche(lussac_saint_emilion_2012,
		[ 	['en bouche les saveurs sont denses et cremeuses, avec beaucoup d\'harmonie','.']
		]).
		nez(lussac_saint_emilion_2012,
		[	['nez de grande intensite avec un fruite remarquable des fruits rouges'],
			['(fraise, groseille), de la violette et des nuances empyreumatiques','.']
		]).
		description(lussac_saint_emilion_2012,
		[	['cette cuvee, composee presque exclusivement de merlot, s\'inscrit'],
			['dans un style tres veloute','.']
		]).
		categorie(lussac_saint_emilion_2012,bordeaux).
		prix(lussac_saint_emilion_2012, 12.54).
		appellation(lussac_saint_emilion_2012,stEmilion).
		accord(lussac_saint_emilion_2012,viandeBlanche).

		%...............................................................
		nom(montagne_saint_emilion_2010,'Ch.Roc de Binet 2010 - Montagne-Saint-Emilion').
		bouche(montagne_saint_emilion_2010,
		[	['tres riche en saveurs. Sensation de richesse, d\'etoffe, de densite'],
			['a l\'attaque, la finale devoile des tannins puissants mais bien integres,'],
			['enrobes par le gras du vin','.']
		]).
		nez(montagne_saint_emilion_2010,
		[	['au nez, grande intensite aromatique, fruits (cassis, cerise), fleur (violette), et truffe','.']
		]).
		description(montagne_saint_emilion_2010,
		[	['sa robe est profonde','.']
		]).
		categorie(montagne_saint_emilion_2010,bordeaux).
		prix(montagne_saint_emilion_2010, 12.69).
		appellation(montagne_saint_emilion_2010,stEmilion).
		accord(montagne_saint_emilion_2010,viandeRouge).

		%...............................................................

		nom(moulis_en_medoc_2010,'Ch.Ruat "Petit Poujeaux" 2010 - Moulis-en-Medoc').
		bouche(moulis_en_medoc_2010,
		[	['aromes de fruits noirs (cassis, myrtilles) associes a des nuances delicatement'],
			['torrefiees, charnues, serrees, riches, concentrees et onctueuses','.']
		]).
		nez(moulis_en_medoc_2010,
		[	['nez intense, tout en elegance, profondeur et complexite','.']
		]).
		description(moulis_en_medoc_2010,
		[	['sis sur un terroir de fines graves blanches, similaire a de nombreux egards'],
			['aux terroirs de Margaux','.']
		]).
		categorie(moulis_en_medoc_2010,bordeaux).
		prix(moulis_en_medoc_2010, 14.37).
		appellation(moulis_en_medoc_2010,medoc).
		accord(moulis_en_medoc_2010,viandeRouge).

		%...............................................................

		nom(saint_emilion_2010,'Ch.Les Polyanthas 2010 - Saint-Emilion').
		bouche(saint_emilion_2010,
		[	['en bouche, les saveurs truffees, fruitees et epicees de l\'attaque '],
			['font place a une note chocolatee en finale','.']
		]).
		nez(saint_emilion_2010,
		[	['il sent bon','.']
		]).
		description(saint_emilion_2010,
		[	['le merlot affectionne tout particulierement les sols de sables et'],
			['de graves de cette petite propriete de 4 Ha; il y exprime'],
			['toute sa rondeur, son opulence','.']
		]).
		categorie(saint_emilion_2010,bordeaux).
		prix(saint_emilion_2010, 15.06).
		appellation(saint_emilion_2010,stEmilion).
		accord(saint_emilion_2010,viandeBlanche).

		%...............................................................

		nom(lalande_de_pomerol_2012,'Ch.La Menotte 2012 - Lalande-de-Pomerol').
		bouche(lalande_de_pomerol_2012,
		[	['la texture en bouche est veloutee, racee, d\'une grande etoffe','.']
		]).
		nez(lalande_de_pomerol_2012,
		[	['nee d\'un bouquet intense, aux aromes de fruits et de fleurs associes a des nuances'],
			['truffees, grain de cafe et violette','.']
		]).
		description(lalande_de_pomerol_2012,
		[	['robe profonde, rouge velours','.']
		]).
		categorie(lalande_de_pomerol_2012,bordeaux).
		prix(lalande_de_pomerol_2012, 15.71).
		appellation(lalande_de_pomerol_2012,pomerol).
		accord(lalande_de_pomerol_2012,viandeBlanche).

		%...............................................................

		nom(saint_estephe_2012,'La Fleur de Pomys 2012 - Saint-Estephe').
		bouche(saint_estephe_2012,
		[	['en bouche ses saveurs sont riches et concentrees, avec beaucoup de densite','.']
		]).
		nez(saint_estephe_2012,
		[	['son nez empyreumatique annonce un vin complexe et concentre, aromes de myrtille'],
			['et de cassis se melent a des notes florales et a un boise bien integre','.']
		]).
		description(saint_estephe_2012,
		[	['propriete du Nord du Haut-Medoc reposant sur un terroir argilo-graveleux'],
			['a l\'origine de vins plus charpentes. Robe profonde','.']
		]).
		categorie(saint_estephe_2012,bordeaux).
		prix(saint_estephe_2012, 21.36).
		appellation(saint_estephe_2012,stEstephe).
		accord(saint_estephe_2012,viandeRouge).

		%...............................................................

		nom(florilege_pauillac_2011,'Florilege Pauillac 2011').
		bouche(florilege_pauillac_2011,
		[	['la bouche est puissante, mais les tannins sont elegants et bien enrobes']
		]).
		nez(florilege_pauillac_2011,
		[	['son nez est concentre, sur les fruits noirs, avec une touche bois'],
			['de vigne et une note reglisse']
		]).
		description(florilege_pauillac_2011,
		[	['d\'une robe velours. Le compagnon ideal des preparations de gibier']
		]).
		categorie(florilege_pauillac_2011,bordeaux).
		prix(florilege_pauillac_2011, 30.65).
		appellation(florilege_pauillac_2011,pauillac).
		accord(florilege_pauillac_2011,viandeRouge).

		%...............................................................

		nom(florilege_saint_julien_2010,'Florilege Saint-Julien 2010').
		bouche(florilege_saint_julien_2010,
		[	['en bouche, la sensation est dense et cremeuse ']
		]).
		nez(florilege_saint_julien_2010,
		[	[' il sent bon']
		]).
		description(florilege_saint_julien_2010,
		[	['c\'est un vin temoin de l\'appellation Saint-Julien avec une trame '],
			['tannique remarquablement enrobee par le gras, la chair du vin. ']
		]).
		categorie(florilege_saint_julien_2010,bordeaux).
		prix(florilege_saint_julien_2010, 30.65).
		appellation(florilege_saint_julien_2010,stJulien).
		accord(florilege_saint_julien_2010,viandeBlanche).

		%...............................................................

		nom(florilege_pomerol_2012,'Florilege Pomerol 2012').
		bouche(florilege_pomerol_2012,
		[	['en bouche, des saveurs riches et intenses au toucher veloute. '],
			['L\'ensemble est cremeux, dense et concentre.']
		]).
		nez(florilege_pomerol_2012,
		[	['son nez presente un bouquet intense avec une dominante de fruits rouges'],
			['associes a de subtiles nuances torrefiees et epicees']
		]).
		description(florilege_pomerol_2012,
		[	['ce vin est issu de sols riches en argile ferrugineuse '],
			['qui font la specificite de l\'appellation']
		]).
		categorie(florilege_pomerol_2012,bordeaux).
		prix(florilege_pomerol_2012, 31.04).
		appellation(florilege_pomerol_2012,pomerol).
		accord(florilege_pomerol_2012,sucreDessert).

		%...............................................................


		nom(vin_de_pays_d_oc_2015,'Syrah 2015 - Vin de Pays d\'Oc').
		bouche(vin_de_pays_d_oc_2015,
		[	['beau caractere en bouche, avec des saveurs enrobees de fruits rouges associees'],
			['a des nuances de reglisse']
		]).
		nez(vin_de_pays_d_oc_2015,
		[	['nez expressif melant les fruits rouges, les agrumes a de jolies notes d\'epices']
		]).
		description(vin_de_pays_d_oc_2015,
		[	['belle robe rouge profond']
		]).
		categorie(vin_de_pays_d_oc_2015,rhoneLanguedoc).
		prix(vin_de_pays_d_oc_2015, 5.14).
		appellation(vin_de_pays_d_oc_2015,paysOc).
		accord(vin_de_pays_d_oc_2015,viandeBlanche).

		%...............................................................

		nom(cuvee_pierre_et_charlotte_2014,'Cotes du Rhone Villages 2014 "Cuvee Pierre et Charlotte" ').
		bouche(cuvee_pierre_et_charlotte_2014,
		[	['en bouche l\'attaque est tout en fruit avec des saveurs fruitees et epicees,'],
			['la suite est de caractere, racee avec une nuance de reglisse']
		]).
		nez(cuvee_pierre_et_charlotte_2014,
		[	['le nez presente un bouquet plein de charme, tres aromatique. Les aromes de fruits '],
			['rouges (mures, fruits a noyaux) s\'allient a des nuances de garrigue'],
			['(bois de cedre) et d\'agrumes']
		]).
		description(cuvee_pierre_et_charlotte_2014,
		[	['magnifique terroir argile-limoneux a proximite de l\'Aygues']
		]).
		categorie(cuvee_pierre_et_charlotte_2014,rhoneLanguedoc).
		prix(cuvee_pierre_et_charlotte_2014, 7.36).
		appellation(cuvee_pierre_et_charlotte_2014,rhoneVillages).
		accord(cuvee_pierre_et_charlotte_2014,viandeBlanche).

		%...............................................................

		nom(cotes_du_roussilion_villages_2014,'Tautavel 2014 - Cotes du Roussillon Villages').
		bouche(cotes_du_roussilion_villages_2014,
		[	['la bouche devoile d\'abord des saveurs de fruits frais et d\'epices.'],
			['Elle est remarquablement concentree. Finale cacao, a la fois dense,'],
			['puissante, juteuse et harmonieuse']
		]).
		nez(cotes_du_roussilion_villages_2014,
		[	['au nez, un bouquet intense de fruits noirs (noyaux) et d\'epices'],
			[' associe a des notes de chocolat et de garrigue']
		]).
		description(cotes_du_roussilion_villages_2014,
		[	['robe noire']
		]).
		categorie(cotes_du_roussilion_villages_2014,rhoneLanguedoc).
		prix(cotes_du_roussilion_villages_2014, 7.37).
		appellation(cotes_du_roussilion_villages_2014,roussillonVillages).
		accord(cotes_du_roussilion_villages_2014,sucreDessert).

		%...............................................................
		nom(lirac_2015,'Lirac 2015').
		bouche(lirac_2015,
		[	['la bouche est a la fois dense et minerale, avec des saveurs '],
			['fruitees et epicees (aiguilles de pin, eucalyptus).']
		]).
		nez(lirac_2015,
		[	['nez parfume, domine par les fruits a noyaux et les epices '],
			['(cannelle, reglisse)']
		]).
		description(lirac_2015,
		[	['vignoble sur la rive droite du Rhone, face a Chateauneuf-du-Pape.'],
			['Robe grenat profond']
		]).
		categorie(lirac_2015,rhoneLanguedoc).
		prix(lirac_2015, 9.23).
		appellation(lirac_2015,lirac).
		accord(lirac_2015,viandeBlanche).

		%...............................................................


		nom(cairanne_2014,'Cairanne 2014 - Cotes du Rhone Villages').
		bouche(cairanne_2014,
		[	['la bouche est equilibree avec des tannins soyeux. '],
			['Finale de caractere, de belle persistance. ']
		]).
		nez(cairanne_2014,
		[	['au nez, les aromes sont tres expressifs, tres purs, bien types,'],
			['evoquant la guimauve, le bois de genevrier, le tabac. ']
		]).
		description(cairanne_2014,
		[	['magnifique terroir a cote de Rasteau, en altitude.'],
			['Robe profonde, couleur cerise du Nord. ']
		]).
		categorie(cairanne_2014,rhoneLanguedoc).
		prix(cairanne_2014, 9.98).
		appellation(cairanne_2014,rhoneVillages).
		accord(cairanne_2014,viandeRouge).

		%...............................................................

		nom(beaumes_de_venise_2015,'Beaumes-de-Venise 2015').
		bouche(beaumes_de_venise_2015, 
		[ 	[ 'les aromes de fraise, de violette cotoient les nuances' ],
		    [ 'de baies de genevrier, de sureau et une delicate touche' ],
		    [ 'de fleur d oranger. Cette intensite se poursuit en' ],
		    [ 'bouche avec des saveurs juteuses, racees et tres elegantes', '.' ]
		]).
		nez(beaumes_de_venise_2015, 
		[ 	[ 'nez intensement parfume','.' ] 
		]).
		description(beaumes_de_venise_2015, 
		[ 	[ 'vignoble situe au sud-est des Dentelles de Montmirail', '.' ],
			[ 'grand vin', '.' ]
		]).
		categorie(beaumes_de_venise_2015,rhoneLanguedoc).
		prix(beaumes_de_venise_2015, 12.39).
		appellation(beaumes_de_venise_2015,beaumeVenise).
		accord(beaumes_de_venise_2015,viandeBlanche).

		%...............................................................

		nom(vacqueyras_2014,'Vacqueyras 2014').
		bouche(vacqueyras_2014,
		[	['en bouche les saveurs sont a la fois intenses (fruits surmuris,'],
			['guimauve, reglisse) et juteuses, dense et veloute','.']
		]).
		nez(vacqueyras_2014,
		[	['le nez de la cuvee est tres aromatique','.']
		]).
		description(vacqueyras_2014,
		[	['les sols caillouteux de Vacqueyras sont a l\'origine de vins chaleureux,'],
			['fruites et epices','.']
		]).
		categorie(vacqueyras_2014,rhoneLanguedoc).
		prix(vacqueyras_2014, 13.92).
		appellation(vacqueyras_2014,vacqueyras).
		accord(vacqueyras_2014,sucreDessert).

		%...............................................................

		nom(saint_jospeh_2014,'Saint-Joseph 2014').
		bouche(saint_jospeh_2014,
		[	['en bouche, un vin aromatique, race, genereux, concentre, puissant et long,'],
			[' tout en conservant une belle harmonie','.']
		]).
		nez(saint_jospeh_2014,
		[	['nez tres aromatique, avec beaucoup de fruit (pamplemousse), des notes'],
			['d\'epices (poivre), et une nuance empyreumatique (bois brule)','.']
		]).
		description(saint_jospeh_2014,
		[	['vin \"type\" syrab du Nord','.']
		]).
		categorie(saint_jospeh_2014,rhoneLanguedoc).
		prix(saint_jospeh_2014, 16.34).
		appellation(saint_jospeh_2014,stJoseph).
		accord(saint_jospeh_2014,viandeRouge).

		%...............................................................

		nom(gigondas_2014,'Gigondas 2014').
		bouche(gigondas_2014,
		[	['bouche racee, riche en saveurs complexes (fruits noirs, epices)','.']
		]).
		nez(gigondas_2014,
		[	['nez riche et concentre, annonce un vin tres elegant, avec un fond remarquable','.']
		]).
		description(gigondas_2014,
		[	['vignoble escarpe situe au pied des Dentelles de Montmirail, le terroir'],
			['y est caillouteux et particulierement adapte a la culture du cepage'],
			['grenache noir (present a 80%)','.']
		]).
		categorie(gigondas_2014,rhoneLanguedoc).
		prix(gigondas_2014, 16.77).
		appellation(gigondas_2014,gigondas).
		accord(gigondas_2014,sucreDessert).

		%...............................................................

		nom(chateauneuf_2013,'Chateauneuf-du-Pape rouge 2013').
		bouche(chateauneuf_2013,
		[	['en bouche les saveurs sont intenses, racees, riches et complexes','.']
		]).
		nez(chateauneuf_2013,
		[	['nez complexe, expressif et suave, associant aromes de fruits rouges,'],
			['de cannelle et d\'epices (poivre, reglisse)','.']
		]).
		description(chateauneuf_2013,
		[	['vignes reposant sur des terrasses du Quaternaire constituees'],
			['d\'une epaisse couche de galets roules, a l\'origine de vins puissants et charnus','.']
		]).
		categorie(chateauneuf_2013,rhoneLanguedoc).
		prix(chateauneuf_2013, 23.87).
		appellation(chateauneuf_2013,cndp).
		accord(chateauneuf_2013,viandeRouge).

		%...............................................................

		nom(hermitage_rouge_2007,'Hermitage rouge 2007').
		bouche(hermitage_rouge_2007,
		[	['grande harmonie en bouche, tres homogene, avec une belle profondeur. Aucune durete','.']
		]).
		nez(hermitage_rouge_2007,
		[	['nez au bouquet complexe, tres profond, associant les fruits noirs,'],
			['les agrumes a des notes de vanille, de tabac et de reglisse','.']
		]).
		description(hermitage_rouge_2007,
		[	['une complexite qui temoigne d\'un grand vin','.']
		]).
		categorie(hermitage_rouge_2007,rhoneLanguedoc).
		prix(hermitage_rouge_2007, 33.98).
		appellation(hermitage_rouge_2007,hermitage).
		accord(hermitage_rouge_2007,viandeBlanche).

		%...............................................................

		nom(coteaux_bourguignons_2014,'Coteaux Bourgignons 2014').
		bouche(coteaux_bourguignons_2014,
		[	['en bouche, l\'intensite de fruit se prolonge en bouche avec des saveurs juteuses','.']
		]).
		nez(coteaux_bourguignons_2014,
		[	['son nez degage des aromes de cerise associes a des nuances florales (violette) et minerales','.']
		]).
		description(coteaux_bourguignons_2014,
		[	['un excellent vin de bourgogne','.']
		]).
		categorie(coteaux_bourguignons_2014,bourgogne).
		prix(coteaux_bourguignons_2014, 7.99).
		appellation(coteaux_bourguignons_2014,coteauxBourguignons).
		accord(coteaux_bourguignons_2014,viandeBlanche).

		%...............................................................

		nom(bourgogne_pinot_noir_2014,'Bourgogne Pinot Noir 2014 - Cuvee les Marnes').
		bouche(bourgogne_pinot_noir_2014,
		[	['en bouche, un vin fin et concentre, avec des saveurs d\'une grande unite '],
			['l\'ensemble est genereux, frais, tendre et gourmand','.']
		]).
		nez(bourgogne_pinot_noir_2014,
		[	['son nez presente des aromes de griottes et de fruits des bois associes a de jolies notes epicees','.']
		]).
		description(bourgogne_pinot_noir_2014,
		[	['cuvee issue de vignes de la Cote de Nuits','.']
		]).
		categorie(bourgogne_pinot_noir_2014,bourgogne).
		prix(bourgogne_pinot_noir_2014, 11.92).
		appellation(bourgogne_pinot_noir_2014,coteNuits).
		accord(bourgogne_pinot_noir_2014,viandeBlanche).

		%...............................................................

		nom(hautes_cotes_de_nuits_2014,'Hautes Cotes de Nuits 2014').
		bouche(hautes_cotes_de_nuits_2014,
		[	['sa bouche devoile un vin au joli grain, d\'une texture souple, bien enrobee','.']
		]).
		nez(hautes_cotes_de_nuits_2014,
		[	['son nez est bien expressif, type fruits rouges (groseilles, griottes) et nuances florales','.']
		]).
		description(hautes_cotes_de_nuits_2014,
		[	['le vignoble des Hautes Cotes se situe sur le plateau entre 300 m'],
			['et 400 m d\'altitude sur les hauteurs de la Cote de Nuits','.']
		]).
		categorie(hautes_cotes_de_nuits_2014,bourgogne).
		prix(hautes_cotes_de_nuits_2014, 15.16).
		appellation(hautes_cotes_de_nuits_2014,cotesNuits).
		accord(hautes_cotes_de_nuits_2014,sucreDessert).

		%...............................................................

		nom(savigny_les_beaunes_2014,'Savigny-les-beaune 2014').
		bouche(savigny_les_beaunes_2014,
		[	['la bouche est tout en velours, avec du volume et de la rondeur,'],
			['melant les fruits rouges a une touche moka','.']
		]).
		nez(savigny_les_beaunes_2014,
		[	['le nez est intense, tres charmeur de fruits bien murs (griottes) associes'],
			['a des aromes de pain d\'epice','.']
		]).
		description(savigny_les_beaunes_2014,
		[	['belle robe','.']
		]).
		categorie(savigny_les_beaunes_2014,bourgogne).
		prix(savigny_les_beaunes_2014, 20.46).
		appellation(savigny_les_beaunes_2014,savignyBeaunes).
		accord(savigny_les_beaunes_2014,sucreDessert).

		%...............................................................

		nom(aux_serpentieres_2014,'Savigny-les-beaune 1er Cru 2014 "Aux Serpentieres"').
		bouche(aux_serpentieres_2014,
		[	['attaque velours. Beau volume en bouche, longueur et superbe gras en finale','.']
		]).
		nez(aux_serpentieres_2014,
		[	['nez gourmand de fruits rouges, note d\'encens, touche grain de cafe','.']
		]).
		description(aux_serpentieres_2014,
		[	['le Climat \" Aux Serpentieres \" est repute pour etre a l\'origine de vins'],
			['de caractere, denses et pleins','.']
		]).
		categorie(aux_serpentieres_2014,bourgogne).
		prix(aux_serpentieres_2014, 25.82).
		appellation(aux_serpentieres_2014,savignyBeaunes).
		accord(aux_serpentieres_2014,viandeBlanche).

		%...............................................................


		nom(aloxe_corton_2014,'Aloxe-Corton 2014').
		bouche(aloxe_corton_2014,
		[	['en bouche, il presente des saveurs plus corsees, bien typees du terroir d\'Aloxe ','.']
		]).
		nez(aloxe_corton_2014,
		[	['son nez presente une forte intensite aromatique (griotte, sous-bois, grain de cafe, epices, ...)','.']
		]).
		description(aloxe_corton_2014,
		[	['l\'ensemble est colore, dense et concentre','.']
		]).
		categorie(aloxe_corton_2014,bourgogne).
		prix(aloxe_corton_2014, 26.02).
		appellation(aloxe_corton_2014,aloxeCorton).
		accord(aloxe_corton_2014,viandeRouge).

		%...............................................................

		nom(les_chaboeufs_2013,'Nuits-Saint-Georges 1er Cru 2013, Les Chaboeufs').
		bouche(les_chaboeufs_2013,
		[	['en bouche, sa texture est d\'une belle epaisseur reunissant toutes les qualites attendues:'],
			['puissance, richesse, rondeur, generosite, et longueur', '.']
		]).
		nez(les_chaboeufs_2013,
		[	['son nez presente une intensite aromatique ou se melent, avec elegance, les notes de griotte,'],
			['de sous-bois (feuilles mortes) et de champignon','.']
		]).
		description(les_chaboeufs_2013,
		[	['son vignoble se trouve sur une parcelle escarpee, pierreuse', '.']
		]).
		categorie(les_chaboeufs_2013,bourgogne).
		prix(les_chaboeufs_2013, 42.35).
		appellation(les_chaboeufs_2013,nuitsStGeorges).
		accord(les_chaboeufs_2013,sucreDessert).

		%...............................................................

		nom(les_noirots_2012,'Chambolle-Musigny 1er Cru 2012 - Les Noirots').
		bouche(les_noirots_2012,
		[	['bouche complexe, avec des saveurs denses, concentrees et enrobees']
		]).
		nez(les_noirots_2012,
		[	['nez intense de fruits rouges, d\'epices (notes de poivre) meles'],
			['a des nuances empyreumatiques et de sous-bois','.']
		]).
		description(les_noirots_2012,
		[	['la parcelle \" les Noirots \" est une toute petite parcelle situee au sud'],
			['du celebre Grand Cru de Bonnes Mares','.']
		]).
		categorie(les_noirots_2012,bourgogne).
		prix(les_noirots_2012, 63.85).
		appellation(les_noirots_2012,chambolleMusigny).
		accord(les_noirots_2012,viandeRouge).

		%...............................................................

		nom(chiroubles_2013,'Chiroubles 2013').
		bouche(chiroubles_2013,
		[	['bouche fruitee avec une nuance florale et minerale','.']
		]).
		nez(chiroubles_2013,
		[	['nez tendrement parfume, domine par les fruits rouges (groseilles, fraises) et les epices','.']
		]).
		description(chiroubles_2013,
		[	['terroir granitique et schisteux d\'origine volcanique. C\'est dans cette region'],
			['que le gamay donne le meilleur de lui-meme','.']
		]).
		categorie(chiroubles_2013,beaujolais).
		prix(chiroubles_2013, 8.41).
		appellation(chiroubles_2013,chiroubles).
		accord(chiroubles_2013,viandeBlanche).

		%...............................................................

		nom(fleurie_2015,'Fleurie 2015').
		bouche(fleurie_2015,
		[	['en bouche, texture velours, generosite du fruit, des epices et des nuances florales,'],
			['L\'harmonie regne','.']
		]).
		nez(fleurie_2015,
		[	['nez fruite, notes d\'epices et nuances florales, on est sous le charme de l\'elegance','.']
		]).
		description(fleurie_2015,
		[	['fleurie est la Reine des Crus du Beaujolais ','.']
		]).
		categorie(fleurie_2015,beaujolais).
		prix(fleurie_2015, 11).
		appellation(fleurie_2015,fleurie).
		accord(fleurie_2015,sucreDessert).

		%...............................................................

		nom(moulin_a_vent_2014,'Moulin-a-Vent 2014').
		bouche(moulin_a_vent_2014,
		[	['en bouche, il presente beaucoup de complexite avec une jolie structure enrobee par le gras du vin','.']
		]).
		nez(moulin_a_vent_2014,
		[	['nez expressif domine par les fruits sauvages, la griotte et le sous-bois,'],
			['associes a une nuance de cire','.']
		]).
		description(moulin_a_vent_2014,
		[	['son terroir est a l\'origine de gamay vineux, tres concentres. robe grenat aux reflets rubis','.']
		]).
		categorie(moulin_a_vent_2014,beaujolais).
		prix(moulin_a_vent_2014, 11.4).
		appellation(moulin_a_vent_2014,moulinVent).
		accord(moulin_a_vent_2014,viandeBlanche).

		%...............................................................

		nom(chinon_vieilles_vignes_2014,'Chinon Vieilles Vignes 2014').
		bouche(chinon_vieilles_vignes_2014,
		[	['les saveurs sont d\'une remarquable intensite alliant structure, volume, race'],
			['et concentration','.']
		]).
		nez(chinon_vieilles_vignes_2014,
		[	['nez bien marque par le cabernet franc bien mur, avec des aromes de reglisse noire '],
			[', de vanille et de fruits rouges associes a une nuance sous-bois','.']
		]).
		description(chinon_vieilles_vignes_2014,
		[	['un magnifique Chinon, puissant et tres bien type. Gastronomique','.']
		]).
		categorie(chinon_vieilles_vignes_2014,valLoire).
		prix(chinon_vieilles_vignes_2014, 8.39).
		appellation(chinon_vieilles_vignes_2014,chinon).
		accord(chinon_vieilles_vignes_2014,viandeBlanche).

		%...............................................................

		nom(sancerre_rouge_2015,'Sancerre rouge 2015').
		bouche(sancerre_rouge_2015,
		[	['bouche delicieuse, charmeuse, deployant ses notes de fruits et d\'epices (notes de poivre)'],
			['avec fraicheur et elegance','.']
		]).
		nez(sancerre_rouge_2015,
		[	['nez aromatique et friand qui \" pinote \" (cerise rouge du Nord, fruits des bois,'],
			['sous-bois, champignons','.']
		]).
		description(sancerre_rouge_2015,
		[	['vin rond, ample, souple, et soyeux. La finale tres harmonieuse temoigne'],
			['de la maturite de ce cru','.']
		]).
		categorie(sancerre_rouge_2015,valLoire).
		prix(sancerre_rouge_2015, 15.13).
		appellation(sancerre_rouge_2015,sancerre).
		accord(sancerre_rouge_2015,viandeRouge).

		%...............................................................

		nom(aoc_cotes_de_duras_2015,'Les Guignards 2015 - AOC Cotes de Duras').
		bouche(aoc_cotes_de_duras_2015,
		[	['c\'est un vin expressif, bien equilibre, harmonieux, qui allie la fraicheur '],
			['du sauvignon a la tendresse de la muscadelle','.']
		]).
		nez(aoc_cotes_de_duras_2015,
		[	['nez charmeur, a la fois frais et expressif, evoquant des aromes de cassis'],
			['et de fruits du verger. Nuance d\'agrumes et de rose','.']
		]).
		description(aoc_cotes_de_duras_2015,
		[	['appellation voisine de la region de Bordeaux. Belle robe aux reflets verts','.']
		]).
		categorie(aoc_cotes_de_duras_2015,blancs).
		prix(aoc_cotes_de_duras_2015, 5.30).
		appellation(aoc_cotes_de_duras_2015,cotesDuras).
		accord(aoc_cotes_de_duras_2015,poissonEntree).

		%...............................................................

		nom(vin_de_pays_d_oc_2016,'Chardonnay Exception 2016 - Vin de Pays d\'Oc').
		bouche(vin_de_pays_d_oc_2016,
		[	['beaucoup d\'epices, de caractere et de volume. Un vin relativement puissant,'],
			['et une finale en rondeur, note boisee tout au long de la degustation','.']
		]).
		nez(vin_de_pays_d_oc_2016,
		[	['nez intense, expressif, aromes de fruits du verger, avec une touche boisee','.']
		]).
		description(vin_de_pays_d_oc_2016,
		[	['un vin blanc plein de caractere','.']
		]).
		categorie(vin_de_pays_d_oc_2016,blancs).
		prix(vin_de_pays_d_oc_2016, 6.47).
		appellation(vin_de_pays_d_oc_2016,paysOc).
		accord(vin_de_pays_d_oc_2016,fromage).

		% Prédicats par défaut, au cas où un vin recherché ne serait pas répertorié
		nom(_,'Vin Inconnu').
		bouche(_,
		[	['desole mais je ne connais pas encore ce vin.'],
			['Veuillez verifier l\'orthographe, ne pas faire usage de tirets et preciser le millesime.']
		]).
		nez(_,
		[	['desole, je ne connais pas encore ce vin.'],
			['Veuillez verifier l\'orthographe, ne pas faire usage de tirets et preciser le millesime. ']
		]).
		description(_,
		[	['desole, je ne connais pas encore ce vin.'],
			['Veuillez verifier l\'orthographe, ne pas faire usage de tirets et preciser le millesime. ']
		]).

	% ┌───────────────────────────────────────────────────────────┐
	% │ Noms des Catégories   (pour affichage)  			      │
	% └───────────────────────────────────────────────────────────┘
	    nom_categorie(bordeaux,'Bordeaux').
	    nom_categorie(rhoneLanguedoc,'Cotes du Rhone - Languedoc').
	    nom_categorie(bourgogne,'Bourgogne').
	    nom_categorie(beaujolais,'Beaujolais').
	    nom_categorie(valLoire,'Val de Loire').
	    nom_categorie(blanc, 'vin blanc').

	% ┌───────────────────────────────────────────────────────────┐
	% │ Noms des appellations (pour affichage)		              │
	% └───────────────────────────────────────────────────────────┘

	    nom_appellation(bordeaux, 'Bordeaux').
	    nom_appellation(bordeaux_sup, 'Bordeaux Superieur').
	    nom_appellation(bord_blaye, 'Blayes - Cotes de Bordeaux').
	    nom_appellation(bord_castillon,'Cotes de Bordeaux-Castillon').
	    nom_appellation(graves, 'Graves').
	    nom_appellation(madiran, 'Madiran').
	    nom_appellation(bordeaux, 'Bordeaux').
	    nom_appellation(bordeaux_sup, 'Bordeaux Superieur').
	    nom_appellation(blaye, 'Cotes-de-Bordeaux-Blaye' ).
	    nom_appellation(castillon, 'Cotes-de-Bordeaux-Castillon').
	    nom_appellation(graves, 'Graves').
	    nom_appellation(madiran, 'Madiran').
	    nom_appellation(medoc, 'Medoc').
	    nom_appellation(stEmilion, 'Saint-Emilion').
	    nom_appellation(pomerol, 'Lalande-de-Pomerol').
	    nom_appellation(stEstephe, 'Saint-Estephe').
	    nom_appellation(pauillac, 'Pauillac').
	    nom_appellation(stJulien, 'Saint-Julien'). 
	    nom_appellation(pomerol, 'Pomerol').
	    nom_appellation(paysOc, 'Pays d\'Oc').
	    nom_appellation(rhoneVillages, 'Cotes-du-Rhone Villages').
	    nom_appellation(roussillonVillages, 'Cotes-du-Roussillon Villages').
	    nom_appellation(lirac, 'Lirac').
	    nom_appellation(beaumeVenise, 'Beaumes-de-Venise').
	    nom_appellation(vacqueyras, 'Vacqueyras').
	    nom_appellation(stJoseph, 'Saint-Joseph').
	    nom_appellation(gigondas, 'Gigondas').
	    nom_appellation(cndp, 'Chateauneuf-du-Pape').
	    nom_appellation(hermitage, 'Hermitage').
	    nom_appellation(coteauxBourguignons, 'Coteaux-Bourguignons').
	    nom_appellation(coteNuits, 'Hautes-Cotes de Nuits').
	    nom_appellation(savignyBeaunes, 'Savigny-les-beaune').
	    nom_appellation(aloxeCorton, 'Aloxe-Corton').
	    nom_appellation(nuitsStGeorges, 'Nuits-Saint-Georges').
	    nom_appellation(chambolleMusigny, 'Chambolle-Musigny').
	    nom_appellation(chiroubles, 'Chiroubles').
	    nom_appellation(fleurie, 'Fleurie').
	    nom_appellation(moulinVent, 'Moulin-a-Vent').
	    nom_appellation(chinon, 'Chinon').
	    nom_appellation(sancerre, 'Sancerre').
	    nom_appellation(cotesDuras, 'Cotes-de-Duras').
    
	% ┌───────────────────────────────────────────────────────────┐
	% │ Description des appellations						      │
	% └───────────────────────────────────────────────────────────┘

	    appellation_desc(bordeaux,
	    [	['le bordeaux est un vin francais d\'appellation d\'origine controlee'],
	        ['produit dans le vignoble de Bordeaux. Il s\'agit de l\'appellation generique'],
	        ['de ce vaste vignoble : elle peut etre revendiquee sous certaines conditions'],
	        ['par tous les vins rouges, roses et blancs provenant des raisins recoltes'],
	        ['sur les communes viticoles du departement de la Gironde, a l\'exception'],
	        ['des zones de palus, des marais et des parties forestieres.']
	    ]).

	    appellation_desc(bordeaux_sup,
		[	['l\'AOC Bordeaux superieur est une AOC regionale, au meme titre que l\'AOC Bordeaux.'],
	 		['Les vins de cette appellation peuvent, eux aussi provenir de toute la region viticole bordelaise.'],
	  		['Pour pretendre a l\'appellation de Bordeaux superieur, les vins doivent repondre a des criteres'],
	   		['qualitatifs encore plus rigoureux que ceux de l\'AOC Bordeaux.'],
	   		['Ces vins doivent notamment etre elabores a partir de vignes agees'],
	   		['et etre eleves pendant neuf mois minimum avant leur commercialisation.']
		]).

		appellation_desc(bord_blaye,
		[	['l\'AOC Blaye - Cotes de Bordeaux, fait partie du Blayais, region la plus septentrionale du bordelais,'],
		 	['situee au nord ouest du vignoble bordelais sur la rive droite de la Gironde, en face du Medoc.'],
		  	['L\'appellation couvre aujourd\'hui 6.700 ha et produit 310.000 hl.'],
		  	[''],
			['Le terroir de l\'appellation est extremement diversifie, on compte pres de vingt types de sols differents'],
	 		['composes d\'argilo-calcaires, de calcaires, de sables et de graviers.']
		]).
		
		appellation_desc(bord_castillon,
		[	['depuis 2009, les Cotes-de-Castillon sont devenues une denomination '],
			['geographique au sein de l\'appellation Cotes-de-Bordeaux. '],
			['Cette AOC porte depuis le nom de Castillon-Cotes de Bordeaux. '],
			['Etendus sur 3.000 ha et produisant 160.000 hl de vins rouges, '],
			['les sols sont constitues d\'alluvions modernes vers le nord en bordure de Dordogne,'], 
			['sablo-graveleux ou sablo-argileux qui deviennent argilo-calcaires '],
			['ou marneux des que l\'on atteint les coteaux.']
		]).
		appellation_desc(graves,
		[	['l\'AOC Graves s\'etend sur 60 km et longe la rive gauche de la Garonne'],
		 	['jusqu\'a Langon. Le vignoble des Graves est limite au sud-ouest par la foret'], 
		 	['des Landes. Cette situation geographique ideale permet a la vigne d\'etre a la fois'],
		 	['protegee des intemperies, grace a la foret des Landes, et aussi de la secheresse,'],
		  	['grace a la Garonne. La vigne des Graves est cultivee sur une longue bande '],
		  	['graveleuse composee de cailloux, d\'argile et de calcaire a asteries. '],
		  	['Le terroir de cette AOC, typique de la region bordelaise, est si renomme qu\'il est'],
		  	['le seul a avoir donne son nom a une appellation.'], 
		  	['Le vignoble s\'etend sur 3.500 ha et produit chaque annee 163.000 hl de vins rouges et de vins blancs.']
		]).
		appellation_desc(madiran,
		[	['l\'AOC Madiran s\'etend un domaine viticole de 1 200 hectares a cheval sur trois departements :'],
		 	['le Gers, les Hautes-Pyrenees et les Pyrenees-Atlantiques. Le vignoble, qui se confond avec'], 
		 	['celui de l\'AOC Pacherenc du Vic-Bihl, est tres ancien et date de l\'epoque gallo-romaine '],
		 	['comme pour la plupart des regions viticoles francaises.']
		]).
		appellation_desc(medoc,
		[	['l\'AOC Medoc concerne la partie nord de la presqu\'île de la Gironde. Elle s\'etend sur'], 
			['80 km de long et 10 km de large. On distingue le Haut-Medoc au sud et le Bas-Medoc au nord,'], 
			['qui correspond a l\'appellation Medoc proprement dite. Cette AOC s\'etend sur 5.800 ha et'],
		 	['produit 285.000 hl de vins rouges par an.']
		]).
		appellation_desc(stEmilion,
		[	['l\'AOC Saint-Emilion est situee dans le Libournais sur la rive droite de la Dordogne'],
		 	['est donne son nom a deux appellations : Saint-Emilion et Saint-Emilion Grand Cru.'], 
		 	['Le vignoble est classe au patrimoine mondial de l\'humanite par l\'UNESCO.'],
		  	['Cette AOC s\'etend sur 5.600 ha et produit en moyenne 235.000 hl/an de vins rouges.'],
		   	['Il y a quatre types de terrains a Saint-Emilion : des sols argilo-limoneux, argileux,'],
		   	['calcaires composes d\'alluvions de graves et de sables.']
		]).
		appellation_desc(pomerol,
		[	['l\'AOC Pomerol se situe dans la region du Libournais, elle forme une terrasse au-dessus'], 
			['de l\'Isle, un affluent de la Dordogne. Situee a proximite de Libourne, l\'appellation Pomerol'],
		 	['est celebre pour le fameux Petrus, l\'un des crus les plus rares et les plus chers du monde.'], 
		 	['Contrairement aux Graves et a Saint-Emilion, l\'appellation Pomerol n\'a pas ete incluse dans'], 
		 	['la classification de 1855, mais sa reputation n\'en est pas moins bonne.'], 
		 	['Repartie sur 770 ha l\'AOC produit chaque annee 31.000 hl de vins rouges.']
		]).
		appellation_desc(stEstephe,
		[	['l\'AOC Saint-Estephe situee sur la rive gauche de Bordeaux, est rattachee au Medoc.'],
		 	['Son vignoble s\'etend sur 1.230 ha d\'alluvions graveleuses qui reposent sur des calcaires'],
		  	['ou des marnes a huitres. Il produit chaque 59.000 hl/an de vins rouges a partir des'], 
		  	['cepages rouges traditionnellement utilises dans le bordelais.']
		]).
		appellation_desc(pauillac,
		[	['l\'AOC Pauillac est situee sur la rive gauche de la Gironde et reunit des conditions'], 
			['climatiques et geologiques exceptionnelles, ce qui lui permet de produire de tres grands vins.'],
		 	['Capitale du Medoc viticole, la ville portuaire de Pauillac a donne son nom a l\'appellation.']
		]).
		appellation_desc(stJulien,
		[	['l\'AOC Saint-Julien est situee dans le centre geographique du Medoc entre Pauillac et Margaux.'],
		 	['C\'est la plus petite appellation du Medoc en surface puisqu\'elle ne represente que 910 ha de vignes'], 
		 	['(soit 6 % du vignoble medocain).']
		]). 
		appellation_desc(paysOc,
		[	['anciennement appele vin de pays d\'Oc, ce vin de pays regional IGP depuis 2009, fait partie d\'une region'], 
			['en France qui produit le plus de vin de pays. Le vignoble, entre montagnes, vallees et oceans,'], 
			['avec des sols tres divers, couvre plus de la moitie de la production de vin du Languedoc.']
		]).
		appellation_desc(rhoneVillages,
		[	['l\'AOC Cotes-du-Rhone-villages est issue de l\'AOC Cotes-du-Rhone.'], 
			['Il s\'agit d\'une mention visant a hierarchiser l\'immense et relativement opaque production'],
		 	['des Cotes-du-Rhone, en mettant en place un systeme de valorisation des terroirs et des savoir-faire locaux.']
		]).
		appellation_desc(roussillonVillages,
		[	['l\'AOC Cotes-du-Roussillon-Villages provient de 32 communes situees dans la vallee de l\'Agly.'], 
			['Cette appellation s\'etend sur 2.250 hectares, et se differencie des Cotes-du-Roussillon par des '],
			['contraintes liees au rendement (45hl/ha au lieu de 50).']
		]).
		appellation_desc(lirac,
		[	['l\'AOC Lirac delimite 660 hectares de vignoble sur les communes de Lirac, Roquemaure,'],
		 	['Saint-Genies-de-Comolas et Saint-Laurent-des-Arbres, dans le departement du Gard, au nord-est de Nîmes.']
		]).
		appellation_desc(beaumeVenise,
		[	['l\'AOC Beaumes-de-Venise s\'etend sur 560 hectares de vignoble, du versant sud-est des'], 
			['Dentelles de Montmirail aux communes de Beaumes-de-Venise, Lafare, Suzette et '],
			['La Roque Alric, au nord d\'Avignon.']
		]).
		appellation_desc(vacqueyras,
		[	['l\'AOC Vacqueyras est produite sur les communes de Vacqueyras et de Sarrians,'], 
			['au nord-est d\'Orange dans le departement du Vaucluse. Ce terroir s\'etend sur 1 400 hectares de vignes,'],
		 	['bordees par les vignobles de Gigondas et de Beaumes-de-Venise.']
		]).
		appellation_desc(stJoseph,
		[	['l\'AOC Saint-Joseph delimite pres de 50 km de vignoble de la rive droite du Rhone,'],
		 	['dans les departements de la Loire et de l\'Ardeche (Vallee du Rhone septentrionale),'], 
		 	['dont la production de 38 000 hectolitres par an s\'etend sur une superficie de 1 100 hectares.']
		]).
		appellation_desc(gigondas,
		[	['l\'AOC Gigondas s\'etend sur les 1 230 hectares du vignoble de la commune de Gigondas (Vaucluse),'],
		 	['au pied des celebres Dentelles de Montmirail. Le terroir se divise en 2 zones de production : les pentes du massif,'],
		  	['aux sols sableux sur sous-sols calcaires et de marnes, et la haute terrasse'], 
		  	['de l\'Ouveze (un affluent du Rhone), aux sols caillouteux.']
		]).
		appellation_desc(cndp,
		[	['l\'AOC Chateauneuf-du-Pape est le fleuron du patrimoine viticole de la Vallee du Rhone meridional,'],
		 	['et un des plus grands crus francais. Au XIVe siecle, le pape Jean XXII fit construire'], 
		 	['a Chateauneuf une forteresse, et y developpa le celebre vignoble, dont la culture fut'],
		  	['perpetuee dans la grande tradition papale de la Cite des Papes d\'Avignon']
		]).
		appellation_desc(hermitage,
		[	['l\'AOC Hermitage (ou Ermitage), est une appellation prestigieuse qui s\'etend sur'], 
			['seulement 135 hectares et 3 communes, dans le departement de la Drome : Tain-l\'Hermitage,'], 
			['Crozes-Hermitage et Larnage. Bien que restreint, ce vignoble a la particularite d\'etre sur'], 
			['la rive gauche du Rhone (les autres vignobles septentrionaux etant concentres sur la rive droite), '],
			['et d\'offrir une grande richesse de terroirs, arenes granitiques, sols sableux, ou terrains caillouteux']
		]).
		appellation_desc(coteauxBourguignons,
		[	['l\'AOC Coteaux Bourguignons est apparue en 2012, remplacant l\'ancienne appellation'],
		 	['\"Bourgogne Ordinaire\" ou \"Bourgogne Grand Ordinaire\" (BGO) utilisee jusqu\'en 2011.'],
		  	['L\'appellation d\'origine controlee Coteaux Bourguignon rassemble les departements de l\'Yonne,'], 
		  	['la Cote d\'Or, la Saone-et-Loire et le Rhone. Les vins produits peuvent provenir de differents cepages'], 
		  	['et peuvent etre Rouge, Rose ou blanc.']
		]).
		appellation_desc(coteNuits,
		[	['la Cote de Nuits se situe au nord de la Cote d\'Or et occupe une etroite bande de coteaux qui s\'etire'],
		 	['sur plusieurs kilometres de long, entre Dijon au nord et Corgoloin au sud. Cette region s\'etend'],
		  	['sur 3.160 hectares de vignoble et produit 77.500 hectolitres de vin par an,'],
		   	['principalement des rouges issus du pinot noir, qui donne des vins uniques.']
		]).
		appellation_desc(savignyBeaunes,
		[	['l\'AOC Savigny-les-Beaune est situee en amont d\'un cone de dejection et sur les deux flancs de la vallee du Rhin.'],
			['C\'est a partir de ce vignoble de 350 hectares, que demarre reellement la Cote de Beaune.'], 
			['Les vins de Corton possedent donc encore des caracteristiques de la Cote de Nuits.'], 
			['L\'appellation Savigny-les-Beaune produit 17 000 hectolitres de vins rouges(pinot noir)'], 
			['et blancs (chardonnay et pinot blanc) chaque annee.']
		]).
		appellation_desc(aloxeCorton,
		[	['l\'AOC Aloxe-Corton est une appellation Villages de Cote de Beaune qui existe depuis 1938.'], 
			['Son vignoble s\'etend au sud de la montagne de Corton entre Ladoix-Serrigny et Pernand-Vergelesses.'],
		 	['Sur une superficie de 255 hectares, l\'AOC produit chaque annee 10.000 hectolitres de vins.'], 
		 	['Dans leur globalite les rouges d\'Aloxe-Corton sont des vins puissants, races et de bonne garde.']
		]).
		appellation_desc(nuitsStGeorges,
		[	['l\'AOC Nuits-Saint-Georges produit des vins rouges et des vins blancs sur 41 climats classes en Premier Cru.'],
		 	['Elle s\'etend sur les communes de Premeaux-Prissey et de Nuits-Saint-Georges, avec 310 hectares au total.'], 
		 	['Le vignoble est constitue de deux parties bien distinctes, l\'une, au nord de Nuits-Saint-Georges,'], 
		 	['avoisine l\'aire d\'appellation Vosne-Romanee ; l\'autre relie les deux communes dans une orientation nord a sud.']
		]).
		appellation_desc(chambolleMusigny,
		[	['l\'AOC Chambolle-Musigny correspond au vignoble du meme nom situe dans le prolongement de l\'aire'], 
			['d\'appellation Morey-Saint-Denis, au nord de celle de Vougeot. Les vignes sont implantees sur une superficie'],
		 	['totale de 180 hectares et donnent chaque annee 6 700 hectolitres de vins. ']
		]).
		appellation_desc(chiroubles,
		[	['l\'AOC Chiroubles fait partie des crus du Beaujolais. Le vignoble de 350 hectares trouve son equilibre'],
		 	['entre une altitude elevee (400m) et une tres bonne exposition qui rechauffe suffisamment les sols pour un'], 
		 	['elevage qualitatif du Gamay.']
		]).
		appellation_desc(fleurie,
		[	['l\'AOC Fleurie fait partie des crus du Beaujolais. Le vignoble d\'une superficie de 870 hectares est'],
		 	['implante entre 220 et 430 metres d\'altitude. Annuellement il produit environ 42.500 hectolitres'], 
		 	['de vins rouges d\'une grande finesse, notamment grace a une exposition sud-est ou nord-ouest']
		]).
		appellation_desc(moulinVent,
		[	['l\'AOC Moulin-a-Vent fait partie des crus du Beaujolais. Situee aux alentours de la commune de Moulin-a-Vent,'],
		 	['sur 655 hectares, le vignoble presente un paysage viticole et des sols variables. Des sables surmontent les socles granitiques,'],
		  	['donnant des sols maigres et bien drainants qui evitent la retention des eaux de pluies.']
		]).

		appellation_desc(chinon,
		[	['l\'AOC Chinon voit son aire d\'appellation se situer a 40km au sud-est de Tours, elle appartient'], 
			['donc a la sous-region Touraine. Le climat, oceanique a l\'ouest, est de forte influence continentale a l\'est.'],
		 	['112 000 hectolitres de jus par an sont produits sur 2 350 hectares de vignoble adosse a la falaise bordant la Vienne.']
		]).
		appellation_desc(sancerre,
		[	['l\'AOC Sancerre est produit dans la sous-region Centre-Loire, dans l\'aire naturelle \"les collines du Sancerrois \".'],
		 	['Le vignoble s\'etend sur 2 800 hectares, sur la rive droite du fleuve, au nord-est du departement du Cher.'], 
		 	['Cette AOC produit annuellement 164 000 hectolitres de vins.']
		]).

		appellation_desc(cotesDuras,
		[	['l\'AOC Cotes de Duras s\'etend sur une surface de 2 000 hectares en Aquitaine, qui couvre 15 communes'], 
			['entre Bergerac et Marmande. La region est constituee de petites collines aux pentes douces, sur lesquelles'],
		 	['les vignobles se sont installes, fuyant le froid et l\'humidite excessives des fonds de vallees.'],
		 	['A une centaine de kilometres de l\'Atlantique, le climat encore oceanique, permet aux vignes de se developper'],
		  	['dans une atmosphere douce, a l\'ensoleillement suffisant l\'ete et en automne. ']
		]).
	% ┌───────────────────────────────────────────────────────────┐
	% │ Textes d'accords avec les mets						      │
	% └───────────────────────────────────────────────────────────┘
		desc_accord(viandeRouge,[	
			['idealement, un vin rouge puissant, epice et fume, reposant sur une'],
			['fin de bouche autoritaire tannique. par exemple,'],[]
		]).
		desc_accord(viandeBlanche,[	
			['idealement, un vin rouge fin et delicat, reposant sur une'],
			['fin de bouche fruitee.','par exemple,'],[]
		]).
		desc_accord(sucreDessert,[	
			['idealement, un vin rouge doux et naturel.', 'par exemple,'],[]
		]).
		desc_accord(poissonEntree,[	
			['idealement, un vin blanc fruite et vif.', 'par exemple,'],[]
		]).
		desc_accord(fromage,[	
			['idealement, un vin blanc sec et fruite.','par exemple,'],[]
		]).

%╔════════════════════════════════════════════════════════════════╗
%║                    Règles de réponse                           ║
%╚════════════════════════════════════════════════════════════════╝

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 1: Proposer une liste de vins selon leur région     │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(vins,1, [vins, de, Region], Rep) :-
			lvins_region(Region,Lvins),
			rep_lvins_region(Lvins,Rep).

        regle_rep(vins,1, [vins, du, Region], Rep) :-
			lvins_region(Region,Lvins),
			rep_lvins_region(Lvins,Rep).

		lvins_region(Region, [V1,V2,V3]) :- 
			findall((Vin,Prix),vin_region_prix(Vin,Region,Prix),[V1,V2,V3|Lvins]),
			nb_setval(lvins, Lvins).

		lvins_region(Region, Lvins) :- 
			findall((Vin,Prix),vin_region_prix(Vin,Region,Prix),Lvins),
			nb_setval(lvins, []).

		vin_region_prix(Vin,Region,Prix) :-
			categorie(Vin,Region),
			prix(Vin,Prix).


		rep_lvins_region([], [[desole, mais , je, ne ,dispose, pas, encore, de, vins, de, cette, categorie]]).
		rep_lvins_region(Lvins, [ [en, premier, 'conseil,', je, vous, propose, les, vins, suivants] | L]) :-
   			rep_litems_vin(Lvins,L).

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 2: Proposer des vins dans un intervalle de prix     │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(entre, 2, [vins, entre, X, et, Y], Rep) :-
	    	lvins_prix_min_max(X,Y,Lvins),
	     	rep_lvins_min_max(Lvins,Rep).
	    regle_rep(dessous, 2, [vins, en, dessous, de, X], Rep) :-
	    	lvins_prix_min_max(0,X,Lvins),
	     	rep_lvins_min_max(Lvins,Rep).
	    regle_rep(dessus, 2, [vins, au, dessus, de, X], Rep) :-
	    	lvins_prix_min_max(X,9999,Lvins),
	     	rep_lvins_min_max(Lvins,Rep).

   		rep_lvins_min_max([], [['desole,', je, ne ,dispose, pas, de, vins, dans, cette, gamme, de, prix]]).
		rep_lvins_min_max(Lvins, [ [ dans, cette, gamme, de, prix, je, vous, conseille, les, vins, suivants] | L]) :-
   			rep_litems_vin(Lvins,L).

		prix_vin_min_max(Vin,P,Min,Max) :-
		prix(Vin,P),
		Min =< P, P =< Max.

		lvins_prix_min_max(Min,Max, [V1,V2,V3]) :- 
			findall((Vin,Prix),prix_vin_min_max(Vin,Prix,Min,Max),[V1,V2,V3|Lvins]),
			nb_setval(lvins, Lvins).

		lvins_prix_min_max(Min,Max, Lvins) :- 
			findall((Vin,Prix),prix_vin_min_max(Vin,Prix,Min,Max),Lvins),
			nb_setval(lvins, []).

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 3: Donner toules les informations sur un vin        │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(dire, 3 , [dire, plus, sur, le, Vin], Rep):- 
			desc_complete(Vin,Rep),
			reset_lvins_sauvee().

		regle_rep(dire, 3 , [dire, plus, sur, Vin], Rep):- 
			desc_complete(Vin,Rep),
			reset_lvins_sauvee().

		desc_complete(Vin,Rep):- 
		categorie(Vin,Cat),
		nom_categorie(Cat,NomCat),
		nom(Vin,NomVin),
		description(Vin,Desc),
		bouche(Vin,Bouche),
		nez(Vin,Nez),
		append([[[' ',NomVin, '-', NomCat,'.']],[[]],Desc,[[]],Bouche,[[]],Nez],Rep).

		desc_complete(_,
		[
			['desole, je ne connais pas encore ce vin.'],
			['Veuillez verifier l\'orthographe, ne pas faire usage de tirets et preciser le millesime']
		]).

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 4: Donner la description en bouche d'un vin         │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(bouche, 4, [ Vin, en, bouche ], Rep) :- 
			bouche(Vin, Rep),
			reset_lvins_sauvee().
		regle_rep(bouche, 4, [ bouche, du, Vin ], Rep) :- 
			bouche(Vin, Rep),
			reset_lvins_sauvee().

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 5: Donner la decription du nez d'un vin             │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(nez, 5, [nez, presente, le, Vin], Rep ) :- 
			nez(Vin, Rep),
			reset_lvins_sauvee().
		regle_rep(nez, 5, [nez, du, Vin], Rep ) :- 
			nez(Vin, Rep),
			reset_lvins_sauvee().

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 6: Donner des informations sur une appellation      │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(lappellation, 6, [lappellation, Appellation], Rep ) :- 
			appellation_desc(Appellation, Rep),
			reset_lvins_sauvee().
		regle_rep(appellation, 6, [appellation, Appellation], Rep ) :- 
			appellation_desc(Appellation, Rep),
			reset_lvins_sauvee().

	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 7: Proposer une liste de vins selon leur appelation │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(un,7, [un, Appellation], Rep) :-
			lvins_appellation(Appellation,Lvins),
			rep_lvins_appellation(Lvins,Rep).

		lvins_appellation(Appellation, [V1,V2,V3]) :- 
			findall((Vin,Prix),vin_appellation_prix(Vin,Appellation,Prix),[V1,V2,V3|Lvins]),
			nb_setval(lvins, Lvins).

		lvins_appellation(Appellation, Lvins) :- 
			findall((Vin,Prix),vin_appellation_prix(Vin,Appellation,Prix),Lvins),
			nb_setval(lvins,[]).

		vin_appellation_prix(Vin,Appellation,Prix) :-
			appellation(Vin,Appellation),
			prix(Vin,Prix).	

		rep_lvins_appellation([], [[desole, mais , je, ne ,dispose, pas, encore, de, vins, de, cette, appellation]]).
		rep_lvins_appellation(Lvins, [ [ 'bien-sur,', je, vous, propose, ce, vin] | L]) :-
   			rep_litems_vin(Lvins,L).

   	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 8: Proposer des vins en accord avec un met          │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(avec,8, [avec, du, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).

		regle_rep(avec,8, [avec, de, la, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).

		regle_rep(cuisine,8, [cuisine, de, la, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).

		regle_rep(cuisine,8, [cuisine, du, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).
		regle_rep(cuisiner,8, [cuisiner, de, la, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).

		regle_rep(cuisiner,8, [cuisiner, du, Met], Rep) :-
			lvins_met(Met,Lvins),
			rep_lvins_accord(Lvins,Met,Rep).


		lvins_met(Met, [V1,V2,V3]) :- 
			findall((Vin,Prix),vin_met_prix(Vin,Met,Prix),[V1,V2,V3|Lvins]),
			nb_setval(lvins, Lvins).

		lvins_met(Met, Lvins) :- 
			findall((Vin,Prix),vin_met_prix(Vin,Met,Prix),Lvins),
			nb_setval(lvins, []).
			

		vin_met_prix(Vin,Met,Prix) :-
			accord(Vin,Met),
			prix(Vin,Prix).

		rep_lvins_accord([], _, [[desole, mais , je, ne ,possede, pas, de, vins, a, vous, conseiller, pour, ce, plat]]).
		rep_lvins_accord(Lvins, Met, Rep) :-
   			rep_litems_vin(Lvins,L),
   			desc_accord(Met, Desc),
   			append(Desc,L, Rep).
   	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 9: Donner les vins suivants                         │
	% └───────────────────────────────────────────────────────────┘
		regle_rep(autres,9, [autres], Rep) :-
   			nb_getval(lvins, Lvins),
   			rep_autres_lvins(Lvins,Rep).

   		regle_rep(dautres,9, [dautres], Rep) :-
   			nb_getval(lvins, Lvins),
   			rep_autres_lvins(Lvins,Rep).

   		rep_autres_lvins([], [[non, desole]]).

		rep_autres_lvins(Lvins, [['oui,', je, dispose, egalement, des, vins, suivants] | L]):-
   			rep_litems_vin(Lvins,L),
   			nb_setval(lvins, []).

   		rep_autres_lvins(-1, [['d\'autres ? je ne me souviens pas vous avoir conseille de vins, posez moi d\'abord une question.']]).
   	% ┌───────────────────────────────────────────────────────────┐
	% │ Règle 10: Donner les requêtes possibles                   │
	% └───────────────────────────────────────────────────────────┘
   		regle_rep(aide,10, [aide], Rep) :-
   			rep_aide(Rep).
   		regle_rep(help,10, [help], Rep) :-
   			rep_aide(Rep).

   		rep_aide([
   			['demandez moi par exemple: '],
   			[],
   			['- Quels vins de {Region} avez vous ? / Auriez vous des vins de {Region} ?'],
   			['- Auriez vous des vins entre {Min} et {Max} / en dessous de {Max} / au dessus de {Min} euros ?'],
   			['- Pouvez-vous m\'en dire plus sur le {Vin} ?'],
   			['- Que donne le {Vin} en bouche ? / A quoi ressemble la bouche du {Vin} ?'],
   			['- Quel nez presente le {Vin} ? / Que donne le nez du {Vin} ?'],
   			['- Que represente l\'appellation {Appellation} ?'],
   			['- Auriez vous un {Appellation} ?'],
   			['- Quel vin servir avec du {Met} ? / Je cuisine du {Met}, quel vin me conseillez-vous ?'],
   			[],
   			['Si les vins proposes ne vous conviennent pas, vous pouvez toujours m\'en demander d\'autres'],
   			['apres votre premiere requete.']
   		]).

   	% ┌───────────────────────────────────────────────────────────┐
	% │ Fonctions auxiliaires                                     │
	% └───────────────────────────────────────────────────────────┘
		rep_litems_vin([],[]) :- !.
		rep_litems_vin([(V,P)|L], [Irep|Ll]) :-
   			nom(V,Nom),
   			Irep = [ Nom, '-', Prix],
   			rep_litems_vin(L,Ll),
   			formatPrix(P,Prix).

   		formatPrix(P,Prix):-
   		atomic_list_concat(['(',P,' Eur)'], Prix).
   		
		reset_lvins_sauvee():- nb_setval(lvins, -1).
	% ┌───────────────────────────────────────────────────────────┐
	% │ Mot-clés                                                  │
	% └───────────────────────────────────────────────────────────┘
		mclef(autres,20).
		mclef(dautres,20).
		mclef(bouche,15).
		mclef(nez,15).
		mclef(vins,5).
		mclef(dire, 10).
		mclef(un,5).
		mclef(lappellation,10).
		mclef(appellation,10).
		mclef(entre,15).
		mclef(dessus,15).
		mclef(dessous,15).
		mclef(avec,10).
		mclef(cuisine,10).
		mclef(cuisiner,10).
		mclef(aide, 10).
		mclef(help,15).
		
 
%╔════════════════════════════════════════════════════════════════╗
%║            Conversion d'une question de l'utilisateur          ║
%║				       en une liste de mots                       ║
%╚════════════════════════════════════════════════════════════════╝

	% lire_question(L_Mots) 

	lire_question(LMots) :- read_atomics(LMots).



	/*****************************************************************************/
	% my_char_type(+Char,?Type)
	%    Char is an ASCII code.
	%    Type is whitespace, punctuation, numeric, alphabetic, or special.

	my_char_type(46,period) :- !.
	my_char_type(X,alphanumeric) :- X >= 65, X =< 90, !.
	my_char_type(X,alphanumeric) :- X >= 97, X =< 123, !.
	my_char_type(X,alphanumeric) :- X >= 48, X =< 57, !.
	my_char_type(X,whitespace) :- X =< 32, !.
	my_char_type(X,punctuation) :- X >= 33, X =< 47, !.
	my_char_type(X,punctuation) :- X >= 58, X =< 64, !.
	my_char_type(X,punctuation) :- X >= 91, X =< 96, !.
	my_char_type(X,punctuation) :- X >= 123, X =< 126, !.
	my_char_type(_,special).


	/*****************************************************************************/
	% lower_case(+C,?L)
	%   If ASCII code C is an upper-case letter, then L is the
	%   corresponding lower-case letter. Otherwise L=C.

	lower_case(X,Y) :-
		X >= 65,
		X =< 90,
		Y is X + 32, !.

	lower_case(X,X).


	/*****************************************************************************/
	% read_lc_string(-String)
	%  Reads a line of input into String as a list of ASCII codes,
	%  with all capital letters changed to lower case.

	read_lc_string(String) :-
		get0(FirstChar),
		lower_case(FirstChar,LChar),
		read_lc_string_aux(LChar,String).

	read_lc_string_aux(10,[]) :- !.  % end of line

	read_lc_string_aux(-1,[]) :- !.  % end of file

	read_lc_string_aux(LChar,[LChar|Rest]) :- read_lc_string(Rest).


	/*****************************************************************************/
	% extract_word(+String,-Rest,-Word) (final version)
	%  Extracts the first Word from String; Rest is rest of String.
	%  A word is a series of contiguous letters, or a series
	%  of contiguous digits, or a single special character.
	%  Assumes String does not begin with whitespace.

	extract_word([C|Chars],Rest,[C|RestOfWord]) :-
		my_char_type(C,Type),
		extract_word_aux(Type,Chars,Rest,RestOfWord).

	extract_word_aux(special,Rest,Rest,[]) :- !.
	   % if Char is special, don't read more chars.

	extract_word_aux(Type,[C|Chars],Rest,[C|RestOfWord]) :-
		my_char_type(C,Type), !,
		extract_word_aux(Type,Chars,Rest,RestOfWord).

	extract_word_aux(_,Rest,Rest,[]).   % if previous clause did not succeed.


	/*****************************************************************************/
	% remove_initial_blanks(+X,?Y)
	%   Removes whitespace characters from the
	%   beginning of string X, giving string Y.

	remove_initial_blanks([C|Chars],Result) :-
		my_char_type(C,whitespace), !,
		remove_initial_blanks(Chars,Result).

	remove_initial_blanks(X,X).   % if previous clause did not succeed.


	/*****************************************************************************/
	% digit_value(?D,?V)
	%  Where D is the ASCII code of a digit,
	%  V is the corresponding number.

	digit_value(48,0).
	digit_value(49,1).
	digit_value(50,2).
	digit_value(51,3).
	digit_value(52,4).
	digit_value(53,5).
	digit_value(54,6).
	digit_value(55,7).
	digit_value(56,8).
	digit_value(57,9).


	/*****************************************************************************/
	% string_to_number(+S,-N)
	%  Converts string S to the number that it
	%  represents, e.g., "234" to 234.
	%  Fails if S does not represent a nonnegative integer.

	string_to_number(S,N) :-
		string_to_number_aux(S,0,N).

	string_to_number_aux([D|Digits],ValueSoFar,Result) :-
		digit_value(D,V),
		NewValueSoFar is 10*ValueSoFar + V,
		string_to_number_aux(Digits,NewValueSoFar,Result).

	string_to_number_aux([],Result,Result).


	/*****************************************************************************/
	% string_to_atomic(+String,-Atomic)
	%  Converts String into the atom or number of
	%  which it is the written representation.

	string_to_atomic([C|Chars],Number) :-
		string_to_number([C|Chars],Number), !.

	string_to_atomic(String,Atom) :- name(Atom,String).
	  % assuming previous clause failed.


	/*****************************************************************************/
	% extract_atomics(+String,-ListOfAtomics) (second version)
	%  Breaks String up into ListOfAtomics
	%  e.g., " abc def  123 " into [abc,def,123].

	extract_atomics(String,ListOfAtomics) :-
		remove_initial_blanks(String,NewString),
		extract_atomics_aux(NewString,ListOfAtomics).

	extract_atomics_aux([C|Chars],[A|Atomics]) :-
		extract_word([C|Chars],Rest,Word),
		string_to_atomic(Word,A),       % <- this is the only change
		extract_atomics(Rest,Atomics).

	extract_atomics_aux([],[]).


	/*****************************************************************************/
	% clean_string(+String,-Cleanstring)
	%  removes all punctuation characters from String and return Cleanstring

	clean_string([C|Chars],L) :-
		my_char_type(C,punctuation),
		clean_string(Chars,L), !.
	clean_string([C|Chars],[C|L]) :-
		clean_string(Chars,L), !.
	clean_string([C|[]],[]) :-
		my_char_type(C,punctuation), !.
	clean_string([C|[]],[C]).


	/*****************************************************************************/
	% read_atomics(-ListOfAtomics)
	%  Reads a line of input, removes all punctuation characters, and converts
	%  it into a list of atomic terms, e.g., [this,is,an,example].

	read_atomics(ListOfAtomics) :-
		read_lc_string(String),
		clean_string(String,Cleanstring),
		extract_atomics(Cleanstring,ListOfAtomics).

%╔════════════════════════════════════════════════════════════════╗
%║      ECRIRE_REPONSE : ecrit une suite de lignes de texte       ║
%╚════════════════════════════════════════════════════════════════╝

	ecrire_reponse(L) :-
	   nl, write('GGS :'),
	   ecrire_li_reponse(L,1,1).

	% ecrire_li_reponse(Ll,M,E)
	% input : Ll, liste de listes de mots (tout en minuscules)
	%         M, indique si le premier caractere du premier mot de 
	%            la premiere ligne doit etre mis en majuscule (1 si oui, 0 si non)
	%         E, indique le nombre d'espaces avant ce premier mot 

	ecrire_li_reponse([],_,_) :- 
	    nl.

	ecrire_li_reponse([Li|Lls],Mi,Ei) :- 
	   ecrire_ligne(Li,Mi,Ei,Mf),
	   ecrire_li_reponse(Lls,Mf,2).

	% ecrire_ligne(Li,Mi,Ei,Mf)
	% input : Li, liste de mots a ecrire
	%         Mi, Ei booleens tels que decrits ci-dessus
	% output : Mf, booleen tel que decrit ci-dessus a appliquer 
	%          a la ligne suivante, si elle existe

	ecrire_ligne([],M,_,M) :- 
	   nl.

	ecrire_ligne([M|L],Mi,Ei,Mf) :-
	   ecrire_mot(M,Mi,Maux,Ei,Eaux),
	   ecrire_ligne(L,Maux,Eaux,Mf).

	% ecrire_mot(M,B1,B2,E1,E2)
	% input : M, le mot a ecrire
	%         B1, indique s'il faut une majuscule (1 si oui, 0 si non)
	%         E1, indique s'il faut un espace avant le mot (1 si oui, 0 si non)
	% output : B2, indique si le mot suivant prend une majuscule
	%          E2, indique si le mot suivant doit etre precede d'un espace

	ecrire_mot('.',_,1,_,1) :-
	   write('. '), !.
	ecrire_mot('\'',X,X,_,0) :-
	   write('\''), !.
	ecrire_mot(',',X,X,E,1) :-
	   espace(E), write(','), !.
	ecrire_mot(M,0,0,E,1) :-
	   espace(E), write(M).
	ecrire_mot(M,1,0,E,1) :-
	   name(M,[C|L]),
	   D is C - 32,
	   name(N,[D|L]),
	   espace(E), write(N).

	espace(0).
	espace(N) :- N>0, Nn is N-1, write(' '), espace(Nn).

%╔════════════════════════════════════════════════════════════════╗
%║                           TEST DE FIN                          ║
%╚════════════════════════════════════════════════════════════════╝

	fin(L) :- member(fin,L).

%╔════════════════════════════════════════════════════════════════╗
%║                      Boucle Principale                         ║
%╚════════════════════════════════════════════════════════════════╝

	grandgousier :- 

	   reset_lvins_sauvee(),

	   nl, nl, nl,
	   write('Bonjour, je suis Grandgousier, GGS pour les intimes,'), nl,
	   write('conseiller en vin. En quoi puis-je vous etre utile ?'), 
	   nl, nl, 

	   repeat,
	      write('Vous : '),
	      lire_question(L_Mots),
	      produire_reponse(L_Mots,L_ligne_reponse),
	      ecrire_reponse(L_ligne_reponse),
	   fin(L_Mots), !.

%╔════════════════════════════════════════════════════════════════╗
%║           Activation du programme après compilation            ║
%╚════════════════════════════════════════════════════════════════╝

	:- grandgousier.