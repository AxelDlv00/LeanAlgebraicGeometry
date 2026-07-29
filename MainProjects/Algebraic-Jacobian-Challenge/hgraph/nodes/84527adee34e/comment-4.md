---
author: horizon
created: '2026-07-29T21:56:47'
date: '2026-07-29T21:56:47'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '1'
  rounds: '8'
  run: 0081
  session: 0004-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
updated: '2026-07-29T21:56:47'
---
CORRECTION to my comment-3 above, same day (review-ajc). THE ROUTE CONCLUSION STANDS; THE MECHANISM I GAVE FOR IT IS WITHDRAWN.

comment-3 said the refutation of G3/G4 was a Lean derivation: representability of picSharp forces picSharp to be a Zariski sheaf (picSharp_isSheaf_zariski_of_representableBy, true and axiom-clean), while Kleiman exhibits a curve where it is not one. THE SECOND HALF IS NOT SUPPORTED BY ANY SOURCE IN THE WORKSPACE, as a fresh-context work-reviewer pass established (I-0970):

* Exercise ex:Pfs, which comment-3 cited, compares Pic_{(X/R)zar} with Pic_{(X/R)et} -- BOTH are sheafifications, hence already sheaves. It witnesses zar != et. It says nothing about Zariski descent for the unsheafified picSharp.
* Kleiman th:cmp part 1 (L1391-L1393) points the other way: Pic_{X/S} INJECTS into Pic_{(X/S)zar} whenever O_S = f_*O_X holds universally, which is automatic on this theorem's binders. So picSharp is Zariski-SEPARATED here and any failure could only be gluing.
* Consistent with campaign milestone B1, titled 'picSharp is a Zariski sheaf', whose own audit note says the statement is false only WITHOUT a section.

WHAT THE CONCLUSION NOW RESTS ON, and it is stronger for being direct: Kleiman L5105-L5108 (repeated L5126-L5129) states outright that Pic_{X/R} is NOT REPRESENTABLE for the conic u^2+v^2+w^2=0 in P^2_R -- a smooth plane conic, hence smooth, proper and geometrically integral, over a field where it has no rational point, i.e. exactly this node's hypotheses -- because Pic_{(X/R)et} is representable by s4 th:main while the two functors differ. No sheaf step is needed.

So: G3 and G4 of the Milne-Kollar campaign still target a FALSE statement as written, the repair is still to descend picEt rather than picSharp, and AJC.picrep.etale-rep is still a route repair rather than a missing theorem. Only the derivation is retracted, and the claim that the Lean theorem supplies half of it.

THE LESSON, filed as I-0973 and worth more than the fact: the seam's ORIGINAL citation for this slot (s2 L1292-L1302) was false because those lines are about the ABSOLUTE functor Pic_X. My REPLACEMENT was false in the same slot for a different reason. A replacement citation gets checked against the conclusion everyone already believes, not against the claim in the slot -- and this one sat in a Lean docstring beside a true theorem, which made it look measured. Landed: 3a7a58a02; board row AJC.picrep at 94b4339f2.