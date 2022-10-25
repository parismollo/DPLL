let rec simplifie l clauses = match clauses with 
  | [] -> []
  | clause :: new_clauses -> let filter x = (if x = ~-l then None else Some x) in 
    if not (List.exists (fun y -> y = l) clause)
      then
        [List.rev (filter_map filter clause)] @ simplifie l new_clauses
      else 
          simplifie l new_clauses


(*Tests for simplifie*)
let clauses_1 = [[1; -2; -1]; [-3; 2]; [-3]]
let clauses_2 = [[]]
let clauses_3 = [[-1; -2; 2]; [-2; 1]; [1]]
let clauses_4 = [[-1; 3]; [2]]
let clauses_5 = [[-2]]

let simplifie_tests = let eq l1 l2 = (l1 = l2) in let res_1 = simplifie 1 clauses_1 in
  List.equal eq [[-3;2]; [-3]] res_1 && let res_2 = simplifie 3 clauses_2 in
  List.equal eq [[]]  res_2 && let res_3 = simplifie ~-2 clauses_3 in
  List.equal eq [[1]] res_3 && let res_4 = simplifie ~-1 clauses_4 in
  List.equal eq [[2]] res_4 && let res_5 = simplifie 5 clauses_5 in
  List.equal eq [[-2]] res_5
    
(*Trying to force the return value to be an int with the multiplication, otherwise raise Error, might need to review this later*)
let unitaire clauses = let target_clause = List.find (fun clause -> List.length clause = 1) clauses in
  List.hd target_clause * 1;
  ;;

let tests_unitaire = let res_1 = unitaire clauses_1 in
  ~-3 = res_1 && let res_3 = unitaire clauses_3 in 
  1   = res_3 && let res_4 = unitaire clauses_4 in
  2   = res_4 && let res_5 = unitaire clauses_5 in
  ~-2 = res_5
  ;;

(*unitaire clauses_2*);; (*enlever commentaire pour faire voir exception*) 
(*unitaire [["clauses_2"]] *) (*enlever commentaire pour faire voir error*) 

let rec pur_aux elements_of_list list = match elements_of_list with 
  | [] -> failwith "Pas de literal pur"
  | x :: xs -> if not (isDual x list) then x else pur_aux xs list

let pur clauses = let flatten_clauses = List.flatten clauses in 
  let unique_sorted_clauses = List.sort_uniq compare flatten_clauses in
    pur_aux unique_sorted_clauses flatten_clauses

let tests_pur = let res_1 = pur clauses_1 in
  ~-3 = res_1 && let res_4 = pur clauses_4 in 
    ~-1 = res_4 && let res_5 = pur clauses_5 in
      ~-2 = res_5

(*Tests*)
let a = [[]; [1; 2]];;
let b = [[2]; [3]];;
(*---------------*)
let rec contains_empty_clause clauses = match clauses with
  | [] -> false (*Later this will have to change*)
  | clause :: new_clauses -> if List.length clause = 0 then true 
    else contains_empty_clause new_clauses
  ;;

contains_empty_clause a;;
contains_empty_clause b;;

let c = [[]; [1; 2]];;
let d = [];;
let is_empty_clauses clauses = if List.length clauses = 0 then true else false;;
is_empty_clauses c;;
is_empty_clauses d;;


let get_exn = function
  | Some x -> x
  | None   -> raise (Invalid_argument "Option.get")


let unitaire_wrapper clauses = 
  try Some (unitaire clauses) with 
    Not_found -> None

let pur_wrapper clauses = 
  try Some (pur clauses) with
    Not_found -> None
    
let rec dpll clauses interp = 
  (*Get unitiare*)
  let unit_l = unitaire_wrapper clauses in 
  
  (*Get pure*)
  let pure_l = pur_wrapper clauses in
  
  (*Check if clauses = []*)
  if is_empty_clauses clauses = true then interp
  
  (*Check if exists [[]]*)
  else if contains_empty_clause clauses then [None]
  
  (*If unitaire is not none*)
  else if unit_l <> None then let int_l = get_exn unit_l in
  let new_interp = [unit_l] @ interp in
  let new_clauses = simplifie int_l clauses in
  dpll new_clauses new_interp
  
  (*If pure is not none*)
  else if pure_l <> None then let int_l2 = get_exn pure_l in
  let new_interp = [pure_l] @ interp in
  let new_clauses = simplifie int_l2 clauses in
  dpll new_clauses new_interp
  
  (* Branchement *)
  else let l = List.hd (List.hd clauses) in let branch = dpll (simplifie l clauses) (Some l :: interp) 
  in match branch with 
    |[None] -> dpll (simplifie (~-l) clauses) (Some ~-l::interp)
    | _ -> branch
  ;;