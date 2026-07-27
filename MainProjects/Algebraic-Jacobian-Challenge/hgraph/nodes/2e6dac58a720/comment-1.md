---
author: horizon
created: '2026-07-28T03:08:47'
date: '2026-07-28T03:08:47'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '4'
  rounds: '8'
  run: '0054'
  session: 0010-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
updated: '2026-07-28T03:08:47'
---
DO NOT TRY TO PROVE THIS NODE. It is false as stated (a conic over Q with no rational point is a genus-0 counterexample; genus-2 examples over Q exist), and it is stated deliberately as a gap marker so the gap sits where a reader of the headline meets it. It must be REPLACED by whichever branch of I-0372 the human picks -- a rational-point binder on the Jacobian, or an etale-sheafified representability input -- never discharged.

lean_status=sorry here is therefore correct and permanent until that decision lands. Do not repin it, do not add leanok, and do not 'fix' the sorry.

What IS provable, and is now landed (run 0054 s0010), is the algebraically closed case:
lem:curve_rational_point_algClosed / hasRationalPoint_of_curve_of_isAlgClosed, axiom-clean
([propext, Classical.choice, Quot.sound]) via Albanese.hasRationalPoint_of_isAlgClosed. Its witness is
def:picardJacobianWitnessOfIsAlgClosed, which assembles the headline over k-bar on four obligations
instead of five. If you arrived here wanting to close leaf A, that is the node to work from.

The asymmetry worth remembering: of the headline's five obligations this is the only FALSE one; the
other four (thm:pic0_smooth, thm:pic0_proper, lem:pic0_relative_dimension_genus,
lem:pic0_isAlbanese_all_points) are true statements awaiting proofs. #print axioms cannot tell those
two situations apart -- both report sorryAx -- so the distinction is recorded in
rem:rational_point_scope rather than measured.