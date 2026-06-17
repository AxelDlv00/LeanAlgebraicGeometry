# Session 31 (iter-031) — Review Summary

## Metadata
- **Session / iter:** session_31 = iter-031. Model: claude-opus-4-8.
- **Active sorry count: 9 → 9** (FBC 4, QUOT 4 protected stubs, GR 0, GF 1). No active sorry closed.
- **Net declarations: +12 axiom-clean** (8 GR + 4 QUOT), all `#print axioms = {propext, Classical.choice, Quot.sound}`.
- **Build:** all three prover-edited modules `lake build` GREEN (8317–8318 jobs; expected pre-existing
  sorry + linter long-line / deprecation warnings only).
- **sync_leanok:** ran on current tree (iter 31, sha `d942808`): +11 `\leanok`, 0 removed; chapters =
  FlatBaseChange / GrassmannianCells / QuotScheme.
- **blueprint-doctor:** 0 findings (every chapter `\input`'d; every `\ref`/`\uses` resolves; no `axiom`).
- **leandag:** `gaps=0`, `unmatched=9` (6 GR + 3 QUOT new helpers — coverage debt, listed in recommendations).
- **Targets attempted:** GR `scheme` + cocycle cone (SOLVED — lane CLOSED); QUOT gap1 bridge C →
  `overRestrictIso` (SOLVED — bridge closed); FBC `_legs` (PARTIAL — one verified advance, not closed).

## Headline
The iter's value is **structural, not count-based**: two whole sub-lanes closed.
1. **GR-glue lane CLOSED.** `Grassmannian.scheme := (theGlueData d r).glued` now exists and is
   axiom-clean — the keystone of the Grassmannian construction. The 2-iter "no output" stall was
   confirmed to have been a dispatch-wording bug (a 0-sorry file dropped by the no-op objective filter),
   not a math wall: with the objective re-worded, the prover landed all 8 decls in one round.
2. **QUOT gap1 bridge C CLOSED.** The slice→geometric restriction iso `overRestrictIso` is axiom-clean;
   the "current obstacle" (step-2 geometric ring-sheaf identification) collapsed to `rfl`. P1 (the
   per-element presentation transport) is now unblocked.
3. **FBC `_legs`** advanced one verified `simp only` step (codomain-read unfold + factor distribution),
   but did NOT close — and surfaced a concrete declaration-ordering blocker. This is the documented FBC
   budget boundary (~13 iters; STRATEGY Open Q2).

---

## Target 1 — `Grassmannian.scheme` (GR) — SOLVED (lane closed)

8 new axiom-clean decls: `awayMulCommEquiv_comp_awayInclLeft`, `rotMid` (private),
`transitionInvImageMatrix` (private), `transitionInvPair` (private), `cocyclePhiId`,
`chartTransition'_cocycle`, `theGlueData`, `scheme`. (A drafted `awayMulCommEquiv_comp_symm` was
removed — the telescoping route absorbed swap∘swap into `rotMid`+`cocycleCondition`.)

- **`cocyclePhiId`** (the ring-level cocycle Φ = id): proved by **telescoping**, not a single giant
  generator computation. `rotMid` recovers `cocycleΘJK` in the I,J,K frame; `cocycleCondition` collapses
  `Θ_IJ ∘ Θ_JK = Θ_IK`; the residual single inverse pair `Θ_IK ∘ Θ_KI ∘ swap_I = id` is closed by the
  matrix collapse `transitionInvImageMatrix` (`(W_K)⁻¹ W` with `W_I = 1`). Key insight: **one** application
  of `cocycleCondition` to the 3-fold loop leaves **exactly one** inverse pair; only that residual needs
  the matrix engine.
- **`chartTransition'_cocycle`** (scheme-level cocycle field): `simp only [chartTransition',
  Category.assoc, Iso.inv_hom_id_assoc]` cancels the two internal `awayPullbackIso` pairs; six `Spec.map`s
  collapse via `←Spec.map_comp`/`←CommRingCat.ofHom_comp` into `Spec.map (ofHom Φ)`; `cocyclePhiId` +
  `ofHom_id` + `Spec.map_id` ⟹ `𝟙`; `rw [reassoc_of% h6, Iso.hom_inv_id]` closes.
  - Needs `set_option maxHeartbeats 1600000` (HasPullback instance diamond on heavy MvPolynomial
    away-localisation makes the `Iso` cancellation defeq-expensive). `reassoc_of%` auto-absorbs the `𝟙 ≫`.
- **`theGlueData` / `scheme`**: `Scheme.GlueData` indexed by `{I : Finset (Fin r) // I.card = d}`;
  `f_mono`/`f_hasPullback` default `by infer_instance` **WORKED** (contrary to the prior dead-end warning
  that explicit instances were needed). `scheme := theGlueData.glued`.

## Target 2 — `overRestrictIso` (QUOT gap1 bridge C) — SOLVED (bridge closed)

4 new axiom-clean defs: `overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictIso` (the pinned
target), `overRestrictPullbackIso`.

- **Step 2 (the named "current obstacle")** dissolved to `rfl`: `U.toScheme.ringCatSheaf =
  (overEquivalence_sheafCongr U RingCat).functor.obj (X.ringCatSheaf.over U)` is `rfl` because
  `U.toScheme.presheaf = U.ι.opensFunctor.op ⋙ X.presheaf` is `rfl` (`toScheme_presheaf_obj/map`).
- **Step 3 `overRestrictEquiv`**: `pushforwardPushforwardEquivalence (Opens.overEquivalence U) φ ψ H₁ H₂`
  with `φ = whiskerRight (NatTrans.op eqv.unitIso.inv) ..` and `ψ = 𝟙`. Coherence `H₁` via
  `Equivalence.unitInv_app_inverse`; `H₂` via `erw [Category.id_comp, ← Functor.map_comp]` then a separate
  `have` discharging the op-composition identity, closed by `(congrArg map h).trans (Functor.map_id ..)`.
  - **Dead-end:** `rw [Category.id_comp]` / `rw [← op_comp]` fail by *syntactic* pattern-match even when
    the subterm is visibly present (Over/opposite-category `Category` instance reducibly-but-not-
    syntactically expected). Use `erw` + the defeq-aware `have`+`congrArg`+`Functor.map_id`. Do NOT retry
    `rw [h]`/`rw [Category.id_comp]` here.
- **Step 4 `overRestrictFunctorIso`/`overRestrictIso`**: both sides are `pushforward` along the SAME opens
  functor (`eqv.inverse ⋙ Over.forget U = U.ι.opensFunctor`, `rfl`), so `pushforwardComp ≪≫
  pushforwardCongr (by cat_disch)`. Needed an explicit `haveI : (eqv.inverse ⋙ Over.forget
  U).IsContinuous _ _ := Functor.isContinuous_comp` (composition continuity not auto-synthesised). The
  ring-morphism equality fed to `pushforwardCongr` is closed by **`cat_disch`** (manual `ext;simp` stalls
  on the `Sheaf.Hom`/`.hom.app` wrapper). `overRestrictPullbackIso := overRestrictIso ≪≫
  restrictFunctorIsoPullback.app M` (the form P1 consumes).

## Target 3 — `base_change_mate_fstar_reindex_legs` (FBC) — PARTIAL (not closed)

- **Advance (verified, build green):** after the iter-030 `link_distributeCollapse` splice, added
  `simp only [base_change_mate_codomain_read_legs, Iso.trans_hom, Functor.mapIso_hom, Functor.map_comp,
  Category.assoc, Functor.comp_map]`. This unfolds the variable-legs codomain read (exposing
  `(pullbackComp e (Spec inclA)).symm`, `(asIso η^e).symm`, `(pushforwardComp e (Spec inclR')).symm`) and
  distributes the LHS three surviving factors into uniform `moduleSpecΓFunctor.map (...)` form. Goal
  strictly more advanced than the prior bare-`refine ... sorry`.
  - `Functor.map_comp` is an **unused** simp arg (LSP warning; 5/6 fire) — dead weight to remove.
- **Two concrete blockers surfaced (real handoff):**
  1. **Declaration ordering.** The eCancel atoms (`base_change_mate_inner_eCancel_eUnit/_pushforwardComp/
     _pullbackComp`) and `base_change_mate_inner_value_eq` are all defined **after** `_legs`, so they are
     **out of scope** at the `_legs` sorry (`Unknown identifier ...` confirmed). Next iter must reorder
     them above `_legs` OR inline their content (≤3 lines each: `pullback_isEquivalence_of_iso`;
     `(pullbackComp _ _).hom_inv_id_app`; the pre-`_legs` `gammaMap_pushforwardComp_hom_eq_id`).
  2. **Keyed collapse dead, again.** `rw [gammaMap_pushforwardComp_hom_eq_id]` on even the *trivial*
     trailing factor reports "did not find an occurrence" — the `pushforwardComp` first arg stays the
     LITERAL `(pullbackSpecIso ..).hom ≫ Spec.map (..)` under the `X.Modules` diamond. Residual collapse is
     term-mode only. The RHS codomain read is moreover wrapped in three `Eq.mpr` casts from the leg-`subst`
     — collapsing those (via the concrete-legs `base_change_mate_codomain_read`) before splicing may be the
     unlock.

---

## Critic / auditor dispositions (full reports in logs/iter-031/)
- **lean-auditor `iter031`** — 0 must-fix; 5 major (1 stale GR planner-note @33–44; 4 pre-existing QUOT
  excuse-commented stubs — out of scope per directive); 5 minor (FBC dead simp arg @1452; 2 misplaced
  `maxHeartbeats` comments @979/@1371; 2 missing "sorry-backed" disclaimers @1486/@1635). All 12 new decls
  re-verified axiom-clean. Report: `logs/iter-031/lean-auditor-iter031-report.md`.
- **lean-vs-blueprint-checker `gr-iter031`** — correct + sorry-free for all pinned decls; 0 red flags. 2
  major coverage gaps (`theGlueData`, `chartTransition'_cocycle` need `\lean{}` blocks) + a **pre-existing
  major: 9 `private` GR decls carry public-namespace `\lean{}` pins** that don't resolve under `lake env
  lean` (breaks sync_leanok for those blocks). Report: `...gr-iter031-report.md`.
- **lean-vs-blueprint-checker `quot-iter031`** — correct, axiom-clean; `overRestrictIso` signature matches
  blueprint verbatim; the 4-step prose was adequate. 3 major coverage-debt (`overRestrictEquiv`,
  `overRestrictFunctorIso`, `overRestrictPullbackIso` need blocks). Report: `...quot-iter031-report.md`.
- **lean-vs-blueprint-checker `fbc-iter031`** — iter-031 advance confirmed; 2 major (declaration-ordering
  wall; 3 dangling `\lean{}` pins L3–L5 `link_cancelEUnit`/`link_cancelPullbackComp`/`link_survivor` —
  reserved-by-design, no `\leanok`). Report: `...fbc-iter031-report.md`.

## Blueprint markers updated (manual)
- `Picard_GrassmannianCells.tex`, `def:gr_glued_scheme`: rewrote the stale `% NOTE (formalization status)`
  (which claimed `cocycle`/`Scheme.GlueData`/`Grassmannian.scheme` "NOT yet formalized" and "does not yet
  exist in Lean") → "FULLY FORMALIZED and axiom-clean" with the decl inventory. (`scheme` now exists;
  verified sorry-free + axiom-clean; sync_leanok added `\leanok`.)
- `Picard_QuotScheme.tex`, `lem:over_restrict_iso`: rewrote three stale `% NOTE`s (one claimed
  `overRestrictIso` "does NOT yet exist"; one a forward `set_option` warning; one "may need to be
  sharpened … routed THROUGH the step-3 equivalence functor") → one "RESOLVED and axiom-clean" note
  recording the `rfl` step-2 collapse and that the statement IS routed through the equivalence functor as
  anticipated (no sharpening needed).
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_fstar_reindex_legs`: added a `% NOTE (iter-031,
  declaration-ordering constraint)` recording that the eCancel atoms are defined after `_legs` (out of
  scope at the sorry) and must be reordered/inlined, with the inline recipe and the term-mode-only note.
- No `\mathlibok` added (no new Mathlib-backed *project* re-export decls this iter). No `\lean{}` renames
  flagged. No stale `\notready` found.

## Notes (LOW severity)
- lean-auditor: GR `set_option maxHeartbeats 1600000` (×2) is substantiated with correctly-placed
  comments — not flagged. FBC `maxHeartbeats 4000000` comments are mis-*placed* (before the line) — minor
  style-linter trigger only.
