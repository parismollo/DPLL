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