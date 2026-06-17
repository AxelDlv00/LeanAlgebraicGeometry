# iter-044 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (`CechHigherDirectImage.lean:679`
  frozen P5b, `CechAcyclic.lean:110` dead `affine`). Prover file `QcohTildeSections.lean` is 0-sorry.
- **Build:** GREEN. Independently re-verified by review — fresh `lake env lean … QcohTildeSections.lean`
  EXIT 0; all 5 new decls `#print axioms` = `{propext, Classical.choice, Quot.sound}` (fresh build, not
  LSP-only, per the stale-olean trap).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+5 axiom-clean decls**, 0 new sorries.
- **dag-query:** gaps = 0, unmatched = 6 (1 pre-existing dead + 5 new this iter). `sync_leanok` ran iter
  44 (sha `9447815`, +4/−0). **blueprint-doctor:** no structural findings.

## Headline — the keystone's last tile ingredient (Sub-lemma B) is CLOSED, axiom-clean
The iter-043 reduction ("Sub-lemma B → one structure-sheaf ring identity, ~30–50 LOC") was realized this
iter. The prover closed the named target `tile_scalar_compat` via **route (A) (Γ-Spec naturality)** and
built four reusable supporting lemmas (`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`,
`tile_section_ring_identity`). The keystone route has landed axiom-clean decls every prover iter
(040:+4, 041:+3, 042:+1, 043:+2, 044:+5). The iter-043 progress-critic CHURNING verdict is resolved on
contact: the planner's corrective (blueprint expansion before re-dispatch) was the right call — the
route converged rather than rotating helpers.

## This iter's analysis
- **No forced mathematics; clean stop.** The `mathlib-build` no-sorry invariant held. The named target
  closed fully; the downstream assembly `tile_section_localization` was scouted, its obstruction
  kernel-confirmed, and left absent (not papered) — the honest stopping point.
- **The decisive technical finding** (worth the Knowledge Base): `Scheme.ΓSpecIso.inv` form is composable
  with `(Spec R).presheaf.map`/`appTop` where `StructureSheaf.globalSectionsIso.hom` is NOT — the latter's
  codomain is defeq-but-not-syntactic to `(Spec R).presheaf`, so `rw`/`assoc` silently fail to fire. The
  prover's attempt-2 failure (`globalSectionsIso.hom` form: "did not find pattern" / "motive not type
  correct") and attempt-4 success (`ΓSpecIso.inv` form) pin this precisely. Swap is `CommRingCat.hom_ext rfl`.
- **Soundness independently confirmed.** lean-auditor `iter044`: all 5 decls axiom-clean; the
  `congr 1`/`convert using 2` closures are genuine thin-Opens-cat subsingleton equalities, NOT the
  documented spurious-rfl/kernel-soundness trap. Review's own fresh `lake env lean` + `#print axioms`
  agree. The reduction step's "PROVEN prefix" comment was validated by the prover with `lean_goal` before
  use (the progress-critic enforcement the planner baked in) — no longer the never-compiled risk of iter-043.
- **The `\lean{}` pin the prover requested was REJECTED on review.** `tile_scalar_compat` is the scalar
  equality at `V=⊤`, not the full natural `R_g`-linear iso `lem:tile_section_comparison` asserts. Pinning
  would over-claim formalization of an iso that was not built. Recorded as a `% NOTE`; the planner must
  author a dedicated block instead (see recommendations HIGH-1).

## Markers / coverage
- **Manual marker edit (1 `% NOTE`):** `lem:tile_section_comparison` — recorded that the residual ring
  identity is CLOSED as `tile_scalar_compat` (+ 4 route-(A) helpers), that the `\lean{tile_scalar_compat}`
  pin is rejected (statement mismatch), and a planner pointer to author a dedicated block + tighten the
  under-specified sketch. No `\leanok` touched (sync owns it; +4 this iter). No `\mathlibok` (project
  theorems). No `\lean{}` rename (pin rejected — the 5 new decls are coverage debt for new blocks).
- **Coverage debt = 6 unmatched** (1 pre-existing dead + 5 new). The 5 new are cleared by the
  recommendations HIGH-1 blueprint-writer item. Listed for the planner in `recommendations.md`.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter044`,
  lean-vs-blueprint-checker `qts`. See `recommendations.md` for landed findings.)
