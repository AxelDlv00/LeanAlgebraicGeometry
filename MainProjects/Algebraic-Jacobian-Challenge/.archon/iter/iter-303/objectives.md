# iter-303 objectives

Resumption iter (first prover round since iter-271; iters 272–302 were DAG/blueprint).
Build green. 4 lanes, all A.2.c/A.1.c critical path, no A.3+, no Route C.

| # | File | Mode | Target | Blueprint | Recipe |
|---|------|------|--------|-----------|--------|
| 1 | `Picard/TensorObjSubstrate/DualInverse.lean` | fine-grained | close `sliceDualTransport` invFun + round-trips (naturality attempt) | `lem:slice_dual_transport`, `lem:slice_dual_transport_inv` | corrected dual prose + `restrictScalarsLaxε` (PresheafInternalHom.lean:290) |
| 2 | `Picard/TensorObjSubstrate.lean` | fine-grained | `sheafificationCompPullback_comp_tail` (L2536) + ready tensor-iso nodes | `lem:sheafificationcomppullback_comp_tail`, `lem:jw_ismonoidal`, … | `analogies/d3-mate271.md` (`conjugateEquiv_whiskerLeft`, Mates.lean:525) |
| 3 | `Cohomology/CechHigherDirectImage.lean` | mathlib-build | generalized eqToHom-cancellation → `pushPullMap_comp` | `lem:push_pull_functor` | option-b free-hyp `subst` lemma (in-objective) |
| 4 | `Picard/FlatteningStratification.lean` | mathlib-build | `genericFlatness` bottom-up (Stacks 052B) | `thm:generic_flatness_algebraic`, `lem:flat_locus_*` | lift Mathlib module-level generic flatness |

**Expected outcomes / reversal signals:**
- Lanes 1–2 closing → next iter opens RelPicFunctor (group inverse unblocked).
- Lane 3 kernel wall surviving `subst` → escalate to refactor (transport-light `pushPullMap`, option a).
- Lane 4 Mathlib genuinely lacking the module-level core → name it as the Mathlib-gradient next target.

Race mitigation: lanes 1 and 4 import lane 2's file; lane 2 must not change exported signatures,
only close sorries, commit only compiling states.
