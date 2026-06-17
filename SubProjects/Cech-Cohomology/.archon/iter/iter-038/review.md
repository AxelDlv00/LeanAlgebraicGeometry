# iter-038 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead line 110,
  `CechHigherDirectImage.lean` frozen P5b). Prover file `QcohRestrictBasicOpen.lean` is 0-sorry.
- **Build:** GREEN. `lake env lean … QcohRestrictBasicOpen.lean` EXIT 0; all 8 new decls `#print axioms`
  = `[propext, Classical.choice, Quot.sound]` (re-verified independently by review on the 7 public decls).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+8 axiom-clean decls**; 0 new sorries.
- **dag-query:** gaps = 0, unmatched = 9 (1 pre-existing dead + 8 new). `sync_leanok` ran iter 38
  (`sha 3cbfd77`, +0/−2 — the 2 removals are on `Cohomology_CechHigherDirectImage.tex`).
- **blueprint-doctor:** no structural findings (every chapter `\input`'d, all refs resolve, no `axiom`).

## Headline — Route B step B3b (the analogist-designated single load-bearing lane) closed
The lane delivered `modulesOverBasicOpenEquivalence` — the equivalence
`(specBasicOpen g).toScheme.Modules ≌ SheafOfModules ((Spec R).ringCatSheaf.over (specBasicOpen g))`
built from `pushforwardPushforwardEquivalence` — plus 7 supporting decls (two `_isContinuous_toScheme`
defeq instances, a private image–preimage helper, `overForgetIso`/`overForgetInvIso`, and the φ/ψ
ring-sheaf comparisons `overBasicOpenRingHom`/`overBasicOpenRingInvHom`). The two genuinely-hard
coherence obligations H₁/H₂ were discharged kernel-soundly. This is the heaviest categorical half of the
B3 bridge; what remains (`overBasicOpenIsoRestrict`, the object iso) is a bounded mechanical step with a
recipe in hand.

## The stop is clean and lands on a bounded, recipe'd step
`overBasicOpenIsoRestrict` (the `\lean{}`-pinned named target) was left as a precise in-file TODO — a
comment, **not a sorry**. `(SheafOfModules.pushforwardCongr ?_).app M` typechecks against the exact
target but leaves the site functor `F` a stuck metavariable; remaining work is supplying φ/ψ/F explicitly
+ a ring-sheaf data equality via `ι_appIso`. No mathematical wall remains on Route B.

## This iter's analysis
- **No forced mathematics; clean stop.** The `mathlib-build` no-sorry invariant held; the lane delivered
  its provable engine and stopped on a bounded mechanical residual, decomposed in the file TODO.
- **A real kernel-soundness trap was caught and fixed by the prover.** Bare `ext`/`congr 1` auto-closed
  the thin-category coherence goals via an unsound rfl-term the LSP accepted but `lake env lean` rejected
  (`unknown free variable _fvar…`). The prover diagnosed this, switched to explicit
  `NatTrans.ext`/`congrArg`/`Subsingleton.elim`, and re-verified with `lake env lean` + `#print axioms`.
  The lean-auditor independently confirmed no spurious-rfl survives and the proofs are genuine. This is
  the single most important correctness fact of the iter — recorded in the Knowledge Base.
- **No Lean-side must-fix from either reviewer.** lean-auditor: 0 must-fix / 1 major (deprecated
  `Sheaf.val`) / 5 minor. lean-vs-blueprint-checker: 0 red flags / 2 major (both blueprint coverage).
- **All findings are coverage/quality, not correctness:** (1) `modulesOverBasicOpenEquivalence` has no
  `\lean{}` pin → invisible to sync_leanok (planner: add `def:modules_over_basicOpen_equivalence`); (2)
  the `\lean{overBasicOpenIsoRestrict}` pin is forward-looking (correct, `% NOTE: to-build`); (3)
  deprecated `Sheaf.val` at 5 sites → migrate before next Mathlib bump; (4) 8 new helpers DAG-invisible.

## Markers / coverage
- **Manual marker edit (1 `% NOTE` extension):** `lem:restrict_over_compat` — recorded that B3b is DONE
  (engine `modulesOverBasicOpenEquivalence`, axiom-clean), that the `\lean{}` pin is the remaining B3c
  object iso, and the planner action (give the engine a trackable node). No `\leanok` touched. No
  `\mathlibok` (all 8 new decls are project theorems). No `\lean{}` rename (pinned target is unbuilt).
- **Coverage debt = 9 unmatched**: 8 new this-iter decls + dead `CechAcyclic.affine`. Itemized in
  `recommendations.md` for the planner to blueprint.

## Subagent findings (reports linked, not duplicated)
- `task_results/lean-auditor-iter038.md` — 8 decls axiom-clean + genuine; major = deprecated `Sheaf.val`.
- `task_results/lean-vs-blueprint-checker-qrbo.md` — faithful B3a/B3b execution; 2 major coverage gaps.
