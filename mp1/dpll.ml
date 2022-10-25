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


(* simplifie : int -> int list list -> int list list 
   Applique la simplification de l'ensemble des clauses en mettant
   le littéral l à vrai
*)
let rec simplifie l clauses = match clauses with 
  (*ETAPE 1. parcours du tableau clauses, avec pattern matching*)
  (*NOTE: si tableau est vide, renvoie un tableau vide*)
  | [] -> []
  (*ETAPE 2. sinon, pour chaque clause*)
  (*NOTE: methode filter vérifie si existe le dual du litteral 'l'*)
  | clause :: new_clauses -> let filter x = (if x = -l then None else Some x) in
  (*ETAPE 3. si clause ne contient pas le littéral 'l'*)
    if not (List.exists (fun y -> y = l) clause) 
    then 
      (*ETAPE 4. append la clause, sans le dual de l, s'il existe. ensuite appel recursif*)
      (*NOTE: ici, on utiliser filter et filter_map pour ajouter au
        tableau seulement les valeurs que nous intéresse.*)
      [List.rev (filter_map filter clause)] @ simplifie l new_clauses 
      (*ETAPE 5. sinon, on ignore clause qui contient l (car on met à true 'l') et on fait appel recursif sur le reste du tableau*)
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
(* let () = print_modele (solveur_split systeme []) *)
(* let () = print_modele (solveur_split coloriage []) *)
    
(* unitaire : int list list -> int
    - si `clauses' contient au moins une clause unitaire, retourne
      le littéral de cette clause unitaire ;
    - sinon, lève une exception `Not_found' *)
let unitaire clauses = let target_clause = 
  List.find (fun clause -> List.length clause = 1) clauses
  in
  List.hd target_clause * 1
    
let isDual x l = List.exists (fun ls -> ls = -x) l

let rec pur_aux elements_of_list list = match elements_of_list with 
  | [] -> raise Not_found
  | x :: xs -> if not (isDual x list) then x else pur_aux xs list

(* pur : int list list -> int
    - si `clauses' contient au moins un littéral pur, retourne
      ce littéral ;
    - sinon, lève une exception `Failure "pas de littéral pur"' *)
let pur clauses = let flatten_clauses = List.flatten clauses in 
  let unique_sorted_clauses = List.sort_uniq compare flatten_clauses in
  pur_aux unique_sorted_clauses flatten_clauses

let rec contains_empty_clause clauses = match clauses with
  | [] -> false
  | clause :: new_clauses -> if List.length clause = 0 then true 
  else contains_empty_clause new_clauses

let is_empty_clauses clauses = if List.length clauses = 0 then true else false

let get_exn = function
  | Some x -> x
  | None   -> raise (Invalid_argument "Option.get")

let unitaire_wrapper clauses = 
  try Some (unitaire clauses) with 
  Not_found -> None

let pur_wrapper clauses = 
  try Some (pur clauses) with
  Not_found -> None

let rec solveur_dpll_rec clauses interp = 
  (*Get unitiare*)
  let unit_l = unitaire_wrapper clauses in 
  
  (*Get pure*)
  let pure_l = pur_wrapper clauses in
  
  (*Check if clauses = []*)
  if is_empty_clauses clauses = true then Some interp
  
  (*Check if exists [[]]*)
  else if contains_empty_clause clauses then None
  
  (*If unitaire is not none*)
  else if unit_l <> None then let int_l = get_exn unit_l in
  let new_interp = int_l :: interp in
  let new_clauses = simplifie int_l clauses in
  solveur_dpll_rec new_clauses new_interp
  
  (*If pure is not none*)
  else if pure_l <> None then let int_l2 = get_exn pure_l in
  let new_interp = int_l2 ::interp in
  let new_clauses = simplifie int_l2 clauses in
  solveur_dpll_rec new_clauses new_interp
  
  (* Branchement *)
  else let l = List.hd (List.hd clauses) in let branch = solveur_dpll_rec (simplifie l clauses) (l :: interp) 
  in match branch with 
    |None -> solveur_dpll_rec (simplifie (-l) clauses) (-l::interp)
    | _ -> branch
  ;;

(* tests *)
(* let () = print_modele (solveur_dpll_rec systeme [])  *)
(* let () = print_modele (solveur_dpll_rec coloriage []) *)

let () =
  let clauses = Dimacs.parse Sys.argv.(1) in
  print_modele (solveur_dpll_rec clauses [])
