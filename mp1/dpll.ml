open List

(* filter_map : ('a -> 'b option) -> 'a list -> 'b list
   disponible depuis la version 4.08.0 de OCaml dans le module List :
   pour chaque élément de `list', appliquer `filter' :
   - si le résultat est `Some e', ajouter `e' au résultat ;
   - si le résultat est `None', ne rien ajouter au résultat.
   Attention, cette implémentation inverse l'ordre de la liste *)
let filter_map filter list =
  let rec aux list ret =
    match list with
    | []   -> ret
    | h::t -> match (filter h) with
      | None   -> aux t ret
      | Some e -> aux t (e::ret)
  in aux list []

(* print_modele : int list option -> unit
   affichage du résultat *)
let print_modele: int list option -> unit = function
  | None   -> print_string "UNSAT\n"
  | Some modele -> print_string "SAT\n";
     let modele2 = sort (fun i j -> (abs i) - (abs j)) modele in
     List.iter (fun i -> print_int i; print_string " ") modele2;
     print_string "0\n"

(* ensembles de clauses de test *)
let exemple_3_12 = [[1;2;-3];[2;3];[-1;-2;3];[-1;-3];[1;-2]]
let exemple_7_2 = [[1;-1;-3];[-2;3];[-2]]
let exemple_7_4 = [[1;2;3];[-1;2;3];[3];[1;-2;-3];[-1;-2;-3];[-3]]
let exemple_7_8 = [[1;-2;3];[1;-3];[2;3];[1;-2]]
let systeme = [[-1;2];[1;-2];[1;-3];[1;2;3];[-1;-2]]
let coloriage = [[1;2;3];[4;5;6];[7;8;9];[10;11;12];[13;14;15];[16;17;18];[19;20;21];[-1;-2];[-1;-3];[-2;-3];[-4;-5];[-4;-6];[-5;-6];[-7;-8];[-7;-9];[-8;-9];[-10;-11];[-10;-12];[-11;-12];[-13;-14];[-13;-15];[-14;-15];[-16;-17];[-16;-18];[-17;-18];[-19;-20];[-19;-21];[-20;-21];[-1;-4];[-2;-5];[-3;-6];[-1;-7];[-2;-8];[-3;-9];[-4;-7];[-5;-8];[-6;-9];[-4;-10];[-5;-11];[-6;-12];[-7;-10];[-8;-11];[-9;-12];[-7;-13];[-8;-14];[-9;-15];[-7;-16];[-8;-17];[-9;-18];[-10;-13];[-11;-14];[-12;-15];[-13;-16];[-14;-17];[-15;-18]]
(* let example_new = [[2; 3]; [2; 3]; [-1; 3; 2]; [-3; -1]; [1; -3; -1]; [1]];; *)
(* simplifie : int -> int list list -> int list list 
   Applique la simplification de l'ensemble des clauses en mettant
   le littéral l à vrai
*)
let rec simplifie l clauses = match clauses with
  (*ETAPE 1. parcours du tableau clauses, avec pattern matching*)
  (*NOTE: si tableau est vide, renvoie un tableau vide*)
  | [] -> []
  (*ETAPE 2. sinon, pour chaque clause*)
  (*NOTE: methode filter vérifie si existe le dual du littéral 'l'*)
  | clause :: new_clauses -> let filter x = (if x = -l then None else Some x) in
  (*ETAPE 3. si clause ne contient pas le littéral 'l'*)
    if not (List.exists (fun y -> y = l) clause) 
    then 
      (*A. Append la clause, sans le dual de l, s'il existe. Ensuite appel récursif.*)
      (*NOTE: ici, on utiliser filter et filter_map pour ajouter au 
        tableau seulement les valeurs que nous intéresse.*)
      [List.rev (filter_map filter clause)] @ simplifie l new_clauses 
      (*B. Sinon, on ignore clause qui contient l (car on met à true 'l') et 
        on fait appel recursif sur le reste du tableau*)
    else 
       simplifie l new_clauses
  

(* solveur_split : int list list -> int list -> int list option
   exemple d'utilisation de `simplifie' *)
let rec solveur_split clauses interpretation =
  (* l'ensemble vide de clauses est satisfiable *)
  if clauses = [] then Some interpretation else
  (* un clause vide n'est jamais satisfiable *)
  if mem [] clauses then None else
  (* branchement *) 
  let l = hd (hd clauses) in
  let branche = solveur_split (simplifie l clauses) (l::interpretation) in
  match branche with
  | None -> solveur_split (simplifie (-l) clauses) ((-l)::interpretation)
  | _    -> branche

(* Tests solveur_split *)
(* let () = print_modele (solveur_split systeme []) 
let () = print_modele (solveur_split coloriage []) *)
(* let () = print_modele (solveur_split example_new []) *)

    
(* unitaire : int list list -> int
    - si `clauses' contient au moins une clause unitaire, retourne
      le littéral de cette clause unitaire ;
    - sinon, lève une exception `Not_found' *)
let unitaire clauses = let target_clause = 
  (*ETAPE 1. On cherche avec find une clause de taille 1 dans la liste de clauses*)
  List.find (fun clause -> List.length clause = 1) clauses
  in
  (*ETAPE 2. On envoie l'élement *)
  List.hd target_clause * 1

(*Méthode auxiliaire*)
(*val isDual : int -> int list -> bool = <fun>*)
let isDual x l = List.exists (fun ls -> ls = -x) l

(*Méthode auxiliaire*)
(*val pur_aux : int list -> int list -> int = <fun>*)
let rec pur_aux elements_of_list list = 
  (*ETAPE 1. Pour chaque élément de la liste 'elements of list', qui
    consiste aux propositions uniques de la clause list*)
  match elements_of_list with 
    (*ETAPE 2. On vérifie si son dual existe*)
    | [] -> raise Not_found
    (*ETAPE 3. Si son dual n'existe pas, retourne x*)
    | x :: xs -> if not (isDual x list) then x else pur_aux xs list

(* pur : int list list -> int
    - si `clauses' contient au moins un littéral pur, retourne
      ce littéral ;
    - sinon, lève une exception `Failure "pas de littéral pur"' *)
let pur clauses = 
  (*ETAPE 1. On transforme la liste de liste dans un liste simple.*)
  let flatten_clauses = List.flatten clauses 
  in 
  (*ETAPE 2. On récupère les propositions uniques avec méthode uniq *)
  let unique_sorted_clauses = List.sort_uniq compare flatten_clauses 
  in
  (*ETAPE 3. On applique méthode auxiliaire que cherche pour chaque proposition si son dual existe ou pas*)
  pur_aux unique_sorted_clauses flatten_clauses

(* let rec contains_empty_clause clauses = match clauses with
  | [] -> false
  | clause :: new_clauses -> if List.length clause = 0 then true 
  else contains_empty_clause new_clauses

let is_empty_clauses clauses = if List.length clauses = 0 then true else false *)

(*fonction auxiliaire: retourne valeur d'un type Some*)
let get_exn = function
  | Some x -> x
  | None   -> raise (Invalid_argument "Option.get")

(*fonction auxiliaire: retourne (Some résultat) ou None si exception.*)
let unitaire_wrapper clauses = 
  try Some (unitaire clauses) with 
  Not_found -> None

(*fonction auxiliaire: retourne (Some résultat) ou None si exception.*)
let pur_wrapper clauses = 
  try Some (pur clauses) with
  Not_found -> None

let rec solveur_dpll_rec clauses interp = 
  (*Get unitiare*)
  let unit_l = unitaire_wrapper clauses in 
  
  (*Get pure*)
  let pure_l = pur_wrapper clauses in
  
  (*Check if clauses = []*)
  if clauses = [] then Some interp
  
  (*Check if exists [] in clauses*)
  else if mem [] clauses then None
  
  (*If unitaire is not none, appel récursif sur la propositon unitaire*)
  else if unit_l <> None then let int_l = get_exn unit_l in
  let new_interp = int_l :: interp in
  let new_clauses = simplifie int_l clauses in
  solveur_dpll_rec new_clauses new_interp
  
  (*If pure is not none, appel récursif sur la proposition pure*)
  else if pure_l <> None then let int_l2 = get_exn pure_l in
  let new_interp = int_l2 :: interp in
  let new_clauses = simplifie int_l2 clauses in
  solveur_dpll_rec new_clauses new_interp
  
  (* Branchement, dans un premier temps appel récursif sur propostion p *)
  else let l = List.hd (List.hd clauses) in let branch = solveur_dpll_rec (simplifie l clauses) (l :: interp) 
  in match branch with 
    (*Si son retour est None, appel récursif sur son dual*)
    |None -> solveur_dpll_rec (simplifie (-l) clauses) (-l::interp)
    | _ -> branch
  ;;

(* tests *)
(* let () = print_modele (solveur_dpll_rec systeme [])
let () = print_modele (solveur_dpll_rec coloriage []) *)
(* let () = print_modele (solveur_dpll_rec example_new []) *)

let () =
  let clauses = Dimacs.parse Sys.argv.(1) in
  print_modele (solveur_dpll_rec clauses [])
